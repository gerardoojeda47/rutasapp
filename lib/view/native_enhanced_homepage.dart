import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import 'widgets/native_banner_widget.dart';
import 'widgets/improved_stats_widget.dart';
import 'widgets/native_news_widget.dart';
import 'widgets/native_weather_traffic_widget.dart';
import 'widgets/animated_markers.dart';
import 'smart_search_page.dart';
import '../core/services/navigation_service.dart';
import '../core/utils/icon_helper.dart';

// Clase para representar puntos de interés en el mapa
class PointOfInterest {
  final String name;
  final LatLng position;
  final POIType type;
  final String? description;

  PointOfInterest({
    required this.name,
    required this.position,
    required this.type,
    this.description,
  });
}

// Tipos de puntos de interés
enum POIType {
  hospital,
  school,
  university,
  park,
  church,
  mall,
  restaurant,
  bank,
  gasStation,
  police,
  hotel,
  museum,
  library,
  pharmacy,
  supermarket,
}

// Extensión para obtener el icono según el tipo de POI
extension POITypeExtension on POIType {
  IconData get icon {
    switch (this) {
      case POIType.hospital:
        return Icons.local_hospital;
      case POIType.school:
        return Icons.school;
      case POIType.university:
        return Icons.account_balance;
      case POIType.park:
        return Icons.park;
      case POIType.church:
        return Icons.church;
      case POIType.mall:
        return Icons.shopping_bag;
      case POIType.restaurant:
        return Icons.restaurant;
      case POIType.bank:
        return Icons.account_balance;
      case POIType.gasStation:
        return Icons.local_gas_station;
      case POIType.police:
        return Icons.local_police;
      case POIType.hotel:
        return Icons.hotel;
      case POIType.museum:
        return Icons.museum;
      case POIType.library:
        return Icons.local_library;
      case POIType.pharmacy:
        return Icons.local_pharmacy;
      case POIType.supermarket:
        return Icons.shopping_cart;
    }
  }

  Color get color {
    switch (this) {
      case POIType.hospital:
        return Colors.red;
      case POIType.school:
        return Colors.orange;
      case POIType.university:
        return Colors.deepPurple;
      case POIType.park:
        return Colors.green;
      case POIType.church:
        return Colors.indigo;
      case POIType.mall:
        return Colors.pink;
      case POIType.restaurant:
        return Colors.amber;
      case POIType.bank:
        return Colors.blue;
      case POIType.gasStation:
        return Colors.red.shade800;
      case POIType.police:
        return Colors.blue.shade900;
      case POIType.hotel:
        return Colors.teal;
      case POIType.museum:
        return Colors.brown;
      case POIType.library:
        return Colors.deepOrange;
      case POIType.pharmacy:
        return Colors.lightGreen;
      case POIType.supermarket:
        return Colors.cyan;
    }
  }
}

class NativeEnhancedHomepage extends StatefulWidget {
  final String username;

  const NativeEnhancedHomepage({super.key, required this.username});

  @override
  State<NativeEnhancedHomepage> createState() => _NativeEnhancedHomepageState();
}

class _NativeEnhancedHomepageState extends State<NativeEnhancedHomepage> {
  Position? _currentPosition;
  final fm.MapController _mapController = fm.MapController();

  // Coordenadas de Popayán como fallback
  static final LatLng _popayanCenter = LatLng(2.444814, -76.614739);

