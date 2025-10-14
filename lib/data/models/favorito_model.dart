import 'package:equatable/equatable.dart';
import 'package:rouwhite/domain/entities/favorito.dart';
import 'package:rouwhite/domain/entities/favoritos_estadisticas.dart';
import 'package:rouwhite/domain/usecases/params/favorito_params.dart';

/// Modelo de datos para Favorito con serialización JSON
class FavoritoModel extends Equatable {
  const FavoritoModel({
    required this.id,
    required this.usuarioId,
    required this.rutaId,
    required this.fechaAgregado,
    this.alias,
    this.orden = 0,
    this.notificacionesHabilitadas = false,
    this.fechaCreacion,
    this.fechaActualizacion,
  });

  final String id;
  final String usuarioId;
  final String rutaId;
  final DateTime fechaAgregado;
  final String? alias;
  final int orden;
  final bool notificacionesHabilitadas;
  final DateTime? fechaCreacion;
  final DateTime? fechaActualizacion;

  /// Crea un FavoritoModel desde JSON
  factory FavoritoModel.fromJson(Map<String, dynamic> json) {
    return FavoritoModel(
      id: json['id'] as String,
      usuarioId: json['usuario_id'] as String,
      rutaId: json['ruta_id'] as String,
      fechaAgregado: DateTime.parse(json['fecha_agregado'] as String),
      alias: json['alias'] as String?,
      orden: json['orden'] as int? ?? 0,
      notificacionesHabilitadas:
          json['notificaciones_habilitadas'] as bool? ?? false,
      fechaCreacion: json['fecha_creacion'] != null
          ? DateTime.parse(json['fecha_creacion'] as String)
          : null,
      fechaActualizacion: json['fecha_actualizacion'] != null
          ? DateTime.parse(json['fecha_actualizacion'] as String)
          : null,
    );
  }

  /// Convierte el FavoritoModel a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'usuario_id': usuarioId,
      'ruta_id': rutaId,
      'fecha_agregado': fechaAgregado.toIso8601String(),
      'alias': alias,
      'orden': orden,
      'notificaciones_habilitadas': notificacionesHabilitadas,
      'fecha_creacion': fechaCreacion?.toIso8601String(),
      'fecha_actualizacion': fechaActualizacion?.toIso8601String(),
    };
  }

  /// Convierte el modelo a entidad de dominio
  Favorito toEntity() {
    return Favorito(
      id: id,
      usuarioId: usuarioId,
      rutaId: rutaId,
      fechaAgregado: fechaAgregado,
      alias: alias,
      orden: orden,
      notificacionesHabilitadas: notificacionesHabilitadas,
    );
  }

  /// Crea un FavoritoModel desde una entidad de dominio
  factory FavoritoModel.fromEntity(Favorito favorito) {
    return FavoritoModel(
      id: favorito.id,
      usuarioId: favorito.usuarioId,
      rutaId: favorito.rutaId,
      fechaAgregado: favorito.fechaAgregado,
      alias: favorito.alias,
      orden: favorito.orden,
      notificacionesHabilitadas: favorito.notificacionesHabilitadas,
      fechaCreacion: DateTime.now(),
      fechaActualizacion: DateTime.now(),
    );
  }

  /// Crea una copia del modelo con algunos campos modificados
  FavoritoModel copyWith({
    String? id,
    String? usuarioId,
    String? rutaId,
    DateTime? fechaAgregado,
    String? alias,
    int? orden,
    bool? notificacionesHabilitadas,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
  }) {
    return FavoritoModel(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      rutaId: rutaId ?? this.rutaId,
      fechaAgregado: fechaAgregado ?? this.fechaAgregado,
      alias: alias ?? this.alias,
      orden: orden ?? this.orden,
      notificacionesHabilitadas:
          notificacionesHabilitadas ?? this.notificacionesHabilitadas,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }

  @override
  List<Object?> get props => [
        id,
        usuarioId,
        rutaId,
        fechaAgregado,
        alias,
        orden,
        notificacionesHabilitadas,
        fechaCreacion,
        fechaActualizacion,
      ];

  @override
  String toString() {
    return 'FavoritoModel(id: $id, usuarioId: $usuarioId, rutaId: $rutaId, alias: $alias)';
  }
}

/// Lista de modelos de favorito con métodos de utilidad
class FavoritoModelList extends Equatable {
  const FavoritoModelList(this.favoritos);

  final List<FavoritoModel> favoritos;

