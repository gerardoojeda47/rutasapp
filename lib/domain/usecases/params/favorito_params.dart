import 'package:equatable/equatable.dart';

/// Parámetros para agregar favorito
class AgregarFavoritoParams extends Equatable {
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

  @override
  List<Object?> get props => [
        usuarioId,
        rutaId,
        alias,
        notificacionesHabilitadas,
      ];

  @override
  String toString() {
    return 'AgregarFavoritoParams(usuarioId: $usuarioId, rutaId: $rutaId, alias: $alias)';
  }
}

/// Parámetros para actualizar favorito
class ActualizarFavoritoParams extends Equatable {
  const ActualizarFavoritoParams({
    required this.favoritoId,
    this.alias,
    this.orden,
    this.notificacionesHabilitadas,
  });

  final String favoritoId;
  final String? alias;
  final int? orden;
  final bool? notificacionesHabilitadas;

  /// Verifica si hay cambios para aplicar
  bool get hasChanges =>
      alias != null || orden != null || notificacionesHabilitadas != null;

  @override
  List<Object?> get props => [
        favoritoId,
        alias,
        orden,
        notificacionesHabilitadas,
      ];

  @override
  String toString() {
    return 'ActualizarFavoritoParams(favoritoId: $favoritoId, alias: $alias, orden: $orden)';
  }
}
