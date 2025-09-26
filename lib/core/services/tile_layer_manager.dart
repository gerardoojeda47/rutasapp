import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';

/// Enumeración de proveedores de tiles disponibles
enum TileProvider {
  openStreetMap,
  cartoDBPositron,
  cartoDBVoyager,
  stamenTerrain,
}

/// Extensión para obtener configuraciones de cada proveedor
extension TileProviderExtension on TileProvider {
  /// URL template del proveedor
  String get urlTemplate {
    switch (this) {
      case TileProvider.openStreetMap:
        return 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
      case TileProvider.cartoDBPositron:
        return 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png';
      case TileProvider.cartoDBVoyager:
        return 'https://cartodb-basemaps-{s}.global.ssl.fastly.net/rastertiles/voyager/{z}/{x}/{y}.png';
      case TileProvider.stamenTerrain:
        return 'https://stamen-tiles-{s}.a.ssl.fastly.net/terrain/{z}/{x}/{y}.png';
    }
  }

  /// Subdomains disponibles para el proveedor
  List<String> get subdomains {
    switch (this) {
      case TileProvider.openStreetMap:
        return ['a', 'b', 'c'];
      case TileProvider.cartoDBPositron:
      case TileProvider.cartoDBVoyager:
        return ['a', 'b', 'c', 'd'];
      case TileProvider.stamenTerrain:
        return ['a', 'b', 'c', 'd'];
    }
  }

  /// Zoom máximo soportado por el proveedor
  int get maxZoom {
    switch (this) {
      case TileProvider.openStreetMap:
        return 19;
      case TileProvider.cartoDBPositron:
      case TileProvider.cartoDBVoyager:
        return 18;
      case TileProvider.stamenTerrain:
        return 16;
    }
  }

  /// Nombre descriptivo del proveedor
  String get displayName {
    switch (this) {
      case TileProvider.openStreetMap:
        return 'OpenStreetMap';
      case TileProvider.cartoDBPositron:
        return 'CartoDB Positron';
      case TileProvider.cartoDBVoyager:
        return 'CartoDB Voyager';
      case TileProvider.stamenTerrain:
        return 'Stamen Terrain';
    }
  }

  /// Atribución requerida por el proveedor
  String get attribution {
    switch (this) {
      case TileProvider.openStreetMap:
        return '© OpenStreetMap contributors';
      case TileProvider.cartoDBPositron:
      case TileProvider.cartoDBVoyager:
        return '© CartoDB, © OpenStreetMap contributors';
      case TileProvider.stamenTerrain:
        return '© Stamen Design, © OpenStreetMap contributors';
    }
  }
}

/// Gestor de capas de tiles con múltiples proveedores y fallback automático
class TileLayerManager {
  static TileProvider _currentProvider = TileProvider.openStreetMap;
  static final Set<String> _failedTiles = <String>{};
  static int _providerSwitchCount = 0;

  /// Lista de proveedores en orden de preferencia
  static const List<TileProvider> _providers = [
    TileProvider.openStreetMap,
    TileProvider.cartoDBPositron,
    TileProvider.cartoDBVoyager,
    TileProvider.stamenTerrain,
  ];

  /// Obtiene el proveedor actual
  static TileProvider get currentProvider => _currentProvider;

  /// Obtiene estadísticas de cambios de proveedor
  static int get providerSwitchCount => _providerSwitchCount;

  /// Crea una capa de tiles optimizada con fallback automático
  static TileLayer createOptimizedTileLayer({
    TileProvider? preferredProvider,
    double? maxZoom,
  }) {
    final provider = preferredProvider ?? _currentProvider;

    return TileLayer(
      urlTemplate: provider.urlTemplate,
      subdomains: provider.subdomains,
      maxZoom: maxZoom?.toDouble() ?? provider.maxZoom.toDouble(),
      userAgentPackageName: 'com.popayan.rutasapp',
      // Configuraciones para mejor performance
      maxNativeZoom: provider.maxZoom,
      tileDimension: 256,
      // Headers para optimizar requests
      additionalOptions: const {
        'Accept': 'image/png,image/jpeg,image/*;q=0.8',
        'Accept-Encoding': 'gzip, deflate',
      },
      // Callback para manejar errores de tiles
      errorTileCallback: (tile, error, stackTrace) {
        _handleTileError(
            '${tile.coordinates.x}_${tile.coordinates.y}_${tile.coordinates.z}',
            error);
      },
    );
  }

  /// Crea múltiples capas de tiles para fallback
  static List<TileLayer> createFallbackTileLayers({double? maxZoom}) {
    return _providers.map((provider) {
      final effectiveMaxZoom = maxZoom != null
          ? (maxZoom.toInt() > provider.maxZoom
              ? provider.maxZoom
              : maxZoom.toInt())
          : provider.maxZoom;

      return TileLayer(
        urlTemplate: provider.urlTemplate,
        subdomains: provider.subdomains,
        maxZoom: effectiveMaxZoom.toDouble(),
        userAgentPackageName: 'com.popayan.rutasapp',
        maxNativeZoom: provider.maxZoom,
        tileDimension: 256,
        additionalOptions: const {
          'Accept': 'image/png,image/jpeg,image/*;q=0.8',
          'Accept-Encoding': 'gzip, deflate',
        },
        errorTileCallback: (tile, error, stackTrace) {
          _handleTileError(
              '${tile.coordinates.x}_${tile.coordinates.y}_${tile.coordinates.z}',
              error);
        },
      );
    }).toList();
  }

  /// Maneja errores de carga de tiles
  static void _handleTileError(String tileKey, dynamic error) {
    _failedTiles.add(tileKey);

    // Si hay muchos errores, cambiar de proveedor
    if (_failedTiles.length > 10) {
      _switchToNextProvider();
      _failedTiles.clear();
    }

    // Log error for debugging
    debugPrint('🗺️ Error cargando tile $tileKey: $error');
  }

  /// Cambia al siguiente proveedor disponible
  static void _switchToNextProvider() {
    final currentIndex = _providers.indexOf(_currentProvider);
    final nextIndex = (currentIndex + 1) % _providers.length;
    _currentProvider = _providers[nextIndex];
    _providerSwitchCount++;

    debugPrint('🔄 Cambiando a proveedor: ${_currentProvider.displayName}');
  }

  /// Reinicia el proveedor al principal
  static void resetToMainProvider() {
    _currentProvider = _providers.first;
    _failedTiles.clear();
    _providerSwitchCount = 0;
  }

  /// Obtiene información del estado actual
  static Map<String, dynamic> getStatus() {
    return {
      'currentProvider': _currentProvider.displayName,
      'failedTilesCount': _failedTiles.length,
      'providerSwitchCount': _providerSwitchCount,
      'availableProviders': _providers.map((p) => p.displayName).toList(),
    };
  }
}
