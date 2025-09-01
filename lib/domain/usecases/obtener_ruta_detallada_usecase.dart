import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import '../entities/ruta_detallada.dart';
import '../repositories/routing_repository.dart';
import '../../core/exceptions/app_exceptions.dart';
import '../../core/exceptions/network_exceptions.dart';

/// Parámetros para obtener ruta detallada
class ObtenerRutaDetalladaParams extends Equatable {
  const ObtenerRutaDetalladaParams({
    required this.origen,
    required this.destino,
    this.perfil = 'driving-car',
    this.incluirAlternativas = false,
    this.numeroAlternativas = 3,
  });

  final LatLng origen;
  final LatLng destino;
  final String perfil; // 'driving-car', 'foot-walking', 'cycling-regular'
  final bool incluirAlternativas;
  final int numeroAlternativas;

  @override
  List<Object?> get props => [
        origen,
        destino,
        perfil,
        incluirAlternativas,
        numeroAlternativas,
      ];
}

/// Caso de uso para obtener rutas detalladas con instrucciones
class ObtenerRutaDetalladaUseCase {
  final RoutingRepository _repository;

  ObtenerRutaDetalladaUseCase(this._repository);

  /// Ejecuta el caso de uso
  Future<Either<AppException, List<RutaDetallada>>> call(
    ObtenerRutaDetalladaParams params,
  ) async {
    // Validar parámetros
    final validationResult = _validateParams(params);
    if (validationResult != null) {
      return Left(validationResult);
    }

    try {
      if (params.incluirAlternativas) {
        // Obtener rutas alternativas
        return await _repository.obtenerRutasAlternativas(
          origen: params.origen,
          destino: params.destino,
          perfil: params.perfil,
          numeroAlternativas: params.numeroAlternativas,
        );
      } else {
        // Obtener solo la ruta principal
        final result = await _repository.obtenerRutaDetallada(
          origen: params.origen,
          destino: params.destino,
          perfil: params.perfil,
        );

        return result.fold(
          (error) => Left(error),
          (ruta) => Right([ruta]),
        );
      }
    } catch (e) {
      return const Left(
          ServerException(message: 'Error inesperado al obtener ruta'));
    }
  }

  /// Valida los parámetros de entrada
  ValidationException? _validateParams(ObtenerRutaDetalladaParams params) {
    // Validar coordenadas de origen
    if (!_isValidLatLng(params.origen)) {
      return const ValidationException('Coordenadas de origen inválidas');
    }

    // Validar coordenadas de destino
    if (!_isValidLatLng(params.destino)) {
      return const ValidationException('Coordenadas de destino inválidas');
    }

    // Validar que origen y destino no sean iguales
    if (_areCoordinatesEqual(params.origen, params.destino)) {
      return const ValidationException(
        'El origen y destino no pueden ser iguales',
      );
    }

    // Validar perfil
    const perfilesValidos = [
      'driving-car',
      'foot-walking',
      'cycling-regular',
      'wheelchair',
    ];
    if (!perfilesValidos.contains(params.perfil)) {
      return ValidationException(
        'Perfil inválido. Debe ser uno de: ${perfilesValidos.join(', ')}',
      );
    }

    // Validar número de alternativas
    if (params.numeroAlternativas < 1 || params.numeroAlternativas > 5) {
      return const ValidationException(
        'El número de alternativas debe estar entre 1 y 5',
      );
    }

    return null;
  }

  /// Valida si las coordenadas son válidas
  bool _isValidLatLng(LatLng coords) {
    return coords.latitude >= -90 &&
        coords.latitude <= 90 &&
        coords.longitude >= -180 &&
        coords.longitude <= 180;
  }

  /// Verifica si dos coordenadas son iguales (con tolerancia)
  bool _areCoordinatesEqual(LatLng coord1, LatLng coord2) {
    const tolerance = 0.0001; // ~11 metros
    return (coord1.latitude - coord2.latitude).abs() < tolerance &&
        (coord1.longitude - coord2.longitude).abs() < tolerance;
  }
}

/// Caso de uso para buscar direcciones
class BuscarDireccionUseCase {
  final RoutingRepository _repository;

  BuscarDireccionUseCase(this._repository);

  Future<Either<AppException, List<LatLng>>> call(String direccion) async {
    if (direccion.trim().isEmpty) {
      return const Left(
        ValidationException('La dirección no puede estar vacía'),
      );
    }

    if (direccion.trim().length < 3) {
      return const Left(
        ValidationException('La dirección debe tener al menos 3 caracteres'),
      );
    }

    return await _repository.buscarDireccion(direccion.trim());
  }
}

/// Caso de uso para calcular distancia y tiempo
class CalcularDistanciaTiempoUseCase {
  final RoutingRepository _repository;

  CalcularDistanciaTiempoUseCase(this._repository);

  Future<Either<AppException, Map<String, dynamic>>> call({
    required LatLng origen,
    required LatLng destino,
  }) async {
    // Validar coordenadas
    if (!_isValidLatLng(origen)) {
      return const Left(ValidationException('Coordenadas de origen inválidas'));
    }

    if (!_isValidLatLng(destino)) {
      return const Left(
          ValidationException('Coordenadas de destino inválidas'));
    }

    return await _repository.calcularDistanciaTiempo(
      origen: origen,
      destino: destino,
    );
  }

  bool _isValidLatLng(LatLng coords) {
    return coords.latitude >= -90 &&
        coords.latitude <= 90 &&
        coords.longitude >= -180 &&
        coords.longitude <= 180;
  }
}
