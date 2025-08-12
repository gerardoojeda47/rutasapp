import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapaRutaPagina extends StatefulWidget {
  final String routeName;
  final List<String> stops;

  const MapaRutaPagina({
    super.key,
    required this.routeName,
    required this.stops,
  });

  @override
  State<MapaRutaPagina> createState() => _MapaRutaPaginaState();
}

class _MapaRutaPaginaState extends State<MapaRutaPagina> {
  LatLng? myPosition;
  final MapController _mapController = MapController();
  List<LatLng> _routeStops = [];
  bool _isLoading = true;

  // Coordenadas simuladas para las paradas de Popayán
  final Map<String, LatLng> _stopCoordinates = {
    'Centro': const LatLng(2.4389, -76.6064),
    'La Paz': const LatLng(2.4450, -76.6100),
    'Jose María Obando': const LatLng(2.4400, -76.6000),
    'San Camilo': const LatLng(2.4350, -76.6050),
    'Campan': const LatLng(2.4500, -76.6150),
    'La Esmeralda': const LatLng(2.4550, -76.6200),
    'El Recuerdo': const LatLng(2.4600, -76.6250),
    'Terminal': const LatLng(2.4300, -76.5900),
    'El Uvo': const LatLng(2.4200, -76.5800),
    'San Eduardo': const LatLng(2.4250, -76.5850),
    'Bello Horizonte': const LatLng(2.4650, -76.6300),
    'El Placer': const LatLng(2.4700, -76.6350),
    'La Arboleda': const LatLng(2.4750, -76.6400),
    'Alfonso López': const LatLng(2.4800, -76.6450),
    'El Limonar': const LatLng(2.4850, -76.6500),
    'El Boquerón': const LatLng(2.4900, -76.6550),
    'La Floresta': const LatLng(2.4950, -76.6600),
    'El Lago': const LatLng(2.5000, -76.6650),
    'Gabriel G. Marqués': const LatLng(2.5050, -76.6700),
    'Los Sauces': const LatLng(2.5100, -76.6750),
    'La Campiña': const LatLng(2.5150, -76.6800),
    'María Oriente': const LatLng(2.5200, -76.6850),
    'La Primavera': const LatLng(2.5250, -76.6900),
    'Universidad': const LatLng(2.4400, -76.6000),
  };

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
    for (String stop in widget.stops) {
      if (_stopCoordinates.containsKey(stop)) {
        _routeStops.add(_stopCoordinates[stop]!);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    _setupRouteStops();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: Text(
          'Mapa: ${widget.routeName}',
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
                        color: Colors.black.withOpacity(0.1),
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
                            widget.routeName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF6A00),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${widget.stops.length} paradas • Ruta activa',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
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
                                    color: Colors.blue.withOpacity(0.3),
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

                      // Marcadores de paradas
                      MarkerLayer(
                        markers: _routeStops.asMap().entries.map((entry) {
                          int index = entry.key;
                          LatLng stop = entry.value;
                          String stopName = widget.stops[index];

                          return Marker(
                            point: stop,
                            child: GestureDetector(
                              onTap: () =>
                                  _showStopInfo(stopName, stop, index + 1),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF6A00),
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFFF6A00)
                                          .withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      // Línea de la ruta
                      if (_routeStops.length > 1)
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: _routeStops,
                              strokeWidth: 4,
                              color: const Color(0xFFFF6A00).withOpacity(0.7),
                            ),
                          ],
                        ),
                    ],
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

    _mapController.fitBounds(bounds);
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
                    color: const Color(0xFFFF6A00).withOpacity(0.1),
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
                        'Parada ${stopNumber} de ${widget.stops.length}',
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
}
