# Design Document

## Overview

El diseño se enfoca en solucionar los pantallazos rojos instantáneos que ocurren durante la navegación en la aplicación Flutter RouWhite. Los problemas principales identificados son:

1. **Manejo inadecuado de AnimationControllers** en `WelcomeAnimationProWidget`
2. **Transiciones de navegación problemáticas** con múltiples `PageRouteBuilder`
3. **Race conditions** en `Future.delayed` sin verificación de `mounted`
4. **Memory leaks potenciales** por controladores no disposed correctamente
5. **Renderizado ineficiente** del mapa con muchos marcadores

## Architecture

### Patrón de Navegación Mejorado

- **NavigationService**: Servicio centralizado para manejar todas las navegaciones
- **TransitionManager**: Gestor de transiciones personalizadas reutilizables
- **StateManager**: Manejo robusto del ciclo de vida de widgets

### Gestión de Animaciones

- **AnimationLifecycleManager**: Controlador centralizado para múltiples animaciones
- **SafeAnimationController**: Wrapper que maneja automáticamente el dispose
- **AnimationSequencer**: Secuenciador para animaciones complejas

### Optimización de Renderizado

- **MapMarkerManager**: Gestión eficiente de marcadores del mapa
- **WidgetLifecycleObserver**: Observer para cleanup automático de recursos

## Components and Interfaces

### 1. NavigationService

```dart
class NavigationService {
  static Future<T?> pushWithSafeTransition<T>(
    BuildContext context,
    Widget destination, {
    TransitionType type = TransitionType.slide,
    Duration duration = const Duration(milliseconds: 300),
  });

  static Future<T?> pushReplacementWithSafeTransition<T>(
    BuildContext context,
    Widget destination, {
    TransitionType type = TransitionType.fade,
  });
}
```

### 2. SafeAnimationController

```dart
class SafeAnimationController extends AnimationController {
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  bool get isSafe => !_isDisposed && mounted;
}
```

### 3. AnimationLifecycleManager

```dart
class AnimationLifecycleManager {
  final List<AnimationController> _controllers = [];

  void addController(AnimationController controller);
  void disposeAll();
  Future<void> executeSequence(List<AnimationStep> steps);
}
```

### 4. TransitionManager

```dart
enum TransitionType { slide, fade, scale, custom }

class TransitionManager {
  static PageRouteBuilder<T> createRoute<T>(
    Widget destination,
    TransitionType type, {
    Duration duration,
    Curve curve,
  });
}
```

### 5. MapMarkerManager

```dart
class MapMarkerManager {
  static const int MAX_VISIBLE_MARKERS = 50;

  List<Marker> getOptimizedMarkers(
    LatLng center,
    double zoom,
    List<MarkerData> allMarkers,
  );

  void updateMarkersEfficiently(List<MarkerData> newMarkers);
}
```

## Data Models

### AnimationStep

```dart
class AnimationStep {
  final AnimationController controller;
  final Duration duration;
  final VoidCallback? onComplete;
  final bool waitForCompletion;
}
```

### TransitionConfig

```dart
class TransitionConfig {
  final TransitionType type;
  final Duration duration;
  final Curve curve;
  final Offset? slideBegin;
  final Offset? slideEnd;
}
```

### MarkerData

```dart
class MarkerData {
  final LatLng position;
  final Widget widget;
  final int priority;
  final double visibilityRadius;
}
```

## Error Handling

### 1. Animation Error Recovery

- **Graceful Degradation**: Si una animación falla, continuar sin ella
- **Error Boundaries**: Wrapper widgets que capturan errores de animación
- **Fallback Transitions**: Transiciones simples como backup

### 2. Navigation Error Handling

- **Safe Navigation**: Verificar contexto válido antes de navegar
- **Route Validation**: Validar rutas antes de la navegación
- **Error Reporting**: Log detallado de errores de navegación

### 3. Memory Management

- **Automatic Cleanup**: Dispose automático de recursos
- **Leak Detection**: Herramientas para detectar memory leaks
- **Resource Monitoring**: Monitoreo de uso de memoria

## Testing Strategy

### 1. Unit Tests

- **AnimationLifecycleManager**: Tests para manejo correcto de controladores
- **NavigationService**: Tests para navegación segura
- **TransitionManager**: Tests para transiciones personalizadas

### 2. Widget Tests

- **WelcomeAnimationProWidget**: Tests para animaciones sin errores
- **MapMarkerManager**: Tests para renderizado eficiente
- **SafeAnimationController**: Tests para dispose correcto

### 3. Integration Tests

- **Navigation Flow**: Tests end-to-end de navegación completa
- **Animation Sequences**: Tests de secuencias de animación complejas
- **Memory Usage**: Tests de uso de memoria durante navegación

### 4. Performance Tests

- **Frame Rate**: Medición de FPS durante animaciones
- **Memory Leaks**: Detección de leaks en navegación repetida
- **Rendering Performance**: Tiempo de renderizado del mapa

## Implementation Phases

### Phase 1: Core Infrastructure

1. Crear `SafeAnimationController` y `AnimationLifecycleManager`
2. Implementar `NavigationService` con transiciones seguras
3. Crear `TransitionManager` para transiciones reutilizables

### Phase 2: Widget Refactoring

1. Refactorizar `WelcomeAnimationProWidget` para usar nuevos managers
2. Actualizar navegación en `BienvenidaPagina` y `Homepage`
3. Implementar cleanup automático en todos los widgets con animaciones

### Phase 3: Map Optimization

1. Implementar `MapMarkerManager` para renderizado eficiente
2. Optimizar marcadores en `HomeContent`
3. Agregar lazy loading para marcadores distantes

### Phase 4: Error Handling & Testing

1. Implementar error boundaries y fallbacks
2. Agregar logging detallado para debugging
3. Crear suite completa de tests

## Performance Considerations

### Memory Management

- Dispose automático de todos los AnimationControllers
- Cancelación de Future.delayed cuando widget se desmonta
- Pool de objetos reutilizables para marcadores

### Rendering Optimization

- Culling de marcadores fuera de vista
- Batching de updates de UI
- Uso de RepaintBoundary para aislar repaints

### Animation Performance

- Uso de Transform en lugar de cambios de layout
- Animaciones con GPU acceleration
- Reducción de rebuilds innecesarios

## Security Considerations

### Input Validation

- Validación de parámetros de navegación
- Sanitización de datos de marcadores
- Verificación de contextos válidos

### Resource Protection

- Límites en número de animaciones simultáneas
- Timeouts para operaciones de navegación
- Protección contra memory exhaustion
