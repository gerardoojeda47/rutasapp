import 'package:dartz/dartz.dart';
import 'package:rouwhite/domain/entities/favorito.dart';
import 'package:rouwhite/domain/entities/ruta.dart';
import 'package:rouwhite/domain/repositories/favoritos_repository.dart';
import 'package:rouwhite/domain/repositories/ruta_repository.dart';

/// Caso de uso para obtener favoritos de un usuario
class ObtenerFavoritosUseCase {
  const ObtenerFavoritosUseCase(this._repository);

  final FavoritosRepository _repository;

  /// Ejecuta el caso de uso para obtener favoritos
  Future<Either<FavoritosFailure, List<Favorito>>> call(
      String usuarioId) async {
    if (usuarioId.isEmpty) {
      return const Left(FavoritosLoadFailure('ID de usuario requerido'));
    }

    return await _repository.obtenerFavoritos(usuarioId);
  }
}

/// Caso de uso para obtener favoritos con información completa de rutas
class ObtenerFavoritosConRutasUseCase {
  const ObtenerFavoritosConRutasUseCase(this._repository);

  final FavoritosRepository _repository;

  /// Ejecuta el caso de uso para obtener favoritos con rutas
  Future<Either<FavoritosFailure, List<FavoritoConRuta>>> call(
      String usuarioId) async {
    if (usuarioId.isEmpty) {
      return const Left(FavoritosLoadFailure('ID de usuario requerido'));
    }

    return await _repository.obtenerFavoritosConRutas(usuarioId);
  }
}

/// Caso de uso para verificar si una ruta es favorita
class EsRutaFavoritaUseCase {
  const EsRutaFavoritaUseCase(this._repository);

  final FavoritosRepository _repository;

  /// Ejecuta el caso de uso para verificar si una ruta es favorita
  Future<Either<FavoritosFailure, bool>> call(
      String usuarioId, String rutaId) async {
    if (usuarioId.isEmpty || rutaId.isEmpty) {
      return const Left(
          FavoritosLoadFailure('Usuario ID y Ruta ID son requeridos'));
    }

    return await _repository.esRutaFavorita(usuarioId, rutaId);
  }
}

/// Caso de uso para agregar una ruta a favoritos
class AgregarFavoritoUseCase {
  const AgregarFavoritoUseCase(this._favoritosRepository, this._rutaRepository);

  final FavoritosRepository _favoritosRepository;
  final RutaRepository _rutaRepository;

  /// Ejecuta el caso de uso para agregar un favorito
  Future<Either<FavoritosFailure, Favorito>> call(
      AgregarFavoritoParams params) async {
    // Validaciones de entrada
    if (params.usuarioId.isEmpty) {
      return const Left(FavoritosSaveFailure('ID de usuario requerido'));
    }

    if (params.rutaId.isEmpty) {
      return const Left(FavoritosSaveFailure('ID de ruta requerido'));
    }

    // Verificar que la ruta existe
    final rutaResult = await _rutaRepository.obtenerRutaPorId(params.rutaId);
    if (rutaResult.isLeft()) {
      return const Left(FavoritosSaveFailure('La ruta especificada no existe'));
    }

    // Verificar si ya está en favoritos
    final yaEsFavoritoResult = await _favoritosRepository.esRutaFavorita(
      params.usuarioId,
      params.rutaId,
    );

    return yaEsFavoritoResult.fold(
      (failure) => Left(failure),
      (yaEsFavorito) async {
        if (yaEsFavorito) {
          return const Left(FavoritoAlreadyExistsFailure(''));
        }

        // Verificar límite de favoritos
        final limitResult =
            await _favoritosRepository.haAlcanzadoLimiteFavoritos(
          params.usuarioId,
        );

        return limitResult.fold(
          (failure) => Left(failure),
          (haAlcanzadoLimite) async {
            if (haAlcanzadoLimite) {
              return const Left(FavoritosSaveFailure(
                  'Has alcanzado el límite máximo de favoritos'));
            }

            return await _favoritosRepository.agregarFavorito(params);
          },
        );
      },
    );
  }
}

/// Caso de uso para remover una ruta de favoritos
class RemoverFavoritoUseCase {
  const RemoverFavoritoUseCase(this._repository);

  final FavoritosRepository _repository;

  /// Ejecuta el caso de uso para remover un favorito por ID
  Future<Either<FavoritosFailure, void>> call(String favoritoId) async {
    if (favoritoId.isEmpty) {
      return const Left(FavoritosSaveFailure('ID de favorito requerido'));
    }

    return await _repository.removerFavorito(favoritoId);
  }
}

