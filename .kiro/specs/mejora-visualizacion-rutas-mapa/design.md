# Documento de Diseño - Mejora de Visualización de Rutas en Mapa

## Resumen

Este documento describe el diseño técnico para transformar la visualización de rutas en RouWhite, pasando de líneas rectas simples a un sistema de rutas realistas, visualmente atractivas y funcionalmente superiores que sigan las calles reales de Popayán.

## Arquitectura

### Componentes Principales

```
MapaRutasService
├── RutaGeometryService (Generación de geometrías realistas)
├── RutaStyleService (Estilos y colores)
├── ParadaVisualizationService (Manejo de paradas)
├── AnimationService (Animaciones y transiciones)
└── MapInteractionService (Interacciones del usuario)
```

### Flujo de Datos

1. **Carga de Datos** → RutaGeometryService procesa coordenadas
2. **Generación de Geometría** → Crea waypoints intermedios realistas
3. **Aplicación de Estilos** → RutaStyleService aplica colores y efectos
4. **Renderizado** → FlutterMap muestra las rutas optimizadas
5. **Interacciones** → MapInteractionService maneja toques y gestos

## Componentes y Interfaces

### 1. RutaGeometryService

**Responsabilidad:** Convertir coordenadas simples en rutas realistas que sigan calles.

```dart
class RutaGeometryService {
  // Genera waypoints intermedios para rutas realistas
  List<LatLng> generateRealisticRoute(List<LatLng> originalPoints);

  // Suaviza las curvas de la ruta
  List<LatLng> smoothRoute(List<LatLng> points);

  // Optimiza puntos según nivel de zoom
  List<LatLng> optimizeForZoom(List<LatLng> points, double zoom);
}
```

**Implementación Clave:**

- Usar algoritmo de interpolación Catmull-Rom para curvas suaves
- Integración con servicios de routing (OpenRouteService o similar)
- Cache de geometrías calculadas para mejor rendimiento

### 2. RutaStyleService

**Responsabilidad:** Manejo de estilos visuales, colores y efectos.

```dart
class RutaStyleService {
  // Obtiene el estilo base de una ruta
  RutaStyle getRouteStyle(String routeId, bool isSelected);

  // Genera colores distintivos automáticamente
  Color generateRouteColor(String routeId);

  // Aplica efectos de selección (glow, resaltado)
  RutaStyle applySelectionEffect(RutaStyle baseStyle);
}

class RutaStyle {
  final Color color;
  final double strokeWidth;
  final List<Color> gradientColors;
  final double opacity;
  final bool hasGlowEffect;
  final double glowRadius;
}
```

### 3. GuiaVisualService

**Responsabilidad:** Creación de guías visuales con paradas numeradas para rutas específicas.

````dart
class GuiaVisualService {
  // Genera guía visual con paradas numeradas
  GuiaVisual generateRouteGuide(RutaCompleta ruta);

  // Crea marcadores numerados para paradas
  List<Marker> generateNumberedStops(List<Parada> paradas, Color routeColor);

  // Genera línea guía punteada entre paradas siguiendo calles (NO líneas directas)
  List<Polyline> generateGuideLine(List<LatLng> points, Color routeColor);

  // Calcula ruta realista entre dos paradas usando calles
  List<LatLng> calculateStreetRoute(LatLng from, LatLng to);

  // Optimiza paradas para mostrar (máximo 10, prioriza importantes)
  List<Parada> optimizeStopsForDisplay(List<Parada> allStops);
}

class GuiaVisual {
  final List<Marker> paradasNumeradas;
  final List<Polyline> lineasGuia;
  final Color colorRuta;
  final String rutaId;
}

### 4. ParadaVisualizationService

**Responsabilidad:** Renderizado y manejo de paradas generales del sistema.

