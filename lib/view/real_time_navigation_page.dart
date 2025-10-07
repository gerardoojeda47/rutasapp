import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

import '../core/services/navigation_service.dart';
import '../data/popayan_places_data.dart';

class RealTimeNavigationPage extends StatefulWidget {
  final PopayanPlace destination;
  final LatLng userLocation;

  const RealTimeNavigationPage({
    super.key,
    required this.destination,
    required this.userLocation,
  });

  @override
  State<RealTimeNavigationPage> createState() => _RealTimeNavigationPageState();
}

class _RealTimeNavigationPageState extends State<RealTimeNavigationPage>
    with TickerProviderStateMixin {
  final fm.MapController _mapController = fm.MapController();

  Position? _currentPosition;
  LatLng? _nearestBusStop;
  double _distanceToStop = 0.0;
  bool _hasArrivedAtStop = false;

  StreamSubscription<Position>? _positionStream;
  Timer? _updateTimer;

  late AnimationController _pulseController;
  late AnimationController _arrivalController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _arrivalAnimation;

  // Lista completa de paradas de bus en Popayán (coordenadas reales del sistema)
  final List<BusStop> _busStops = [
    // Paradas principales del centro
    BusStop(
      id: 'stop_centro_caldas',
      name: 'Parque Caldas - Centro Histórico',
      coordinates: LatLng(2.4448, -76.6147),
      routes: [
        'SOTRACAUCA Ruta 5',
        'SOTRACAUCA Ruta 6',
        'TRANSLIBERTAD Ruta 1'
      ],
    ),
    BusStop(
      id: 'stop_carrera_6',
      name: 'Carrera 6 - Zona Bancaria',
      coordinates: LatLng(2.4445, -76.6145),
      routes: [
        'TRANSPUBENZA Ruta 2',
        'TRANSPUBENZA Ruta 5',
        'SOTRACAUCA Ruta 6'
      ],
    ),
    BusStop(
      id: 'stop_calle_5',
      name: 'Calle 5 - Eje Central',
      coordinates: LatLng(2.4448, -76.6147),
      routes: [
        'SOTRACAUCA Ruta 7',
        'SOTRACAUCA Ruta 8',
        'TRANSLIBERTAD Ruta 1'
      ],
    ),

    // Paradas del norte
    BusStop(
      id: 'stop_la_paz',
      name: 'La Paz',
      coordinates: LatLng(2.4490, -76.6080),
      routes: ['SOTRACAUCA Ruta 1', 'SOTRACAUCA Ruta 2', 'TRANSPUBENZA Ruta 1'],
    ),
    BusStop(
      id: 'stop_la_esmeralda',
      name: 'La Esmeralda',
      coordinates: LatLng(2.4515, -76.6065),
      routes: [
        'TRANSPUBENZA Ruta 1',
        'TRANSPUBENZA Ruta 8',
        'TRANSPUBENZA Ruta 9'
      ],
    ),
    BusStop(
      id: 'stop_lomas_granada',
      name: 'Lomas Granada',
      coordinates: LatLng(2.4540, -76.6130),
      routes: [
        'SOTRACAUCA Ruta 2',
        'TRANSPUBENZA Ruta 4',
        'TRANSLIBERTAD Ruta 2'
      ],
    ),
    BusStop(
      id: 'stop_los_naranjos',
      name: 'Los Naranjos',
      coordinates: LatLng(2.4530, -76.6035),
      routes: [
        'TRANSPUBENZA Ruta 1',
        'TRANSPUBENZA Ruta 3',
        'TRANSPUBENZA Ruta 9'
      ],
    ),
    BusStop(
      id: 'stop_morinda',
      name: 'Morinda',
      coordinates: LatLng(2.4470, -76.6110),
      routes: [
        'SOTRACAUCA Ruta 5',
        'TRANSPUBENZA Ruta 9',
        'TRANSPUBENZA Ruta 10'
      ],
    ),

    // Paradas del sur y occidente
    BusStop(
      id: 'stop_tomas_cipriano',
      name: 'Tomás Cipriano de Mosquera',
      coordinates: LatLng(2.4400, -76.6080),
      routes: [
        'SOTRACAUCA Ruta 3',
        'TRANSPUBENZA Ruta 1',
        'TRANSPUBENZA Ruta 2'
      ],
    ),
    BusStop(
      id: 'stop_las_palmas',
      name: 'Las Palmas',
      coordinates: LatLng(2.4380, -76.6050),
      routes: ['SOTRACAUCA Ruta 3', 'SOTRACAUCA Ruta 6', 'SOTRACAUCA Ruta 8'],
    ),
    BusStop(
      id: 'stop_chirimia',
      name: 'Chirimía',
      coordinates: LatLng(2.4410, -76.6180),
      routes: ['SOTRACAUCA Ruta 1', 'SOTRACAUCA Ruta 3', 'TRANSPUBENZA Ruta 2'],
    ),
    BusStop(
      id: 'stop_alfonso_lopez',
      name: 'Alfonso López',
      coordinates: LatLng(2.4340, -76.6190),
      routes: ['SOTRACAUCA Ruta 4'],
    ),

    // Paradas del terminal y zonas especiales
    BusStop(
      id: 'stop_terminal',
      name: 'Terminal de Transportes',
      coordinates: LatLng(2.4500, -76.6170),
      routes: ['SOTRACAUCA Ruta 2', 'TRANSPUBENZA Ruta 3'],
    ),
    BusStop(
      id: 'stop_campanario',
      name: 'Centro Comercial Campanario',
      coordinates: LatLng(2.4448, -76.6147),
      routes: [
        'SOTRACAUCA Ruta 1',
        'TRANSPUBENZA Ruta 2',
        'TRANSPUBENZA Ruta 7'
      ],
    ),
    BusStop(
      id: 'stop_san_francisco',
      name: 'San Francisco',
      coordinates: LatLng(2.4520, -76.6150),
      routes: ['SOTRACAUCA Ruta 2'],
    ),

    // Paradas de la Calle 13 (eje importante)
    BusStop(
      id: 'stop_calle_13',
      name: 'Calle 13',
      coordinates: LatLng(2.4475, -76.6065),
      routes: [
        'TRANSPUBENZA Ruta 4',
        'TRANSPUBENZA Ruta 5',
        'TRANSPUBENZA Ruta 6'
      ],
    ),

    // Paradas del corredor Carrera 9
    BusStop(
      id: 'stop_carrera_9',
      name: 'Carrera 9',
      coordinates: LatLng(2.4450, -76.6120),
      routes: ['SOTRACAUCA Ruta 3', 'TRANSLIBERTAD Ruta 1'],
    ),
    BusStop(
      id: 'stop_carrera_9_norte',
      name: 'Carrera 9 Norte - Anarkos',
      coordinates: LatLng(2.4520, -76.6050),
      routes: ['TRANSLIBERTAD Ruta 2', 'TRANSLIBERTAD Ruta 3'],
    ),

    // Paradas del oriente
    BusStop(
      id: 'stop_yambitara',
      name: 'Yambitará',
      coordinates: LatLng(2.4565, -76.5955),
      routes: ['TRANSPUBENZA Ruta 5'],
    ),
    BusStop(
      id: 'stop_la_aldea',
      name: 'La Aldea',
      coordinates: LatLng(2.4640, -76.5980),
      routes: ['TRANSPUBENZA Ruta 3'],
    ),
    BusStop(
      id: 'stop_lacteos_purace',
      name: 'Lácteos Puracé',
      coordinates: LatLng(2.4520, -76.6020),
      routes: ['TRANSPUBENZA Ruta 6', 'TRANSPUBENZA Ruta 13'],
    ),

    // Paradas adicionales del norte
    BusStop(
      id: 'stop_jardines_paz',
      name: 'Jardines de Paz',
      coordinates: LatLng(2.4575, -76.6065),
      routes: ['TRANSPUBENZA Ruta 2'],
    ),
    BusStop(
      id: 'stop_modelo',
      name: 'Barrio Modelo',
      coordinates: LatLng(2.4550, -76.6050),
      routes: ['TRANSPUBENZA Ruta 10'],
    ),
    BusStop(
      id: 'stop_sena_norte',
      name: 'SENA Norte',
      coordinates: LatLng(2.4590, -76.6040),
      routes: ['TRANSPUBENZA Ruta 12'],
    ),

    // Paradas del corredor norte TRANSLIBERTAD
    BusStop(
      id: 'stop_transversal_9_norte',
      name: 'Transversal 9 Norte',
      coordinates: LatLng(2.4580, -76.6030),
      routes: ['TRANSLIBERTAD Ruta 2'],
    ),
    BusStop(
      id: 'stop_calle_68_norte',
      name: 'Calle 68 Norte',
      coordinates: LatLng(2.4610, -76.5990),
      routes: ['TRANSLIBERTAD Ruta 2', 'TRANSLIBERTAD Ruta 3'],
    ),

    // Paradas rurales y periféricas
    BusStop(
      id: 'stop_julumito',
      name: 'Julumito',
      coordinates: LatLng(2.4300, -76.6300),
      routes: ['SOTRACAUCA Ruta 7', 'SOTRACAUCA Ruta 9'],
    ),
    BusStop(
      id: 'stop_parque_industrial',
      name: 'Parque Industrial',
      coordinates: LatLng(2.4500, -76.6200),
      routes: ['SOTRACAUCA Ruta 7'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();

    // Retrasar la inicialización para que el mapa se renderice primero
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _findNearestBusStop();
        _startLocationTracking();
        _startPeriodicUpdates();
      }
    });
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _arrivalController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _arrivalAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _arrivalController,
      curve: Curves.elasticOut,
    ));

    _pulseController.repeat(reverse: true);
  }

  void _findNearestBusStop() {
    double minDistance = double.infinity;
    LatLng? nearestStop;

    for (final stop in _busStops) {
      final distance = _calculateDistance(
        widget.userLocation,
        stop.coordinates,
      );

      if (distance < minDistance) {
        minDistance = distance;
        nearestStop = stop.coordinates;
      }
    }

    setState(() {
      _nearestBusStop = nearestStop;
      _distanceToStop = minDistance;
    });

    // Centrar el mapa entre el usuario y la parada
    if (nearestStop != null) {
      _centerMapBetweenPoints(widget.userLocation, nearestStop);
    }
  }

  void _centerMapBetweenPoints(LatLng point1, LatLng point2) {
    final centerLat = (point1.latitude + point2.latitude) / 2;
    final centerLng = (point1.longitude + point2.longitude) / 2;
    final center = LatLng(centerLat, centerLng);

    // Calcular zoom apropiado basado en la distancia
    final distance = _calculateDistance(point1, point2);
    double zoom = 16.0;
    if (distance > 1000) {
      zoom = 14.0;
    } else if (distance > 500) {
      zoom = 15.0;
    } else if (distance < 100) {
      zoom = 17.0;
    }

    // Usar Future.delayed para asegurar que el mapa esté renderizado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _mapController.move(center, zoom);
      }
    });
  }

  void _startLocationTracking() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 1, // Actualizar cada metro
    );

    _positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      setState(() {
        _currentPosition = position;
      });

      if (_nearestBusStop != null) {
        final newDistance = _calculateDistance(
          LatLng(position.latitude, position.longitude),
          _nearestBusStop!,
        );

        setState(() {
          _distanceToStop = newDistance;
        });

        // Verificar si llegó a la parada (dentro de 10 metros)
        if (newDistance <= 10.0 && !_hasArrivedAtStop) {
          _onArrivedAtStop();
        }

        // Actualizar vista del mapa para seguir al usuario
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _mapController.move(
              LatLng(position.latitude, position.longitude),
              _mapController.camera.zoom,
            );
          }
        });
      }
    });
  }

  void _startPeriodicUpdates() {
    _updateTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted && _currentPosition != null && _nearestBusStop != null) {
        // Aquí podrías agregar lógica adicional como:
        // - Verificar horarios de buses
        // - Actualizar información de tráfico
        // - Recalcular ruta si es necesario
      }
    });
  }

  void _onArrivedAtStop() {
    setState(() {
      _hasArrivedAtStop = true;
    });

    _arrivalController.forward();

    // Mostrar celebración de llegada
    _showArrivalDialog();
  }

  void _showArrivalDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.celebration, color: Colors.green, size: 30),
            SizedBox(width: 10),
            Text('¡Has llegado!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '🎉 ¡Excelente! Has llegado a la parada de bus.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Ahora puedes esperar tu bus. Te recomendamos verificar los horarios y rutas disponibles.',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar diálogo
              NavigationService.popSafely(
                  context); // Volver a la página anterior
            },
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }

  double _calculateDistance(LatLng point1, LatLng point2) {
    return Geolocator.distanceBetween(
      point1.latitude,
      point1.longitude,
      point2.latitude,
      point2.longitude,
    );
  }

  String _getDistanceText() {
    if (_distanceToStop < 1000) {
      return '${_distanceToStop.toInt()} metros';
    } else {
      return '${(_distanceToStop / 1000).toStringAsFixed(1)} km';
    }
  }

  String _getNavigationMessage() {
    if (_hasArrivedAtStop) {
      return '¡Has llegado a la parada!';
    } else if (_distanceToStop <= 50) {
      return '¡Ya casi llegas! Sigue caminando.';
    } else if (_distanceToStop <= 100) {
      return 'Estás muy cerca de la parada.';
    } else if (_distanceToStop <= 200) {
      return 'Continúa hacia la parada de bus.';
    } else {
      return 'Dirígete hacia la parada más cercana.';
    }
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    _updateTimer?.cancel();
    _pulseController.dispose();
    _arrivalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Navegando a ${widget.destination.name}'),
        backgroundColor: const Color(0xFFFF6A00),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              if (_currentPosition != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    _mapController.move(
                      LatLng(_currentPosition!.latitude,
                          _currentPosition!.longitude),
                      16.0,
                    );
                  }
                });
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Mapa principal
          fm.FlutterMap(
            mapController: _mapController,
            options: fm.MapOptions(
              initialCenter: widget.userLocation,
              initialZoom: 16.0,
              interactionOptions: const fm.InteractionOptions(
                flags: fm.InteractiveFlag.all,
              ),
            ),
            children: [
              fm.TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.rouwhite',
              ),

              // Marcador de ubicación actual del usuario
              if (_currentPosition != null)
                fm.MarkerLayer(
                  markers: [
                    fm.Marker(
                      width: 60,
                      height: 60,
                      point: LatLng(_currentPosition!.latitude,
                          _currentPosition!.longitude),
                      child: AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _pulseAnimation.value,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue.withValues(alpha: 0.3),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.person_pin_circle,
                                  color: Colors.blue,
                                  size: 30,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

              // Marcador de la parada de bus más cercana
              if (_nearestBusStop != null)
                fm.MarkerLayer(
                  markers: [
                    fm.Marker(
                      width: 50,
                      height: 50,
                      point: _nearestBusStop!,
                      child: AnimatedBuilder(
                        animation: _hasArrivedAtStop
                            ? _arrivalAnimation
                            : _pulseAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _hasArrivedAtStop
                                ? _arrivalAnimation.value
                                : 1.0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: _hasArrivedAtStop
                                    ? Colors.green.withValues(alpha: 0.9)
                                    : const Color(0xFFFF6A00)
                                        .withValues(alpha: 0.9),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Icon(
                                _hasArrivedAtStop
                                    ? Icons.check_circle
                                    : Icons.directions_bus,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),

              // Línea de ruta entre usuario y parada
              if (_currentPosition != null && _nearestBusStop != null)
                fm.PolylineLayer(
                  polylines: [
                    fm.Polyline(
                      points: [
                        LatLng(_currentPosition!.latitude,
                            _currentPosition!.longitude),
                        _nearestBusStop!,
                      ],
                      strokeWidth: 4.0,
                      color: _hasArrivedAtStop
                          ? Colors.green
                          : const Color(0xFFFF6A00),
                    ),
                  ],
                ),
            ],
          ),

          // Panel de información en la parte superior
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        _hasArrivedAtStop
                            ? Icons.celebration
                            : Icons.navigation,
                        color: _hasArrivedAtStop
                            ? Colors.green
                            : const Color(0xFFFF6A00),
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _getNavigationMessage(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _hasArrivedAtStop
                                ? Colors.green
                                : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoCard(
                        icon: Icons.straighten,
                        label: 'Distancia',
                        value: _getDistanceText(),
                        color: Colors.blue,
                      ),
                      _buildInfoCard(
                        icon: Icons.access_time,
                        label: 'Tiempo est.',
                        value:
                            '${(_distanceToStop / 80).ceil()} min', // Asumiendo 80m/min caminando
                        color: Colors.orange,
                      ),
                      _buildInfoCard(
                        icon: Icons.directions_bus,
                        label: 'Parada',
                        value: 'Más cercana',
                        color: const Color(0xFFFF6A00),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Botón de acción en la parte inferior
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: ElevatedButton.icon(
              onPressed: _hasArrivedAtStop
                  ? () => NavigationService.popSafely(context)
                  : () {
                      if (_currentPosition != null && _nearestBusStop != null) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            _centerMapBetweenPoints(
                              LatLng(_currentPosition!.latitude,
                                  _currentPosition!.longitude),
                              _nearestBusStop!,
                            );
                          }
                        });
                      }
                    },
              icon: Icon(
                _hasArrivedAtStop ? Icons.check : Icons.center_focus_strong,
                color: Colors.white,
              ),
              label: Text(
                _hasArrivedAtStop ? 'Finalizar Navegación' : 'Centrar Vista',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _hasArrivedAtStop ? Colors.green : const Color(0xFFFF6A00),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

// Modelo para las paradas de bus
class BusStop {
  final String id;
  final String name;
  final LatLng coordinates;
  final List<String> routes;

  BusStop({
    required this.id,
    required this.name,
    required this.coordinates,
    required this.routes,
  });
}
