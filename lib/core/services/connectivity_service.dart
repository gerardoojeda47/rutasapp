import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:network_info_plus/network_info_plus.dart';

/// Servicio moderno de conectividad usando tecnologías actualizadas
/// Reemplaza connectivity_plus con soluciones más estables y modernas
class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final InternetConnectionChecker _connectionChecker = InternetConnectionChecker();
  final NetworkInfo _networkInfo = NetworkInfo();
  
  StreamSubscription<InternetConnectionStatus>? _connectionSubscription;
  final StreamController<bool> _connectivityController = StreamController<bool>.broadcast();
  
  bool _isConnected = false;
  String? _connectionType;
  String? _wifiName;

  /// Stream de cambios de conectividad
  Stream<bool> get connectivityStream => _connectivityController.stream;
  
  /// Estado actual de conectividad
  bool get isConnected => _isConnected;
  
  /// Tipo de conexión actual
  String? get connectionType => _connectionType;
  
  /// Nombre de la red WiFi (si está conectado por WiFi)
  String? get wifiName => _wifiName;

  /// Inicializa el servicio de conectividad
  Future<void> initialize() async {
    try {
      debugPrint('🌐 Inicializando ConnectivityService...');
      
      // Verificar conectividad inicial
      await _checkInitialConnectivity();
      
      // Configurar listener para cambios de conectividad
      _connectionSubscription = _connectionChecker.onStatusChange.listen(
        _onConnectivityChanged,
        onError: (error) {
          debugPrint('❌ Error en connectivity stream: $error');
        },
      );
      
      debugPrint('✅ ConnectivityService inicializado correctamente');
    } catch (e) {
      debugPrint('❌ Error al inicializar ConnectivityService: $e');
      rethrow;
    }
  }

  /// Verifica la conectividad inicial
  Future<void> _checkInitialConnectivity() async {
    try {
      final status = await _connectionChecker.connectionStatus;
      await _updateConnectivityStatus(status);
    } catch (e) {
      debugPrint('❌ Error al verificar conectividad inicial: $e');
      _isConnected = false;
      _connectivityController.add(false);
    }
  }

  /// Maneja cambios en la conectividad
  Future<void> _onConnectivityChanged(InternetConnectionStatus status) async {
    debugPrint('🔄 Cambio de conectividad detectado: $status');
    await _updateConnectivityStatus(status);
  }

  /// Actualiza el estado de conectividad
  Future<void> _updateConnectivityStatus(InternetConnectionStatus status) async {
    final wasConnected = _isConnected;
    _isConnected = status == InternetConnectionStatus.connected;
    
    if (_isConnected) {
      await _updateConnectionDetails();
    } else {
      _connectionType = null;
      _wifiName = null;
    }
    
    // Notificar solo si cambió el estado
    if (wasConnected != _isConnected) {
      _connectivityController.add(_isConnected);
      debugPrint('📡 Estado de conectividad: ${_isConnected ? "Conectado" : "Desconectado"}');
    }
  }

  /// Actualiza detalles de la conexión
  Future<void> _updateConnectionDetails() async {
    try {
      // Obtener información de la red
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
      debugPrint('⚠️ Error al obtener detalles de conexión: $e');
      _connectionType = 'Desconocido';
    }
  }

  /// Verifica conectividad de forma síncrona
  Future<bool> hasInternetConnection() async {
    try {
      final status = await _connectionChecker.connectionStatus;
      return status == InternetConnectionStatus.connected;
    } catch (e) {
      debugPrint('❌ Error al verificar conectividad: $e');
      return false;
    }
  }

  /// Verifica conectividad con timeout personalizado
  Future<bool> hasInternetConnectionWithTimeout({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    try {
      final status = await _connectionChecker.connectionStatus
          .timeout(timeout);
      return status == InternetConnectionStatus.connected;
    } catch (e) {
      debugPrint('⏱️ Timeout o error al verificar conectividad: $e');
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
      };
    } catch (e) {
      debugPrint('❌ Error al obtener información de red: $e');
      return {
        'error': e.toString(),
        'isConnected': _isConnected,
      };
    }
  }

  /// Libera recursos
  void dispose() {
    debugPrint('🔄 Liberando recursos de ConnectivityService...');
    _connectionSubscription?.cancel();
    _connectivityController.close();
  }
}

/// Extensión para facilitar el uso del servicio
extension ConnectivityServiceExtension on ConnectivityService {
  /// Verifica si hay conexión y muestra un mensaje si no la hay
  Future<bool> checkConnectionWithMessage({
    String? customMessage,
    bool showDialog = true,
  }) async {
    final hasConnection = await hasInternetConnection();
    
    if (!hasConnection && showDialog) {
      // Aquí podrías mostrar un dialog o snackbar
      debugPrint('❌ Sin conexión a internet: ${customMessage ?? "Verifica tu conexión"}');
    }
    
    return hasConnection;
  }
}
