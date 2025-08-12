import 'package:flutter/material.dart';
import 'rutas_pagina.dart';
import 'perfil_usuario_pagina.dart';
import 'paradas_pagina.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart';
import 'buscar_ruta_pagina.dart';
import '../model/favoritos.dart'; // Agrega este import
import '../view/driver/driver.dart'; // Asegúrate que este archivo contiene la clase DriverPage

class Homepage extends StatefulWidget {
  final String username;
  final VoidCallback onLogout;
  const Homepage({super.key, required this.username, required this.onLogout});

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
            if (value == 'perfil') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PerfilUsuarioPagina(
                    username: widget.username,
                    onLogout: widget.onLogout,
                  ),
                ),
              );
            } else if (value == 'registrarse') {
              Navigator.pushNamed(context, '/registro');
            } else if (value == 'conductor') {
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
              value: 'perfil',
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text('Perfil'),
              ),
            ),
            const PopupMenuItem(
              value: 'registrarse',
              child: ListTile(
                leading: Icon(Icons.app_registration),
                title: Text('Registrarse'),
              ),
            ),
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
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> routes = [
    {'name': 'La Paz', 'subtitle': 'Jose María Obando'},
    {'name': 'La Esmeralda', 'subtitle': 'Campan'},
  ];

  void _navigateToSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BuscarRutaPagina()),
    );
  }

  void _showTourismInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Turismo en Popayán'),
          content: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Lugares turísticos destacados:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('• Centro Histórico (Patrimonio de la Humanidad)'),
                Text('• Puente del Humilladero'),
                Text('• Iglesia de San Francisco'),
                Text('• Museo de Arte Religioso'),
                Text('• Cerro de las Tres Cruces'),
                Text('• Parque Caldas'),
                Text('• Morro de Tulcán'),
                SizedBox(height: 10),
                Text(
                  '¿Te gustaría ver las rutas que te llevan a estos lugares?',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RutasPagina()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6A00),
                foregroundColor: Colors.white,
              ),
              child: const Text('Ver Rutas'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  // ignore: deprecated_member_use
                  color: Colors.grey.withOpacity(0.5),
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
                  'Historial de rutas',
                  style: TextStyle(
                    fontSize: 18,
                    // ignore: deprecated_member_use
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          // Animación Lottie centrada
          Center(
            child: Lottie.asset(
              'assets/animaciones/bus.json',
              height: 140,
              repeat: true,
            ),
          ),
          const SizedBox(height: 20),
          // Rutas recientes
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rutas recientes',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                for (int i = 0; i < routes.length; i++)
                  RouteCard(
                    name: routes[i]['name']!,
                    subtitle: routes[i]['subtitle']!,
                    isFirst: i == 0,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          // Turismo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Turismo',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(0),
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          'https://images.unsplash.com/photo-1581269875754-aea2a9b3970a?q=80&w=387&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              // ignore: deprecated_member_use
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Descubre los mejores lugares turísticos de Popayán y sus alrededores',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 15),
                              ElevatedButton(
                                onPressed: _showTourismInfo,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFFFF6A00),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: const Text(
                                  '¡Click aquí!',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFF6A00),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey[600]),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: _navigateToSearch,
                      child: TextField(
                        controller: _searchController,
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: 'Buscar ruta o destino...',
                          hintStyle: TextStyle(color: Colors.grey[600]),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search, color: Color(0xFFFF6A00)),
                    onPressed: _navigateToSearch,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
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
            color: Colors.grey.withOpacity(0.2),
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
                      // ignore: deprecated_member_use
                      center: center,
                      // ignore: deprecated_member_use
                      zoom: 14.0,
                      // ignore: deprecated_member_use
                      interactiveFlags: fm.InteractiveFlag.none,
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
                color: const Color(0xFF4CAF50).withOpacity(0.1),
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
                  key: Key(favorito['nombre']),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      Favoritos().quitar(favorito);
                    });
                    // Mostrar snackbar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Ruta ${favorito['nombre']} eliminada de favoritos',
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
                          color: Colors.grey.withOpacity(0.2),
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
                                favorito['nombre'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                favorito['empresa'],
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
                            Favoritos().esFavorito(favorito['nombre'])
                                ? Icons.star
                                : Icons.star_border,
                            color: Favoritos().esFavorito(favorito['nombre'])
                                ? Colors.amber
                                : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              if (Favoritos().esFavorito(favorito['nombre'])) {
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