```dart
class ParadaVisualizationService {
  // Genera marcadores de paradas generales
  List<Marker> generateStopMarkers(List<Parada> paradas);

  // Obtiene ícono según tipo de parada
  Widget getStopIcon(TipoParada tipo, List<String> rutasQueAtendes);

  // Maneja interacciones con paradas
  void handleStopTap(Parada parada);
}

enum TipoParada {
  normal,
  terminal,
  intercambio,
  principal
}
````

### 4. AnimationService

**Responsabilidad:** Animaciones fluidas y efectos visuales.

```dart
class AnimationService {
  // Anima el trazado progresivo de una ruta
  void animateRouteDrawing(List<LatLng> points, Duration duration);

  // Transición suave entre rutas
  void transitionBetweenRoutes(String fromRoute, String toRoute);

  // Efectos de zoom y pan
  void animateMapMovement(LatLng target, double zoom);
}
```

## Modelos de Datos

### RutaCompleta

```dart
class RutaCompleta {
  final String id;
  final String nombre;
  final String empresa;
  final Color colorPrincipal;
  final List<LatLng> geometriaOriginal;
  final List<LatLng> geometriaOptimizada;
  final List<Parada> paradas;
  final RutaMetadata metadata;
  final RutaEstado estado;
}

class RutaMetadata {
  final int tarifa;
  final String frecuencia;
  final List<String> horarios;
  final DireccionRuta direccion;
}

class RutaEstado {
  final bool activa;
  final NivelCongestion congestion;
  final DateTime ultimaActualizacion;
}
```

### Parada

```dart
class Parada {
  final String id;
  final String nombre;
  final LatLng coordenadas;
  final TipoParada tipo;
  final List<String> rutasQueAtiende;
  final List<ServicioParada> servicios;
}

class ServicioParada {
  final TipoServicio tipo;
  final bool disponible;
}
```

## Estrategia Anti-Líneas Directas

### Principio Fundamental

**NUNCA** mostrar líneas rectas que atraviesen edificios, manzanas o espacios no transitables. Todas las conexiones entre paradas deben seguir rutas realistas por calles.

### Implementación Técnica

```dart
class AntiDirectLineStrategy {
  // Valida que una línea no cruce áreas prohibidas
  bool isValidRoute(LatLng from, LatLng to, List<LatLng> proposedRoute);

  // Genera ruta alternativa siguiendo calles
  List<LatLng> generateStreetBasedRoute(LatLng from, LatLng to);

  // Detecta si una línea cruza edificios o áreas no transitables
  bool crossesBuildings(LatLng from, LatLng to);
}
```

### Métodos de Conexión Permitidos

1. **Routing API**: Usar OpenRouteService para rutas reales
2. **Waypoints Intermedios**: Agregar puntos que sigan calles conocidas
3. **Líneas Punteadas Inteligentes**: Solo mostrar segmentos que sigan vías
4. **Fallback Seguro**: Si no hay ruta disponible, mostrar solo las paradas sin conectar

## Estrategia de Renderizado

### 1. Optimización por Niveles de Zoom

```dart
class ZoomOptimization {
  static const Map<double, RenderConfig> configs = {
    // Zoom lejano: rutas simplificadas
    10.0: RenderConfig(
      strokeWidth: 2.0,
      showStops: false,
      simplificationTolerance: 0.001,
    ),

    // Zoom medio: rutas completas
    13.0: RenderConfig(
      strokeWidth: 4.0,
      showStops: true,
      simplificationTolerance: 0.0005,
    ),

    // Zoom cercano: máximo detalle
    16.0: RenderConfig(
      strokeWidth: 6.0,
      showStops: true,
      showDirectionArrows: true,
      simplificationTolerance: 0.0,
    ),
  };
}
```

### 2. Sistema de Capas

```dart
enum MapLayer {
  baseMap,           // Mapa base
  routesShadow,      // Sombras de rutas
  routesMain,        // Rutas principales
  routesGlow,        // Efectos de glow
  stops,             // Paradas
  userLocation,      // Ubicación del usuario
  interactions       // Elementos interactivos
}
```

## Manejo de Errores

### Estrategias de Fallback

1. **Fallo en Routing Service:**

   - Usar geometría original con suavizado básico
   - Mostrar notificación discreta al usuario

2. **Problemas de Rendimiento:**

   - Reducir automáticamente la complejidad visual
   - Implementar LOD (Level of Detail) dinámico

3. **Errores de Datos:**
   - Validación robusta de coordenadas
   - Rutas de respaldo predefinidas

## Estrategia de Testing

### Tests Unitarios

```dart
// Ejemplo de test para RutaGeometryService
testWidgets('should generate smooth realistic route', (tester) async {
  final service = RutaGeometryService();
  final originalPoints = [
    LatLng(2.444814, -76.614739),
    LatLng(2.445000, -76.617000),
  ];

  final result = service.generateRealisticRoute(originalPoints);

  expect(result.length, greaterThan(originalPoints.length));
  expect(result.first, equals(originalPoints.first));
  expect(result.last, equals(originalPoints.last));
});
```

### Tests de Integración

- Verificar renderizado correcto en diferentes dispositivos
- Probar rendimiento con múltiples rutas simultáneas
- Validar animaciones en dispositivos de gama baja

### Tests de UI

- Verificar que las rutas no se superpongan incorrectamente
- Comprobar legibilidad de colores en diferentes temas
- Validar responsividad de interacciones táctiles

## Consideraciones de Rendimiento

### 1. Optimizaciones de Memoria

```dart
class RouteCache {
  static const int maxCachedRoutes = 10;
  static const Duration cacheExpiry = Duration(minutes: 30);

