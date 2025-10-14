import 'package:equatable/equatable.dart';
import 'favorito.dart';

/// Estadísticas de favoritos del usuario
class FavoritosEstadisticas extends Equatable {
  const FavoritosEstadisticas({
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
  final Favorito? favoritoMasAntiguo;
  final Favorito? favoritoMasReciente;

  /// Porcentaje de favoritos con notificaciones habilitadas
  double get porcentajeConNotificaciones {
    if (totalFavoritos == 0) return 0.0;
    return (conNotificaciones / totalFavoritos) * 100;
  }

  /// Porcentaje de favoritos recientes
  double get porcentajeFavoritosRecientes {
    if (totalFavoritos == 0) return 0.0;
    return (favoritosRecientes / totalFavoritos) * 100;
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

  @override
  String toString() {
    return 'FavoritosEstadisticas(total: $totalFavoritos, recientes: $favoritosRecientes, conNotificaciones: $conNotificaciones)';
  }
}

