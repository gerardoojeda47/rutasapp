import 'package:dartz/dartz.dart';
import 'package:latlong2/latlong.dart';
import '../../domain/entities/ruta_detallada.dart';
import '../../domain/repositories/routing_repository.dart';
import '../../core/exceptions/app_exceptions.dart';
import '../../core/services/routing_service_mock.dart';

/// Implementación mock del repositorio de routing para demo
class RoutingRepositoryMock implements RoutingRepository {
  final RoutingServiceMock _routingService = RoutingServiceMock();

  @override
  Future<Either<AppException, RutaDetallada>> obtenerRutaDetallada({
    required LatLng origen,
    required LatLng destino,
    String perfil = 'driving-car',
  }) async {
    try {
      final ruta = await _routingService.obtenerRutaDetallada(
        origen: origen,
        destino: destino,
        perfil: perfil,
      );
      return Right(ruta);
    } catch (e) {
      return const Left(ValidationException('Error al obtener ruta simulada'));
    }
  }

  @override
  Future<Either<AppException, List<RutaDetallada>>> obtenerRutasAlternativas({
    required LatLng origen,
    required LatLng destino,
    String perfil = 'driving-car',
    int numeroAlternativas = 3,
  }) async {
    try {
      final rutas = await _routingService.obtenerRutasAlternativas(
        origen: origen,
        destino: destino,
        perfil: perfil,
        numeroAlternativas: numeroAlternativas,
      );
      return Right(rutas);
    } catch (e) {
      return const Left(
          ValidationException('Error al obtener rutas alternativas simuladas'));
    }
  }

  @override
  Future<Either<AppException, List<LatLng>>> buscarDireccion(
    String direccion,
  ) async {
    try {
      final resultados = await _routingService.buscarDireccion(direccion);
      return Right(resultados);
    } catch (e) {
      return const Left(
          ValidationException('Error al buscar dirección simulada'));
    }
  }

  @override
  Future<Either<AppException, RutaDetallada>> obtenerRutaTransportePublico({
    required LatLng origen,
    required LatLng destino,
    DateTime? horaPartida,
  }) async {
    try {
      final ruta = await _routingService.obtenerRutaDetallada(
        origen: origen,
        destino: destino,
        perfil: 'foot-walking',
      );
      return Right(ruta);
    } catch (e) {
      return const Left(ValidationException(
          'Error al obtener ruta de transporte público simulada'));
    }
  }

  @override
  Future<Either<AppException, Map<String, dynamic>>> calcularDistanciaTiempo({
    required LatLng origen,
    required LatLng destino,
  }) async {
    try {
      final ruta = await _routingService.obtenerRutaDetallada(
        origen: origen,
        destino: destino,
        incluirInstrucciones: false,
        incluirGeometria: false,
      );

      return Right({
        'distancia': ruta.distanciaTotal,
        'tiempo': ruta.tiempoEstimado.inSeconds,
        'distancia_formateada': ruta.distanciaTotalFormateada,
        'tiempo_formateado': ruta.tiempoEstimadoFormateado,
      });
    } catch (e) {
      return const Left(ValidationException(
          'Error al calcular distancia y tiempo simulados'));
    }
  }
}

