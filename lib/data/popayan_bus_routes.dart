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

  BusRoute({
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
  static final List<BusRoute> routes = [
    // SOTRACAUCA - RUTA 1: La Paz/Campanario/Pomona/Chirimía
    BusRoute(
      id: 'sotracauca_ruta_1',
      name: 'SOTRACAUCA Ruta 1 - La Paz/Campanario/Pomona/Chirimía',
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
      name: 'SOTRACAUCA Ruta 2 - La Paz/Terminal/San Francisco/Lomas Granada',
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
      name: 'SOTRACAUCA Ruta 3 - Las Palmas/Tomas C./Chirimía/Cra 5/Cra 9',
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
      name: 'SOTRACAUCA Ruta 4 - Cll5/Alfonso López/Cra6/Aida Lucía',
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
      name: 'SOTRACAUCA Ruta 5 - La Paz/Morinda/Centro/Tomas C.',
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
      name: 'SOTRACAUCA Ruta 6 - La Paz/Cra6/Centro/Chirimía/Las Palmas',
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
      name: 'SOTRACAUCA Ruta 7 - Julumito/Cll5/Centro/Parque Industrial',
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
      name: 'SOTRACAUCA Ruta 8 - Las Palmas/Cll5/Centro/Villa Del Viento',
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
      name: 'SOTRACAUCA Ruta 9 - Julumito/Tomas C/Morinda/La Paz',
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
    // TRANSPUBENZA - RUTA 1: La Paz/La Esmeralda/Tomás C./Los Naranjos
    BusRoute(
      id: 'transpubenza_ruta_1',
      name: 'TRANSPUBENZA Ruta 1 - La Paz/La Esmeralda/Tomás C./Los Naranjos',
      company: 'TRANSPUBENZA',
      stops: [
        LatLng(2.4490, -76.6080), // La Paz
        LatLng(2.4515, -76.6065), // La Esmeralda (aprox)
        LatLng(2.4400, -76.6080), // Tomás Cipriano de Mosquera
        LatLng(2.4530, -76.6035), // Los Naranjos (aprox)
      ],
      neighborhoods: ['La Paz', 'La Esmeralda', 'Tomás C.', 'Los Naranjos'],
      schedule: '5:00 AM - 10:00 PM',
      fare: '\$2.800',
      color: '#2E86DE',
      description:
          'Conecta el norte (La Paz, La Esmeralda) con Tomás Cipriano y el sector de Los Naranjos.',
      pointsOfInterest: [
        'La Paz',
        'La Esmeralda',
        'Tomás Cipriano',
        'Los Naranjos'
      ],
      services: ['Servicio continuo', 'Paradas señalizadas'],
      distance: 8.0,
      estimatedTime: 28,
    ),

    // TRANSPUBENZA - RUTA 2: Tomás C./Chirimía/Cra 6/Campanario/Jardines de Paz
    BusRoute(
      id: 'transpubenza_ruta_2',
      name:
          'TRANSPUBENZA Ruta 2 - Tomás C./Chirimía/Cra 6/Campanario/Jardines de Paz',
      company: 'TRANSPUBENZA',
      stops: [
        LatLng(2.4400, -76.6080), // Tomás C.
        LatLng(2.4410, -76.6180), // Chirimía
        LatLng(2.4445, -76.6145), // Carrera 6 - Centro
        LatLng(2.4448, -76.6147), // Campanario (eje Calle 5)
        LatLng(2.4575, -76.6065), // Jardines de Paz (aprox)
      ],
      neighborhoods: [
        'Tomás C.',
        'Chirimía',
        'Carrera 6',
        'Campanario',
        'Jardines de Paz'
      ],
      schedule: '5:00 AM - 10:00 PM',
      fare: '\$2.800',
      color: '#2E86DE',
      description:
          'Ruta transversal con paso por el centro y el eje comercial.',
      pointsOfInterest: ['Carrera 6', 'CC Campanario', 'Jardines de Paz'],
      services: ['Conexión con centro', 'Frecuencia 10-12 min'],
      distance: 9.0,
      estimatedTime: 30,
    ),

    // TRANSPUBENZA - RUTA 3: Los Naranjos/Centro/Terminal/La Aldea
    BusRoute(
      id: 'transpubenza_ruta_3',
      name: 'TRANSPUBENZA Ruta 3 - Los Naranjos/Centro/Terminal/La Aldea',
      company: 'TRANSPUBENZA',
      stops: [
        LatLng(2.4530, -76.6035), // Los Naranjos (aprox)
        LatLng(2.4448, -76.6147), // Centro - Parque Caldas
        LatLng(2.4500, -76.6170), // Terminal
        LatLng(2.4640, -76.5980), // La Aldea (aprox NE)
      ],
      neighborhoods: ['Los Naranjos', 'Centro', 'Terminal', 'La Aldea'],
      schedule: '5:00 AM - 9:30 PM',
      fare: '\$2.800',
      color: '#2E86DE',
      description:
          'Conecta norte-centro-terminal con extensión hacia La Aldea.',
      pointsOfInterest: ['Parque Caldas', 'Terminal'],
      services: ['Paradas principales', 'Acceso a terminal'],
      distance: 10.5,
      estimatedTime: 36,
    ),

    // TRANSPUBENZA - RUTA 4: Línea TP4BT Piscinas Comfa/Cra 5/Cll 13/Lomas Granada
    BusRoute(
      id: 'transpubenza_ruta_4',
      name:
          'TRANSPUBENZA Ruta 4 - TP4BT Piscinas Comfa/Cra 5/Cll 13/Lomas Granada',
      company: 'TRANSPUBENZA',
      stops: [
        LatLng(2.4315, -76.6125), // Piscinas Comfa (aprox)
        LatLng(2.4440, -76.6130), // Carrera 5 (centro)
        LatLng(2.4475, -76.6065), // Calle 13 (aprox)
        LatLng(2.4540, -76.6130), // Lomas Granada
      ],
      neighborhoods: [
        'Piscinas Comfa',
        'Carrera 5',
        'Calle 13',
        'Lomas Granada'
      ],
      schedule: '5:00 AM - 9:30 PM',
      fare: '\$2.800',
      color: '#2E86DE',
      description:
          'Ruta TP4BT con eje centro-Calle 13 y conexión a Lomas Granada.',
      pointsOfInterest: ['Puente Humilladero', 'Calle 13'],
      services: ['Frecuencia 12-15 min'],
      distance: 11.0,
      estimatedTime: 38,
    ),

    // TRANSPUBENZA - RUTA 5: Yambitará/Cra 6/Cll 13/Cementerio/Tomás C.
    BusRoute(
      id: 'transpubenza_ruta_5',
      name: 'TRANSPUBENZA Ruta 5 - Yambitará/Cra 6/Cll 13/Cementerio/Tomás C.',
      company: 'TRANSPUBENZA',
      stops: [
        LatLng(2.4565, -76.5955), // Yambitará (aprox)
        LatLng(2.4445, -76.6145), // Carrera 6
        LatLng(2.4475, -76.6065), // Calle 13
        LatLng(2.4470, -76.6125), // Cementerio (aprox)
        LatLng(2.4400, -76.6080), // Tomás C.
      ],
      neighborhoods: [
        'Yambitará',
        'Carrera 6',
        'Calle 13',
        'Cementerio',
        'Tomás C.'
      ],
      schedule: '5:00 AM - 9:30 PM',
      fare: '\$2.800',
      color: '#2E86DE',
      description: 'Eje norte-centro con paso por Calle 13 y Cementerio.',
      pointsOfInterest: ['Carrera 6', 'Cementerio'],
      services: ['Paradas señalizadas'],
      distance: 10.2,
      estimatedTime: 34,
    ),

    // TRANSPUBENZA - RUTA 6: La Paz/Lácteos Puracé/Calle 13/Los Naranjos
    BusRoute(
      id: 'transpubenza_ruta_6',
      name: 'TRANSPUBENZA Ruta 6 - La Paz/Lácteos Puracé/Calle 13/Los Naranjos',
      company: 'TRANSPUBENZA',
      stops: [
        LatLng(2.4490, -76.6080), // La Paz
        LatLng(2.4520, -76.6020), // Lácteos Puracé (aprox)
        LatLng(2.4475, -76.6065), // Calle 13
        LatLng(2.4530, -76.6035), // Los Naranjos
      ],
      neighborhoods: ['La Paz', 'Lácteos Puracé', 'Calle 13', 'Los Naranjos'],
      schedule: '5:00 AM - 10:00 PM',
      fare: '\$2.800',
      color: '#2E86DE',
      description:
          'Conecta La Paz con el eje productivo de Lácteos Puracé y Los Naranjos.',
      pointsOfInterest: ['Lácteos Puracé', 'Calle 13'],
      services: ['Servicio continuo'],
      distance: 8.6,
      estimatedTime: 29,
    ),

    // TRANSPUBENZA - RUTA 7: Piscinas Comfa/Campanario/Camilo Torres/Cll 13
    BusRoute(
      id: 'transpubenza_ruta_7',
      name:
          'TRANSPUBENZA Ruta 7 - Piscinas Comfa/Campanario/Camilo Torres/Cll 13',
      company: 'TRANSPUBENZA',
      stops: [
        LatLng(2.4315, -76.6125), // Piscinas Comfa (aprox)
        LatLng(2.4448, -76.6147), // Campanario
        LatLng(2.4360, -76.6150), // Camilo Torres (aprox sur)
        LatLng(2.4475, -76.6065), // Calle 13
      ],
      neighborhoods: [
        'Piscinas Comfa',
        'Campanario',
        'Camilo Torres',
        'Calle 13'
      ],
      schedule: '5:30 AM - 9:30 PM',
      fare: '\$2.800',
      color: '#2E86DE',
      description:
          'Ruta sur-centro-norte con cruce por Camilo Torres y Calle 13.',
      pointsOfInterest: ['CC Campanario'],
      services: ['Frecuencia 12-15 min'],
      distance: 10.8,
      estimatedTime: 37,
    ),

    // TRANSPUBENZA - RUTA 8: Lomas Granada/La Esmeralda/Centro/La Villa
    BusRoute(
      id: 'transpubenza_ruta_8',
      name: 'TRANSPUBENZA Ruta 8 - Lomas Granada/La Esmeralda/Centro/La Villa',
      company: 'TRANSPUBENZA',
      stops: [
        LatLng(2.4540, -76.6130), // Lomas Granada
        LatLng(2.4515, -76.6065), // La Esmeralda (aprox)
        LatLng(2.4448, -76.6147), // Centro
        LatLng(2.4485, -76.6070), // La Villa (aprox)
      ],
      neighborhoods: ['Lomas Granada', 'La Esmeralda', 'Centro', 'La Villa'],
      schedule: '5:00 AM - 10:00 PM',
      fare: '\$2.800',
      color: '#2E86DE',
      description: 'Eje norte-centro con destino residencial La Villa.',
      pointsOfInterest: ['Centro Histórico'],
      services: ['Paradas principales'],
      distance: 9.1,
      estimatedTime: 33,
    ),

    // TRANSPUBENZA - RUTA 9: Los Naranjos/Tomás C./La Esmeralda/Cll 13/Morinda
    BusRoute(
      id: 'transpubenza_ruta_9',
      name:
          'TRANSPUBENZA Ruta 9 - Los Naranjos/Tomás C./La Esmeralda/Cll 13/Morinda',
      company: 'TRANSPUBENZA',
      stops: [
        LatLng(2.4530, -76.6035), // Los Naranjos
        LatLng(2.4400, -76.6080), // Tomás C.
        LatLng(2.4515, -76.6065), // La Esmeralda
        LatLng(2.4475, -76.6065), // Calle 13
        LatLng(2.4470, -76.6110), // Morinda (aprox)
      ],
      neighborhoods: [
        'Los Naranjos',
        'Tomás C.',
        'La Esmeralda',
        'Calle 13',
        'Morinda'
      ],
      schedule: '5:00 AM - 10:00 PM',
      fare: '\$2.800',
      color: '#2E86DE',
      description: 'Anillo norte con paso por eje Calle 13 y Morinda.',
      pointsOfInterest: ['Calle 13', 'Morinda'],
      services: ['Servicio continuo'],
      distance: 9.7,
      estimatedTime: 34,
    ),

    // TRANSPUBENZA - RUTA 10: Cra 10/Chirimía/La Esmeralda/Modelo/Morinda
    BusRoute(
      id: 'transpubenza_ruta_10',
      name:
          'TRANSPUBENZA Ruta 10 - Cra 10/Chirimía/La Esmeralda/Modelo/Morinda',
      company: 'TRANSPUBENZA',
      stops: [
        LatLng(2.4460, -76.6100), // Cra 10 (aprox)
        LatLng(2.4410, -76.6180), // Chirimía
        LatLng(2.4515, -76.6065), // La Esmeralda
        LatLng(2.4550, -76.6050), // Modelo (aprox)
        LatLng(2.4470, -76.6110), // Morinda (aprox)
      ],
      neighborhoods: [
        'Carrera 10',
        'Chirimía',
        'La Esmeralda',
        'Modelo',
        'Morinda'
      ],
      schedule: '5:00 AM - 9:30 PM',
      fare: '\$2.800',
      color: '#2E86DE',
      description: 'Eje norte-oriente con retorno por Morinda.',
      pointsOfInterest: ['Barrio Modelo'],
      services: ['Frecuencia 12-15 min'],
      distance: 10.0,
      estimatedTime: 35,
    ),

    // TRANSPUBENZA - RUTA 11: Los Naranjos/Tomás C./Cll 13/Centro/La Venta
    BusRoute(
      id: 'transpubenza_ruta_11',
      name:
          'TRANSPUBENZA Ruta 11 - Los Naranjos/Tomás C./Cll 13/Centro/La Venta',
      company: 'TRANSPUBENZA',
      stops: [
        LatLng(2.4530, -76.6035), // Los Naranjos
        LatLng(2.4400, -76.6080), // Tomás C.
        LatLng(2.4475, -76.6065), // Calle 13
        LatLng(2.4448, -76.6147), // Centro
        LatLng(2.4680, -76.5920), // La Venta (aprox)
      ],
      neighborhoods: [
        'Los Naranjos',
        'Tomás C.',
        'Calle 13',
        'Centro',
        'La Venta'
      ],
      schedule: '5:00 AM - 9:30 PM',
      fare: '\$2.800',
      color: '#2E86DE',
      description: 'Extensión hacia el nororiente (La Venta) desde eje centro.',
      pointsOfInterest: ['Centro Histórico', 'Calle 13'],
      services: ['Paradas principales'],
      distance: 12.3,
      estimatedTime: 42,
    ),

    // TRANSPUBENZA - RUTA 12: Lomas Granada/La Esmeralda/Campanario/SENA Norte
    BusRoute(
      id: 'transpubenza_ruta_12',
      name:
          'TRANSPUBENZA Ruta 12 - Lomas Granada/La Esmeralda/Campanario/SENA Norte',
      company: 'TRANSPUBENZA',
      stops: [
        LatLng(2.4540, -76.6130), // Lomas Granada
        LatLng(2.4515, -76.6065), // La Esmeralda
        LatLng(2.4448, -76.6147), // Campanario
        LatLng(2.4590, -76.6040), // SENA Norte (aprox)
      ],
      neighborhoods: [
        'Lomas Granada',
        'La Esmeralda',
        'Campanario',
        'SENA Norte'
      ],
      schedule: '5:00 AM - 10:00 PM',
      fare: '\$2.800',
      color: '#2E86DE',
      description: 'Conexión norte con eje educativo SENA Norte.',
      pointsOfInterest: ['CC Campanario', 'SENA Norte'],
      services: ['Frecuencia 12-15 min'],
      distance: 9.4,
      estimatedTime: 33,
    ),

    // TRANSPUBENZA - RUTA 13: Puelenje/Centro/Cra 6/Lácteos Puracé/Calibío
    BusRoute(
      id: 'transpubenza_ruta_13',
      name:
          'TRANSPUBENZA Ruta 13 - Puelenje/Centro/Cra 6/Lácteos Puracé/Calibío',
      company: 'TRANSPUBENZA',
      stops: [
        LatLng(2.4250, -76.6400), // Puelenje (aprox SW)
        LatLng(2.4448, -76.6147), // Centro
        LatLng(2.4445, -76.6145), // Carrera 6
        LatLng(2.4520, -76.6020), // Lácteos Puracé
        LatLng(2.4425, -76.5900), // Calibío (aprox E)
      ],
      neighborhoods: [
        'Puelenje',
        'Centro',
        'Carrera 6',
        'Lácteos Puracé',
        'Calibío'
      ],
      schedule: '5:00 AM - 9:00 PM',
      fare: '\$2.800',
      color: '#2E86DE',
      description:
          'Ruta larga que cruza de suroccidente al oriente por el centro.',
      pointsOfInterest: ['Centro Histórico', 'Carrera 6'],
      services: ['Servicio extendido'],
      distance: 16.0,
      estimatedTime: 55,
    ),

    // TRANSLIBERTAD - RUTA 1: Calle 5
    BusRoute(
      id: 'translibertad_ruta_1',
      name: 'TRANSLIBERTAD Ruta 1 - Calle 5',
      company: 'TRANSLIBERTAD',
      stops: [
        LatLng(2.4510, -76.6200), // Calle 5 - Occidente
        LatLng(2.4448, -76.6147), // Calle 5 - Centro
        LatLng(2.4450, -76.6120), // Carrera 9
        LatLng(2.4460, -76.6100), // Carrera 10
        LatLng(2.4490, -76.6080), // La Paz (conexión norte)
      ],
      neighborhoods: ['Calle 5', 'Centro', 'Carrera 9', 'Carrera 10', 'La Paz'],
      schedule: '5:00 AM - 10:00 PM',
      fare: '\$2.800',
      color: '#1ABC9C',
      description:
          'Recorrido principal por la Calle 5 conectando el occidente con el Centro y el norte.',
      pointsOfInterest: ['Parque Caldas', 'Centro Histórico'],
      services: ['Frecuencia 8-12 min'],
      distance: 7.2,
      estimatedTime: 24,
    ),

    // TRANSLIBERTAD - RUTA 2: Transversal 9 Norte
    BusRoute(
      id: 'translibertad_ruta_2',
      name: 'TRANSLIBERTAD Ruta 2 - Transversal 9 Norte',
      company: 'TRANSLIBERTAD',
      stops: [
        LatLng(2.4540, -76.6130), // Lomas de Granada
        LatLng(2.4520, -76.6050), // Zona Anarkos / Carrera 9 Norte
        LatLng(2.4580, -76.6030), // Transversal 9 Norte
        LatLng(2.4610, -76.5990), // Calle 68 Norte (aprox)
        LatLng(2.4630, -76.5960), // Carrera 17 Norte (aprox)
        LatLng(2.4490, -76.6080), // La Paz
      ],
      neighborhoods: [
        'Lomas de Granada',
        'Carrera 9 Norte',
        'Transversal 9 Norte',
        'Calle 68 Norte',
        'Carrera 17',
        'La Paz'
      ],
      schedule: '5:00 AM - 10:00 PM',
      fare: '\$2.800',
      color: '#16A085',
      description:
          'Conecta el corredor de la Transversal 9 Norte con Lomas de Granada y La Paz.',
      services: ['Frecuencia 10-15 min'],
      distance: 10.3,
      estimatedTime: 33,
    ),

    // TRANSLIBERTAD - RUTA 3: Corredor Carrera 9 Norte
    BusRoute(
      id: 'translibertad_ruta_3',
      name: 'TRANSLIBERTAD Ruta 3 - Carrera 9 Norte/Centro',
      company: 'TRANSLIBERTAD',
      stops: [
        LatLng(2.4520, -76.6050), // Carrera 9 Norte (Anarkos)
        LatLng(2.4480, -76.6080), // Conexión norte-centro
        LatLng(2.4448, -76.6147), // Centro - Calle 5
        LatLng(2.4460, -76.6130), // Centro Histórico
        LatLng(2.4600, -76.6000), // Carrera 17 Norte
        LatLng(2.4615, -76.5950), // Calle 68 Norte
      ],
      neighborhoods: [
        'Carrera 9 Norte',
        'Centro',
        'Calle 5',
        'Carrera 17',
        'Calle 68 Norte'
      ],
      schedule: '5:00 AM - 10:00 PM',
      fare: '\$2.800',
      color: '#27AE60',
      description:
          'Eje norte por Carrera 9 con conexión al Centro y retorno por el sector 17 Norte.',
      services: ['Frecuencia 10-15 min'],
      distance: 9.1,
      estimatedTime: 31,
    ),

    // TRANSLIBERTAD - RUTA 4: TL2M Lomas de Granada → Calle 5
    BusRoute(
      id: 'translibertad_ruta_4',
      name: 'TRANSLIBERTAD Ruta 4 - Lomas de Granada/Calle 5',
      company: 'TRANSLIBERTAD',
      stops: [
        LatLng(2.4545, -76.6135), // Lomas de Granada
        LatLng(2.4520, -76.6100), // Calle 3B (aprox)
        LatLng(2.4485, -76.6125), // Conexión hacia centro
        LatLng(2.4448, -76.6147), // Calle 5 - Centro
      ],
      neighborhoods: ['Lomas de Granada', 'Calle 3B', 'Centro', 'Calle 5'],
      schedule: '5:00 AM - 10:00 PM',
      fare: '\$2.800',
      color: '#2ECC71',
      description:
          'Línea TL2M conectando Lomas de Granada con el Centro por la Calle 5.',
      services: ['Frecuencia 12-18 min'],
      distance: 6.4,
      estimatedTime: 22,
    ),

    // TRANSLIBERTAD - RUTA 5: Oeste Calle 5 – Centro – Norte
    BusRoute(
      id: 'translibertad_ruta_5',
      name: 'TRANSLIBERTAD Ruta 5 - Calle 5/Carreras 6-9/Transversal 7',
      company: 'TRANSLIBERTAD',
      stops: [
        LatLng(2.4390, -76.6200), // Calle 5 - occidente
        LatLng(2.4448, -76.6147), // Calle 5 - Centro
        LatLng(2.4445, -76.6145), // Carrera 6
        LatLng(2.4560, -76.5950), // Transversal 7 - 48 Norte
        LatLng(2.4450, -76.6120), // Carrera 9
      ],
      neighborhoods: [
        'Calle 5',
        'Centro',
        'Carrera 6',
        'Transversal 7',
        'Carrera 9'
      ],
      schedule: '5:00 AM - 10:00 PM',
      fare: '\$2.800',
      color: '#3498DB',
      description:
          'Cubre el eje de la Calle 5 y se abre hacia el norte por Transversal 7 y Carrera 9.',
      services: ['Frecuencia 10-15 min'],
      distance: 10.8,
      estimatedTime: 36,
    ),

    // TRANSLIBERTAD - RUTA 6: Calle 73 Norte circular
    BusRoute(
      id: 'translibertad_ruta_6',
      name: 'TRANSLIBERTAD Ruta 6 - Calle 73 Norte (circular)',
      company: 'TRANSLIBERTAD',
      stops: [
        LatLng(2.4680, -76.5950), // Calle 73 Norte - Oriente
        LatLng(2.4700, -76.6000), // Calle 73 Norte - Occidente
        LatLng(2.4660, -76.5970), // Tramo medio
      ],
      neighborhoods: ['Calle 73 Norte', 'Zona Norte'],
      schedule: '5:00 AM - 10:00 PM',
      fare: '\$2.800',
      color: '#9B59B6',
      description:
          'Servicio circular en el extremo norte alrededor de la Calle 73 Norte.',
      services: ['Frecuencia 15-20 min'],
      distance: 5.0,
      estimatedTime: 18,
    ),

    // TRANSLIBERTAD - RUTA 7: Piendamó – Popayán
    BusRoute(
      id: 'translibertad_ruta_7',
      name: 'TRANSLIBERTAD Ruta 7 - Piendamó/Popayán/Calle 5',
      company: 'TRANSLIBERTAD',
      stops: [
        LatLng(2.6560, -76.5350), // Piendamó (aprox)
        LatLng(2.4710, -76.6000), // Ingreso norte Popayán (aprox)
        LatLng(2.4540, -76.6130), // Lomas de Granada
        LatLng(2.4448, -76.6147), // Calle 5 - Centro
        LatLng(2.4410, -76.6160), // Calle 5 - Occidente
        LatLng(2.4500, -76.6170), // Terminal de Transportes
      ],
      neighborhoods: [
        'Piendamó',
        'Ingresos Norte',
        'Lomas de Granada',
        'Calle 5',
        'Terminal'
      ],
      schedule: '5:00 AM - 10:00 PM',
      fare: '\$2.800',
      color: '#E67E22',
      description:
          'Servicio intermunicipal Piendamó - Popayán con ingreso por el norte y paso por Calle 5.',
      services: ['Frecuencia variable', 'Conexión intermunicipal'],
      distance: 32.0,
      estimatedTime: 70,
    ),

    // TRANSLIBERTAD - RUTA 8: Corredor Carrera 45 y Calle 5
    BusRoute(
      id: 'translibertad_ruta_8',
      name: 'TRANSLIBERTAD Ruta 8 - Carrera 45/Calle 5/Carrera 9',
      company: 'TRANSLIBERTAD',
      stops: [
        LatLng(2.4700, -76.5850), // Carrera 45 (aprox oriente/norte)
        LatLng(2.4540, -76.6130), // Lomas de Granada
        LatLng(2.4448, -76.6147), // Calle 5 - Centro
        LatLng(2.4520, -76.6050), // Carrera 9 Norte
        LatLng(2.4500, -76.6170), // Terminal de Transportes
      ],
      neighborhoods: [
        'Carrera 45',
        'Lomas de Granada',
        'Calle 5',
        'Carrera 9',
        'Terminal'
      ],
      schedule: '5:00 AM - 10:00 PM',
      fare: '\$2.800',
      color: '#F1C40F',
      description:
          'Conecta el eje oriental (Cra 45) con el Centro y la Carrera 9, finalizando en el Terminal.',
      services: ['Frecuencia 12-18 min'],
      distance: 12.6,
      estimatedTime: 40,
    ),
    // TRANSTAMBO - RUTA 1: Villa Del Viento/Piscinas Comfa./Cra6/Cll13/Lomas G.
    BusRoute(
      id: 'transtambo_ruta_1',
      name:
          'TRANSTAMBO Ruta 1 - Villa Del Viento/Piscinas Comfa./Cra 6/Cll 13/Lomas G.',
      company: 'TRANSTAMBO',
      stops: [
        LatLng(2.4480, -76.6080), // Villa Del Viento
        LatLng(2.4560, -76.6065), // Piscinas Comfa (aprox)
        LatLng(2.4445, -76.6145), // Carrera 6 - Centro
        LatLng(2.4520, -76.6065), // Calle 13 (aprox)
        LatLng(2.4540, -76.6130), // Lomas de Granada
      ],
      neighborhoods: [
        'Villa Del Viento',
        'Piscinas Comfa',
        'Carrera 6',
        'Calle 13',
        'Lomas de Granada'
      ],
      schedule: '5:00 AM - 10:00 PM',
      fare: '\$2.800',
      color: '#1F77B4',
      description:
          'Conecta Villa Del Viento con el corredor de Carrera 6, sube por Calle 13 y finaliza en Lomas de Granada.',
      services: ['Frecuencia 10-15 min'],
      distance: 9.0,
      estimatedTime: 30,
    ),

    // TRANSTAMBO - RUTA 2: Las Guacas/Sena N/Centro/Lomas G
    BusRoute(
      id: 'transtambo_ruta_2',
      name: 'TRANSTAMBO Ruta 2 - Las Guacas/SENA Norte/Centro/Lomas G.',
      company: 'TRANSTAMBO',
      stops: [
        LatLng(2.4405, -76.6270), // Las Guacas (aprox)
        LatLng(2.4590, -76.6035), // SENA Norte (aprox)
        LatLng(2.4448, -76.6147), // Centro - Parque Caldas
        LatLng(2.4540, -76.6130), // Lomas de Granada
      ],
      neighborhoods: ['Las Guacas', 'SENA Norte', 'Centro', 'Lomas de Granada'],
      schedule: '5:00 AM - 10:00 PM',
      fare: '\$2.800',
      color: '#FF5733',
      description:
          'Une el sector de Las Guacas con SENA Norte y el Centro, terminando en Lomas de Granada.',
      services: ['Frecuencia 10-15 min'],
      distance: 10.2,
      estimatedTime: 34,
    ),

    // TRANSTAMBO - RUTA 3: Lomas G/Tomas C/Chirimía/Cra3/Morinda
    BusRoute(
      id: 'transtambo_ruta_3',
      name: 'TRANSTAMBO Ruta 3 - Lomas G./Tomás C./Chirimía/Cra 3/Morinda',
      company: 'TRANSTAMBO',
      stops: [
        LatLng(2.4540, -76.6130), // Lomas de Granada
        LatLng(2.4400, -76.6080), // Tomás Cipriano de Mosquera
        LatLng(2.4410, -76.6180), // Chirimía
        LatLng(2.4440, -76.6115), // Carrera 3 (aprox centro-este)
        LatLng(2.4470, -76.6110), // Morinda
      ],
      neighborhoods: [
        'Lomas de Granada',
        'Tomás Cipriano',
        'Chirimía',
        'Carrera 3',
        'Morinda'
      ],
      schedule: '5:00 AM - 10:00 PM',
      fare: '\$2.800',
      color: '#8E44AD',
      description:
          'Baja de Lomas a Tomás Cipriano, cruza por Chirimía y el eje de Carrera 3 hasta Morinda.',
      services: ['Frecuencia 10-15 min'],
      distance: 8.6,
      estimatedTime: 28,
    ),

    // TRANSTAMBO - RUTA 4: Los Llanos/La Paz/Lácteos Puracé/Centro/Las Palmas
    BusRoute(
      id: 'transtambo_ruta_4',
      name:
          'TRANSTAMBO Ruta 4 - Los Llanos/La Paz/Lácteos Puracé/Centro/Las Palmas',
      company: 'TRANSTAMBO',
      stops: [
        LatLng(2.4350, -76.6220), // Los Llanos (aprox)
        LatLng(2.4490, -76.6080), // La Paz
        LatLng(2.4460, -76.6200), // Lácteos Puracé (aprox)
        LatLng(2.4448, -76.6147), // Centro - Parque Caldas
        LatLng(2.4380, -76.6050), // Las Palmas
      ],
      neighborhoods: [
        'Los Llanos',
        'La Paz',
        'Lácteos Puracé',
        'Centro',
        'Las Palmas'
      ],
      schedule: '5:00 AM - 10:00 PM',
      fare: '\$2.800',
      color: '#2E86C1',
      description:
          'Conecta el suroccidente (Los Llanos) con La Paz y Centro, finalizando en Las Palmas.',
      services: ['Frecuencia 12-18 min'],
      distance: 11.4,
      estimatedTime: 37,
    ),

    // TRANSTAMBO - RUTA 5: Morinda/Lácteos Puracé/Centro/Lomas G.
    BusRoute(
      id: 'transtambo_ruta_5',
      name: 'TRANSTAMBO Ruta 5 - Morinda/Lácteos Puracé/Centro/Lomas G.',
      company: 'TRANSTAMBO',
      stops: [
        LatLng(2.4470, -76.6110), // Morinda
        LatLng(2.4460, -76.6200), // Lácteos Puracé (aprox)
        LatLng(2.4448, -76.6147), // Centro - Parque Caldas
        LatLng(2.4540, -76.6130), // Lomas de Granada
      ],
      neighborhoods: [
        'Morinda',
        'Lácteos Puracé',
        'Centro',
        'Lomas de Granada'
      ],
      schedule: '5:00 AM - 10:00 PM',
      fare: '\$2.800',
      color: '#17A589',
      description:
          'Ruta directa desde Morinda hacia el Centro y subida a Lomas de Granada.',
      services: ['Frecuencia 10-15 min'],
      distance: 7.9,
      estimatedTime: 27,
    ),

    // TRANSTAMBO - RUTA 6: Los Llanos/La Paz/La Esmeralda/Cajete
    BusRoute(
      id: 'transtambo_ruta_6',
      name: 'TRANSTAMBO Ruta 6 - Los Llanos/La Paz/La Esmeralda/Cajete',
      company: 'TRANSTAMBO',
      stops: [
        LatLng(2.4350, -76.6220), // Los Llanos (aprox)
        LatLng(2.4490, -76.6080), // La Paz
        LatLng(2.4515, -76.6065), // La Esmeralda (aprox)
        LatLng(2.4550, -76.6400), // Cajete (aprox rural occidente)
      ],
      neighborhoods: ['Los Llanos', 'La Paz', 'La Esmeralda', 'Cajete'],
      schedule: '5:00 AM - 10:00 PM',
      fare: '\$2.800',
      color: '#CA6F1E',
      description:
          'Conecta Los Llanos y La Paz con La Esmeralda y servicio hacia Cajete.',
      services: ['Frecuencia 15-20 min'],
      distance: 14.8,
      estimatedTime: 45,
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