  // Lista completa de puntos de interés en toda la ciudad de Popayán
  final List<PointOfInterest> _pointsOfInterest = [
    // ========== ZONA CENTRO ==========

    // BANCOS CENTRO
    PointOfInterest(
      name: 'Banco de la República',
      position: LatLng(2.4415, -76.6050),
      type: POIType.bank,
      description: 'Banco central',
    ),
    PointOfInterest(
      name: 'Bancolombia Centro',
      position: LatLng(2.4425, -76.6055),
      type: POIType.bank,
      description: 'Banco comercial',
    ),
    PointOfInterest(
      name: 'Banco de Bogotá',
      position: LatLng(2.4435, -76.6045),
      type: POIType.bank,
      description: 'Banco nacional',
    ),
    PointOfInterest(
      name: 'Banco Popular',
      position: LatLng(2.4405, -76.6065),
      type: POIType.bank,
      description: 'Servicios bancarios',
    ),
    PointOfInterest(
      name: 'BBVA',
      position: LatLng(2.4440, -76.6035),
      type: POIType.bank,
      description: 'Banco internacional',
    ),

    // RESTAURANTES CENTRO
    PointOfInterest(
      name: 'La Cosecha',
      position: LatLng(2.4410, -76.6050),
      type: POIType.restaurant,
      description: 'Comida típica payanesa',
    ),
    PointOfInterest(
      name: 'Italiano D\'Verona',
      position: LatLng(2.4430, -76.6040),
      type: POIType.restaurant,
      description: 'Restaurante italiano',
    ),
    PointOfInterest(
      name: 'Café Macondo',
      position: LatLng(2.4440, -76.6060),
      type: POIType.restaurant,
      description: 'Café cultural',
    ),
    PointOfInterest(
      name: 'Balcón de los Arrieros',
      position: LatLng(2.4420, -76.6070),
      type: POIType.restaurant,
      description: 'Comida tradicional',
    ),
    PointOfInterest(
      name: 'Restaurante Mora Castilla',
      position: LatLng(2.4390, -76.6080),
      type: POIType.restaurant,
      description: 'Restaurante gourmet',
    ),
    PointOfInterest(
      name: 'Pizzería Leños & Carbón',
      position: LatLng(2.4450, -76.6030),
      type: POIType.restaurant,
      description: 'Pizzas artesanales',
    ),

    // FARMACIAS CENTRO
    PointOfInterest(
      name: 'Droguería La Rebaja Centro',
      position: LatLng(2.4420, -76.6055),
      type: POIType.pharmacy,
      description: 'Farmacia 24 horas',
    ),
    PointOfInterest(
      name: 'Cruz Verde Centro',
      position: LatLng(2.4410, -76.6065),
      type: POIType.pharmacy,
      description: 'Cadena farmacéutica',
    ),
    PointOfInterest(
      name: 'Farmacia San Jorge',
      position: LatLng(2.4430, -76.6050),
      type: POIType.pharmacy,
      description: 'Farmacia local',
    ),
    PointOfInterest(
      name: 'Droguería Colsubsidio',
      position: LatLng(2.4440, -76.6040),
      type: POIType.pharmacy,
      description: 'Farmacia cooperativa',
    ),

    // HOTELES CENTRO
    PointOfInterest(
      name: 'Hotel Monasterio',
      position: LatLng(2.4410, -76.6070),
      type: POIType.hotel,
      description: 'Hotel colonial',
    ),
    PointOfInterest(
      name: 'Hotel Dann Monasterio',
      position: LatLng(2.4400, -76.6075),
      type: POIType.hotel,
      description: 'Hotel de lujo',
    ),
    PointOfInterest(
      name: 'Hotel La Plazuela',
      position: LatLng(2.4430, -76.6065),
      type: POIType.hotel,
      description: 'Hotel boutique',
    ),

    // ========== ZONA NORTE ==========

    // CENTROS COMERCIALES NORTE
    PointOfInterest(
      name: 'Centro Comercial Campanario',
      position: LatLng(2.4550, -76.5920),
      type: POIType.mall,
      description: 'Principal centro comercial',
    ),
    PointOfInterest(
      name: 'Plaza de Mercado del Norte',
      position: LatLng(2.4480, -76.6000),
      type: POIType.mall,
      description: 'Mercado tradicional',
    ),

    // SUPERMERCADOS NORTE
    PointOfInterest(
      name: 'Éxito Campanario',
      position: LatLng(2.4550, -76.5925),
      type: POIType.supermarket,
      description: 'Supermercado grande',
    ),
    PointOfInterest(
      name: 'Carulla Norte',
      position: LatLng(2.4460, -76.5980),
      type: POIType.supermarket,
      description: 'Supermercado premium',
    ),
    PointOfInterest(
      name: 'D1 Norte',
      position: LatLng(2.4480, -76.5990),
      type: POIType.supermarket,
      description: 'Tienda de descuento',
    ),

    // RESTAURANTES NORTE
    PointOfInterest(
      name: 'McDonald\'s Campanario',
      position: LatLng(2.4545, -76.5915),
      type: POIType.restaurant,
      description: 'Comida rápida',
    ),
    PointOfInterest(
      name: 'KFC Norte',
      position: LatLng(2.4540, -76.5930),
      type: POIType.restaurant,
      description: 'Pollo frito',
    ),
    PointOfInterest(
      name: 'Subway Norte',
      position: LatLng(2.4535, -76.5925),
      type: POIType.restaurant,
      description: 'Sándwiches',
    ),

    // BANCOS NORTE
    PointOfInterest(
      name: 'Bancolombia Campanario',
      position: LatLng(2.4548, -76.5922),
      type: POIType.bank,
      description: 'Sucursal norte',
    ),
    PointOfInterest(
      name: 'Davivienda Norte',
      position: LatLng(2.4470, -76.5985),
      type: POIType.bank,
      description: 'Banco comercial',
    ),

    // ========== ZONA SUR ==========

    // SUPERMERCADOS SUR
    PointOfInterest(
      name: 'Olímpica Sur',
      position: LatLng(2.4300, -76.6100),
      type: POIType.supermarket,
      description: 'Supermercado familiar',
    ),
    PointOfInterest(
      name: 'Justo & Bueno Sur',
      position: LatLng(2.4280, -76.6080),
      type: POIType.supermarket,
      description: 'Tienda de conveniencia',
    ),

    // RESTAURANTES SUR
    PointOfInterest(
      name: 'Asadero El Corral Sur',
      position: LatLng(2.4320, -76.6090),
      type: POIType.restaurant,
      description: 'Parrilla y carnes',
    ),
    PointOfInterest(
      name: 'Pollo Campero Sur',
      position: LatLng(2.4290, -76.6070),
      type: POIType.restaurant,
      description: 'Pollo a la brasa',
    ),

    // FARMACIAS SUR
    PointOfInterest(
      name: 'La Rebaja Sur',
      position: LatLng(2.4310, -76.6085),
      type: POIType.pharmacy,
      description: 'Farmacia sur',
    ),
    PointOfInterest(
      name: 'Locatel Sur',
      position: LatLng(2.4285, -76.6075),
      type: POIType.pharmacy,
      description: 'Farmacia 24h',
    ),

    // ========== ZONA ESTE ==========

    // SUPERMERCADOS ESTE
    PointOfInterest(
      name: 'Ara Este',
      position: LatLng(2.4400, -76.5950),
      type: POIType.supermarket,
      description: 'Supermercado económico',
    ),
    PointOfInterest(
      name: 'Tiendas Ara',
      position: LatLng(2.4450, -76.5940),
      type: POIType.supermarket,
      description: 'Cadena de descuento',
    ),

    // RESTAURANTES ESTE
    PointOfInterest(
      name: 'Frisby Este',
      position: LatLng(2.4420, -76.5960),
      type: POIType.restaurant,
      description: 'Pollo broaster',
    ),
    PointOfInterest(
      name: 'Presto Este',
      position: LatLng(2.4440, -76.5945),
      type: POIType.restaurant,
      description: 'Comida rápida',
    ),

    // BANCOS ESTE
    PointOfInterest(
      name: 'Banco Agrario Este',
      position: LatLng(2.4430, -76.5955),
      type: POIType.bank,
      description: 'Banco rural',
    ),

    // ========== ZONA OESTE ==========

    // SUPERMERCADOS OESTE
    PointOfInterest(
      name: 'Merquefácil Oeste',
      position: LatLng(2.4380, -76.6200),
      type: POIType.supermarket,
      description: 'Supermercado local',
    ),
    PointOfInterest(
      name: 'Surtimax Oeste',
      position: LatLng(2.4420, -76.6180),
      type: POIType.supermarket,
      description: 'Cadena regional',
    ),

    // RESTAURANTES OESTE
    PointOfInterest(
      name: 'Donde Juancho',
      position: LatLng(2.4390, -76.6190),
      type: POIType.restaurant,
      description: 'Comida casera',
    ),
    PointOfInterest(
      name: 'El Rincón Payanés',
      position: LatLng(2.4410, -76.6170),
      type: POIType.restaurant,
      description: 'Comida típica',
    ),

    // FARMACIAS OESTE
    PointOfInterest(
      name: 'Farmacia Popular Oeste',
      position: LatLng(2.4400, -76.6185),
      type: POIType.pharmacy,
      description: 'Farmacia comunitaria',
    ),

    // ========== ESTACIONES DE GASOLINA ==========
    PointOfInterest(
      name: 'Terpel Centro',
      position: LatLng(2.4500, -76.5950),
      type: POIType.gasStation,
      description: 'Estación de servicio',
    ),
    PointOfInterest(
      name: 'Mobil Norte',
      position: LatLng(2.4520, -76.5970),
      type: POIType.gasStation,
      description: 'Combustibles norte',
    ),
    PointOfInterest(
      name: 'Esso Sur',
      position: LatLng(2.4300, -76.6120),
      type: POIType.gasStation,
      description: 'Estación sur',
    ),
    PointOfInterest(
      name: 'Petrobras Este',
      position: LatLng(2.4450, -76.5930),
      type: POIType.gasStation,
      description: 'Combustibles este',
    ),

    // ========== LUGARES HISTÓRICOS Y CULTURALES ==========
    PointOfInterest(
      name: 'Parque Caldas',
      position: LatLng(2.4418, -76.6060),
      type: POIType.park,
      description: 'Parque principal',
    ),
    PointOfInterest(
      name: 'Catedral Basílica',
      position: LatLng(2.4415, -76.6063),
      type: POIType.church,
      description: 'Catedral principal',
    ),
    PointOfInterest(
      name: 'Iglesia San Francisco',
      position: LatLng(2.4425, -76.6075),
      type: POIType.church,
      description: 'Iglesia colonial',
    ),
    PointOfInterest(
      name: 'Universidad del Cauca',
      position: LatLng(2.4448, -76.6060),
      type: POIType.university,
      description: 'Universidad pública',
    ),
    PointOfInterest(
      name: 'Hospital San José',
      position: LatLng(2.4427, -76.6064),
      type: POIType.hospital,
      description: 'Hospital principal',
    ),
  ];

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
        desiredAccuracy: LocationAccuracy.high,
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

