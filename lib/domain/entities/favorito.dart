import 'package:equatable/equatable.dart';

/// Entidad que representa un favorito del usuario
class Favorito extends Equatable {
  const Favorito({
    required this.id,
    required this.usuarioId,
    required this.rutaId,
    required this.fechaAgregado,
    this.alias,
    this.orden = 0,
    this.notificacionesHabilitadas = false,
  });

  /// Identificador único del favorito
  final String id;

  /// ID del usuario propietario del favorito
  final String usuarioId;

  /// ID de la ruta marcada como favorita
  final String rutaId;

  /// Fecha en que se agregó a favoritos
  final DateTime fechaAgregado;

  /// Alias personalizado para la ruta (opcional)
  final String? alias;

  /// Orden de visualización en la lista de favoritos
  final int orden;

  /// Indica si las notificaciones están habilitadas para esta ruta
  final bool notificacionesHabilitadas;

  /// Calcula los días desde que se agregó a favoritos
  int get diasEnFavoritos {
    return DateTime.now().difference(fechaAgregado).inDays;
  }

  /// Indica si es un favorito reciente (menos de 7 días)
  bool get esReciente => diasEnFavoritos < 7;

  /// Indica si es un favorito antiguo (más de 30 días)
  bool get esAntiguo => diasEnFavoritos > 30;

  /// Obtiene el nombre para mostrar (alias o ID de ruta)
  String get nombreParaMostrar => alias ?? rutaId;

  /// Crea una copia del favorito con algunos campos modificados
  Favorito copyWith({
    String? id,
    String? usuarioId,
    String? rutaId,
    DateTime? fechaAgregado,
    String? alias,
    int? orden,
    bool? notificacionesHabilitadas,
  }) {
    return Favorito(
      id: id ?? this.id,
      usuarioId: usuarioId ?? this.usuarioId,
      rutaId: rutaId ?? this.rutaId,
      fechaAgregado: fechaAgregado ?? this.fechaAgregado,
      alias: alias ?? this.alias,
      orden: orden ?? this.orden,
      notificacionesHabilitadas:
          notificacionesHabilitadas ?? this.notificacionesHabilitadas,
    );
  }

  /// Actualiza el alias del favorito
  Favorito actualizarAlias(String? nuevoAlias) {
    return copyWith(alias: nuevoAlias);
  }

  /// Actualiza el orden del favorito
  Favorito actualizarOrden(int nuevoOrden) {
    return copyWith(orden: nuevoOrden);
  }

  /// Habilita o deshabilita las notificaciones
  Favorito toggleNotificaciones() {
    return copyWith(notificacionesHabilitadas: !notificacionesHabilitadas);
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
      ];

  @override
  String toString() {
    return 'Favorito(id: $id, usuarioId: $usuarioId, rutaId: $rutaId, alias: $alias)';
  }
}

/// Clase de utilidad para manejar listas de favoritos
class FavoritosList extends Equatable {
  const FavoritosList(this.favoritos);

  final List<Favorito> favoritos;

  /// Obtiene los favoritos ordenados por el campo orden
  List<Favorito> get ordenados {
    final lista = List<Favorito>.from(favoritos);
    lista.sort((a, b) => a.orden.compareTo(b.orden));
    return lista;
  }

  /// Obtiene los favoritos recientes (menos de 7 días)
  List<Favorito> get recientes {
    return favoritos.where((f) => f.esReciente).toList();
  }

  /// Obtiene los favoritos con notificaciones habilitadas
  List<Favorito> get conNotificaciones {
    return favoritos.where((f) => f.notificacionesHabilitadas).toList();
  }

  /// Verifica si una ruta está en favoritos
  bool contiene(String rutaId) {
    return favoritos.any((f) => f.rutaId == rutaId);
  }

  /// Obtiene un favorito por ID de ruta
  Favorito? getPorRutaId(String rutaId) {
    try {
      return favoritos.firstWhere((f) => f.rutaId == rutaId);
    } catch (e) {
      return null;
    }
  }

  /// Obtiene el número total de favoritos
  int get cantidad => favoritos.length;

  /// Indica si la lista está vacía
  bool get isEmpty => favoritos.isEmpty;

  /// Indica si la lista no está vacía
  bool get isNotEmpty => favoritos.isNotEmpty;

  /// Agrega un favorito a la lista
  FavoritosList agregar(Favorito favorito) {
    if (contiene(favorito.rutaId)) {
      return this; // Ya existe, no agregar duplicado
    }

    final nuevaLista = List<Favorito>.from(favoritos);
    nuevaLista.add(favorito);
    return FavoritosList(nuevaLista);
  }

  /// Remueve un favorito de la lista
  FavoritosList remover(String rutaId) {
    final nuevaLista = favoritos.where((f) => f.rutaId != rutaId).toList();
    return FavoritosList(nuevaLista);
  }

  /// Actualiza un favorito en la lista
  FavoritosList actualizar(Favorito favoritoActualizado) {
    final nuevaLista = favoritos.map((f) {
      if (f.id == favoritoActualizado.id) {
        return favoritoActualizado;
      }
      return f;
    }).toList();

    return FavoritosList(nuevaLista);
  }

  /// Reordena los favoritos
  FavoritosList reordenar(List<String> nuevoOrden) {
    final nuevaLista = <Favorito>[];

    for (int i = 0; i < nuevoOrden.length; i++) {
      final rutaId = nuevoOrden[i];
      final favorito = getPorRutaId(rutaId);
      if (favorito != null) {
        nuevaLista.add(favorito.actualizarOrden(i));
      }
    }

    return FavoritosList(nuevaLista);
  }

  @override
  List<Object?> get props => [favoritos];

  @override
  String toString() {
    return 'FavoritosList(cantidad: $cantidad)';
  }
}
