import 'dart:math';
import 'package:latlong2/latlong.dart';

/// Información de rutas de bus en Popayán
class BusRoute {
  final String id;
  final String name;
  final String company;
  final List<LatLng> stops;
  final List<String> neighborhoods;
  final String schedule;
  final String fare;
  final String color;
  final String? description;
  final List<String>? pointsOfInterest;
  final List<String>? services;
  final double? distance;
  final int? estimatedTime;

  const BusRoute({
    required this.id,
    required this.name,
    required this.company,
    required this.stops,
    required this.neighborhoods,
    required this.schedule,
    required this.fare,
    required this.color,
    this.description,
    this.pointsOfInterest,
    this.services,
    this.distance,
    this.estimatedTime,
  });
}

/// Base de datos de rutas de bus reales en Popayán
class PopayanBusRoutes {
  static const List<BusRoute> routes = [
    // SOTRACAUCA - RUTA 1: La Paz/Campanario/Pomona/Chirimía
    BusRoute(
      id: 'sotracauca_ruta_1',
      name: 'Ruta 1 - La Paz/Campanario/Pomona/Chirimía',
      company: 'SOTRACAUCA',
      stops: [
        LatLng(2.4490, -76.6080), // La Paz
        LatLng(2.4470, -76.6100), // Conexión hacia Campanario
        LatLng(2.4448, -76.6147), // Centro Comercial Campanario
        LatLng(2.4430, -76.6160), // Pomona
        LatLng(2.4410, -76.6180), // Chirimía
        LatLng(2.4400, -76.6200), // Terminal Chirimía
      ],
      neighborhoods: ['La Paz', 'Campanario', 'Pomona', 'Chirimía'],
      schedule: '5:00 AM - 10:00 PM',
      fare: '\$2.800',
      color: '#FF6B35',
      description:
          'Ruta que conecta el barrio La Paz con Campanario, pasando por Pomona y terminando en Chirimía. Ideal para acceso al centro comercial y zonas residenciales del norte.',
      pointsOfInterest: [
        'Centro Comercial Campanario',
        'Barrio La Paz',
        'Zona Pomona',
        'Terminal Chirimía',
        'Conexión con otras rutas'
      ],
      services: [
        'Servicio frecuente cada 10 minutos',
        'Buses con capacidad para 40 pasajeros',
        'Paradas señalizadas',
        'Conexión directa al centro comercial'
      ],
      distance: 8.5,
      estimatedTime: 25,
    ),

    // SOTRACAUCA - RUTA 2: La Paz/Terminal/San Francisco/Lomas Granada
    BusRoute(
      id: 'sotracauca_ruta_2',
      name: 'Ruta 2 - La Paz/Terminal/San Francisco/Lomas Granada',
      company: 'SOTRACAUCA',
      stops: [
        LatLng(2.4490, -76.6080), // La Paz
        LatLng(2.4480, -76.6120), // Conexión hacia Terminal
        LatLng(2.4500, -76.6170), // Terminal de Transportes
        LatLng(2.4520, -76.6150), // San Francisco
        LatLng(2.4540, -76.6130), // Lomas Granada
        LatLng(2.4560, -76.6110), // Terminal Lomas Granada
      ],
      neighborhoods: ['La Paz', 'Terminal', 'San Francisco', 'Lomas Granada'],
      schedule: '5:00 AM - 10:00 PM',
      fare: '\$2.800',
      color: '#FF8C42',
      description:
          'Ruta estratégica que conecta La Paz con el Terminal de Transportes, continuando hacia San Francisco y Lomas Granada. Esencial para viajeros y residentes del norte.',
      pointsOfInterest: [
        'Terminal de Transportes',
        'Barrio La Paz',
        'San Francisco',
        'Lomas Granada',
        'Conexión intermunicipal'
      ],
      services: [
        'Conexión directa con Terminal',
        'Servicio de equipaje permitido',
        'Paradas techadas principales',
        'Información turística en Terminal'
      ],
      distance: 9.2,
      estimatedTime: 30,
    ),

    // SOTRACAUCA - RUTA 3: Las Palmas/Tomas C./Chirimía/Cra 5/Cra 9
    BusRoute(
      id: 'sotracauca_ruta_3',
      name: 'Ruta 3 - Las Palmas/Tomas C./Chirimía/Cra 5/Cra 9',
      company: 'SOTRACAUCA',
      stops: [
        LatLng(2.4380, -76.6050), // Las Palmas
        LatLng(2.4400, -76.6080), // Tomas Cipriano de Mosquera
        LatLng(2.4410, -76.6180), // Chirimía
        LatLng(2.4440, -76.6140), // Carrera 5 - Centro
        LatLng(2.4450, -76.6120), // Carrera 9
        LatLng(2.4460, -76.6100), // Terminal Carrera 9
      ],
      neighborhoods: [
        'Las Palmas',
        'Tomas Cipriano',
        'Chirimía',
        'Centro',
        'Carrera 9'
      ],
      schedule: '5:00 AM - 10:00 PM',
      fare: '\$2.800',
      color: '#FFAA5A',
      description:
          'Ruta que atraviesa importantes arterias de la ciudad, conectando Las Palmas con el centro histórico a través de Tomas Cipriano y las principales carreras.',
      pointsOfInterest: [
        'Barrio Las Palmas',
        'Tomas Cipriano de Mosquera',
        'Centro Histórico',
        'Carrera 5 - Zona Comercial',
        'Carrera 9 - Zona Norte'
      ],
      services: [
        'Recorrido por el centro histórico',
        'Conexión con zona comercial',
        'Paradas en puntos estratégicos',
        'Servicio continuo'
      ],
      distance: 7.8,
      estimatedTime: 28,
    ),

    // SOTRACAUCA - RUTA 4: Cll5/Alfonso López/Cra6/Aida Lucía
    BusRoute(
      id: 'sotracauca_ruta_4',
      name: 'Ruta 4 - Cll5/Alfonso López/Cra6/Aida Lucía',
      company: 'SOTRACAUCA',
      stops: [
        LatLng(2.4448, -76.6147), // Calle 5 - Centro
        LatLng(2.4430, -76.6160), // Conexión Alfonso López
        LatLng(2.4340, -76.6190), // Alfonso López
        LatLng(2.4445, -76.6145), // Carrera 6 - Centro
        LatLng(2.4350, -76.6200), // Aida Lucía
        LatLng(2.4330, -76.6220), // Terminal Aida Lucía
      ],
      neighborhoods: ['Centro', 'Alfonso López', 'Carrera 6', 'Aida Lucía'],
      schedule: '5:00 AM - 10:00 PM',
      fare: '\$2.800',
      color: '#FFC971',
      description:
          'Ruta del sur que conecta el centro histórico con los barrios populares, pasando por Alfonso López y terminando en Aida Lucía. Importante para la movilidad de trabajadores y estudiantes.',
      pointsOfInterest: [
        'Centro Histórico - Calle 5',
        'Barrio Alfonso López',
        'Carrera 6 - Zona Bancaria',
        'Aida Lucía',
        'Conexión sur de la ciudad'
      ],
      services: [
        'Descuento estudiantil',
        'Paradas señalizadas',
        'Servicio matutino temprano',
        'Conexión con rutas del centro'
      ],
      distance: 6.5,
      estimatedTime: 22,
    ),

    // SOTRACAUCA - RUTA 5: La Paz/Morinda/Centro/Tomas C.
    BusRoute(
      id: 'sotracauca_ruta_5',
      name: 'Ruta 5 - La Paz/Morinda/Centro/Tomas C.',
      company: 'SOTRACAUCA',
      stops: [
        LatLng(2.4490, -76.6080), // La Paz
        LatLng(2.4470, -76.6110), // Morinda
        LatLng(2.4448, -76.6147), // Centro - Parque Caldas
        LatLng(2.4430, -76.6160), // Conexión Tomas C.
        LatLng(2.4400, -76.6080), // Tomas Cipriano de Mosquera
        LatLng(2.4380, -76.6060), // Terminal Tomas C.
      ],
      neighborhoods: ['La Paz', 'Morinda', 'Centro', 'Tomas Cipriano'],
      schedule: '5:00 AM - 10:00 PM',
      fare: '\$2.800',
      color: '#FFE66D',
      description:
          'Ruta circular que conecta La Paz con el centro de la ciudad, pasando por Morinda y terminando en Tomas Cipriano de Mosquera. Excelente para acceso al centro histórico.',
      pointsOfInterest: [
        'Barrio La Paz',
        'Morinda',
        'Parque Caldas - Centro',
        'Tomas Cipriano de Mosquera',
        'Centro Histórico UNESCO'
      ],
      services: [
        'Acceso directo al centro histórico',
        'Conexión con zona universitaria',
        'Paradas en puntos turísticos',
        'Servicio frecuente'
      ],
      distance: 7.0,
      estimatedTime: 25,
    ),

    // SOTRACAUCA - RUTA 6: La Paz/Cra6/Centro/Chirimía/Las Palmas
    BusRoute(
      id: 'sotracauca_ruta_6',
      name: 'Ruta 6 - La Paz/Cra6/Centro/Chirimía/Las Palmas',
      company: 'SOTRACAUCA',
      stops: [
        LatLng(2.4490, -76.6080), // La Paz
        LatLng(2.4470, -76.6130), // Conexión Carrera 6
        LatLng(2.4445, -76.6145), // Carrera 6 - Centro
        LatLng(2.4448, -76.6147), // Centro - Parque Caldas
        LatLng(2.4410, -76.6180), // Chirimía
        LatLng(2.4380, -76.6050), // Las Palmas
      ],
      neighborhoods: [
        'La Paz',
        'Carrera 6',
        'Centro',
        'Chirimía',
        'Las Palmas'
      ],
      schedule: '5:00 AM - 10:00 PM',
      fare: '\$2.800',
      color: '#A8E6CF',
      description:
          'Ruta integral que conecta múltiples sectores importantes de la ciudad, desde La Paz hasta Las Palmas, pasando por el centro y la zona bancaria de la Carrera 6.',
      pointsOfInterest: [
        'Barrio La Paz',
        'Carrera 6 - Zona Bancaria',
        'Centro Histórico',
        'Chirimía',
        'Las Palmas'
      ],
      services: [
        'Conexión con zona bancaria',
        'Acceso al centro histórico',
        'Paradas en puntos comerciales',
        'Servicio integral'
      ],
      distance: 8.8,
      estimatedTime: 32,
    ),

    // SOTRACAUCA - RUTA 7: Julumito/Cll5/Centro/Parque Industrial
    BusRoute(
      id: 'sotracauca_ruta_7',
      name: 'Ruta 7 - Julumito/Cll5/Centro/Parque Industrial',
      company: 'SOTRACAUCA',
      stops: [
        LatLng(2.4300, -76.6300), // Julumito
        LatLng(2.4350, -76.6250), // Conexión Calle 5
        LatLng(2.4448, -76.6147), // Calle 5 - Centro
        LatLng(2.4460, -76.6130), // Centro Histórico
        LatLng(2.4500, -76.6200), // Parque Industrial
        LatLng(2.4520, -76.6220), // Terminal Parque Industrial
      ],
      neighborhoods: ['Julumito', 'Calle 5', 'Centro', 'Parque Industrial'],
      schedule: '5:00 AM - 10:00 PM',
      fare: '\$2.800',
      color: '#88D8B0',
      description:
          'Ruta que conecta la zona rural de Julumito con el centro de la ciudad y el Parque Industrial, facilitando el transporte de trabajadores y estudiantes.',
      pointsOfInterest: [
        'Julumito - Zona Rural',
        'Calle 5 - Eje Central',
        'Centro Histórico',
        'Parque Industrial',
        'Zona de Empresas'
      ],
      services: [
        'Conexión rural-urbana',
        'Transporte de trabajadores',
        'Horarios especiales industriales',
        'Tarifas preferenciales'
      ],
      distance: 12.5,
      estimatedTime: 40,
    ),

    // SOTRACAUCA - RUTA 8: Las Palmas/Cll5/Centro/Villa Del Viento
    BusRoute(
      id: 'sotracauca_ruta_8',
      name: 'Ruta 8 - Las Palmas/Cll5/Centro/Villa Del Viento',
      company: 'SOTRACAUCA',
      stops: [
        LatLng(2.4380, -76.6050), // Las Palmas
        LatLng(2.4420, -76.6120), // Conexión Calle 5
        LatLng(2.4448, -76.6147), // Calle 5 - Centro
        LatLng(2.4460, -76.6130), // Centro Histórico
        LatLng(2.4480, -76.6080), // Villa Del Viento
        LatLng(2.4500, -76.6060), // Terminal Villa Del Viento
      ],
      neighborhoods: ['Las Palmas', 'Calle 5', 'Centro', 'Villa Del Viento'],
      schedule: '5:00 AM - 10:00 PM',
      fare: '\$2.800',
      color: '#FFB3BA',
      description:
          'Ruta que une Las Palmas con Villa Del Viento, pasando por el eje central de la Calle 5 y el centro histórico. Importante para la conectividad norte-sur.',
      pointsOfInterest: [
        'Las Palmas',
        'Calle 5 - Corredor Principal',
        'Centro Histórico',
        'Villa Del Viento',
        'Zona Residencial Norte'
      ],
      services: [
        'Conexión norte-sur',
        'Paso por corredor principal',
        'Acceso a zona residencial',
        'Servicio continuo'
      ],
      distance: 9.5,
      estimatedTime: 35,
    ),

    // SOTRACAUCA - RUTA 9: Julumito/Tomas C/Morinda/La Paz
    BusRoute(
      id: 'sotracauca_ruta_9',
      name: 'Ruta 9 - Julumito/Tomas C/Morinda/La Paz',
      company: 'SOTRACAUCA',
      stops: [
        LatLng(2.4300, -76.6300), // Julumito
        LatLng(2.4350, -76.6200), // Conexión Tomas C.
        LatLng(2.4400, -76.6080), // Tomas Cipriano de Mosquera
        LatLng(2.4470, -76.6110), // Morinda
        LatLng(2.4490, -76.6080), // La Paz
        LatLng(2.4510, -76.6060), // Terminal La Paz
      ],
      neighborhoods: ['Julumito', 'Tomas Cipriano', 'Morinda', 'La Paz'],
      schedule: '5:00 AM - 10:00 PM',
      fare: '\$2.800',
      color: '#BFACC8',
      description:
          'Ruta circular que conecta la zona rural de Julumito con importantes barrios del norte, pasando por Tomas Cipriano, Morinda y terminando en La Paz.',
      pointsOfInterest: [
        'Julumito - Zona Rural',
        'Tomas Cipriano de Mosquera',
        'Morinda',
        'La Paz',
        'Conexión Rural-Urbana'
      ],
      services: [
        'Servicio rural-urbano',
        'Conexión con barrios populares',
        'Transporte de estudiantes',
        'Horarios extendidos'
      ],
      distance: 11.0,
      estimatedTime: 38,
    ),
  ];