  // Métodos para mostrar información de los iconos del mapa
  void _showBusInfo() {
    _showMapDialog(
      '🚌 Buses en Tiempo Real',
      'Información de buses activos en Popayán:\n\n'
          '• Ruta 1 (Centro-Norte): 3 buses activos\n'
          '• Ruta 2 (Sur-Universidad): 2 buses activos\n'
          '• Ruta 3 (Este-Oeste): 4 buses activos\n'
          '• Próximo bus: 5 minutos',
      const Color(0xFFFF6A00),
    );
  }

  void _showStopsInfo() {
    _showMapDialog(
      '🚏 Paradas de Bus',
      'Paradas principales en Popayán:\n\n'
          '• Terminal de Transporte\n'
          '• Parque Caldas (Centro)\n'
          '• Universidad del Cauca\n'
          '• Centro Comercial Campanario\n'
          '• Hospital Universitario',
      const Color(0xFFFF6A00),
    );
  }

  void _showTrafficInfo() {
    _showMapDialog(
      '🚦 Estado del Tráfico',
      'Condiciones actuales del tráfico:\n\n'
          '• Centro Histórico: Fluido ✅\n'
          '• Av. Panamericana: Moderado ⚠️\n'
          '• Sector Universidad: Ligero 🟡\n'
          '• Puente del Humilladero: Normal ✅',
      const Color(0xFFFF6A00),
    );
  }

