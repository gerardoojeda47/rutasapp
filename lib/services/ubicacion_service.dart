import 'package:latlong2/latlong.dart';
import '../models/ubicacion.dart';

class UbicacionService {
  static final UbicacionService _instance = UbicacionService._internal();
  factory UbicacionService() => _instance;
  UbicacionService._internal();

  // Coordenadas centrales de Popayán
  static const LatLng centroPopayanCoords = LatLng(2.444814, -76.614739);

  // Mapa completo de ubicaciones en Popayán
  final Map<String, Ubicacion> _ubicaciones = {
    // Comuna 1 - Centro Histórico
    'Centro Histórico': Ubicacion(
      nombre: 'Centro Histórico',
      tipo: TipoUbicacion.zona,
      comuna: 'Comuna 1',
      coordenadas: const LatLng(2.444814, -76.614739),
    ),
    'Avelino Ull': Ubicacion(
      nombre: 'Avelino Ull',
      tipo: TipoUbicacion.barrio,
      comuna: 'Comuna 1',
      coordenadas: const LatLng(2.445500, -76.615200),
    ),
    'Braceros': Ubicacion(
      nombre: 'Braceros',
      tipo: TipoUbicacion.barrio,
      comuna: 'Comuna 1',
      coordenadas: const LatLng(2.446000, -76.614800),
    ),
    'El Lago': Ubicacion(
      nombre: 'El Lago',
      tipo: TipoUbicacion.barrio,
      comuna: 'Comuna 1',
      coordenadas: const LatLng(2.447000, -76.613000),
    ),
    'Berlín': Ubicacion(
      nombre: 'Berlín',
      tipo: TipoUbicacion.barrio,
      comuna: 'Comuna 1',
      coordenadas: const LatLng(2.446000, -76.615000),
    ),
    'Suizo': Ubicacion(
      nombre: 'Suizo',
      tipo: TipoUbicacion.barrio,
      comuna: 'Comuna 1',
      coordenadas: const LatLng(2.445000, -76.617000),
    ),
    'Las Ferias': Ubicacion(
      nombre: 'Las Ferias',
      tipo: TipoUbicacion.barrio,
      comuna: 'Comuna 1',
      coordenadas: const LatLng(2.444000, -76.619000),
    ),
    'La Campiña': Ubicacion(
      nombre: 'La Campiña',
      tipo: TipoUbicacion.barrio,
      comuna: 'Comuna 1',
      coordenadas: const LatLng(2.454000, -76.604000),
    ),
    'María Oriente': Ubicacion(
      nombre: 'María Oriente',
      tipo: TipoUbicacion.barrio,
      comuna: 'Comuna 1',
      coordenadas: const LatLng(2.456000, -76.602000),
    ),
    'Los Sauces': Ubicacion(
      nombre: 'Los Sauces',
      tipo: TipoUbicacion.barrio,
      comuna: 'Comuna 1',
      coordenadas: const LatLng(2.452000, -76.606000),
    ),
    'Santa Mónica': Ubicacion(
      nombre: 'Santa Mónica',
      tipo: TipoUbicacion.barrio,
      comuna: 'Comuna 1',
      coordenadas: const LatLng(2.448000, -76.611000),
    ),
    'La Floresta': Ubicacion(
      nombre: 'La Floresta',
      tipo: TipoUbicacion.barrio,
      comuna: 'Comuna 1',
      coordenadas: const LatLng(2.450000, -76.608000),
    ),

    // Comuna 2 - Norte
    'La Paz': Ubicacion(
      nombre: 'La Paz',
      tipo: TipoUbicacion.barrio,
      comuna: 'Comuna 5',
      coordenadas: const LatLng(2.449000, -76.601000),
    ),
    'Jose María Obando': Ubicacion(
      nombre: 'Jose María Obando',
      tipo: TipoUbicacion.barrio,
      comuna: 'Comuna 1',
      coordenadas: const LatLng(2.453000, -76.599000),
    ),
    'San Camilo': Ubicacion(
      nombre: 'San Camilo',
      tipo: TipoUbicacion.barrio,
      comuna: 'Comuna 7',
      coordenadas: const LatLng(2.447500, -76.610000),
    ),
    'La Esmeralda': Ubicacion(
      nombre: 'La Esmeralda',
      tipo: TipoUbicacion.barrio,
      comuna: 'Comuna 8',
      coordenadas: const LatLng(2.440000, -76.600000),
    ),
    'Campan': Ubicacion(
      nombre: 'Campan',
      tipo: TipoUbicacion.barrio,
      comuna: 'Comuna 6',
      coordenadas: const LatLng(2.441500, -76.602500),
    ),
    'El Recuerdo': Ubicacion(
      nombre: 'El Recuerdo',
      tipo: TipoUbicacion.barrio,
      comuna: 'Comuna 6',
      coordenadas: const LatLng(2.442500, -76.605000),
    ),
    'El Uvo': Ubicacion(
      nombre: 'El Uvo',
      tipo: TipoUbicacion.barrio,
      comuna: 'Comuna 2',
      coordenadas: const LatLng(2.455000, -76.620000),
    ),
    'San Eduardo': Ubicacion(
      nombre: 'San Eduardo',
      tipo: TipoUbicacion.barrio,
      comuna: 'Comuna 8',
      coordenadas: const LatLng(2.457000, -76.618000),
    ),
    'Bello Horizonte': Ubicacion(
      nombre: 'Bello Horizonte',
      tipo: TipoUbicacion.barrio,
      comuna: 'Comuna 2',
      coordenadas: const LatLng(2.438000, -76.610000),
    ),
    'El Placer': Ubicacion(
      nombre: 'El Placer',
      tipo: TipoUbicacion.barrio,
      comuna: 'Comuna 2',
      coordenadas: const LatLng(2.437000, -76.612000),
    ),
    'Alfonso López': Ubicacion(
      nombre: 'Alfonso López',
      tipo: TipoUbicacion.barrio,
      comuna: 'Comuna 3',
      coordenadas: const LatLng(2.435000, -76.615000),
    ),
    'El Limonar': Ubicacion(
      nombre: 'El Limonar',
      tipo: TipoUbicacion.barrio,
      comuna: 'Comuna 3',
      coordenadas: const LatLng(2.433000, -76.617000),
    ),
    'El Boquerón': Ubicacion(
      nombre: 'El Boquerón',
      tipo: TipoUbicacion.barrio,
      comuna: 'Comuna 3',
      coordenadas: const LatLng(2.431000, -76.619000),
    ),

    // Puntos de interés
    'Terminal de Transportes': Ubicacion(
      nombre: 'Terminal de Transportes',
      tipo: TipoUbicacion.terminal,
      comuna: 'Centro',
      coordenadas: const LatLng(2.445000, -76.617000),
    ),
    'Universidad del Cauca': Ubicacion(
      nombre: 'Universidad del Cauca',
      tipo: TipoUbicacion.universidad,
      comuna: 'Centro',
      coordenadas: const LatLng(2.444000, -76.613000),
    ),
    'Hospital San José': Ubicacion(
      nombre: 'Hospital San José',
      tipo: TipoUbicacion.hospital,
      comuna: 'Centro',
      coordenadas: const LatLng(2.445500, -76.614000),
    ),
    'Centro Comercial Campanario': Ubicacion(
      nombre: 'Centro Comercial Campanario',
      tipo: TipoUbicacion.centroComercial,
      comuna: 'Centro',
      coordenadas: const LatLng(2.446000, -76.612000),
    ),
    'Plaza de Mercado': Ubicacion(
      nombre: 'Plaza de Mercado',
      tipo: TipoUbicacion.mercado,
      comuna: 'Centro',
      coordenadas: const LatLng(2.444500, -76.615500),
    ),
    'Parque Caldas': Ubicacion(
      nombre: 'Parque Caldas',
      tipo: TipoUbicacion.parque,
      comuna: 'Centro',
      coordenadas: const LatLng(2.444814, -76.614739),
    ),
    'Aeropuerto Guillermo León Valencia': Ubicacion(
      nombre: 'Aeropuerto Guillermo León Valencia',
      tipo: TipoUbicacion.aeropuerto,
      comuna: 'Rural',
      coordenadas: const LatLng(2.420000, -76.610000),
    ),
  };

