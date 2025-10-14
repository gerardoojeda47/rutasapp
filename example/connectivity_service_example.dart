import 'package:flutter/material.dart';
import '../lib/core/services/connectivity_service.dart';
import '../lib/core/mixins/connectivity_mixin.dart';

/// Ejemplo de uso del nuevo ConnectivityService
/// Reemplaza connectivity_plus con tecnologías modernas
class ConnectivityExamplePage extends StatefulWidget {
  const ConnectivityExamplePage({super.key});

  @override
  State<ConnectivityExamplePage> createState() => _ConnectivityExamplePageState();
}

class _ConnectivityExamplePageState extends State<ConnectivityExamplePage>
    with ConnectivityMixin {
  
  final ConnectivityService _connectivityService = ConnectivityService();
  Map<String, dynamic> _networkInfo = {};

  @override
  void onConnectivityInitialized(bool isConnected) {
    debugPrint('🔌 Conectividad inicializada: $isConnected');
    _loadNetworkInfo();
  }

  @override
  void onConnectivityChanged(bool isConnected) {
    debugPrint('🔄 Conectividad cambió: $isConnected');
    if (isConnected) {
      _loadNetworkInfo();
    } else {
      setState(() {
        _networkInfo = {};
      });
    }
  }

  Future<void> _loadNetworkInfo() async {
    final info = await getNetworkInfo();
    if (mounted) {
      setState(() {
        _networkInfo = info;
      });
    }
  }

  Future<void> _testConnection() async {
    final hasConnection = await checkConnectionWithTimeout();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            hasConnection 
                ? '✅ Conexión verificada exitosamente'
                : '❌ Sin conexión a internet'
          ),
          backgroundColor: hasConnection ? Colors.green : Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connectivity Service Example'),
        actions: [
          ConnectivityIndicator(
            connectivityService: _connectivityService,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Estado de conectividad
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isConnected ? Icons.wifi : Icons.wifi_off,
                          color: isConnected ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isConnected ? 'Conectado' : 'Desconectado',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isConnected ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (isConnected && _networkInfo.isNotEmpty) ...[
                      Text('Tipo: ${_networkInfo['connectionType'] ?? 'Desconocido'}'),
                      if (_networkInfo['wifiName'] != null)
                        Text('Red WiFi: ${_networkInfo['wifiName']}'),
                      if (_networkInfo['wifiIP'] != null)
                        Text('IP: ${_networkInfo['wifiIP']}'),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Botones de prueba
            Wrap(
              spacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: _testConnection,
                  icon: const Icon(Icons.network_check),
                  label: const Text('Verificar Conexión'),
                ),
                ElevatedButton.icon(
                  onPressed: _loadNetworkInfo,
                  icon: const Icon(Icons.info),
                  label: const Text('Actualizar Info'),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Información detallada de la red
            if (_networkInfo.isNotEmpty) ...[
              const Text(
                'Información Detallada de la Red:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Conectado', isConnected.toString()),
                      _buildInfoRow('Tipo de Conexión', _networkInfo['connectionType'] ?? 'N/A'),
                      _buildInfoRow('Nombre WiFi', _networkInfo['wifiName'] ?? 'N/A'),
                      _buildInfoRow('IP WiFi', _networkInfo['wifiIP'] ?? 'N/A'),
                      _buildInfoRow('Máscara de Subred', _networkInfo['wifiSubmask'] ?? 'N/A'),
                      _buildInfoRow('Gateway', _networkInfo['wifiGatewayIP'] ?? 'N/A'),
                      _buildInfoRow('Broadcast', _networkInfo['wifiBroadcast'] ?? 'N/A'),
                    ],
                  ),
                ),
              ),
            ],
            
            const Spacer(),
            
            // Widget de estado de conectividad
            ConnectivityStatusWidget(
              connectivityService: _connectivityService,
              builder: (isConnected, connectionType) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isConnected ? Colors.green.shade50 : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isConnected ? Colors.green : Colors.red,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isConnected ? Icons.cloud_done : Icons.cloud_off,
                        color: isConnected ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isConnected ? 'Conexión Activa' : 'Sin Conexión',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isConnected ? Colors.green : Colors.red,
                              ),
                            ),
                            if (connectionType != null)
                              Text(
                                'Tipo: $connectionType',
                                style: const TextStyle(fontSize: 12),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget de ejemplo que muestra cómo usar el mixin en cualquier página
class SimpleConnectivityPage extends StatefulWidget {
  const SimpleConnectivityPage({super.key});

  @override
  State<SimpleConnectivityPage> createState() => _SimpleConnectivityPageState();
}

class _SimpleConnectivityPageState extends State<SimpleConnectivityPage>
    with ConnectivityMixin {
  
  @override
  void onConnectivityChanged(bool isConnected) {
    super.onConnectivityChanged(isConnected);
    
    // Mostrar mensaje cuando se pierde/restaura la conexión
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isConnected 
                ? '✅ Conexión restaurada'
                : '⚠️ Conexión perdida'
          ),
          backgroundColor: isConnected ? Colors.green : Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página con Conectividad'),
        actions: [
          ConnectivityIndicator(
            connectivityService: connectivityService,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isConnected ? Icons.wifi : Icons.wifi_off,
              size: 64,
              color: isConnected ? Colors.green : Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              isConnected ? 'Conectado a Internet' : 'Sin Conexión',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isConnected ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            if (isConnected)
              Text(
                'Tipo: ${connectivityService.connectionType ?? 'Desconocido'}',
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                final hasConnection = await checkConnectionAndHandle(
                  noConnectionMessage: 'No hay conexión a internet',
                  showSnackBar: true,
                );
                
                if (hasConnection) {
                  // Aquí puedes realizar acciones que requieren internet
                  debugPrint('Realizando acción que requiere internet...');
                }
              },
              child: const Text('Verificar Conexión y Continuar'),
            ),
          ],
        ),
      ),
    );
  }
}
