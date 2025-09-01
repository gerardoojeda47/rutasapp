import 'package:dartz/dartz.dart';
import '../entities/favorito.dart';
import '../entities/ruta.dart';
import '../../core/exceptions/app_exceptions.dart';

/// Tipos de falla que pueden ocurrir en operaciones de favoritos
abstract class FavoritosFailure extends AppException {
  const FavoritosFailure(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);
}

class FavoritoNotFoundFailure extends FavoritosFailure {
  const FavoritoNotFoundFailure(String favoritoId)
      : super('Favorito con ID $favoritoId no encontrado',
            code: 'FAVORITO_NOT_FOUND');
}

class FavoritoAlreadyExistsFailure extends FavoritosFailure {
  const FavoritoAlreadyExistsFailure(String rutaId)
      : super('La ruta $rutaId ya está en favoritos', code: 'FAVORITO_EXISTS');
}

class FavoritosLoadFailure extends FavoritosFailure {
  const FavoritosLoadFailure(String message, {dynamic originalError})
      : super(message,
            code: 'FAVORITOS_LOAD_ERROR', originalError: originalError);
}

class FavoritosSaveFailure extends FavoritosFailure {
  const FavoritosSaveFailure(String message, {dynamic originalError})
      : super(message,
            code: 'FAVORITOS_SAVE_ERROR', originalError: originalError);
}

/// Parámetros para agregar un favorito
class AgregarFavoritoParams {
  const AgregarFavoritoParams({
    required this.usuarioId,
    required this.rutaId,
    this.alias,
    this.notificacionesHabilitadas = false,
  });

  final String usuarioId;
  final String rutaId;
  final String? alias;
  final bool notificacionesHabilitadas;
}

/// Parámetros para actualizar un favorito
class ActualizarFavoritoParams {
  const ActualizarFavoritoParams({
    this.alias,
    this.orden,
    this.notificacionesHabilitadas,
  });

  final String? alias;
  final int? orden;
  final bool? notificacionesHabilitadas;

  bool get isEmpty =>
      alias == null && orden == null && notificacionesHabilitadas == null;
}

/// Opciones de ordenamiento para favoritos
enum FavoritosOrdenamiento {
  fechaAgregado,
  nombre,
  alias,
  orden,
  empresa,
  costo;

  String get displayName {
    switch (this) {
      case FavoritosOrdenamiento.fechaAgregado:
        return 'Fecha agregado';
      case FavoritosOrdenamiento.nombre:
        return 'Nombre de ruta';
      case FavoritosOrdenamiento.alias:
        return 'Alias';
      case FavoritosOrdenamiento.orden:
        return 'Orden personalizado';
      case FavoritosOrdenamiento.empresa:
        return 'Empresa';
      case FavoritosOrdenamiento.costo:
        return 'Costo';
    }
  }
}

/// Favorito con información completa de la ruta
class FavoritoConRuta {
  const FavoritoConRuta({
    required this.favorito,
    required this.ruta,
  });

  final Favorito favorito;
  final Ruta ruta;

  String get nombreParaMostrar => favorito.alias ?? ruta.nombre;

  bool get rutaActiva => ruta.isOperativa;

  String get empresa => ruta.empresa;

  double get costo => ruta.costo;
}

/// Estadísticas de favoritos del usuario
class FavoritosEstadisticas {
  const FavoritosEstadisticas({
    required this.totalFavoritos,
    required this.favoritosRecientes,
    required this.conNotificaciones,
    required this.empresaMasFavorita,
    required this.costoPromedio,
    required this.favoritoMasAntiguo,
    required this.favoritoMasReciente,
  });

  final int totalFavoritos;
  final int favoritosRecientes;
  final int conNotificaciones;
  final String? empresaMasFavorita;
  final double costoPromedio;
  final Favorito? favoritoMasAntiguo;
  final Favorito? favoritoMasReciente;

  double get porcentajeConNotificaciones =>
      totalFavoritos > 0 ? (conNotificaciones / totalFavoritos) * 100 : 0;

  double get porcentajeRecientes =>
      totalFavoritos > 0 ? (favoritosRecientes / totalFavoritos) * 100 : 0;
}

/// Repositorio para operaciones relacionadas con favoritos
abstract class FavoritosRepository {
  /// Obtiene todos los favoritos de un usuario
  Future<Either<FavoritosFailure, List<Favorito>>> obtenerFavoritos(
      String usuarioId);

  /// Obtiene los favoritos de un usuario con información completa de las rutas
  Future<Either<FavoritosFailure, List<FavoritoConRuta>>>
      obtenerFavoritosConRutas(String usuarioId);

