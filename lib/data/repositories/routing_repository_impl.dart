import 'package:dartz/dartz.dart';
import 'package:latlong2/latlong.dart';
import '../../domain/entities/ruta_detallada.dart';
import '../../domain/repositories/routing_repository.dart';
import '../../core/exceptions/app_exceptions.dart';
import '../../core/exceptions/network_exceptions.dart';
import '../../core/services/routing_service.dart';

/// Implementación del repositorio de routing
class RoutingRepositoryImpl implements RoutingRepository {
  final RoutingService _routingService;

  RoutingRepositoryImpl({
    required RoutingService routingService,
  }) : _routingService = routingService;

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
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return const Left(ServerException(message: 'Error inesperado'));
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
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return const Left(ServerException(message: 'Error inesperado'));
    }
  }

  @override
  Future<Either<AppException, List<LatLng>>> buscarDireccion(
    String direccion,
  ) async {
    try {
      final resultados = await _routingService.buscarDireccion(direccion);
      return Right(resultados);
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return const Left(ServerException(message: 'Error inesperado'));
    }
  }

  @override
  Future<Either<AppException, RutaDetallada>> obtenerRutaTransportePublico({
    required LatLng origen,
    required LatLng destino,
    DateTime? horaPartida,
  }) async {
    try {
      // Para transporte público, usamos el perfil de caminata
      // En una implementación real, aquí integrarías con APIs específicas
      // de transporte público como GTFS o APIs locales
      final ruta = await _routingService.obtenerRutaDetallada(
        origen: origen,
        destino: destino,
        perfil: 'foot-walking',
      );

      // Aquí podrías agregar lógica para combinar con rutas de bus
      return Right(ruta);
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return const Left(ServerException(message: 'Error inesperado'));
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
    } on AppException catch (e) {
      return Left(e);
    } catch (e) {
      return const Left(ServerException(message: 'Error inesperado'));
    }
  }
}