/// Caso de uso para remover una ruta de favoritos por usuario y ruta
class RemoverFavoritoPorRutaUseCase {
  const RemoverFavoritoPorRutaUseCase(this._repository);

  final FavoritosRepository _repository;

  /// Ejecuta el caso de uso para remover un favorito por usuario y ruta
  Future<Either<FavoritosFailure, void>> call(
      String usuarioId, String rutaId) async {
    if (usuarioId.isEmpty || rutaId.isEmpty) {
      return const Left(
          FavoritosSaveFailure('Usuario ID y Ruta ID son requeridos'));
    }

    return await _repository.removerFavoritoPorRuta(usuarioId, rutaId);
  }
}

/// Caso de uso para alternar el estado de favorito de una ruta
class ToggleFavoritoUseCase {
  const ToggleFavoritoUseCase(
    this._esRutaFavoritaUseCase,
    this._agregarFavoritoUseCase,
    this._removerFavoritoPorRutaUseCase,
  );

  final EsRutaFavoritaUseCase _esRutaFavoritaUseCase;
  final AgregarFavoritoUseCase _agregarFavoritoUseCase;
  final RemoverFavoritoPorRutaUseCase _removerFavoritoPorRutaUseCase;

  /// Ejecuta el caso de uso para alternar favorito
  Future<Either<FavoritosFailure, bool>> call(
      String usuarioId, String rutaId) async {
    if (usuarioId.isEmpty || rutaId.isEmpty) {
      return const Left(
          FavoritosSaveFailure('Usuario ID y Ruta ID son requeridos'));
    }

    // Verificar estado actual
    final esFavoritoResult = await _esRutaFavoritaUseCase(usuarioId, rutaId);

    return esFavoritoResult.fold(
      (failure) => Left(failure),
      (esFavorito) async {
        if (esFavorito) {
          // Remover de favoritos
          final removeResult =
              await _removerFavoritoPorRutaUseCase(usuarioId, rutaId);
          return removeResult.fold(
            (failure) => Left(failure),
            (_) => const Right(false),
          );
        } else {
          // Agregar a favoritos
          final params = AgregarFavoritoParams(
            usuarioId: usuarioId,
            rutaId: rutaId,
          );
          final addResult = await _agregarFavoritoUseCase(params);
          return addResult.fold(
            (failure) => Left(failure),
            (_) => const Right(true),
          );
        }
      },
    );
  }
}

/// Caso de uso para actualizar un favorito
class ActualizarFavoritoUseCase {
  const ActualizarFavoritoUseCase(this._repository);

  final FavoritosRepository _repository;

  /// Ejecuta el caso de uso para actualizar un favorito
  Future<Either<FavoritosFailure, Favorito>> call(
    String favoritoId,
    ActualizarFavoritoParams params,
  ) async {
    if (favoritoId.isEmpty) {
      return const Left(FavoritosSaveFailure('ID de favorito requerido'));
    }

    if (params.isEmpty) {
      return const Left(FavoritosSaveFailure('No hay datos para actualizar'));
    }

    return await _repository.actualizarFavorito(favoritoId, params);
  }
}

/// Caso de uso para reordenar favoritos
class ReordenarFavoritosUseCase {
  const ReordenarFavoritosUseCase(this._repository);

  final FavoritosRepository _repository;

  /// Ejecuta el caso de uso para reordenar favoritos
  Future<Either<FavoritosFailure, List<Favorito>>> call(
    String usuarioId,
    List<String> nuevoOrden,
  ) async {
    if (usuarioId.isEmpty) {
      return const Left(FavoritosSaveFailure('ID de usuario requerido'));
    }

    if (nuevoOrden.isEmpty) {
      return const Left(
          FavoritosSaveFailure('Nuevo orden no puede estar vacío'));
    }

    return await _repository.reordenarFavoritos(usuarioId, nuevoOrden);
  }
}

/// Caso de uso para buscar favoritos
class BuscarFavoritosUseCase {
  const BuscarFavoritosUseCase(this._repository);

  final FavoritosRepository _repository;

  /// Ejecuta el caso de uso para buscar favoritos
  Future<Either<FavoritosFailure, List<FavoritoConRuta>>> call(
    String usuarioId,
    String query,
  ) async {
    if (usuarioId.isEmpty) {
      return const Left(FavoritosLoadFailure('ID de usuario requerido'));
    }

    if (query.trim().isEmpty) {
      return const Right([]);
    }

    if (query.trim().length < 2) {
      return const Left(
          FavoritosLoadFailure('La búsqueda debe tener al menos 2 caracteres'));
    }

    return await _repository.buscarFavoritos(usuarioId, query.trim());
  }
}

