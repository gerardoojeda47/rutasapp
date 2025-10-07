import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import 'widgets/html_banner_widget.dart';
import 'widgets/html_stats_widget.dart';
import 'widgets/html_news_widget.dart';
import 'widgets/html_weather_traffic_widget.dart';
import 'widgets/animated_markers.dart';
import 'smart_search_page.dart';
import '../core/services/navigation_service.dart';
import '../core/utils/icon_helper.dart';

class EnhancedHomepage extends StatefulWidget {
  final String username;

  const EnhancedHomepage({super.key, required this.username});

  @override
  State<EnhancedHomepage> createState() => _EnhancedHomepageState();
}

class _EnhancedHomepageState extends State<EnhancedHomepage> {
  Position? _currentPosition;
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
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.high),
      );

      setState(() {
        _currentPosition = position;
      });

      _mapController.move(LatLng(position.latitude, position.longitude), 15.0);
    } catch (e) {
      // Error al obtener ubicación, usar coordenadas por defecto
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
    NavigationService.pushWithSafeTransition(
      context,
      const SmartSearchPage(),
      type: TransitionType.scale,
    );
  }

  // Métodos para los iconos flotantes del mapa
  void _showBusesNearby() {
    _showMapInfoDialog(
      '🚌 Buses Cercanos',
      'Mostrando buses en tiempo real en tu área.\n\n'
          '• Ruta 1: 2 buses a 5 min\n'
          '• Ruta 3: 1 bus a 8 min\n'
          '• Ruta 7: 3 buses a 12 min',
      const Color(0xFFFF6A00),
    );
  }

  void _showTrafficInfo() {
    _showMapInfoDialog(
      '🚦 Estado del Tráfico',
      'Información de tráfico en tiempo real.\n\n'
          '• Centro: Fluido ✅\n'
          '• Av. Panamericana: Moderado ⚠️\n'
          '• Sector Universidad: Congestionado 🔴',
      const Color(0xFFFF6A00),
    );
  }

  void _showHealthCenters() {
    _showMapInfoDialog(
      '🏥 Centros de Salud',
      'Hospitales y centros médicos cercanos.\n\n'
          '• Hospital Universitario San José\n'
          '• Clínica La Estancia\n'
          '• Hospital Susana López de Valencia',
      const Color(0xFFFF6A00),
    );
  }

  void _showEducationCenters() {
    _showMapInfoDialog(
      '🎓 Centros Educativos',
      'Instituciones educativas principales.\n\n'
          '• Universidad del Cauca\n'
          '• Universidad Cooperativa\n'
          '• SENA Regional Cauca',
      const Color(0xFFFF6A00),
    );
  }

  void _showCommerceAreas() {
    _showMapInfoDialog(
      '🛍️ Zonas Comerciales',
      'Principales centros comerciales y de compras.\n\n'
          '• Centro Comercial Campanario\n'
          '• Centro Histórico\n'
          '• Zona Rosa',
      const Color(0xFFFF6A00),
    );
  }

  void _showParks() {
    _showMapInfoDialog(
      '🌳 Parques y Recreación',
      'Espacios verdes y recreativos de la ciudad.\n\n'
          '• Parque Caldas\n'
          '• Parque de Belén\n'
          '• Parque Nacional Natural Puracé',
      const Color(0xFFFF6A00),
    );
  }

  void _showWeatherDetails() {
    _showMapInfoDialog(
      '🌤️ Clima en Popayán',
      'Condiciones climáticas actuales.\n\n'
          '• Temperatura: 24°C\n'
          '• Humedad: 65%\n'
          '• Viento: 8 km/h\n'
          '• Probabilidad de lluvia: 20%',
      const Color(0xFFFF6A00),
    );
  }

  void _showNotifications() {
    _showMapInfoDialog(
      '🔔 Notificaciones',
      'Alertas y actualizaciones recientes.\n\n'
          '• Nueva ruta disponible (5 min)\n'
          '• Desvío en Av. Panamericana (15 min)\n'
          '• Horarios extendidos fin de semana (1h)',
      const Color(0xFFFF6A00),
    );
  }

  void _showMapInfoDialog(String title, String content, Color color) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.info_outline,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cerrar',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Aquí podrías navegar a una página específica
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Ver más'),
            ),
          ],
        );
      },
    );
  }

  List<NewsItem> _getSampleNews() {
    return [
      NewsItem(
        icon: '🚌',
        title: 'Nueva ruta disponible',
        description: 'Ruta Centro - Universidad del Cauca ahora activa',
        timeAgo: 'Hace 5 min',
      ),
      NewsItem(
        icon: '⚠️',
        title: 'Desvío temporal',
        description: 'Calle 5 cerrada por obras hasta las 6 PM',
        timeAgo: 'Hace 15 min',
      ),
      NewsItem(
        icon: '🕐',
        title: 'Horarios extendidos',
        description: 'Servicio hasta las 10 PM los fines de semana',
        timeAgo: 'Hace 1 hora',
      ),
      NewsItem(
        icon: '📱',
        title: 'Nueva función',
        description: 'Ahora puedes ver buses en tiempo real',
        timeAgo: 'Hace 2 horas',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar flexible con gradiente
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFFF6A00),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'ROUWHITE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const Text(
                          'Transporte Público Popayán',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            backgroundColor: const Color(0xFFFF6A00),
          ),

          // Contenido principal
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner HTML animado
                  const HtmlBannerWidget(
                    title: 'POPAYÁN',
                    subtitle: 'Tu ciudad conectada',
                  ),

                  const SizedBox(height: 20),

                  // Clima y tráfico
                  const HtmlWeatherTrafficWidget(
                    temperature: '24',
                    weatherCondition: 'Parcialmente nublado',
                    trafficStatus: 'Fluido',
                    trafficLevel: 2,
                  ),

                  const SizedBox(height: 20),

                  // Estadísticas en tiempo real
                  const HtmlStatsWidget(
                    activeBuses: 45,
                    totalRoutes: 12,
                    busStops: 89,
                    cityName: 'Popayán',
                  ),

                  const SizedBox(height: 20),

                  // Sección de búsqueda rápida
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6A00),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          '🔍 Búsqueda Rápida',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton.icon(
                          onPressed: _mostrarNavegacionDetallada,
                          icon: const Icon(IconHelper.search),
                          label: const Text('Buscar Destino'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFFFF6A00),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Noticias del transporte
                  HtmlNewsWidget(newsItems: _getSampleNews()),

                  const SizedBox(height: 20),

                  // Mapa compacto
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Stack(
                        children: [
                          fm.FlutterMap(
                            mapController: _mapController,
                            options: fm.MapOptions(
                              initialCenter: _currentPosition != null
                                  ? LatLng(_currentPosition!.latitude,
                                      _currentPosition!.longitude)
                                  : _popayanCenter,
                              initialZoom: 14.0,
                            ),
                            children: [
                              fm.TileLayer(
                                urlTemplate:
                                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                subdomains: const ['a', 'b', 'c'],
                              ),
                              // Marcador de ubicación del usuario
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
                            ],
                          ),

                          // Overlay con información
                          Positioned(
                            top: 15,
                            left: 15,
                            right: 15,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    IconHelper.locationOn,
                                    color: Color(0xFFFF6A00),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  const Expanded(
                                    child: Text(
                                      'Mapa de Popayán - Servicios',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF6A00)
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: _centerOnUserLocation,
                                      icon: const Icon(
                                        IconHelper.myLocation,
                                        color: Color(0xFFFF6A00),
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Iconos de servicios - Lado izquierdo
                          Positioned(
                            bottom: 20,
                            left: 15,
                            child: Column(
                              children: [
                                _buildFloatingIcon('🚌',
                                    const Color(0xFFFF6A00), _showBusesNearby),
                                const SizedBox(height: 8),
                                _buildFloatingIcon('🚦',
                                    const Color(0xFFFF6A00), _showTrafficInfo),
                                const SizedBox(height: 8),
                                _buildFloatingIcon(
                                    '🏥',
                                    const Color(0xFFFF6A00),
                                    _showHealthCenters),
                              ],
                            ),
                          ),

                          // Iconos de servicios - Lado derecho
                          Positioned(
                            bottom: 20,
                            right: 15,
                            child: Column(
                              children: [
                                _buildFloatingIcon(
                                    '🎓',
                                    const Color(0xFFFF6A00),
                                    _showEducationCenters),
                                const SizedBox(height: 8),
                                _buildFloatingIcon(
                                    '🛍️',
                                    const Color(0xFFFF6A00),
                                    _showCommerceAreas),
                                const SizedBox(height: 8),
                                _buildFloatingIcon(
                                    '🌳', const Color(0xFFFF6A00), _showParks),
                              ],
                            ),
                          ),

                          // Iconos de información superior izquierdo
                          Positioned(
                            top: 80,
                            left: 15,
                            child: Column(
                              children: [
                                _buildInfoIcon(
                                  emoji: '☀️',
                                  value: '24°',
                                  color: const Color(0xFFFF6A00),
                                  onTap: () => _showWeatherDetails(),
                                ),
                                const SizedBox(height: 10),
                                _buildInfoIcon(
                                  emoji: '🔔',
                                  value: '3',
                                  color: const Color(0xFFFF6A00),
                                  onTap: () => _showNotifications(),
                                ),
                              ],
                            ),
                          ),

                          // Indicador de servicios activos
                          Positioned(
                            bottom: 20,
                            right: 15,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.95),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.15),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                                border: Border.all(
                                  color: const Color(0xFFFF6A00)
                                      .withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF4CAF50),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    '6 servicios activos',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF333333),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Accesos rápidos
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '⚡ Accesos Rápidos',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildQuickAccessButton(
                              icon: IconHelper.routes,
                              label: 'Rutas',
                              color: const Color(0xFFFF6A00),
                              onTap: () {},
                            ),
                            _buildQuickAccessButton(
                              icon: IconHelper.stops,
                              label: 'Paradas',
                              color: const Color(0xFFFF6A00),
                              onTap: () {},
                            ),
                            _buildQuickAccessButton(
                              icon: IconHelper.favorites,
                              label: 'Favoritos',
                              color: const Color(0xFFFF6A00),
                              onTap: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                      height: 100), // Espacio para el bottom navigation
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Icon(
              icon,
              color: color,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoIcon({
    required String emoji,
    required String value,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: color.withValues(alpha: 0.4),
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            // Fondo con gradiente
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(23),
                gradient: RadialGradient(
                  colors: [
                    color.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            // Emoji principal
            Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            // Valor en la esquina
            Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
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

  Widget _buildFloatingIcon(String emoji, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.5),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: color,
            width: 3,
          ),
        ),
        child: Stack(
          children: [
            // Fondo con gradiente
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(21),
                gradient: RadialGradient(
                  colors: [
                    color.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            // Emoji principal
            Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 22),
              ),
            ),
            // Indicador de estado activo
            Positioned(
              top: 2,
              right: 2,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
