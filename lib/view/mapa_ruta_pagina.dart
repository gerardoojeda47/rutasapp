import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapaRutaPagina extends StatelessWidget {
  final String routeName;
  final List<String> stops; // Lista de nombres de barrios/paradas

  const MapaRutaPagina({
    super.key,
    required this.routeName,
    required this.stops,
  });

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
  Widget build(BuildContext context) {
    // Obtener las coordenadas de las paradas
    final List<LatLng> points = stops
        .map((name) => _barriosCoords[name])
        .where((coord) => coord != null)
        .cast<LatLng>()
        .toList();

    final LatLng initialPosition = points.isNotEmpty
        ? points.first
        : LatLng(2.444814, -76.614739); // Centro de Popayán por defecto

    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa de $routeName'),
        backgroundColor: const Color(0xFFFF6A00),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: initialPosition,
          zoom: 13.5,
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
                points: points,
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
                  child: Icon(
                    i == 0
                        ? Icons.location_on
                        : (i == points.length - 1
                            ? Icons.flag
                            : Icons.circle),
                    color: i == 0
                        ? Colors.green
                        : (i == points.length - 1
                            ? Colors.red
                            : Colors.orange),
                    size: 36,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
} 