import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';
import 'package:rouwhite/domain/entities/ruta_detallada.dart';
import '../exceptions/network_exceptions.dart';
import '../config/api_config.dart';

/// Servicio para obtener rutas detalladas usando OpenRouteService
class RoutingService {
  final Dio _dio;

  RoutingService({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options.baseUrl = ApiConfig.openRouteServiceBaseUrl;
    _dio.options.connectTimeout = ApiConfig.connectionTimeout;
    _dio.options.receiveTimeout = ApiConfig.receiveTimeout;
    _dio.options.headers = {
      'Authorization': ApiConfig.openRouteServiceApiKey,
      'Content-Type': 'application/json',
    };
  }

  /// Obtiene una ruta detallada entre dos puntos (punto a punto)
  Future<RutaDetallada> obtenerRutaDetallada({
    required LatLng origen,
    required LatLng destino,
    String perfil = 'driving-car', // driving-car, walking, cycling
    bool incluirInstrucciones = true,
    bool incluirGeometria = true,
  }) async {
    try {
      // Usar POST con coordinates para mayor consistencia con la API
      final response = await _dio.post(
        '/directions/$perfil/geojson',
        data: {
          'coordinates': [
            [origen.longitude, origen.latitude],
            [destino.longitude, destino.latitude],
          ],
          'instructions': incluirInstrucciones,
          'geometry': incluirGeometria,
          'language': 'es',
          'units': 'm',
        },
      );

      return _parseRutaDetallada(response.data, origen, destino);
    } on DioException catch (e) {
      throw TimeoutException(message: _handleDioError(e));
    } catch (e) {
      throw const ServerException(message: 'Error al obtener la ruta');
    }
  }

  /// Obtiene una ruta que pasa por todos los waypoints en orden (paradas)
  Future<RutaDetallada> obtenerRutaConWaypoints({
    required List<LatLng> waypoints,
    String perfil = 'driving-car',
    bool incluirInstrucciones = true,
  }) async {
    if (waypoints.length < 2) {
      throw const ServerException(message: 'Se requieren al menos 2 puntos');
    }

    try {
      final coords = waypoints
          .map((p) => [p.longitude, p.latitude])
          .toList(growable: false);

      final response = await _dio.post(
        '/directions/$perfil/geojson',
        data: {
          'coordinates': coords,
          'instructions': incluirInstrucciones,
          'geometry': true,
          'language': 'es',
          'units': 'm',
        },
      );

      return _parseRutaDetallada(
        response.data,
        waypoints.first,
        waypoints.last,
      );
    } on DioException catch (e) {
      throw TimeoutException(message: _handleDioError(e));
    } catch (e) {
      throw const ServerException(
          message: 'Error al obtener la ruta con paradas');
    }
  }

  /// Obtiene múltiples rutas alternativas
  Future<List<RutaDetallada>> obtenerRutasAlternativas({
    required LatLng origen,
    required LatLng destino,
    String perfil = 'driving-car',
    int numeroAlternativas = 3,
  }) async {
    try {
      final response = await _dio.get(
        '/directions/$perfil',
        queryParameters: {
          'start': '${origen.longitude},${origen.latitude}',
          'end': '${destino.longitude},${destino.latitude}',
          'instructions': true,
          'geometry': true,
          'format': 'json',
          'units': 'm',
          'language': 'es',
          'alternative_routes': {
            'target_count': numeroAlternativas,
            'weight_factor': 1.4,
            'share_factor': 0.6,
          },
        },
      );

      final List<RutaDetallada> rutas = [];
      final routes = response.data['routes'] as List;

      for (final route in routes) {
        rutas.add(_parseRutaIndividual(route, origen, destino));
      }

      return rutas;
    } on DioException catch (e) {
      throw TimeoutException(message: _handleDioError(e));
    } catch (e) {
      throw const ServerException(
          message: 'Error al obtener rutas alternativas');
    }
  }

  /// Obtiene información de una dirección (geocoding)
  Future<List<LatLng>> buscarDireccion(String direccion) async {
    try {
      final response = await _dio.get(
        '/geocode/search',
        queryParameters: {
          'text': direccion,
          'boundary.country': 'CO', // Colombia
          'boundary.rect.min_lon': ApiConfig.popayanMinLng,
          'boundary.rect.min_lat': ApiConfig.popayanMinLat,
          'boundary.rect.max_lon': ApiConfig.popayanMaxLng,
          'boundary.rect.max_lat': ApiConfig.popayanMaxLat, // Área de Popayán
          'size': 10,
        },
      );

      final features = response.data['features'] as List;
      return features.map<LatLng>((feature) {
        final coords = feature['geometry']['coordinates'] as List;
        return LatLng(coords[1], coords[0]); // lat, lng
      }).toList();
    } on DioException catch (e) {
      throw TimeoutException(message: _handleDioError(e));
    } catch (e) {
      throw const ServerException(message: 'Error al buscar dirección');
    }
  }

  /// Parsea la respuesta de la API a RutaDetallada
  RutaDetallada _parseRutaDetallada(
    Map<String, dynamic> data,
    LatLng origen,
    LatLng destino,
  ) {
    // Soporta ambas variantes: JSON (routes[]) y GeoJSON (features[])
    if (data.containsKey('routes')) {
      final routes = data['routes'] as List;
      if (routes.isEmpty) {
        throw const ServerException(message: 'No se encontraron rutas');
      }
      return _parseRutaIndividual(
          routes.first as Map<String, dynamic>, origen, destino);
    }

    if (data.containsKey('features')) {
      final features = data['features'] as List;
      if (features.isEmpty) {
        throw const ServerException(message: 'No se encontraron rutas');
      }
      final feature = features.first as Map<String, dynamic>;
      final properties = feature['properties'] as Map<String, dynamic>;
      final geometry = feature['geometry'] as Map<String, dynamic>;

      // Normalizamos a la estructura que espera _parseRutaIndividual
      final normalized = <String, dynamic>{
        'summary': properties['summary'] ?? <String, dynamic>{},
        'segments': properties['segments'] ?? <dynamic>[],
        'geometry': geometry,
      };
      return _parseRutaIndividual(normalized, origen, destino);
    }

    throw const ServerException(message: 'Formato de respuesta no soportado');
  }

  /// Parsea una ruta individual
  RutaDetallada _parseRutaIndividual(
    Map<String, dynamic> route,
    LatLng origen,
    LatLng destino,
  ) {
    final summary = route['summary'] as Map<String, dynamic>;
    // Compatibilidad con respuesta GeoJSON (geometry ya está anidada) o plana
    final geometry = route['geometry'] as Map<String, dynamic>;
    final segments = route['segments'] as List;

    // Parsear puntos de la geometría (GeoJSON: [lng, lat])
    final coordinates = geometry['coordinates'] as List;
    final puntos = coordinates.map<LatLng>((coord) {
      return LatLng((coord[1] as num).toDouble(), (coord[0] as num).toDouble());
    }).toList();

    // Parsear instrucciones
    final List<InstruccionNavegacion> instrucciones = [];
    final List<SegmentoRuta> segmentosRuta = [];

    for (final segment in segments) {
      final steps = segment['steps'] as List;

      for (final step in steps) {
        final instruction = step['instruction'] as String;
        final name = step['name'] as String? ?? 'Calle sin nombre';
        final distance = (step['distance'] as num).toDouble();
        final duration = (step['duration'] as num).toDouble();
        final wayPoints = step['way_points'] as List;

        if (wayPoints.length >= 2) {
          final startIndex = wayPoints[0] as int;
          final endIndex = wayPoints[1] as int;

          if (startIndex < puntos.length && endIndex < puntos.length) {
            final posicion = puntos[startIndex];
            final segmentoPuntos = puntos.sublist(startIndex, endIndex + 1);

            instrucciones.add(InstruccionNavegacion(
              texto: instruction,
              calle: name,
              tipo: _parseTipoInstruccion(step['type'] as int? ?? 0),
              posicion: posicion,
              distancia: distance,
              duracion: Duration(seconds: duration.round()),
            ));

            segmentosRuta.add(SegmentoRuta(
              puntos: segmentoPuntos,
              calle: name,
              distancia: distance,
              duracion: Duration(seconds: duration.round()),
            ));
          }
        }
      }
    }

    return RutaDetallada(
      puntos: puntos,
      instrucciones: instrucciones,
      segmentos: segmentosRuta,
      distanciaTotal: (summary['distance'] as num).toDouble(),
      tiempoEstimado: Duration(seconds: (summary['duration'] as num).round()),
      origen: origen,
      destino: destino,
      descripcion: 'Ruta generada por OpenRouteService',
    );
  }

  /// Convierte el tipo de instrucción de la API al enum local
  TipoInstruccion _parseTipoInstruccion(int tipo) {
    switch (tipo) {
      case 0:
        return TipoInstruccion.girarIzquierda;
      case 1:
        return TipoInstruccion.girarDerecha;
      case 2:
        return TipoInstruccion.girarLigeroIzquierda;
      case 3:
        return TipoInstruccion.girarLigeroDerecha;
      case 4:
        return TipoInstruccion.continuar;
      case 5:
        return TipoInstruccion.rotonda;
      case 6:
        return TipoInstruccion.salirRotonda;
      case 7:
        return TipoInstruccion.uturn;
      case 10:
        return TipoInstruccion.llegada;
      case 11:
        return TipoInstruccion.salida;
      case 12:
        return TipoInstruccion.mantenerIzquierda;
      case 13:
        return TipoInstruccion.mantenerDerecha;
      default:
        return TipoInstruccion.continuar;
    }
  }

  /// Maneja errores de Dio
  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Tiempo de conexión agotado';
      case DioExceptionType.sendTimeout:
        return 'Tiempo de envío agotado';
      case DioExceptionType.receiveTimeout:
        return 'Tiempo de recepción agotado';
      case DioExceptionType.badResponse:
        return 'Error del servidor: ${e.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Solicitud cancelada';
      case DioExceptionType.connectionError:
        return 'Error de conexión';
      default:
        return 'Error de red desconocido';
    }
  }
}

