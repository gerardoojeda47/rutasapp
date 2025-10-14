import 'package:dartz/dartz.dart';
import 'package:rouwhite/domain/entities/ruta.dart';
import 'package:rouwhite/domain/repositories/ruta_repository.dart';

/// Caso de uso para obtener todas las rutas disponibles
class ObtenerRutasUseCase {
  const ObtenerRutasUseCase(this._repository);

  final RutaRepository _repository;

  /// Ejecuta el caso de uso para obtener todas las rutas
  Future<Either<RutaFailure, List<Ruta>>> call() async {
    return await _repository.obtenerRutas();
  }
}

/// Caso de uso para obtener una ruta específica por ID
class ObtenerRutaPorIdUseCase {
  const ObtenerRutaPorIdUseCase(this._repository);

  final RutaRepository _repository;

  /// Ejecuta el caso de uso para obtener una ruta por ID
  Future<Either<RutaFailure, Ruta>> call(String rutaId) async {
    if (rutaId.isEmpty) {
      return const Left(RutaNotFoundFailure(''));
    }

    return await _repository.obtenerRutaPorId(rutaId);
  }
}

/// Caso de uso para obtener rutas filtradas
class ObtenerRutasFiltradasUseCase {
  const ObtenerRutasFiltradasUseCase(this._repository);

  final RutaRepository _repository;

  /// Ejecuta el caso de uso para obtener rutas filtradas
  Future<Either<RutaFailure, List<Ruta>>> call(RutaFilter filtro) async {
    return await _repository.obtenerRutasFiltradas(filtro);
  }
}

/// Caso de uso para buscar rutas por texto
class BuscarRutasPorTextoUseCase {
  const BuscarRutasPorTextoUseCase(this._repository);

  final RutaRepository _repository;

  /// Ejecuta el caso de uso para buscar rutas por texto
  Future<Either<RutaFailure, List<Ruta>>> call(String query) async {
    if (query.trim().isEmpty) {
      return const Right([]);
    }

    if (query.trim().length < 2) {
      return const Left(
          RutaSearchFailure('La búsqueda debe tener al menos 2 caracteres'));
    }

    return await _repository.buscarRutasPorTexto(query.trim());
  }
}

/// Caso de uso para buscar rutas entre dos paradas
class BuscarRutasEntreUseCase {
  const BuscarRutasEntreUseCase(this._repository);

  final RutaRepository _repository;

  /// Ejecuta el caso de uso para buscar rutas entre dos paradas
  Future<Either<RutaFailure, List<RutaConInfo>>> call(
      BusquedaRutaParams params) async {
    // Validaciones de entrada
    if (params.origenId.isEmpty || params.destinoId.isEmpty) {
      return const Left(RutaSearchFailure('Origen y destino son requeridos'));
    }

    if (params.origenId == params.destinoId) {
      return const Left(
          RutaSearchFailure('Origen y destino no pueden ser iguales'));
    }

    if (params.maxTransbordos < 0 || params.maxTransbordos > 5) {
      return const Left(RutaSearchFailure('Número de transbordos inválido'));
    }

    return await _repository.buscarRutasEntre(params);
  }
}

/// Caso de uso para obtener rutas por parada
class ObtenerRutasPorParadaUseCase {
  const ObtenerRutasPorParadaUseCase(this._repository);

  final RutaRepository _repository;

  /// Ejecuta el caso de uso para obtener rutas que pasan por una parada
  Future<Either<RutaFailure, List<Ruta>>> call(String paradaId) async {
    if (paradaId.isEmpty) {
      return const Left(RutaSearchFailure('ID de parada requerido'));
    }

    return await _repository.obtenerRutasPorParada(paradaId);
  }
}

/// Caso de uso para obtener rutas por empresa
class ObtenerRutasPorEmpresaUseCase {
  const ObtenerRutasPorEmpresaUseCase(this._repository);

  final RutaRepository _repository;

  /// Ejecuta el caso de uso para obtener rutas de una empresa específica
  Future<Either<RutaFailure, List<Ruta>>> call(String empresa) async {
    if (empresa.trim().isEmpty) {
      return const Left(RutaSearchFailure('Nombre de empresa requerido'));
    }

    return await _repository.obtenerRutasPorEmpresa(empresa.trim());
  }
}

/// Caso de uso para obtener empresas disponibles
class ObtenerEmpresasUseCase {
  const ObtenerEmpresasUseCase(this._repository);

  final RutaRepository _repository;

  /// Ejecuta el caso de uso para obtener todas las empresas
  Future<Either<RutaFailure, List<String>>> call() async {
    return await _repository.obtenerEmpresas();
  }
}