/// Caso de uso para obtener favoritos ordenados
class ObtenerFavoritosOrdenadosUseCase {
  const ObtenerFavoritosOrdenadosUseCase(this._repository);

  final FavoritosRepository _repository;

  /// Ejecuta el caso de uso para obtener favoritos ordenados
  Future<Either<FavoritosFailure, List<FavoritoConRuta>>> call(
    String usuarioId,
    FavoritosOrdenamiento ordenamiento, {
    bool ascendente = true,
  }) async {
    if (usuarioId.isEmpty) {
      return const Left(FavoritosLoadFailure('ID de usuario requerido'));
    }

    return await _repository.obtenerFavoritosOrdenados(
      usuarioId,
      ordenamiento,
      ascendente: ascendente,
    );
  }
}

/// Caso de uso para obtener estadísticas de favoritos
class ObtenerEstadisticasFavoritosUseCase {
  const ObtenerEstadisticasFavoritosUseCase(this._repository);

  final FavoritosRepository _repository;

  /// Ejecuta el caso de uso para obtener estadísticas
  Future<Either<FavoritosFailure, FavoritosEstadisticas>> call(
      String usuarioId) async {
    if (usuarioId.isEmpty) {
      return const Left(FavoritosLoadFailure('ID de usuario requerido'));
    }

    return await _repository.obtenerEstadisticas(usuarioId);
  }
}

/// Caso de uso para limpiar favoritos inactivos
class LimpiarFavoritosInactivosUseCase {
  const LimpiarFavoritosInactivosUseCase(this._repository);

  final FavoritosRepository _repository;

  /// Ejecuta el caso de uso para limpiar favoritos de rutas inactivas
  Future<Either<FavoritosFailure, int>> call(String usuarioId) async {
    if (usuarioId.isEmpty) {
      return const Left(FavoritosSaveFailure('ID de usuario requerido'));
    }

    return await _repository.limpiarFavoritosInactivos(usuarioId);
  }
}

/// Caso de uso para sincronizar favoritos
class SincronizarFavoritosUseCase {
  const SincronizarFavoritosUseCase(this._repository);

  final FavoritosRepository _repository;

  /// Ejecuta el caso de uso para sincronizar favoritos con el servidor
  Future<Either<FavoritosFailure, List<Favorito>>> call(
      String usuarioId) async {
    if (usuarioId.isEmpty) {
      return const Left(FavoritosLoadFailure('ID de usuario requerido'));
    }

    return await _repository.sincronizarFavoritos(usuarioId);
  }
}

/// Caso de uso para obtener sugerencias de favoritos
class ObtenerSugerenciasFavoritosUseCase {
  const ObtenerSugerenciasFavoritosUseCase(this._repository);

  final FavoritosRepository _repository;

  /// Ejecuta el caso de uso para obtener sugerencias de rutas para favoritos
  Future<Either<FavoritosFailure, List<Ruta>>> call(String usuarioId) async {
    if (usuarioId.isEmpty) {
      return const Left(FavoritosLoadFailure('ID de usuario requerido'));
    }

    return await _repository.obtenerSugerenciasFavoritos(usuarioId);
  }
}

/// Caso de uso compuesto para gestión completa de favoritos
class GestionarFavoritosUseCase {
  const GestionarFavoritosUseCase({
    required this.obtenerFavoritos,
    required this.obtenerFavoritosConRutas,
    required this.esRutaFavorita,
    required this.agregarFavorito,
    required this.removerFavorito,
    required this.toggleFavorito,
    required this.actualizarFavorito,
    required this.buscarFavoritos,
    required this.obtenerEstadisticas,
  });

  final ObtenerFavoritosUseCase obtenerFavoritos;
  final ObtenerFavoritosConRutasUseCase obtenerFavoritosConRutas;
  final EsRutaFavoritaUseCase esRutaFavorita;
  final AgregarFavoritoUseCase agregarFavorito;
  final RemoverFavoritoPorRutaUseCase removerFavorito;
  final ToggleFavoritoUseCase toggleFavorito;
  final ActualizarFavoritoUseCase actualizarFavorito;
  final BuscarFavoritosUseCase buscarFavoritos;
  final ObtenerEstadisticasFavoritosUseCase obtenerEstadisticas;
}