  final Map<String, CachedRoute> _cache = {};

  void cacheRoute(String id, List<LatLng> geometry) {
    if (_cache.length >= maxCachedRoutes) {
      _evictOldestRoute();
    }
    _cache[id] = CachedRoute(geometry, DateTime.now());
  }
}
```

### 2. Renderizado Eficiente

- Usar `RepaintBoundary` para aislar repaints de rutas
- Implementar culling de rutas fuera del viewport
- Lazy loading de geometrías complejas

### 3. Gestión de Recursos

```dart
class ResourceManager {
  // Pool de objetos reutilizables
  final ObjectPool<Polyline> polylinePool;
  final ObjectPool<Marker> markerPool;

  // Limpieza automática de recursos no utilizados
  void cleanupUnusedResources();
}
```

## Integración con Servicios Externos

### OpenRouteService Integration

```dart
class OpenRouteServiceClient {
  Future<List<LatLng>> getRouteGeometry(
    List<LatLng> waypoints,
    String profile, // driving-car, foot-walking, etc.
  ) async {
    // Implementación de llamada a API
  }
}
```

### Configuración de Fallbacks

- Servicio primario: OpenRouteService
- Servicio secundario: MapBox Directions
- Fallback local: Interpolación lineal suavizada

## Accesibilidad

### Consideraciones Visuales

- Colores con suficiente contraste (WCAG 2.1 AA)
- Patrones alternativos para usuarios daltónicos
- Tamaños de elementos táctiles mínimos (44x44 pt)

### Soporte para Lectores de Pantalla

```dart
class AccessibilitySupport {
  String getRouteDescription(RutaCompleta ruta) {
    return 'Ruta ${ruta.nombre}, operada por ${ruta.empresa}, '
           'tarifa ${ruta.metadata.tarifa} pesos, '
           '${ruta.paradas.length} paradas';
  }
}
```

## Configuración y Personalización

### Configuración de Usuario

```dart
class MapVisualizationSettings {
  final bool showAllRoutes;
  final bool enableAnimations;
  final double routeOpacity;
  final bool showDirectionArrows;
  final ColorScheme colorScheme;
  final PerformanceMode performanceMode;
}
```

Esta arquitectura proporciona una base sólida para crear un sistema de visualización de rutas profesional, escalable y visualmente atractivo que transformará completamente la experiencia del usuario en RouWhite.