/// Caso de uso para obtener rutas cercanas a una ubicación
class ObtenerRutasCercanasUseCase {
  const ObtenerRutasCercanasUseCase(this._repository);

  final RutaRepository _repository;

  /// Ejecuta el caso de uso para obtener rutas cercanas
  Future<Either<RutaFailure, List<Ruta>>> call({
    required double latitud,
    required double longitud,
    double radioEnMetros = 1000.0,
  }) async {
    // Validaciones de coordenadas
    if (latitud < -90 || latitud > 90) {
      return const Left(RutaSearchFailure('Latitud inválida'));
    }

    if (longitud < -180 || longitud > 180) {
      return const Left(RutaSearchFailure('Longitud inválida'));
    }

    if (radioEnMetros <= 0 || radioEnMetros > 50000) {
      return const Left(RutaSearchFailure('Radio de búsqueda inválido'));
    }

    return await _repository.obtenerRutasCercanas(
        latitud, longitud, radioEnMetros);
  }
}

/// Caso de uso para obtener estadísticas de rutas
class ObtenerEstadisticasRutasUseCase {
  const ObtenerEstadisticasRutasUseCase(this._repository);

  final RutaRepository _repository;

  /// Ejecuta el caso de uso para obtener estadísticas
  Future<Either<RutaFailure, RutaEstadisticas>> call() async {
    return await _repository.obtenerEstadisticas();
  }
}

/// Caso de uso para refrescar datos de rutas
class RefrescarRutasUseCase {
  const RefrescarRutasUseCase(this._repository);

  final RutaRepository _repository;

  /// Ejecuta el caso de uso para refrescar rutas desde el servidor
  Future<Either<RutaFailure, void>> call() async {
    return await _repository.refrescarRutas();
  }
}

/// Caso de uso para obtener información de tráfico
class ObtenerInfoTraficoUseCase {
  const ObtenerInfoTraficoUseCase(this._repository);

  final RutaRepository _repository;

  /// Ejecuta el caso de uso para obtener información de tráfico
  Future<Either<RutaFailure, Map<String, TraficoInfo>>> call() async {
    return await _repository.obtenerInfoTrafico();
  }
}

/// Caso de uso para obtener información de tráfico de una ruta específica
class ObtenerInfoTraficoRutaUseCase {
  const ObtenerInfoTraficoRutaUseCase(this._repository);

  final RutaRepository _repository;

  /// Ejecuta el caso de uso para obtener información de tráfico de una ruta
  Future<Either<RutaFailure, TraficoInfo?>> call(String rutaId) async {
    if (rutaId.isEmpty) {
      return const Left(RutaSearchFailure('ID de ruta requerido'));
    }

    final result = await _repository.obtenerInfoTrafico();

    return result.fold(
      (failure) => Left(failure),
      (traficoMap) => Right(traficoMap[rutaId]),
    );
  }
}

/// Caso de uso compuesto para obtener rutas con información de tráfico
class ObtenerRutasConTraficoUseCase {
  const ObtenerRutasConTraficoUseCase(
    this._obtenerRutasUseCase,
    this._obtenerInfoTraficoUseCase,
  );

  final ObtenerRutasUseCase _obtenerRutasUseCase;
  final ObtenerInfoTraficoUseCase _obtenerInfoTraficoUseCase;

  /// Ejecuta el caso de uso para obtener rutas con información de tráfico
  Future<Either<RutaFailure, List<RutaConTrafico>>> call() async {
    // Obtener rutas
    final rutasResult = await _obtenerRutasUseCase();
    if (rutasResult.isLeft()) {
      return rutasResult.fold(
        (failure) => Left(failure),
        (_) => const Left(RutasLoadFailure('Error inesperado')),
      );
    }

    final rutas = rutasResult.getOrElse(() => []);

    // Obtener información de tráfico
    final traficoResult = await _obtenerInfoTraficoUseCase();
    final traficoMap = traficoResult.getOrElse(() => <String, TraficoInfo>{});

    // Combinar información
    final rutasConTrafico = rutas.map((ruta) {
      final trafico = traficoMap[ruta.id];
      return RutaConTrafico(ruta: ruta, trafico: trafico);
    }).toList();

    return Right(rutasConTrafico);
  }
}

/// Clase que combina una ruta con su información de tráfico
class RutaConTrafico {
  const RutaConTrafico({
    required this.ruta,
    this.trafico,
  });

  final Ruta ruta;
  final TraficoInfo? trafico;

  bool get tieneInfoTrafico => trafico != null;

  NivelTrafico get nivelTrafico => trafico?.nivel ?? NivelTrafico.fluido;

  Duration get tiempoAdicional => trafico?.tiempoAdicional ?? Duration.zero;

  String get descripcionTrafico => trafico?.descripcion ?? 'Sin información';
}