  /// Crea desde JSON
  factory FavoritoModelList.fromJson(List<dynamic> json) {
    return FavoritoModelList(
      json
          .map((f) => FavoritoModel.fromJson(f as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Convierte a JSON
  List<Map<String, dynamic>> toJson() {
    return favoritos.map((f) => f.toJson()).toList();
  }

  /// Convierte a entidades de dominio
  List<Favorito> toEntities() {
    return favoritos.map((f) => f.toEntity()).toList();
  }

  /// Filtra favoritos por usuario
  FavoritoModelList filterByUsuario(String usuarioId) {
    return FavoritoModelList(
      favoritos.where((f) => f.usuarioId == usuarioId).toList(),
    );
  }

  /// Filtra favoritos con notificaciones habilitadas
  FavoritoModelList filterConNotificaciones() {
    return FavoritoModelList(
      favoritos.where((f) => f.notificacionesHabilitadas).toList(),
    );
  }

  /// Filtra favoritos recientes (últimos 7 días)
  FavoritoModelList filterRecientes() {
    final ahora = DateTime.now();
    final hace7Dias = ahora.subtract(const Duration(days: 7));

    return FavoritoModelList(
      favoritos.where((f) => f.fechaAgregado.isAfter(hace7Dias)).toList(),
    );
  }

  /// Ordena favoritos por orden personalizado
  FavoritoModelList ordenarPorOrden() {
    final favoritosOrdenados = List<FavoritoModel>.from(favoritos);
    favoritosOrdenados.sort((a, b) => a.orden.compareTo(b.orden));
    return FavoritoModelList(favoritosOrdenados);
  }

  /// Ordena favoritos por fecha agregado (más recientes primero)
  FavoritoModelList ordenarPorFecha({bool ascendente = false}) {
    final favoritosOrdenados = List<FavoritoModel>.from(favoritos);
    favoritosOrdenados.sort((a, b) {
      final comparison = a.fechaAgregado.compareTo(b.fechaAgregado);
      return ascendente ? comparison : -comparison;
    });
    return FavoritoModelList(favoritosOrdenados);
  }

  /// Busca favoritos por alias o ID de ruta
  FavoritoModelList buscar(String query) {
    final queryLower = query.toLowerCase();
    return FavoritoModelList(
      favoritos.where((f) {
        final alias = f.alias?.toLowerCase() ?? '';
        final rutaId = f.rutaId.toLowerCase();
        return alias.contains(queryLower) || rutaId.contains(queryLower);
      }).toList(),
    );
  }

  @override
  List<Object?> get props => [favoritos];
}

/// Modelo para solicitud de agregar favorito
class AgregarFavoritoRequestModel extends Equatable {
  const AgregarFavoritoRequestModel({
    required this.usuarioId,
    required this.rutaId,
    this.alias,
    this.notificacionesHabilitadas = false,
  });

  final String usuarioId;
  final String rutaId;
  final String? alias;
  final bool notificacionesHabilitadas;

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'usuario_id': usuarioId,
      'ruta_id': rutaId,
      'alias': alias,
      'notificaciones_habilitadas': notificacionesHabilitadas,
    };
  }

  /// Crea desde parámetros de dominio
  factory AgregarFavoritoRequestModel.fromParams(AgregarFavoritoParams params) {
    return AgregarFavoritoRequestModel(
      usuarioId: params.usuarioId,
      rutaId: params.rutaId,
      alias: params.alias,
      notificacionesHabilitadas: params.notificacionesHabilitadas,
    );
  }

  @override
  List<Object?> get props =>
      [usuarioId, rutaId, alias, notificacionesHabilitadas];
}

/// Modelo para solicitud de actualizar favorito
class ActualizarFavoritoRequestModel extends Equatable {
  const ActualizarFavoritoRequestModel({
    this.alias,
    this.orden,
    this.notificacionesHabilitadas,
  });

  final String? alias;
  final int? orden;
  final bool? notificacionesHabilitadas;

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (alias != null) json['alias'] = alias;
    if (orden != null) json['orden'] = orden;
    if (notificacionesHabilitadas != null) {
      json['notificaciones_habilitadas'] = notificacionesHabilitadas;
    }
    return json;
  }

  /// Crea desde parámetros de dominio
  factory ActualizarFavoritoRequestModel.fromParams(
      ActualizarFavoritoParams params) {
    return ActualizarFavoritoRequestModel(
      alias: params.alias,
      orden: params.orden,
      notificacionesHabilitadas: params.notificacionesHabilitadas,
    );
  }

  /// Verifica si el modelo está vacío
  bool get isEmpty =>
      alias == null && orden == null && notificacionesHabilitadas == null;

  @override
  List<Object?> get props => [alias, orden, notificacionesHabilitadas];
}

/// Modelo para estadísticas de favoritos
class FavoritosEstadisticasModel extends Equatable {
  const FavoritosEstadisticasModel({
    required this.totalFavoritos,
    required this.favoritosRecientes,
    required this.conNotificaciones,
    this.empresaMasFavorita,
    required this.costoPromedio,
    this.favoritoMasAntiguo,
    this.favoritoMasReciente,
  });

  final int totalFavoritos;
  final int favoritosRecientes;
  final int conNotificaciones;
  final String? empresaMasFavorita;
  final double costoPromedio;
  final FavoritoModel? favoritoMasAntiguo;
  final FavoritoModel? favoritoMasReciente;

  /// Crea desde JSON
  factory FavoritosEstadisticasModel.fromJson(Map<String, dynamic> json) {
    return FavoritosEstadisticasModel(
      totalFavoritos: json['total_favoritos'] as int,
      favoritosRecientes: json['favoritos_recientes'] as int,
      conNotificaciones: json['con_notificaciones'] as int,
      empresaMasFavorita: json['empresa_mas_favorita'] as String?,
      costoPromedio: (json['costo_promedio'] as num).toDouble(),
      favoritoMasAntiguo: json['favorito_mas_antiguo'] != null
          ? FavoritoModel.fromJson(
              json['favorito_mas_antiguo'] as Map<String, dynamic>)
          : null,
      favoritoMasReciente: json['favorito_mas_reciente'] != null
          ? FavoritoModel.fromJson(
              json['favorito_mas_reciente'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Convierte a entidad de dominio
  FavoritosEstadisticas toEntity() {
    return FavoritosEstadisticas(
      totalFavoritos: totalFavoritos,
      favoritosRecientes: favoritosRecientes,
      conNotificaciones: conNotificaciones,
      empresaMasFavorita: empresaMasFavorita,
      costoPromedio: costoPromedio,
      favoritoMasAntiguo: favoritoMasAntiguo?.toEntity(),
      favoritoMasReciente: favoritoMasReciente?.toEntity(),
    );
  }

  @override
  List<Object?> get props => [
        totalFavoritos,
        favoritosRecientes,
        conNotificaciones,
        empresaMasFavorita,
        costoPromedio,
        favoritoMasAntiguo,
        favoritoMasReciente,
      ];
}

