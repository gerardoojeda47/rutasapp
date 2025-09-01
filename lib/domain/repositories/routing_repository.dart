import 'package:dartz/dartz.dart';
import 'package:latlong2/latlong.dart';
import '../entities/ruta_detallada.dart';
import '../../core/exceptions/app_exceptions.dart';

/// Repositorio para operaciones de routing y navegación
abstract class RoutingRepository {
  /// Obtiene una ruta detallada entre dos puntos
  Future<Either<AppException, RutaDetallada>> obtenerRutaDetallada({
    required LatLng origen,
    required LatLng destino,
    String perfil = 'driving-car',
  });

  /// Obtiene múltiples rutas alternativas
  Future<Either<AppException, List<RutaDetallada>>> obtenerRutasAlternativas({
    required LatLng origen,
    required LatLng destino,
    String perfil = 'driving-car',
    int numeroAlternativas = 3,
  });

  /// Busca direcciones por texto
  Future<Either<AppException, List<LatLng>>> buscarDireccion(String direccion);

  /// Obtiene la ruta optimizada para transporte público
  Future<Either<AppException, RutaDetallada>> obtenerRutaTransportePublico({
    required LatLng origen,
    required LatLng destino,
    DateTime? horaPartida,
  });

  /// Calcula la distancia y tiempo entre dos puntos
  Future<Either<AppException, Map<String, dynamic>>> calcularDistanciaTiempo({
    required LatLng origen,
    required LatLng destino,
  });
}