  // Obtener todas las ubicaciones
  List<Ubicacion> get todasLasUbicaciones => _ubicaciones.values.toList();

  // Buscar ubicaciones por nombre
  List<Ubicacion> buscarUbicaciones(String query) {
    if (query.isEmpty) return [];
    
    final queryLowerCase = query.toLowerCase();
    return _ubicaciones.values.where((ubicacion) =>
        ubicacion.nombre.toLowerCase().contains(queryLowerCase) ||
        ubicacion.comuna.toLowerCase().contains(queryLowerCase)
    ).toList();
  }

  // Obtener ubicación por nombre exacto
  Ubicacion? obtenerUbicacion(String nombre) {
    return _ubicaciones[nombre];
  }

  // Obtener ubicaciones por tipo
  List<Ubicacion> obtenerUbicacionesPorTipo(TipoUbicacion tipo) {
    return _ubicaciones.values.where((ubicacion) => ubicacion.tipo == tipo).toList();
  }

  // Obtener ubicaciones por comuna
  List<Ubicacion> obtenerUbicacionesPorComuna(String comuna) {
    return _ubicaciones.values.where((ubicacion) => ubicacion.comuna == comuna).toList();
  }

  // Calcular distancia entre dos ubicaciones
  double calcularDistancia(LatLng punto1, LatLng punto2) {
    const Distance distance = Distance();
    return distance.as(LengthUnit.Meter, punto1, punto2);
  }

  // Obtener ubicaciones cercanas
  List<Ubicacion> obtenerUbicacionesCercanas(LatLng puntoReferencia, double radioMetros) {
    return _ubicaciones.values.where((ubicacion) {
      final distancia = calcularDistancia(puntoReferencia, ubicacion.coordenadas);
      return distancia <= radioMetros;
    }).toList();
  }

  // Validar si una coordenada está dentro de Popayán
  bool estaDentroDePopayen(LatLng coordenadas) {
    // Límites aproximados de Popayán
    const double latitudMin = 2.400;
    const double latitudMax = 2.500;
    const double longitudMin = -76.650;
    const double longitudMax = -76.580;

    return coordenadas.latitude >= latitudMin &&
           coordenadas.latitude <= latitudMax &&
           coordenadas.longitude >= longitudMin &&
           coordenadas.longitude <= longitudMax;
  }
}