  /// Obtiene todas las rutas disponibles
  static List<BusRoute> getAllRoutes() {
    return routes;
  }

  /// Obtiene rutas por empresa
  static List<BusRoute> getRoutesByCompany(String company) {
    return routes.where((route) => route.company == company).toList();
  }

  /// Obtiene una ruta por ID
  static BusRoute? getRouteById(String id) {
    try {
      return routes.firstWhere((route) => route.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Obtiene todas las empresas de transporte
  static List<String> getCompanies() {
    return routes.map((route) => route.company).toSet().toList()..sort();
  }

  /// Busca rutas que pasen por un barrio específico
  static List<BusRoute> getRoutesByNeighborhood(String neighborhood) {
    return routes
        .where((route) => route.neighborhoods
            .any((n) => n.toLowerCase().contains(neighborhood.toLowerCase())))
        .toList();
  }

  /// Obtiene rutas cercanas a una ubicación
  static List<BusRoute> getNearbyRoutes(LatLng location, double radiusKm) {
    const double earthRadius = 6371; // Radio de la Tierra en km

    return routes.where((route) {
      return route.stops.any((stop) {
        // Cálculo de distancia usando fórmula de Haversine
        double lat1Rad = location.latitude * (3.14159 / 180);
        double lon1Rad = location.longitude * (3.14159 / 180);
        double lat2Rad = stop.latitude * (3.14159 / 180);
        double lon2Rad = stop.longitude * (3.14159 / 180);

        double dLat = lat2Rad - lat1Rad;
        double dLon = lon2Rad - lon1Rad;

        double a = sin(dLat / 2) * sin(dLat / 2) +
            cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);
        double c = 2 * asin(sqrt(a));
        double distance = earthRadius * c;

        return distance <= radiusKm;
      });
    }).toList();
  }

  /// Encuentra rutas cercanas (alias para getNearbyRoutes)
  static List<BusRoute> findNearbyRoutes(LatLng location, double radiusKm) {
    return getNearbyRoutes(location, radiusKm);
  }

  /// Obtiene la distancia a la parada más cercana de una ruta
  static double getDistanceToNearestStop(BusRoute route, LatLng location) {
    const double earthRadius = 6371; // Radio de la Tierra en km

    double minDistance = double.infinity;

    for (LatLng stop in route.stops) {
      // Cálculo de distancia usando fórmula de Haversine
      double lat1Rad = location.latitude * (pi / 180);
      double lon1Rad = location.longitude * (pi / 180);
      double lat2Rad = stop.latitude * (pi / 180);
      double lon2Rad = stop.longitude * (pi / 180);

      double dLat = lat2Rad - lat1Rad;
      double dLon = lon2Rad - lon1Rad;

      double a = sin(dLat / 2) * sin(dLat / 2) +
          cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);
      double c = 2 * asin(sqrt(a));
      double distance = earthRadius * c;

      if (distance < minDistance) {
        minDistance = distance;
      }
    }

    return minDistance;
  }
}
