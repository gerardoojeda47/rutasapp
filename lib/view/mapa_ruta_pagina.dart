import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

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
  late final MapController _mapController;
  bool _loadingLocation = false;
  LatLng? _userLocation;
  int? _selectedStopIndex;

  // Para la ruta realista
  List<LatLng> _routePoints = [];
  List _instructions = [];
  bool _loadingRoute = true;
  final String _apiKey = 'TU_API_KEY_AQUI'; // <-- PON AQUÍ TU API KEY DE OPENROUTESERVICE

  // Coordenadas de ejemplo para algunos barrios de Popayán
  static final Map<String, LatLng> _barriosCoords = {
    'Centro': LatLng(2.444814, -76.614739),
    'La Paz': LatLng(2.449000, -76.601000),
    'Jose María Obando': LatLng(2.453000, -76.599000),
    'San Camilo': LatLng(2.447500, -76.610000),
    'La Esmeralda': LatLng(2.440000, -76.600000),
    'Campan': LatLng(2.441500, -76.602500),
    'El Recuerdo': LatLng(2.442500, -76.605000),
    'Terminal': LatLng(2.445000, -76.617000),
    'El Uvo': LatLng(2.455000, -76.620000),
    'San Eduardo': LatLng(2.457000, -76.618000),
    'Bello Horizonte': LatLng(2.438000, -76.610000),
    'El Placer': LatLng(2.437000, -76.612000),
    'Alfonso López': LatLng(2.435000, -76.615000),
    'El Limonar': LatLng(2.433000, -76.617000),
    'El Boquerón': LatLng(2.431000, -76.619000),
    'La Floresta': LatLng(2.450000, -76.608000),
    'Los Sauces': LatLng(2.452000, -76.606000),
    'La Campiña': LatLng(2.454000, -76.604000),
    'María Oriente': LatLng(2.456000, -76.602000),
    'Santa Mónica': LatLng(2.448000, -76.611000),
    'El Lago': LatLng(2.447000, -76.613000),
    'Berlín': LatLng(2.446000, -76.615000),
    'Suizo': LatLng(2.445000, -76.617000),
    'Las Ferias': LatLng(2.444000, -76.619000),
    'Los Andes': LatLng(2.443000, -76.621000),
    'Alameda': LatLng(2.442000, -76.623000),
    'Colgate Palmolive': LatLng(2.441000, -76.625000),
    'Plateado': LatLng(2.440000, -76.627000),
    'Poblado Altos Sauces': LatLng(2.439000, -76.629000),
  };

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _fetchRoute();
  }

  Future<void> _getUserLocation() async {
    setState(() => _loadingLocation = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _userLocation = LatLng(2.444814, -76.614739); // Simula ubicación
      _loadingLocation = false;
    });
    _mapController.move(_userLocation!, 15);
  }

  Future<void> _fetchRoute() async {
    setState(() => _loadingRoute = true);
    final points = widget.stops
        .map((name) => _barriosCoords[name])
        .where((coord) => coord != null)
        .cast<LatLng>()
        .toList();
    if (points.length < 2) {
      setState(() {
        _routePoints = points;
        _instructions = [];
        _loadingRoute = false;
      });
      return;
    }
    try {
      final result = await getMultiStopRoute(stops: points, apiKey: _apiKey);
      setState(() {
        _routePoints = result['route'];
        _instructions = result['instructions'];
        _loadingRoute = false;
      });
    } catch (e) {
      setState(() {
        _routePoints = points;
        _instructions = [];
        _loadingRoute = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error obteniendo la ruta: $e')),
      );
    }
  }

  Future<Map<String, dynamic>> getMultiStopRoute({
    required List<LatLng> stops,
    required String apiKey,
  }) async {
    final coords = stops.map((p) => [p.longitude, p.latitude]).toList();
    final url = Uri.parse('https://api.openrouteservice.org/v2/directions/driving-car/geojson');
    final response = await http.post(
      url,
      headers: {
        'Authorization': apiKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'coordinates': coords,
        'instructions': true,
        'geometry_simplify': false,
      }),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<LatLng> routePoints = (data['features'][0]['geometry']['coordinates'] as List)
          .map<LatLng>((c) => LatLng(c[1], c[0]))
          .toList();
      final List instructions = data['features'][0]['properties']['segments'][0]['steps'];
      return {
        'route': routePoints,
        'instructions': instructions,
      };
    } else {
      throw Exception('Error obteniendo la ruta: ${response.body}');
    }
  }

  void _showStopInfo(int index, String name, LatLng coord) {
    setState(() => _selectedStopIndex = index);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Coordenadas: ${coord.latitude.toStringAsFixed(6)}, ${coord.longitude.toStringAsFixed(6)}'),
            if (index == 0)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text('Origen de la ruta', style: TextStyle(color: Colors.green)),
              ),
            if (index == widget.stops.length - 1)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text('Destino final', style: TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    ).whenComplete(() => setState(() => _selectedStopIndex = null));
  }

  void _showInstructions() {
    if (_instructions.isEmpty) return;
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView.builder(
        itemCount: _instructions.length,
        itemBuilder: (context, i) {
          final step = _instructions[i];
          return ListTile(
            leading: const Icon(Icons.directions),
            title: Text(step['instruction'] ?? ''),
            subtitle: Text('Distancia: ${step['distance']?.toStringAsFixed(0) ?? ''} m'),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<LatLng> points = widget.stops
        .map((name) => _barriosCoords[name])
        .where((coord) => coord != null)
        .cast<LatLng>()
        .toList();

    final LatLng initialPosition = points.isNotEmpty
        ? points.first
        : LatLng(2.444814, -76.614739);

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: initialPosition,
              zoom: 13.5,
              onTap: (_, __) {
                Navigator.of(context).maybePop();
              },
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.rouwhite',
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _routePoints.isNotEmpty ? _routePoints : points,
                    color: Colors.orange,
                    strokeWidth: 5.0,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  for (int i = 0; i < points.length; i++)
                    Marker(
                      width: 60.0,
                      height: 60.0,
                      point: points[i],
                      child: GestureDetector(
                        onTap: () => _showStopInfo(i, widget.stops[i], points[i]),
                        child: Icon(
                          i == 0
                              ? Icons.location_on
                              : (i == points.length - 1
                                  ? Icons.flag
                                  : (_selectedStopIndex == i ? Icons.directions : Icons.circle)),
                          color: i == 0
                              ? Colors.green
                              : (i == points.length - 1
                                  ? Colors.red
                                  : (_selectedStopIndex == i ? Colors.blue : Colors.orange)),
                          size: 36,
                        ),
                      ),
                    ),
                  if (_userLocation != null)
                    Marker(
                      width: 60,
                      height: 60,
                      point: _userLocation!,
                      child: const Icon(Icons.person_pin_circle, color: Colors.blue, size: 36),
                    ),
                ],
              ),
            ],
          ),
          // Botón de regreso flotante
          Positioned(
            top: 40,
            left: 16,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 2,
              onPressed: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back),
            ),
          ),
          // Botón para centrar en usuario
          Positioned(
            bottom: 40,
            right: 16,
            child: FloatingActionButton(
              heroTag: 'centerUser',
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              onPressed: _getUserLocation,
              child: const Icon(Icons.my_location),
            ),
          ),
          // Botones de zoom
          Positioned(
            bottom: 110,
            right: 16,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'zoomIn',
                  mini: true,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  onPressed: () => _mapController.move(_mapController.center, _mapController.zoom + 1),
                  child: const Icon(Icons.add),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'zoomOut',
                  mini: true,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  onPressed: () => _mapController.move(_mapController.center, _mapController.zoom - 1),
                  child: const Icon(Icons.remove),
                ),
              ],
            ),
          ),
          // Botón para ver instrucciones
          Positioned(
            bottom: 180,
            right: 16,
            child: FloatingActionButton(
              heroTag: 'instructions',
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              onPressed: _showInstructions,
              child: const Icon(Icons.list),
            ),
          ),
          // Indicador de carga de ubicación o ruta
          if (_loadingLocation || _loadingRoute)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
} 