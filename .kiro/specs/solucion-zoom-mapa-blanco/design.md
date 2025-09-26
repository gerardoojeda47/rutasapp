# Design Document

## Overview

El problema del mapa en blanco al hacer zoom es un issue común en aplicaciones Flutter Map que ocurre cuando:

1. Los tiles del proveedor no están disponibles en niveles de zoom altos
2. La configuración de maxZoom excede la disponibilidad real de tiles
3. No hay manejo de errores apropiado para tiles faltantes
4. Falta implementación de proveedores de respaldo

La solución implementará un sistema robusto de manejo de tiles con múltiples proveedores, límites de zoom dinámicos y manejo graceful de errores.

## Architecture

### Componente Principal: TileLayerManager

- **Responsabilidad**: Gestionar múltiples proveedores de tiles y cambiar automáticamente entre ellos
- **Ubicación**: `lib/core/services/tile_layer_manager.dart`

### Componente de Configuración: MapConfiguration

- **Responsabilidad**: Definir configuraciones específicas para Popayán y Colombia
- **Ubicación**: `lib/core/config/map_configuration.dart`

### Componente de Respaldo: FallbackTileProvider

- **Responsabilidad**: Proporcionar tiles alternativos cuando el proveedor principal falla
- **Ubicación**: `lib/core/services/fallback_tile_provider.dart`

## Components and Interfaces

### 1. TileLayerManager

```dart
class TileLayerManager {
  static const List<TileProvider> providers = [
    TileProvider.openStreetMap,
    TileProvider.cartoDB,
    TileProvider.stamen,
  ];

  static TileLayer createOptimizedTileLayer();
  static void handleTileError(String url, dynamic error);
  static TileProvider getCurrentProvider();
}

enum TileProvider {
  openStreetMap,
  cartoDB,
  stamen,
}
```

### 2. MapConfiguration

```dart
class MapConfiguration {
  static const double minZoomPopayan = 10.0;
  static const double maxZoomPopayan = 18.0;
  static const LatLng popayanCenter = LatLng(2.4389, -76.6064);
  static const LatLngBounds popayanBounds = LatLngBounds(
    LatLng(2.3800, -76.6800),
    LatLng(2.5000, -76.5300),
  );

  static MapOptions createOptimizedMapOptions();
  static bool isValidZoomLevel(double zoom);
}
```

### 3. Enhanced FlutterMap Widget

El widget FlutterMap será mejorado con:

- Múltiples TileLayer con fallback automático
- Manejo de errores de carga de tiles
- Indicadores de estado de carga
- Límites de zoom dinámicos

## Data Models

### TileLoadingState

```dart
enum TileLoadingState {
  loading,
  loaded,
  error,
  fallback,
}

class TileStatus {
  final TileLoadingState state;
  final String? errorMessage;
  final TileProvider currentProvider;
  final DateTime timestamp;
}
```

### MapState

```dart
class MapState {
  final double currentZoom;
  final LatLng center;
  final TileProvider activeProvider;
  final List<String> failedTiles;
  final bool isLoading;
}
```

## Error Handling

### 1. Tile Loading Errors

- **Detección**: Interceptar errores HTTP de carga de tiles
- **Respuesta**: Cambiar automáticamente al siguiente proveedor disponible
- **Logging**: Registrar errores para análisis posterior

### 2. Network Connectivity Issues

- **Detección**: Monitorear estado de conectividad
- **Respuesta**: Mostrar mensaje informativo y usar cache local si está disponible
- **Recuperación**: Reintentar automáticamente cuando se restaure la conexión

### 3. Zoom Level Validation

- **Prevención**: Validar niveles de zoom antes de aplicarlos
- **Limitación**: Restringir zoom a rangos con tiles disponibles
- **Feedback**: Proporcionar feedback visual cuando se alcancen límites

## Testing Strategy

### 1. Unit Tests

- **TileLayerManager**: Verificar cambio automático entre proveedores
- **MapConfiguration**: Validar configuraciones para Popayán
- **FallbackTileProvider**: Probar manejo de errores y respaldos

### 2. Integration Tests

- **Zoom Limits**: Verificar que el zoom no cause pantallas en blanco
- **Provider Switching**: Probar cambio automático de proveedores
- **Error Recovery**: Simular fallos de red y verificar recuperación

### 3. Widget Tests

- **Loading States**: Verificar indicadores de carga apropiados
- **Error Messages**: Probar visualización de mensajes de error
- **User Interactions**: Validar respuesta a gestos de zoom y pan

## Implementation Details

### Proveedores de Tiles Múltiples

1. **OpenStreetMap** (Principal)

   - URL: `https://tile.openstreetmap.org/{z}/{x}/{y}.png`
   - Zoom máximo: 19
   - Cobertura: Global, buena para Colombia

2. **CartoDB Positron** (Respaldo 1)

   - URL: `https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png`
   - Zoom máximo: 18
   - Estilo: Minimalista, bueno para overlays

3. **Stamen Terrain** (Respaldo 2)
   - URL: `https://stamen-tiles-{s}.a.ssl.fastly.net/terrain/{z}/{x}/{y}.png`
   - Zoom máximo: 16
   - Estilo: Topográfico, útil para contexto geográfico

### Configuración de Zoom Optimizada

```dart
MapOptions(
  initialCenter: MapConfiguration.popayanCenter,
  initialZoom: 15.0,
  minZoom: MapConfiguration.minZoomPopayan,
  maxZoom: MapConfiguration.maxZoomPopayan,
  cameraConstraint: CameraConstraint.contain(
    bounds: MapConfiguration.popayanBounds,
  ),
  interactionOptions: InteractionOptions(
    flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
  ),
)
```

### Manejo de Estados de Carga

- **Loading Overlay**: Mostrar spinner durante carga inicial
- **Tile Placeholders**: Mostrar placeholders para tiles individuales
- **Error Indicators**: Iconos discretos para tiles con error
- **Retry Mechanisms**: Botones para reintentar carga manual

### Performance Optimizations

1. **Tile Caching**: Implementar cache local para tiles frecuentemente usados
2. **Preloading**: Precargar tiles adyacentes para navegación fluida
3. **Memory Management**: Limpiar tiles fuera del viewport para optimizar memoria
4. **Network Optimization**: Usar compresión y headers apropiados para requests