  void _showHealthInfo() {
    _showMapDialog(
      '🏥 Centros de Salud',
      'Hospitales y clínicas en Popayán:\n\n'
          '• Hospital Universitario San José\n'
          '• Clínica La Estancia\n'
          '• Hospital Susana López de Valencia\n'
          '• Centro de Salud Norte\n'
          '• Clínica Popayán',
      const Color(0xFFFF6A00),
    );
  }

  void _showEducationInfo() {
    _showMapDialog(
      '🎓 Centros Educativos',
      'Instituciones educativas principales:\n\n'
          '• Universidad del Cauca\n'
          '• Universidad Cooperativa de Colombia\n'
          '• SENA Regional Cauca\n'
          '• Universidad Antonio Nariño\n'
          '• Colegios públicos y privados',
      const Color(0xFFFF6A00),
    );
  }

  void _showCommerceInfo() {
    _showMapDialog(
      '🛍️ Zonas Comerciales',
      'Centros comerciales y de compras:\n\n'
          '• Centro Comercial Campanario\n'
          '• Centro Histórico de Popayán\n'
          '• Zona Rosa (Calle 5)\n'
          '• Mercado Bolívar\n'
          '• Plaza de Mercado del Norte',
      const Color(0xFFFF6A00),
    );
  }

  void _showWeatherInfo() {
    _showMapDialog(
      '☀️ Clima en Popayán',
      'Condiciones meteorológicas actuales:\n\n'
          '• Temperatura: 24°C\n'
          '• Sensación térmica: 26°C\n'
          '• Humedad: 65%\n'
          '• Viento: 8 km/h\n'
          '• Probabilidad de lluvia: 20%',
      const Color(0xFFFF6A00),
    );
  }

