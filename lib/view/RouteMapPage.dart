import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteMapPage extends StatefulWidget {
  final String routeName;
  final List<String> stops; // Lista de nombres de barrios/paradas

  const RouteMapPage({
    super.key,
    required this.routeName,
    required this.stops,
  });

  @override
  State<RouteMapPage> createState() => _RouteMapPageState();
}

class _RouteMapPageState extends State<RouteMapPage> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  // Coordenadas de ejemplo para algunos barrios de Popayán
  final Map<String, LatLng> _barriosCoords = {
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
    _setMarkersAndPolyline();
  }

  void _setMarkersAndPolyline() {
    final List<LatLng> points = [];
    _markers.clear();
    for (int i = 0; i < widget.stops.length; i++) {
      final name = widget.stops[i];
      final coord = _barriosCoords[name];
      if (coord != null) {
        points.add(coord);
        _markers.add(
          Marker(
            markerId: MarkerId(name),
            position: coord,
            infoWindow: InfoWindow(title: name),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              i == 0
                  ? BitmapDescriptor.hueGreen
                  : (i == widget.stops.length - 1
                      ? BitmapDescriptor.hueRed
                      : BitmapDescriptor.hueOrange),
            ),
          ),
        );
      }
    }
    if (points.length > 1) {
      _polylines.clear();
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          color: Colors.orange,
          width: 5,
          points: points,
        ),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final LatLng initialPosition = _barriosCoords[widget.stops.first] ?? LatLng(2.444814, -76.614739);
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa de ${widget.routeName}'),
        backgroundColor: const Color(0xFFFF6A00),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: initialPosition,
          zoom: 13.5,
        ),
        markers: _markers,
        polylines: _polylines,
        onMapCreated: (controller) {
          _mapController = controller;
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
} 