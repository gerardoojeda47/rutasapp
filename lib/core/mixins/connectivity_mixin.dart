import 'dart:async';
import 'package:flutter/material.dart';
import '../services/network_monitor_service.dart';

/// Mixin que proporciona funcionalidades de conectividad a los widgets
/// Reemplaza el uso directo de connectivity_plus con tecnologías modernas
mixin ConnectivityMixin<T extends StatefulWidget> on State<T> {
  final NetworkMonitorService _networkService = NetworkMonitorService();
  StreamSubscription<bool>? _connectivitySubscription;
  bool _isConnected = true;
  bool _isInitialized = false;

  /// Estado actual de conectividad
  bool get isConnected => _isConnected;

  /// Servicio de monitoreo de red
  NetworkMonitorService get networkService => _networkService;

  @override
  void initState() {
    super.initState();
    _initializeConnectivity();
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  /// Inicializa el monitoreo de conectividad
  Future<void> _initializeConnectivity() async {
    if (_isInitialized) return;
    
    try {
      await _networkService.initialize();
      
      // Verificar estado inicial
      _isConnected = await _networkService.hasInternetConnection();
      
      // Escuchar cambios de conectividad
      _connectivitySubscription = _networkService.networkStatusStream.listen(
        _onConnectivityChanged,
        onError: (error) {
          debugPrint('❌ Error en connectivity stream: $error');
        },
      );
      
      _isInitialized = true;
      
      // Notificar al widget que la conectividad está lista
      if (mounted) {
        onConnectivityInitialized(_isConnected);
      }
    } catch (e) {
      debugPrint('❌ Error al inicializar conectividad: $e');
      _isConnected = false;
      if (mounted) {
        onConnectivityError(e);
      }
    }
  }

  /// Maneja cambios en la conectividad
  void _onConnectivityChanged(bool isConnected) {
    if (_isConnected != isConnected) {
      setState(() {
        _isConnected = isConnected;
      });
      
      if (mounted) {
        onConnectivityChanged(isConnected);
      }
    }
  }

  /// Verifica conectividad con timeout personalizado
  Future<bool> checkConnectionWithTimeout({
    Duration timeout = const Duration(seconds: 5),
  }) async {
    return await _networkService.hasInternetConnectionWithTimeout(
      timeout: timeout,
    );
  }

  /// Verifica conectividad y ejecuta una acción si no hay conexión
  Future<bool> checkConnectionAndHandle({
    String? noConnectionMessage,
    VoidCallback? onNoConnection,
    bool showSnackBar = true,
  }) async {
    final hasConnection = await _networkService.hasInternetConnection();
    
    if (!hasConnection) {
      if (showSnackBar && mounted) {
        _showNoConnectionSnackBar(noConnectionMessage);
      }
      
      if (onNoConnection != null) {
        onNoConnection();
      }
    }
    
    return hasConnection;
  }

  /// Muestra un SnackBar cuando no hay conexión
  void _showNoConnectionSnackBar(String? message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? 'Sin conexión a internet'),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Reintentar',
          textColor: Colors.white,
          onPressed: () {
            _checkConnectionAndRefresh();
          },
        ),
      ),
    );
  }

  /// Verifica conexión y actualiza el estado
  Future<void> _checkConnectionAndRefresh() async {
    final hasConnection = await _networkService.hasInternetConnection();
    if (mounted) {
      setState(() {
        _isConnected = hasConnection;
      });
    }
  }

  /// Obtiene información detallada de la red
  Future<Map<String, dynamic>> getNetworkInfo() async {
    return await _networkService.getNetworkInfo();
  }

  // Métodos que pueden ser sobrescritos por el widget que usa el mixin

  /// Se llama cuando la conectividad se inicializa
  void onConnectivityInitialized(bool isConnected) {
    // Sobrescribir en el widget si necesitas manejar la inicialización
  }

  /// Se llama cuando cambia el estado de conectividad
  void onConnectivityChanged(bool isConnected) {
    // Sobrescribir en el widget si necesitas manejar cambios de conectividad
    if (!isConnected) {
      debugPrint('⚠️ Pérdida de conexión detectada');
    } else {
      debugPrint('✅ Conexión restaurada');
    }
  }

  /// Se llama cuando hay un error en el servicio de conectividad
  void onConnectivityError(dynamic error) {
    // Sobrescribir en el widget si necesitas manejar errores
    debugPrint('❌ Error de conectividad: $error');
  }
}

/// Widget que muestra el estado de conectividad
class ConnectivityStatusWidget extends StatelessWidget {
  final NetworkMonitorService networkService;
  final Widget Function(bool isConnected, String? connectionType) builder;

  const ConnectivityStatusWidget({
    super.key,
    required this.networkService,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: networkService.networkStatusStream,
      initialData: networkService.isConnected,
      builder: (context, snapshot) {
        final isConnected = snapshot.data ?? false;
        final connectionType = networkService.connectionType;
        
        return builder(isConnected, connectionType);
      },
    );
  }
}

/// Indicador visual de conectividad
class ConnectivityIndicator extends StatelessWidget {
  final NetworkMonitorService networkService;
  final double size;
  final Color? connectedColor;
  final Color? disconnectedColor;

  const ConnectivityIndicator({
    super.key,
    required this.networkService,
    this.size = 16.0,
    this.connectedColor = Colors.green,
    this.disconnectedColor = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: networkService.networkStatusStream,
      initialData: networkService.isConnected,
      builder: (context, snapshot) {
        final isConnected = snapshot.data ?? false;
        
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isConnected ? connectedColor : disconnectedColor,
          ),
          child: isConnected
              ? const Icon(
                  Icons.wifi,
                  color: Colors.white,
                  size: 12,
                )
              : const Icon(
                  Icons.wifi_off,
                  color: Colors.white,
                  size: 12,
                ),
        );
      },
    );
  }
}

