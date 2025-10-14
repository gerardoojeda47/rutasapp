import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:network_info_plus/network_info_plus.dart';

/// Servicio moderno de monitoreo de red sin dependencias problemáticas
/// Solución robusta que reemplaza completamente connectivity_plus
class NetworkMonitorService {
  static final NetworkMonitorService _instance = NetworkMonitorService._internal();
  factory NetworkMonitorService() => _instance;
  NetworkMonitorService._internal();

  final InternetConnectionChecker _connectionChecker = InternetConnectionChecker();
  final NetworkInfo _networkInfo = NetworkInfo();
  
  StreamSubscription<InternetConnectionStatus>? _connectionSubscription;
  final StreamController<bool> _networkStatusController = StreamController<bool>.broadcast();
  
  bool _isConnected = false;
  String? _connectionType;
  String? _wifiName;
  DateTime? _lastCheckTime;

  /// Stream de cambios de estado de red
  Stream<bool> get networkStatusStream => _networkStatusController.stream;
  
  /// Estado actual de conexión
  bool get isConnected => _isConnected;
  
  /// Tipo de conexión actual
  String? get connectionType => _connectionType;
  
  /// Nombre de la red WiFi
  String? get wifiName => _wifiName;

  /// Tiempo de la última verificación
  DateTime? get lastCheckTime => _lastCheckTime;

  /// Inicializa el servicio de monitoreo de red
  Future<void> initialize() async {
    try {
      debugPrint('🌐 Inicializando NetworkMonitorService...');
      
      // Verificar estado inicial
      await _checkInitialConnection();
      
      // Configurar listener para cambios
      _connectionSubscription = _connectionChecker.onStatusChange.listen(
        _onConnectionStatusChanged,
        onError: (error) {
          debugPrint('❌ Error en network status stream: $error');
          _networkStatusController.addError(error);
        },
      );
      
      debugPrint('✅ NetworkMonitorService inicializado correctamente');
    } catch (e) {
      debugPrint('❌ Error al inicializar NetworkMonitorService: $e');
      rethrow;
    }
  }

  /// Verifica la conexión inicial
  Future<void> _checkInitialConnection() async {
    try {
      final status = await _connectionChecker.connectionStatus;
      await _updateConnectionStatus(status);
      _lastCheckTime = DateTime.now();
    } catch (e) {
      debugPrint('❌ Error al verificar conexión inicial: $e');
      _isConnected = false;
      _networkStatusController.add(false);
    }
  }

  /// Maneja cambios en el estado de conexión
  Future<void> _onConnectionStatusChanged(InternetConnectionStatus status) async {
    debugPrint('🔄 Cambio de estado de red detectado: $status');
    await _updateConnectionStatus(status);
    _lastCheckTime = DateTime.now();
  }

  /// Actualiza el estado de conexión
  Future<void> _updateConnectionStatus(InternetConnectionStatus status) async {
    final wasConnected = _isConnected;
    _isConnected = status == InternetConnectionStatus.connected;
    
    if (_isConnected) {
      await _updateNetworkDetails();
    } else {
      _connectionType = null;
      _wifiName = null;
    }
    
    // Notificar solo si cambió el estado
    if (wasConnected != _isConnected) {
      _networkStatusController.add(_isConnected);
      debugPrint('📡 Estado de red: ${_isConnected ? "Conectado" : "Desconectado"}');
    }
  }

  /// Actualiza detalles de la red
  Future<void> _updateNetworkDetails() async {
    try {
      final wifiName = await _networkInfo.getWifiName();
      final wifiIP = await _networkInfo.getWifiIP();
      
      _wifiName = wifiName?.replaceAll('"', '');
      
      if (_wifiName != null && _wifiName!.isNotEmpty) {
        _connectionType = 'WiFi';
        debugPrint('📶 Conectado por WiFi: $_wifiName');
      } else if (wifiIP != null) {
        _connectionType = 'Ethernet';
        debugPrint('🔌 Conectado por Ethernet: $wifiIP');
      } else {
        _connectionType = 'Móvil';
        debugPrint('📱 Conectado por datos móviles');
      }
    } catch (e) {
      debugPrint('⚠️ Error al obtener detalles de red: $e');
      _connectionType = 'Desconocido';
    }
  }

  /// Verifica conexión de forma síncrona
  Future<bool> hasInternetConnection() async {
    try {
      final status = await _connectionChecker.connectionStatus;
      final isConnected = status == InternetConnectionStatus.connected;
      _lastCheckTime = DateTime.now();
      return isConnected;
    } catch (e) {
      debugPrint('❌ Error al verificar conexión: $e');
      return false;
    }
  }

  /// Verifica conexión con timeout personalizado
  Future<bool> hasInternetConnectionWithTimeout({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    try {
      final status = await _connectionChecker.connectionStatus.timeout(timeout);
      final isConnected = status == InternetConnectionStatus.connected;
      _lastCheckTime = DateTime.now();
      return isConnected;
    } catch (e) {
      debugPrint('⏱️ Timeout o error al verificar conexión: $e');
      return false;
    }
  }

  /// Obtiene información detallada de la red
  Future<Map<String, dynamic>> getNetworkInfo() async {
    try {
      final wifiName = await _networkInfo.getWifiName();
      final wifiIP = await _networkInfo.getWifiIP();
      final wifiSubmask = await _networkInfo.getWifiSubmask();
      final wifiGatewayIP = await _networkInfo.getWifiGatewayIP();
      final wifiBroadcast = await _networkInfo.getWifiBroadcast();

      return {
        'wifiName': wifiName?.replaceAll('"', ''),
        'wifiIP': wifiIP,
        'wifiSubmask': wifiSubmask,
        'wifiGatewayIP': wifiGatewayIP,
        'wifiBroadcast': wifiBroadcast,
        'connectionType': _connectionType,
        'isConnected': _isConnected,
        'lastCheckTime': _lastCheckTime?.toIso8601String(),
      };
    } catch (e) {
      debugPrint('❌ Error al obtener información de red: $e');
      return {
        'error': e.toString(),
        'isConnected': _isConnected,
        'lastCheckTime': _lastCheckTime?.toIso8601String(),
      };
    }
  }

  /// Libera recursos
  void dispose() {
    debugPrint('🔄 Liberando recursos de NetworkMonitorService...');
    _connectionSubscription?.cancel();
    _networkStatusController.close();
  }
}

/// Extensión para facilitar el uso del servicio
extension NetworkMonitorServiceExtension on NetworkMonitorService {
  /// Verifica si hay conexión y muestra un mensaje si no la hay
  Future<bool> checkConnectionWithMessage({
    String? customMessage,
    bool showDebug = true,
  }) async {
    final hasConnection = await hasInternetConnection();
    
    if (!hasConnection && showDebug) {
      debugPrint('❌ Sin conexión a internet: ${customMessage ?? "Verifica tu conexión"}');
    }
    
    return hasConnection;
  }
}
