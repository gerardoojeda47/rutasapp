import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import 'rutas_pagina.dart';
import 'paradas_pagina.dart';
import 'smart_search_page.dart';
import 'widgets/animated_markers.dart';
import '../model/favoritos.dart';
import '../view/driver/driver.dart';
import '../core/utils/icon_helper.dart';
import 'pqr_pagina.dart';

class Homepage extends StatefulWidget {
  final String username;
  const Homepage({super.key, required this.username});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _currentIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomeContent(),
      const RutasPagina(),
      const ParadasPagina(),
      FavoritosPagina(
        onRemoveFavorito: (_) {
          setState(() {}); // Refresca la pantalla principal
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: PopupMenuButton<String>(
          icon: const Icon(IconHelper.menu),
          onSelected: (value) {
            if (value == 'conductor') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Driver(),
                ),
              );
            } else if (value == 'pqr') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PqrPagina(),
                ),
              );
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'conductor',
              child: ListTile(
                leading: Icon(IconHelper.driver),
                title: Text('Conductor'),
              ),
            ),
                        const PopupMenuItem(
              value: 'pqr',
              child: ListTile(
                leading: Icon(IconHelper.pqr),
                title: Text('PQR'),
              ),
            ),
          ],
        ),
        title: const Text(
          'ROUWHITE',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFF6A00),
        elevation: 0,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFFF6A00),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(IconHelper.home), label: 'Inicio'),
          BottomNavigationBarItem(
            icon: Icon(IconHelper.routes),
            label: 'Rutas',
          ),
          BottomNavigationBarItem(
            icon: Icon(IconHelper.stops),
            label: 'Paradas',
          ),
          BottomNavigationBarItem(icon: Icon(IconHelper.favorites), label: 'favoritos'),
        ],
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  Position? _currentPosition;
  bool _isLoadingLocation = true;
  final fm.MapController _mapController = fm.MapController();

  // Coordenadas de Popayán como fallback
  static const LatLng _popayanCenter = LatLng(2.444814, -76.614739);

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Verificar permisos de ubicación
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _isLoadingLocation = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _isLoadingLocation = false;
        });
        return;
      }

      // Obtener ubicación actual
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      setState(() {
        _currentPosition = position;
        _isLoadingLocation = false;
      });

      // Centrar el mapa en la ubicación del usuario
      _mapController.move(
        LatLng(position.latitude, position.longitude),
        15.0,
      );
    } catch (e) {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  void _centerOnUserLocation() {
    if (_currentPosition != null) {
      _mapController.move(
        LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        15.0,
      );
    }
  }

  void _mostrarNavegacionDetallada() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SmartSearchPage(),
      ),
    );
  }

  // Método para obtener marcadores de puntos de interés
  List<fm.Marker> _getPOIMarkers() {
    return [
      // HOSPITALES
      fm.Marker(
        width: 40,
        height: 40,
        point: const LatLng(2.4427, -76.6064),
        child: const InterestPointMarker(
          size: 30,
          color: Colors.red,
          icon: Icons.local_hospital,
          label: 'Hospital San José',
        ),
      ),
      fm.Marker(
        width: 40,
        height: 40,
        point: const LatLng(2.4489, -76.5972),
        child: const InterestPointMarker(
          size: 30,
          color: Colors.red,
          icon: Icons.local_hospital,
          label: 'Clínica La Estancia',
        ),
      ),
      fm.Marker(
        width: 40,
        height: 40,
        point: const LatLng(2.4631, -76.5936),
        child: const InterestPointMarker(
          size: 30,
          color: Colors.red,
          icon: Icons.local_hospital,
          label: 'Hospital López',
        ),
      ),

      // COLEGIOS Y UNIVERSIDADES
      fm.Marker(
        width: 40,
        height: 40,
        point: const LatLng(2.4448, -76.6060),
        child: const InterestPointMarker(
          size: 30,
          color: Colors.deepPurple,
          icon: Icons.account_balance,
          label: 'Universidad del Cauca',
        ),
      ),
      fm.Marker(
        width: 40,
        height: 40,
        point: const LatLng(2.4417, -76.6068),
        child: const InterestPointMarker(
          size: 30,
          color: Colors.deepPurple,
          icon: Icons.account_balance,
          label: 'Colegio Mayor',
        ),
      ),
      fm.Marker(
        width: 40,
        height: 40,
        point: const LatLng(2.4550, -76.5950),
        child: const InterestPointMarker(
          size: 30,
          color: Colors.orange,
          icon: Icons.school,
          label: 'INEM',
        ),
      ),
      fm.Marker(
        width: 40,
        height: 40,
        point: const LatLng(2.4380, -76.6120),
        child: const InterestPointMarker(
          size: 30,
          color: Colors.orange,
          icon: Icons.school,
          label: 'Champagnat',
        ),
      ),

      // BANCOS
      fm.Marker(
        width: 40,
        height: 40,
        point: const LatLng(2.4415, -76.6050),
        child: const InterestPointMarker(
          size: 30,
          color: Colors.blue,
          icon: Icons.account_balance,
          label: 'Banco República',
        ),
      ),
      fm.Marker(
        width: 40,
        height: 40,
        point: const LatLng(2.4430, -76.6040),
        child: const InterestPointMarker(
          size: 30,
          color: Colors.blue,
          icon: Icons.account_balance,
          label: 'Banco Popular',
        ),
      ),

      // CENTROS COMERCIALES
      fm.Marker(
        width: 40,
        height: 40,
        point: const LatLng(2.4550, -76.5920),
        child: const InterestPointMarker(
          size: 30,
          color: Colors.pink,
          icon: Icons.shopping_bag,
          label: 'C.C. Campanario',
        ),
      ),
      fm.Marker(
        width: 40,
        height: 40,
        point: const LatLng(2.4420, -76.6055),
        child: const InterestPointMarker(
          size: 30,
          color: Colors.pink,
          icon: Icons.shopping_bag,
          label: 'C.C. Anarkos',
        ),
      ),

      // RESTAURANTES
      fm.Marker(
        width: 40,
        height: 40,
        point: const LatLng(2.4410, -76.6050),
        child: const InterestPointMarker(
          size: 30,
          color: Colors.amber,
          icon: Icons.restaurant,
          label: 'La Cosecha',
        ),
      ),
      fm.Marker(
        width: 40,
        height: 40,
        point: const LatLng(2.4420, -76.6045),
        child: const InterestPointMarker(
          size: 30,
          color: Colors.amber,
          icon: Icons.restaurant,
          label: 'La Plazuela',
        ),
      ),

      // IGLESIAS
      fm.Marker(
        width: 40,
        height: 40,
        point: const LatLng(2.4415, -76.6063),
        child: const InterestPointMarker(
          size: 30,
          color: Colors.indigo,
          icon: Icons.church,
          label: 'Catedral',
        ),
      ),
      fm.Marker(
        width: 40,
        height: 40,
        point: const LatLng(2.4425, -76.6075),
        child: const InterestPointMarker(
          size: 30,
          color: Colors.indigo,
          icon: Icons.church,
          label: 'San Francisco',
        ),
      ),

      // PARQUES
      fm.Marker(
        width: 40,
        height: 40,
        point: const LatLng(2.4418, -76.6060),
        child: const InterestPointMarker(
          size: 30,
          color: Colors.green,
          icon: Icons.park,
          label: 'Parque Caldas',
        ),
      ),
      fm.Marker(
        width: 40,
        height: 40,
        point: const LatLng(2.4435, -76.6070),
        child: const InterestPointMarker(
          size: 30,
          color: Colors.green,
          icon: Icons.park,
          label: 'Parque Mosquera',
        ),
      ),

      // FARMACIAS
      fm.Marker(
        width: 40,
        height: 40,
        point: const LatLng(2.4420, -76.6055),
        child: const InterestPointMarker(
          size: 30,
          color: Colors.teal,
          icon: Icons.local_pharmacy,
          label: 'La Rebaja',
        ),
      ),
      fm.Marker(
        width: 40,
        height: 40,
        point: const LatLng(2.4440, -76.6030),
        child: const InterestPointMarker(
          size: 30,
          color: Colors.teal,
          icon: Icons.local_pharmacy,
          label: 'La Economía',
        ),
      ),

      // SUPERMERCADOS
      fm.Marker(
        width: 40,
        height: 40,
        point: const LatLng(2.4550, -76.5925),
        child: const InterestPointMarker(
          size: 30,
          color: Colors.lightGreen,
          icon: Icons.shopping_cart,
          label: 'Éxito',
        ),
      ),
      fm.Marker(
        width: 40,
        height: 40,
        point: const LatLng(2.4430, -76.6030),
        child: const InterestPointMarker(
          size: 30,
          color: Colors.lightGreen,
          icon: Icons.shopping_cart,
          label: 'Olímpica',
        ),
      ),

      // ESTACIONES DE GASOLINA
      fm.Marker(
        width: 40,
        height: 40,
        point: const LatLng(2.4500, -76.5950),
        child: const InterestPointMarker(
          size: 30,
          color: Colors.brown,
          icon: Icons.local_gas_station,
          label: 'Terpel',
        ),
      ),
      fm.Marker(
        width: 40,
        height: 40,
        point: const LatLng(2.4380, -76.6100),
        child: const InterestPointMarker(
          size: 30,
          color: Colors.brown,
          icon: Icons.local_gas_station,
          label: 'Texaco',
        ),
      ),

      // POLICÍA
      fm.Marker(
        width: 40,
        height: 40,
        point: const LatLng(2.4440, -76.6020),
        child: const InterestPointMarker(
          size: 30,
          color: Colors.blueGrey,
          icon: Icons.local_police,
          label: 'Comando Policía',
        ),
      ),
      fm.Marker(
        width: 40,
        height: 40,
        point: const LatLng(2.4418, -76.6070),
        child: const InterestPointMarker(
          size: 30,
          color: Colors.blueGrey,
          icon: Icons.local_police,
          label: 'CAI Centro',
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Mapa extendido que ocupa toda la pantalla
        fm.FlutterMap(
          mapController: _mapController,
          options: fm.MapOptions(
            initialCenter: _currentPosition != null
                ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
                : _popayanCenter,
            initialZoom: 14.0,
            interactionOptions: const fm.InteractionOptions(
              flags: fm.InteractiveFlag.all,
            ),
            onMapReady: () {
              if (_currentPosition != null) {
                _mapController.move(
                  LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                  14.0,
                );
              }
            },
          ),
          children: [
            fm.TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: const ['a', 'b', 'c'],
              userAgentPackageName: 'com.example.rouwhite',
            ),

            // Marcador animado de la ubicación del usuario
            if (_currentPosition != null)
              fm.MarkerLayer(
                markers: [
                  fm.Marker(
                    width: 60,
                    height: 60,
                    point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                    child: const PulsingLocationMarker(
                      size: 50,
                      color: Color(0xFFFF6A00),
                      pulseColor: Color(0xFFFF6A00),
                    ),
                  ),
                ],
              ),

            // Paradas de bus
            fm.MarkerLayer(
              markers: const [
                // Centro de Popayán - Parada activa
                fm.Marker(
                  width: 50,
                  height: 50,
                  point: LatLng(2.444814, -76.614739),
                  child: AnimatedBusStopMarker(
                    size: 35,
                    color: Colors.blue,
                    isActive: true,
                    busId: 'TP001',
                  ),
                ),
                // Terminal de transportes - Parada muy activa
                fm.Marker(
                  width: 50,
                  height: 50,
                  point: LatLng(2.445000, -76.617000),
                  child: AnimatedBusStopMarker(
                    size: 35,
                    color: Colors.green,
                    isActive: true,
                    busId: 'CT002',
                  ),
                ),
                // Más paradas de bus
                fm.Marker(
                  width: 50,
                  height: 50,
                  point: LatLng(2.4480, -76.6000),
                  child: AnimatedBusStopMarker(
                    size: 35,
                    color: Colors.orange,
                    isActive: true,
                    busId: 'TP003',
                  ),
                ),
                fm.Marker(
                  width: 50,
                  height: 50,
                  point: LatLng(2.4400, -76.6100),
                  child: AnimatedBusStopMarker(
                    size: 35,
                    color: Colors.purple,
                    isActive: true,
                    busId: 'TP004',
                  ),
                ),
              ],
            ),

            // Puntos de interés
            fm.MarkerLayer(
              markers: _getPOIMarkers(),
            ),
          ],
        ),

        // Header transparente superpuesto
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFFFF6A00).withValues(alpha: 0.9),
                  const Color(0xFFFF6A00).withValues(alpha: 0.7),
                  const Color(0xFFFF6A00).withValues(alpha: 0.3),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.3, 0.7, 1.0],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'POPAYÁN',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        blurRadius: 4,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isLoadingLocation
                      ? 'Obteniendo ubicación...'
                      : 'Tu ubicación en tiempo real',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white.withValues(alpha: 0.9),
                    shadows: const [
                      Shadow(
                        color: Colors.black54,
                        blurRadius: 2,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Botón para centrar en ubicación del usuario
        Positioned(
          top: 120,
          right: 20,
            child: FloatingActionButton(
              heroTag: "centerLocation",
              onPressed: _centerOnUserLocation,
              backgroundColor: const Color(0xFFFF6A00).withValues(alpha: 0.9),
              child: const Icon(
                IconHelper.myLocation,
                color: Colors.white,
              ),
            ),
        ),

        // Botón de búsqueda flotante
        Positioned(
          bottom: 100,
          left: 20,
          right: 20,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: _mostrarNavegacionDetallada,
              icon: const Icon(IconHelper.search, color: Colors.white),
              label: const Text(
                'Buscar Destino en Popayán',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6A00).withValues(alpha: 0.9),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
        ),

        // Información flotante
        Positioned(
          bottom: 50,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  IconHelper.locationOn,
                  color: Color(0xFFFF6A00),
                  size: 14,
                ),
                const SizedBox(width: 3),
                Expanded(
                  child: Text(
                    'Navegación inteligente con lugares reales de Popayán',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Indicador de carga
        if (_isLoadingLocation)
          Container(
            color: Colors.black.withValues(alpha: 0.3),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6A00)),
              ),
            ),
          ),
      ],
    );
  }
}

// Widget para marcadores de puntos de interés
class InterestPointMarker extends StatelessWidget {
  final double size;
  final Color color;
  final IconData icon;
  final String label;

  const InterestPointMarker({
    super.key,
    required this.size,
    required this.color,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Mostrar información del punto de interés
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(label),
            content: Text('Información sobre $label'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
            ],
          ),
        );
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: size * 0.6,
        ),
      ),
    );
  }
}