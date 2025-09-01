import 'package:flutter/material.dart';
import 'rutas_pagina.dart';
import 'paradas_pagina.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import '../model/favoritos.dart'; // Agrega este import
import '../view/driver/driver.dart'; // Asegúrate que este archivo contiene la clase DriverPage

import 'widgets/animated_markers.dart';
import 'smart_search_page.dart';

class Homepage extends StatefulWidget {
  final String username;
  const Homepage({super.key, required this.username});

  @override
  State<Homepage> createState() => _HomepageState();
}

// Placeholder widget for empty pages (e.g., Favoritos)
class EmptyPage extends StatelessWidget {
  const EmptyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Página vacía',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }
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
          icon: const Icon(Icons.menu),
          onSelected: (value) {
            if (value == 'conductor') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const Driver(), // Usa 'const' si DriverPage es StatelessWidget
                ),
              );
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'conductor',
              child: ListTile(
                leading: Icon(Icons.drive_eta), // Icono de conductor
                title: Text('Conductor'),
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bus),
            label: 'Rutas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Paradas',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'favoritos'),
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
        desiredAccuracy: LocationAccuracy.high,
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header de la ciudad
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFFF6A00),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
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
                ),
              ),
            ],
          ),
        ),

        // Mapa interactivo
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.3),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  fm.FlutterMap(
                    mapController: _mapController,
                    options: fm.MapOptions(
                      initialCenter: _currentPosition != null
                          ? LatLng(_currentPosition!.latitude,
                              _currentPosition!.longitude)
                          : _popayanCenter,
                      initialZoom: 15.0,
                      interactionOptions: const fm.InteractionOptions(
                        flags: fm.InteractiveFlag.all,
                      ),
                      onMapReady: () {
                        if (_currentPosition != null) {
                          _mapController.move(
                            LatLng(_currentPosition!.latitude,
                                _currentPosition!.longitude),
                            15.0,
                          );
                        }
                      },
                    ),
                    children: [
                      fm.TileLayer(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
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
                              point: LatLng(_currentPosition!.latitude,
                                  _currentPosition!.longitude),
                              child: const PulsingLocationMarker(
                                size: 50,
                                color: Color(0xFFFF6A00),
                                pulseColor: Color(0xFFFF6A00),
                              ),
                            ),
                          ],
                        ),

                      // Marcadores animados de puntos de interés
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
                          // Plaza de Caldas - Punto de interés
                          fm.Marker(
                            width: 60,
                            height: 80,
                            point: LatLng(2.444814, -76.614739),
                            child: InterestPointMarker(
                              size: 35,
                              color: Colors.orange,
                              icon: Icons.location_city,
                              label: 'Plaza Caldas',
                            ),
                          ),
                          // Universidad del Cauca
                          fm.Marker(
                            width: 60,
                            height: 80,
                            point: LatLng(2.443000, -76.612000),
                            child: InterestPointMarker(
                              size: 35,
                              color: Colors.purple,
                              icon: Icons.school,
                              label: 'Unicauca',
                            ),
                          ),
                          // Hospital San José
                          fm.Marker(
                            width: 60,
                            height: 80,
                            point: LatLng(2.446000, -76.616000),
                            child: InterestPointMarker(
                              size: 35,
                              color: Colors.red,
                              icon: Icons.local_hospital,
                              label: 'Hospital',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Botón para centrar en ubicación del usuario
                  Positioned(
                    top: 20,
                    right: 20,
                    child: FloatingActionButton(
                      heroTag: "centerLocation",
                      onPressed: _centerOnUserLocation,
                      backgroundColor: const Color(0xFFFF6A00),
                      child: const Icon(
                        Icons.my_location,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // Indicador de carga
                  if (_isLoadingLocation)
                    Container(
                      color: Colors.black.withValues(alpha: 0.3),
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFFFF6A00)),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),

        // Botón de navegación detallada con voz
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              ElevatedButton.icon(
                onPressed: _mostrarNavegacionDetallada,
                icon: const Icon(Icons.search, color: Colors.white),
                label: const Text(
                  'Buscar Destino en Popayán',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6A00),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Descripción de la nueva funcionalidad
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Color(0xFFFF6A00),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Navegación inteligente con lugares reales de Popayán',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class RouteCard extends StatefulWidget {
  final String name;
  final String subtitle;
  final bool isFirst;

  const RouteCard({
    super.key,
    required this.name,
    required this.subtitle,
    this.isFirst = false,
  });

  @override
  State<RouteCard> createState() => _RouteCardState();
}

class _RouteCardState extends State<RouteCard> {
  static final Map<String, LatLng> _barriosCoords = {
    'Centro': const LatLng(2.444814, -76.614739),
    'La Paz': const LatLng(2.449000, -76.601000),
    'Jose María Obando': const LatLng(2.453000, -76.599000),
    'San Camilo': const LatLng(2.447500, -76.610000),
    'La Esmeralda': const LatLng(2.440000, -76.600000),
    'Campan': const LatLng(2.441500, -76.602500),
    'El Recuerdo': const LatLng(2.442500, -76.605000),
    'Terminal': const LatLng(2.445000, -76.617000),
    'El Uvo': const LatLng(2.455000, -76.620000),
    'San Eduardo': const LatLng(2.457000, -76.618000),
    'Bello Horizonte': const LatLng(2.438000, -76.610000),
    'El Placer': const LatLng(2.437000, -76.612000),
    'Alfonso López': const LatLng(2.435000, -76.615000),
    'El Limonar': const LatLng(2.433000, -76.617000),
    'El Boquerón': const LatLng(2.431000, -76.619000),
    'La Floresta': const LatLng(2.450000, -76.608000),
    'Los Sauces': const LatLng(2.452000, -76.606000),
    'La Campiña': const LatLng(2.454000, -76.604000),
    'María Oriente': const LatLng(2.456000, -76.602000),
    'Santa Mónica': const LatLng(2.448000, -76.611000),
    'El Lago': const LatLng(2.447000, -76.613000),
    'Berlín': const LatLng(2.446000, -76.615000),
    'Suizo': const LatLng(2.445000, -76.617000),
    'Las Ferias': const LatLng(2.444000, -76.619000),
    'Los Andes': const LatLng(2.443000, -76.621000),
    'Alameda': const LatLng(2.442000, -76.623000),
    'Colgate Palmolive': const LatLng(2.441000, -76.625000),
    'Plateado': const LatLng(2.440000, -76.627000),
    'Poblado Altos Sauces': const LatLng(2.439000, -76.629000),
  };

  @override
  Widget build(BuildContext context) {
    final LatLng? start = _barriosCoords[widget.name];
    final LatLng? end = _barriosCoords[widget.subtitle];
    final List<LatLng> points = [
      if (start != null) start,
      if (end != null) end
    ];
    final LatLng center =
        points.isNotEmpty ? points.first : const LatLng(2.444814, -76.614739);

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[100],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: fm.FlutterMap(
                    options: fm.MapOptions(
                      initialCenter: center,
                      initialZoom: 14.0,
                      interactionOptions: const fm.InteractionOptions(
                        flags: fm.InteractiveFlag.none,
                      ),
                    ),
                    children: [
                      fm.TileLayer(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: const ['a', 'b', 'c'],
                        userAgentPackageName: 'com.example.rouwhite',
                      ),
                      if (points.length == 2)
                        fm.PolylineLayer(
                          polylines: [
                            fm.Polyline(
                              points: points,
                              color: Colors.orange,
                              strokeWidth: 4.0,
                            ),
                          ],
                        ),
                      fm.MarkerLayer(
                        markers: [
                          if (start != null)
                            fm.Marker(
                              width: 30,
                              height: 30,
                              point: start,
                              child: const Icon(Icons.location_on,
                                  color: Colors.green, size: 24),
                            ),
                          if (end != null)
                            fm.Marker(
                              width: 30,
                              height: 30,
                              point: end,
                              child: const Icon(Icons.flag,
                                  color: Colors.red, size: 24),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: Lottie.asset(
                    'assets/animaciones/bus.json',
                    repeat: true,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.subtitle,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          if (widget.isFirst)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Activa',
                style: TextStyle(
                  color: Color(0xFF4CAF50),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          IconButton(
            icon: Icon(
              Favoritos().esFavorito(widget.name)
                  ? Icons.star
                  : Icons.star_border,
              color: Favoritos().esFavorito(widget.name)
                  ? Colors.amber
                  : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                if (Favoritos().esFavorito(widget.name)) {
                  Favoritos().quitar(
                      {'nombre': widget.name, 'empresa': widget.subtitle});
                } else {
                  Favoritos().agregar(
                      {'nombre': widget.name, 'empresa': widget.subtitle});
                }
              });
            },
          ),
        ],
      ),
    );
  }
}

class FavoritosPagina extends StatefulWidget {
  final void Function(String nombreRuta)? onRemoveFavorito;
  const FavoritosPagina({super.key, this.onRemoveFavorito});

  @override
  State<FavoritosPagina> createState() => _FavoritosPaginaState();
}

class _FavoritosPaginaState extends State<FavoritosPagina> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
        centerTitle: true,
        backgroundColor: const Color(0xFFFF6A00),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Tus rutas favoritas',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),
            const SizedBox(height: 15),
            // Lista de rutas favoritas
            for (var favorito in Favoritos().favoritos)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Dismissible(
                  key: Key(favorito['nombre'] as String? ?? 'favorito'),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      Favoritos().quitar(favorito);
                    });
                    // Mostrar snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Ruta ${favorito['nombre'] as String? ?? 'Sin nombre'} eliminada de favoritos',
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    color: Colors.red,
                    child: const Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.2),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                favorito['nombre'] as String? ?? 'Sin nombre',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                favorito['empresa'] as String? ?? 'Sin empresa',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Favoritos().esFavorito(
                                    favorito['nombre'] as String? ?? '')
                                ? Icons.star
                                : Icons.star_border,
                            color: Favoritos().esFavorito(
                                    favorito['nombre'] as String? ?? '')
                                ? Colors.amber
                                : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              if (Favoritos().esFavorito(
                                  favorito['nombre'] as String? ?? '')) {
                                Favoritos().quitar(favorito);
                              } else {
                                Favoritos().agregar(favorito);
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