  /// Obtiene un favorito específico por su ID
  Future<Either<FavoritosFailure, Favorito>> obtenerFavoritoPorId(
      String favoritoId);

  /// Verifica si una ruta está en favoritos de un usuario
  Future<Either<FavoritosFailure, bool>> esRutaFavorita(
      String usuarioId, String rutaId);

  /// Obtiene un favorito por usuario y ruta
  Future<Either<FavoritosFailure, Favorito?>> obtenerFavoritoPorRuta(
    String usuarioId,
    String rutaId,
  );

  /// Agrega una ruta a favoritos
  Future<Either<FavoritosFailure, Favorito>> agregarFavorito(
      AgregarFavoritoParams params);

  /// Remueve una ruta de favoritos
  Future<Either<FavoritosFailure, void>> removerFavorito(String favoritoId);

  /// Remueve una ruta de favoritos por usuario y ruta
  Future<Either<FavoritosFailure, void>> removerFavoritoPorRuta(
    String usuarioId,
    String rutaId,
  );

  /// Actualiza un favorito existente
  Future<Either<FavoritosFailure, Favorito>> actualizarFavorito(
    String favoritoId,
    ActualizarFavoritoParams params,
  );

  /// Reordena los favoritos de un usuario
  Future<Either<FavoritosFailure, List<Favorito>>> reordenarFavoritos(
    String usuarioId,
    List<String> nuevoOrden,
  );

  /// Obtiene favoritos ordenados según criterio específico
  Future<Either<FavoritosFailure, List<FavoritoConRuta>>>
      obtenerFavoritosOrdenados(
    String usuarioId,
    FavoritosOrdenamiento ordenamiento, {
    bool ascendente = true,
  });

  /// Obtiene favoritos con notificaciones habilitadas
  Future<Either<FavoritosFailure, List<Favorito>>>
      obtenerFavoritosConNotificaciones(
    String usuarioId,
  );

  /// Obtiene favoritos recientes (agregados en los últimos 7 días)
  Future<Either<FavoritosFailure, List<Favorito>>> obtenerFavoritosRecientes(
    String usuarioId,
  );

  /// Busca favoritos por texto (nombre, alias, empresa)
  Future<Either<FavoritosFailure, List<FavoritoConRuta>>> buscarFavoritos(
    String usuarioId,
    String query,
  );

  /// Obtiene estadísticas de favoritos del usuario
  Future<Either<FavoritosFailure, FavoritosEstadisticas>> obtenerEstadisticas(
    String usuarioId,
  );

  /// Exporta los favoritos del usuario
  Future<Either<FavoritosFailure, List<Map<String, dynamic>>>>
      exportarFavoritos(
    String usuarioId,
  );

  /// Importa favoritos desde una lista de datos
  Future<Either<FavoritosFailure, List<Favorito>>> importarFavoritos(
    String usuarioId,
    List<Map<String, dynamic>> favoritosData,
  );

  /// Sincroniza favoritos con el servidor
  Future<Either<FavoritosFailure, List<Favorito>>> sincronizarFavoritos(
    String usuarioId,
  );

  /// Limpia todos los favoritos de un usuario
  Future<Either<FavoritosFailure, void>> limpiarFavoritos(String usuarioId);

  /// Limpia favoritos de rutas inactivas
  Future<Either<FavoritosFailure, int>> limpiarFavoritosInactivos(
      String usuarioId);

  /// Stream de favoritos para actualizaciones en tiempo real
  Stream<Either<FavoritosFailure, List<Favorito>>> watchFavoritos(
      String usuarioId);

  /// Stream de favoritos con rutas para actualizaciones en tiempo real
  Stream<Either<FavoritosFailure, List<FavoritoConRuta>>>
      watchFavoritosConRutas(
    String usuarioId,
  );

  /// Obtiene el número total de favoritos de un usuario
  Future<Either<FavoritosFailure, int>> contarFavoritos(String usuarioId);

  /// Verifica si el usuario ha alcanzado el límite de favoritos
  Future<Either<FavoritosFailure, bool>> haAlcanzadoLimiteFavoritos(
    String usuarioId, {
    int limite = 50,
  });

  /// Obtiene sugerencias de rutas para agregar a favoritos
  Future<Either<FavoritosFailure, List<Ruta>>> obtenerSugerenciasFavoritos(
    String usuarioId,
  );

  /// Marca un favorito como usado recientemente
  Future<Either<FavoritosFailure, void>> marcarComoUsado(String favoritoId);

  /// Obtiene favoritos más usados
  Future<Either<FavoritosFailure, List<FavoritoConRuta>>>
      obtenerFavoritosMasUsados(
    String usuarioId, {
    int limite = 10,
  });
}