  void _showNotificationsInfo() {
    _showMapDialog(
      '🔔 Notificaciones Activas',
      'Alertas y actualizaciones recientes:\n\n'
          '• Nueva ruta Centro-Universidad (5 min)\n'
          '• Desvío temporal en Calle 5 (15 min)\n'
          '• Horarios extendidos fin de semana (1h)\n'
          '• Mantenimiento programado (2h)',
      const Color(0xFFFF6A00),
    );
  }

  // Método para mostrar información de un punto de interés
  void _showPOIInfo(PointOfInterest poi) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icono y título
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: poi.type.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    poi.type.icon,
                    color: poi.type.color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        poi.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (poi.description != null)
                        Text(
                          poi.description!,
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
            const SizedBox(height: 16),
            // Botón para cerrar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6A00),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Cerrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMapDialog(String title, String content, Color color) {
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
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withValues(alpha: 0.3)),
                ),
                child: Icon(
                  Icons.info_outline,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 15),
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
              height: 1.6,
              color: Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cerrar',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Aquí podrías navegar a páginas específicas
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: const Text('Ver más'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarNavegacionDetallada() {
    NavigationService.pushWithSafeTransition(
      context,
      const SmartSearchPage(),
      type: TransitionType.scale,
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
                            color: Colors.white70,
                            fontSize: 16,
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
                  // Banner nativo animado
                  const NativeBannerWidget(
                    title: 'POPAYÁN',
                    subtitle: 'Tu ciudad conectada',
                  ),

                  const SizedBox(height: 20),

                  // Clima y tráfico
                  const NativeWeatherTrafficWidget(
                    temperature: '24',
                    weatherCondition: 'Parcialmente nublado',
                    trafficStatus: 'Fluido',
                    trafficLevel: 2,
                  ),

                  const SizedBox(height: 20),

                  // Estadísticas en tiempo real mejoradas
                  const ImprovedStatsWidget(
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
                            foregroundColor: const Color(0xFF667eea),
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
                  NativeNewsWidget(newsItems: _getSampleNews()),

                  const SizedBox(height: 20),

                  // Mapa amplio y fluido
                  Container(
                    height: 400, // Más alto como pediste
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
                          // Mapa principal - sin overlays que lo hagan lento
                          fm.FlutterMap(
                            mapController: _mapController,
                            options: fm.MapOptions(
                              initialCenter: _currentPosition != null
                                  ? LatLng(_currentPosition!.latitude,
                                      _currentPosition!.longitude)
                                  : _popayanCenter,
                              initialZoom: 13.5, // Zoom más amplio
                            ),
                            children: [
                              fm.TileLayer(
                                urlTemplate:
                                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                                subdomains: const ['a', 'b', 'c'],
                              ),

                              // Marcadores de puntos de interés por toda la ciudad
                              fm.MarkerLayer(
                                markers: _pointsOfInterest.map((poi) {
                                  return fm.Marker(
                                    point: poi.position,
                                    child: GestureDetector(
                                      onTap: () => _showPOIInfo(poi),
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: poi.type.color,
                                            width: 3,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: poi.type.color
                                                  .withValues(alpha: 0.3),
                                              blurRadius: 8,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Icon(
                                            poi.type.icon,
                                            color: poi.type.color,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),

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

                          // Iconos temáticos bonitos - Lado izquierdo
                          Positioned(
                            bottom: 20,
                            left: 15,
                            child: Column(
                              children: [
                                _buildBeautifulMapIcon(
                                  emoji: '🚌',
                                  label: 'Buses',
                                  color: const Color(0xFFFF6A00),
                                  onTap: () => _showBusInfo(),
                                ),
                                const SizedBox(height: 12),
                                _buildBeautifulMapIcon(
                                  emoji: '🚏',
                                  label: 'Paradas',
                                  color: const Color(0xFFFF6A00),
                                  onTap: () => _showStopsInfo(),
                                ),
                                const SizedBox(height: 12),
                                _buildBeautifulMapIcon(
                                  emoji: '🚦',
                                  label: 'Tráfico',
                                  color: const Color(0xFFFF6A00),
                                  onTap: () => _showTrafficInfo(),
                                ),
                              ],
                            ),
                          ),

                          // Iconos temáticos bonitos - Lado derecho
                          Positioned(
                            bottom: 20,
                            right: 15,
                            child: Column(
                              children: [
                                _buildBeautifulMapIcon(
                                  emoji: '🏥',
                                  label: 'Salud',
                                  color: const Color(0xFFFF6A00),
                                  onTap: () => _showHealthInfo(),
                                ),
                                const SizedBox(height: 12),
                                _buildBeautifulMapIcon(
                                  emoji: '🎓',
                                  label: 'Educación',
                                  color: const Color(0xFFFF6A00),
                                  onTap: () => _showEducationInfo(),
                                ),
                                const SizedBox(height: 12),
                                _buildBeautifulMapIcon(
                                  emoji: '🛍️',
                                  label: 'Comercio',
                                  color: const Color(0xFFFF6A00),
                                  onTap: () => _showCommerceInfo(),
                                ),
                              ],
                            ),
                          ),

                          // Iconos superiores - Información del clima y notificaciones
                          Positioned(
                            top: 15,
                            left: 15,
                            child: Column(
                              children: [
                                _buildInfoMapIcon(
                                  emoji: '☀️',
                                  value: '24°',
                                  color: const Color(0xFFFF6A00),
                                  onTap: () => _showWeatherInfo(),
                                ),
                                const SizedBox(height: 10),
                                _buildInfoMapIcon(
                                  emoji: '🔔',
                                  value: '3',
                                  color: const Color(0xFFFF6A00),
                                  onTap: () => _showNotificationsInfo(),
                                ),
                              ],
                            ),
                          ),

                          // Botón de centrar ubicación - esquina superior derecha
                          Positioned(
                            top: 15,
                            right: 15,
                            child: FloatingActionButton(
                              mini: true,
                              onPressed: _centerOnUserLocation,
                              backgroundColor: Colors.white,
                              elevation: 8,
                              child: const Icon(
                                IconHelper.myLocation,
                                color: Color(0xFFFF6A00),
                                size: 20,
                              ),
                            ),
                          ),

                          // Icono central flotante - RouWhite
                          Positioned(
                            top: 80,
                            left: MediaQuery.of(context).size.width / 2 - 35,
                            child: _buildCentralMapIcon(),
                          ),
                        ],
                      ),
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

  // Widget para iconos bonitos del mapa
  Widget _buildBeautifulMapIcon({
    required String emoji,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(0, 5),
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
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
            // Fondo con gradiente sutil
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(27),
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
                style: const TextStyle(fontSize: 28),
              ),
            ),
            // Indicador de estado activo con pulso
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.6),
                      blurRadius: 6,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
            // Etiqueta en la parte inferior
            Positioned(
              bottom: -25,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para iconos de información con valores
  Widget _buildInfoMapIcon({
    required String emoji,
    required String value,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(27.5),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: color.withValues(alpha: 0.6),
            width: 2.5,
          ),
        ),
        child: Stack(
          children: [
            // Fondo con gradiente
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: RadialGradient(
                  colors: [
                    color.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            // Emoji principal
            Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 24),
              ),
            ),
            // Valor en la esquina
            Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.4),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
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

  // Widget para el icono central de RouWhite
  Widget _buildCentralMapIcon() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6A00).withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFFF6A00),
          width: 4,
        ),
      ),
      child: Stack(
        children: [
          // Fondo con gradiente
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(31),
              gradient: const RadialGradient(
                colors: [
                  Color(0xFFFFE0B2),
                  Colors.white,
                ],
              ),
            ),
          ),
          // Logo/Icono principal
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '🚍',
                  style: TextStyle(fontSize: 32),
                ),
                Text(
                  'RW',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF6A00),
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          // Efecto de pulso
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(31),
                border: Border.all(
                  color: const Color(0xFFFF6A00).withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
