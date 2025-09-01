// cSpell:locale es
// Página del mapa de rutas de buses en Popayán, Colombia
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../data/popayan_bus_routes.dart';

class MapaRutaPagina extends StatefulWidget {
  final BusRoute route;

  const MapaRutaPagina({
    super.key,
    required this.route,
  });

  @override
  State<MapaRutaPagina> createState() => _MapaRutaPaginaState();
}

class _MapaRutaPaginaState extends State<MapaRutaPagina>
    with TickerProviderStateMixin {
  LatLng? myPosition;
  final MapController _mapController = MapController();
  List<LatLng> _routeStops = [];
  bool _isLoading = true;

  // Animación del bus
  late AnimationController _busAnimationController;
  late Animation<double> _busAnimation;
  LatLng? _currentBusPosition;
  Timer? _busTimer;
  bool _isAnimating = false;
  late AnimationController _pulseController;

  // Animaciones futuristas
  late AnimationController _neonController;
  late AnimationController _waveController;
  late AnimationController _particleController;
  late Animation<double> _neonAnimation;
  late Animation<double> _waveAnimation;
  late Animation<double> _particleAnimation;
  List<LatLng> _energyParticles = [];

  Future<Position> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Permisos de ubicación denegados');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Permisos de ubicación denegados permanentemente');
    }

    return await Geolocator.getCurrentPosition();
  }

  Color _parseRouteColor() {
    try {
      String colorHex = widget.route.color;
      if (colorHex.startsWith('#')) {
        colorHex = colorHex.substring(1);
      }
      return Color(int.parse('FF$colorHex', radix: 16));
    } catch (e) {
      // Color por defecto si hay error
      return const Color(0xFFFF6A00);
    }
  }

  void getCurrentLocation() async {
    try {
      Position position = await determinePosition();
      setState(() {
        myPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });
    } catch (e) {
      // Si no se puede obtener la ubicación, usar coordenadas por defecto de Popayán
      setState(() {
        myPosition = const LatLng(2.4389, -76.6064); // Centro de Popayán
        _isLoading = false;
      });
    }
  }

  void _setupRouteStops() {
    _routeStops.clear();
    // Generar ruta realista con waypoints siguiendo las calles
    _routeStops.addAll(_generateRealisticRoute(widget.route));
  }

  /// Genera una ruta realista usando waypoints específicos de Popayán
  List<LatLng> _generateRealisticRoute(BusRoute route) {
    List<LatLng> smoothRoute = [];

    // Puntos clave de las calles principales de Popayán
    final Map<String, LatLng> streetIntersections = {
      'parque_caldas': const LatLng(2.4448, -76.6147),
      'carrera_5_calle_5': const LatLng(2.4448, -76.6140),
      'carrera_6_calle_5': const LatLng(2.4448, -76.6145),
      'carrera_9_calle_5': const LatLng(2.4448, -76.6120),
      'carrera_5_norte': const LatLng(2.4480, -76.6140),
      'carrera_5_sur': const LatLng(2.4420, -76.6140),
      'terminal_area': const LatLng(2.4500, -76.6170),
      'campanario_area': const LatLng(2.4448, -76.6147),
    };

    // Agregar el primer punto
    if (route.stops.isNotEmpty) {
      smoothRoute.add(route.stops.first);
    }

    // Crear rutas que sigan las calles principales
    for (int i = 0; i < route.stops.length - 1; i++) {
      LatLng start = route.stops[i];
      LatLng end = route.stops[i + 1];

      // Crear ruta que siga las calles principales
      List<LatLng> streetRoute =
          _createStreetBasedRoute(start, end, streetIntersections);
      smoothRoute.addAll(streetRoute);

      // Agregar el punto final
      smoothRoute.add(end);
    }

    return smoothRoute;
  }

  /// Crea una ruta que sigue las calles principales de Popayán
  List<LatLng> _createStreetBasedRoute(
      LatLng start, LatLng end, Map<String, LatLng> intersections) {
    List<LatLng> route = [];

    // Determinar si necesitamos usar intersecciones intermedias
    double distance = _calculateDistance(start, end);

    if (distance > 0.008) {
      // Para distancias largas, usar intersecciones
      // Encontrar la mejor intersección intermedia
      LatLng? bestIntersection =
          _findBestIntersection(start, end, intersections);

      if (bestIntersection != null) {
        // Crear ruta: inicio -> intersección -> final
        route.addAll(_createDirectStreetPath(start, bestIntersection));
        route.add(bestIntersection);
        route.addAll(_createDirectStreetPath(bestIntersection, end));
      } else {
        // Si no hay intersección buena, crear ruta directa con curvas suaves
        route.addAll(_createDirectStreetPath(start, end));
      }
    } else {
      // Para distancias cortas, ruta directa con curvas suaves
      route.addAll(_createDirectStreetPath(start, end));
    }

    return route;
  }

  /// Encuentra la mejor intersección intermedia entre dos puntos
  LatLng? _findBestIntersection(
      LatLng start, LatLng end, Map<String, LatLng> intersections) {
    LatLng? bestIntersection;
    double bestScore = double.infinity;

    for (LatLng intersection in intersections.values) {
      // Calcular si la intersección está en una buena posición intermedia
      double distToStart = _calculateDistance(start, intersection);
      double distToEnd = _calculateDistance(intersection, end);
      double directDist = _calculateDistance(start, end);

      // La intersección debe estar relativamente cerca de la línea directa
      double totalDist = distToStart + distToEnd;
      double efficiency = totalDist / directDist;

      // Preferir intersecciones que no desvíen mucho la ruta
      if (efficiency < 1.5 && efficiency < bestScore) {
        bestScore = efficiency;
        bestIntersection = intersection;
      }
    }

    return bestIntersection;
  }

  /// Crea un camino directo entre dos puntos siguiendo las calles
  List<LatLng> _createDirectStreetPath(LatLng start, LatLng end) {
    List<LatLng> path = [];

    double latDiff = end.latitude - start.latitude;
    double lngDiff = end.longitude - start.longitude;
    double distance = sqrt(latDiff * latDiff + lngDiff * lngDiff);

    // Número de puntos intermedios basado en la distancia
    int numPoints = (distance * 8000).round().clamp(3, 12);

    for (int i = 1; i < numPoints; i++) {
      double t = i / numPoints;

      // Determinar si seguir carrera (norte-sur) o calle (este-oeste)
      if (latDiff.abs() > lngDiff.abs()) {
        // Movimiento principalmente norte-sur: seguir carrera
        path.addAll(_createCarreraPath(start, end, t));
      } else {
        // Movimiento principalmente este-oeste: seguir calle
        path.addAll(_createCallePath(start, end, t));
      }
    }

    return path;
  }

  /// Crea puntos siguiendo una carrera (calle vertical)
  List<LatLng> _createCarreraPath(LatLng start, LatLng end, double t) {
    List<LatLng> points = [];

    double latDiff = end.latitude - start.latitude;
    double lngDiff = end.longitude - start.longitude;

    // Primero moverse en latitud (norte-sur por la carrera)
    double midLat = start.latitude + (latDiff * t);
    double midLng =
        start.longitude + (lngDiff * 0.2 * t); // Pequeño ajuste en longitud

    points.add(LatLng(midLat, midLng));

    return points;
  }

  /// Crea puntos siguiendo una calle (calle horizontal)
  List<LatLng> _createCallePath(LatLng start, LatLng end, double t) {
    List<LatLng> points = [];

    double latDiff = end.latitude - start.latitude;
    double lngDiff = end.longitude - start.longitude;

    // Primero moverse en longitud (este-oeste por la calle)
    double midLat =
        start.latitude + (latDiff * 0.2 * t); // Pequeño ajuste en latitud
    double midLng = start.longitude + (lngDiff * t);

    points.add(LatLng(midLat, midLng));

    return points;
  }

  /// Calcula la distancia entre dos puntos
  double _calculateDistance(LatLng point1, LatLng point2) {
    double latDiff = point1.latitude - point2.latitude;
    double lngDiff = point1.longitude - point2.longitude;
    return sqrt(latDiff * latDiff + lngDiff * lngDiff);
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    _setupRouteStops();
    _initializeBusAnimation();
  }

  void _initializeBusAnimation() {
    _busAnimationController = AnimationController(
      duration:
          const Duration(seconds: 30), // 30 segundos para recorrer toda la ruta
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2), // Pulso cada 2 segundos
      vsync: this,
    )..repeat(reverse: true);

    _busAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _busAnimationController,
      curve: Curves.easeInOut, // Curva más suave
    ));

    _busAnimation.addListener(() {
      if (_routeStops.isNotEmpty) {
        _updateBusPosition();
      }
    });

    _busAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Reiniciar la animación después de una pausa
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            _busAnimationController.reset();
            _busAnimationController.forward();
          }
        });
      }
    });

    // Inicializar animaciones futuristas
    _initializeFuturisticAnimations();
  }

  void _initializeFuturisticAnimations() {
    // Animación de neón pulsante
    _neonController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _neonAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _neonController,
      curve: Curves.easeInOut,
    ));

    // Animación de ondas
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeOut,
    ));

    // Animación de partículas
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat();

    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _particleController,
      curve: Curves.easeInOut,
    ));

    // Generar partículas de energía
    _generateEnergyParticles();
  }

  void _generateEnergyParticles() {
    _energyParticles.clear();
    if (_routeStops.isNotEmpty) {
      for (int i = 0; i < _routeStops.length; i += 3) {
        _energyParticles.add(_routeStops[i]);
      }
    }
  }

  void _updateBusPosition() {
    if (_routeStops.isEmpty) return;

    double progress = _busAnimation.value;
    int totalPoints = _routeStops.length;
    double exactIndex = progress * (totalPoints - 1);
    int currentIndex = exactIndex.floor();
    double fraction = exactIndex - currentIndex;

    if (currentIndex >= totalPoints - 1) {
      setState(() {
        _currentBusPosition = _routeStops.last;
      });
      debugPrint('🚌 Bus llegó al final: ${_routeStops.last}');
      return;
    }

    LatLng currentPoint = _routeStops[currentIndex];
    LatLng nextPoint = _routeStops[currentIndex + 1];

    // Interpolación entre puntos
    double lat = currentPoint.latitude +
        (nextPoint.latitude - currentPoint.latitude) * fraction;
    double lng = currentPoint.longitude +
        (nextPoint.longitude - currentPoint.longitude) * fraction;

    setState(() {
      _currentBusPosition = LatLng(lat, lng);
    });

    // Log cada 10% del progreso
    if ((progress * 10).toInt() != ((progress - 0.01) * 10).toInt()) {
      debugPrint('🚌 Bus en progreso ${(progress * 100).toInt()}%: $lat, $lng');
    }
  }

  void _startBusAnimation() {
    if (!_isAnimating && _routeStops.isNotEmpty) {
      setState(() {
        _isAnimating = true;
        _currentBusPosition = _routeStops.first;
      });
          debugPrint('🚌 Iniciando animación del bus en: ${_routeStops.first}');
    debugPrint('🚌 Total de puntos en la ruta: ${_routeStops.length}');
      _busAnimationController.forward();
    }
  }

  void _stopBusAnimation() {
    setState(() {
      _isAnimating = false;
    });
    _busAnimationController.stop();
  }

  @override
  void dispose() {
    _busAnimationController.dispose();
    _pulseController.dispose();
    _neonController.dispose();
    _waveController.dispose();
    _particleController.dispose();
    _busTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: Text(
          'Mapa: ${widget.route.name}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFFF6A00),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(_isAnimating ? Icons.pause : Icons.play_arrow),
            onPressed: () {
                  debugPrint('🚌 Botón presionado - Animando: $_isAnimating');
    debugPrint('🚌 Posición actual del bus: $_currentBusPosition');
    debugPrint('🚌 Puntos de ruta: ${_routeStops.length}');
              if (_isAnimating) {
                _stopBusAnimation();
              } else {
                _startBusAnimation();
              }
            },
            tooltip: _isAnimating ? 'Pausar animación' : 'Iniciar animación',
          ),
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () {
              if (myPosition != null) {
                _mapController.move(myPosition!, 18);
              }
            },
            tooltip: 'Mi ubicación',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFFFF6A00)),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Cargando mapa...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Información de la ruta
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.directions_bus,
                            color: const Color(0xFFFF6A00),
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.route.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _parseRouteColor(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '${widget.route.neighborhoods.length} paradas • Ruta activa',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const Spacer(),
                          if (_isAnimating)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(
                                        Icons.directions_bus,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'En ruta',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _parseRouteColor()
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: _parseRouteColor()
                                          .withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.speed,
                                        color: _parseRouteColor(),
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${(_busAnimation.value * 100).toInt()}%',
                                        style: TextStyle(
                                          color: _parseRouteColor(),
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Mapa
                Expanded(
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: myPosition!,
                      initialZoom: 15,
                      minZoom: 10,
                      maxZoom: 20,
                      onMapReady: () {
                        // Ajustar vista para mostrar toda la ruta
                        if (_routeStops.isNotEmpty) {
                          _fitBoundsToRoute();
                        }
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.rutasapp',
                      ),

                      // Marcador de mi ubicación
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: myPosition!,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.person_pin,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Marcador del bus animado - SÚPER VISIBLE
                      if (_currentBusPosition != null)
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: _currentBusPosition!,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.red, // Color súper visible
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 3),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.red.withValues(alpha: 0.6),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.3),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.directions_bus,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),

                      // Marcadores de paradas mejorados con alta visibilidad
                      MarkerLayer(
                        markers:
                            widget.route.stops.asMap().entries.map((entry) {
                          int index = entry.key;
                          LatLng stop = entry.value;
                          String stopName =
                              index < widget.route.neighborhoods.length
                                  ? widget.route.neighborhoods[index]
                                  : 'Parada ${index + 1}';

                          bool isFirstStop = index == 0;
                          bool isLastStop =
                              index == widget.route.stops.length - 1;

                          return Marker(
                            point: stop,
                            child: GestureDetector(
                              onTap: () =>
                                  _showStopInfo(stopName, stop, index + 1),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Círculo de fondo con efecto de pulso
                                  Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      color: isFirstStop
                                          ? Colors.green.withValues(alpha: 0.2)
                                          : isLastStop
                                              ? Colors.red
                                                  .withValues(alpha: 0.2)
                                              : _parseRouteColor()
                                                  .withValues(alpha: 0.2),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  // Marcador principal
                                  Container(
                                    width: 28,
                                    height: 28,
                                    decoration: BoxDecoration(
                                      color: isFirstStop
                                          ? Colors.green
                                          : isLastStop
                                              ? Colors.red
                                              : _parseRouteColor(),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white, width: 4),
                                      boxShadow: [
                                        BoxShadow(
                                          color: (isFirstStop
                                                  ? Colors.green
                                                  : isLastStop
                                                      ? Colors.red
                                                      : _parseRouteColor())
                                              .withValues(alpha: 0.5),
                                          blurRadius: 15,
                                          offset: const Offset(0, 5),
                                        ),
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.2),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: isFirstStop
                                          ? const Icon(
                                              Icons.play_arrow,
                                              color: Colors.white,
                                              size: 14,
                                            )
                                          : isLastStop
                                              ? const Icon(
                                                  Icons.stop,
                                                  color: Colors.white,
                                                  size: 14,
                                                )
                                              : Text(
                                                  '${index + 1}',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      // Líneas de la ruta - Estilo futurista con efectos de neón
                      if (_routeStops.length > 1) ...[
                        // Capa de efectos futuristas
                        AnimatedBuilder(
                          animation: _neonAnimation,
                          builder: (context, child) {
                            return PolylineLayer(
                              polylines: [
                                // Efecto de onda expansiva desde el bus
                                if (_isAnimating && _currentBusPosition != null)
                                  Polyline(
                                    points: _createWaveEffect(
                                        _currentBusPosition!, _waveAnimation.value * 0.01),
                                    strokeWidth:
                                        12 * (1 - _waveAnimation.value),
                                    color: _parseRouteColor().withValues(
                                      alpha:
                                          0.3 * (1 - _waveAnimation.value),
                                    ),
                                  ),

                                // Sombra exterior con efecto de resplandor
                                Polyline(
                                  points: _routeStops,
                                  strokeWidth: 12 + (4 * _neonAnimation.value),
                                  color: _parseRouteColor().withValues(
                                    alpha: 0.1 + (0.1 * _neonAnimation.value),
                                  ),
                                ),

                                // Línea de base con gradiente
                                Polyline(
                                  points: _routeStops,
                                  strokeWidth: 8,
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),

                                // Línea principal con efecto neón pulsante
                                Polyline(
                                  points: _routeStops,
                                  strokeWidth: 6,
                                  color: _parseRouteColor().withValues(
                                    alpha: 0.7 + (0.3 * _neonAnimation.value),
                                  ),
                                ),

                                // Línea central brillante
                                Polyline(
                                  points: _routeStops,
                                  strokeWidth: 2 + (1 * _neonAnimation.value),
                                  color: Colors.white.withValues(
                                    alpha: 0.8 + (0.2 * _neonAnimation.value),
                                  ),
                                ),

                                // Efecto de progreso futurista
                                if (_isAnimating &&
                                    _currentBusPosition != null) ...[
                                  // Resplandor del progreso con pulso
                                  Polyline(
                                    points: _getProgressRoute(),
                                    strokeWidth:
                                        15 + (5 * _neonAnimation.value),
                                    color: Colors.cyan.withValues(
                                      alpha: 0.2 + (0.2 * _neonAnimation.value),
                                    ),
                                  ),

                                  // Línea de progreso principal brillante
                                  Polyline(
                                    points: _getProgressRoute(),
                                    strokeWidth: 8,
                                    color: Colors.cyan.withValues(alpha: 0.9),
                                  ),

                                  // Núcleo del progreso ultra brillante
                                  Polyline(
                                    points: _getProgressRoute(),
                                    strokeWidth: 3,
                                    color: Colors.white,
                                  ),

                                  // Efecto de chispas en el progreso
                                  // Nota: _createSparkEffect() devuelve Widgets, no Polylines
                                ],
                              ],
                            );
                          },
                        ),

                        // Partículas de energía flotantes
                        if (_isAnimating)
                          AnimatedBuilder(
                            animation: _particleAnimation,
                            builder: (context, child) {
                              return PolylineLayer(
                                polylines: _createEnergyParticles(),
                              );
                            },
                          ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
      bottomSheet: _isAnimating
          ? Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.95),
                    Colors.white,
                  ],
                ),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Barra de progreso moderna
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          AnimatedBuilder(
                            animation: _busAnimation,
                            builder: (context, child) {
                              return FractionallySizedBox(
                                widthFactor: _busAnimation.value,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        _parseRouteColor()
                                            .withValues(alpha: 0.7),
                                        _parseRouteColor(),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Información del bus
                    Row(
                      children: [
                        // Icono del bus animado
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: _parseRouteColor(),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    _parseRouteColor().withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.directions_bus,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Información de progreso
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bus ${widget.route.name.split(' ')[1]} en movimiento',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: _parseRouteColor(),
                                ),
                              ),
                              const SizedBox(height: 4),
                              AnimatedBuilder(
                                animation: _busAnimation,
                                builder: (context, child) {
                                  return Text(
                                    'Progreso: ${(_busAnimation.value * 100).toInt()}% • ${widget.route.neighborhoods.length} paradas',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        // Botón de control
                        Container(
                          decoration: BoxDecoration(
                            color: _parseRouteColor().withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            onPressed: () {
                              if (_isAnimating) {
                                _stopBusAnimation();
                              } else {
                                _startBusAnimation();
                              }
                            },
                            icon: Icon(
                              _isAnimating ? Icons.pause : Icons.play_arrow,
                              color: _parseRouteColor(),
                              size: 28,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : null,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (!_isAnimating)
            FloatingActionButton(
              heroTag: "bus_animation",
              onPressed: _startBusAnimation,
              backgroundColor: _parseRouteColor(),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
              ),
            ),
          if (!_isAnimating) const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: "center_route",
            onPressed: _fitBoundsToRoute,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.center_focus_strong,
              color: _parseRouteColor(),
            ),
          ),
        ],
      ),
    );
  }

  void _fitBoundsToRoute() {
    if (_routeStops.isEmpty) return;

    double minLat =
        _routeStops.map((p) => p.latitude).reduce((a, b) => a < b ? a : b);
    double maxLat =
        _routeStops.map((p) => p.latitude).reduce((a, b) => a > b ? a : b);
    double minLng =
        _routeStops.map((p) => p.longitude).reduce((a, b) => a < b ? a : b);
    double maxLng =
        _routeStops.map((p) => p.longitude).reduce((a, b) => a > b ? a : b);

    // Agregar margen
    double latMargin = (maxLat - minLat) * 0.1;
    double lngMargin = (maxLng - minLng) * 0.1;

    LatLngBounds bounds = LatLngBounds(
      LatLng(minLat - latMargin, minLng - lngMargin),
      LatLng(maxLat + latMargin, maxLng + lngMargin),
    );

    _mapController.fitCamera(CameraFit.bounds(bounds: bounds));

    // Iniciar la animación automáticamente después de ajustar la vista
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted && !_isAnimating) {
        debugPrint('🚌 Iniciando animación automática...');
        _startBusAnimation();
      }
    });
  }

  /// Obtiene la parte de la ruta que ya ha sido recorrida por el bus
  List<LatLng> _getProgressRoute() {
    if (_routeStops.isEmpty || _currentBusPosition == null) {
      return [];
    }

    List<LatLng> progressRoute = [];
    double progress = _busAnimation.value;
    int totalPoints = _routeStops.length;
    double exactIndex = progress * (totalPoints - 1);
    int currentIndex = exactIndex.floor();

    // Agregar todos los puntos hasta el índice actual
    for (int i = 0; i <= currentIndex && i < _routeStops.length; i++) {
      progressRoute.add(_routeStops[i]);
    }

    // Agregar la posición actual del bus
    if (_currentBusPosition != null) {
      progressRoute.add(_currentBusPosition!);
    }

    return progressRoute;
  }

  void _showStopInfo(String stopName, LatLng position, int stopNumber) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6A00).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$stopNumber',
                    style: const TextStyle(
                      color: Color(0xFFFF6A00),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stopName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Parada ${stopNumber} de ${widget.route.neighborhoods.length}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: const Color(0xFFFF6A00),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Coordenadas: ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _mapController.move(position, 18);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6A00),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Centrar en esta parada',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Crea efecto de onda expansiva desde la posición del bus
  List<LatLng> _createWaveEffect(LatLng center, double radius) {
    final List<LatLng> wavePoints = [];
    const int segments = 16;
    
    for (int i = 0; i <= segments; i++) {
      final angle = (i * 2 * pi) / segments;
      final lat = center.latitude + (radius * cos(angle));
      final lng = center.longitude + (radius * sin(angle));
      wavePoints.add(LatLng(lat, lng));
    }
    
    return wavePoints;
  }



  /// Crea partículas de energía flotantes
  List<Polyline> _createEnergyParticles() {
    return List.generate(8, (index) {
      final progress = _particleAnimation.value;
      final offset = (index * 0.125) + progress;
      final x = 200 + (100 * (offset % 1.0));
      final y = 150 + (50 * (offset % 1.0));
      
      return Polyline(
        points: [
          LatLng(x, y),
          LatLng(x + 2, y + 2),
        ],
        color: Colors.blue.withValues(alpha: 0.6),
        strokeWidth: 2,
      );
    });
    }
}
