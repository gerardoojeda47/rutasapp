# Documento de Diseño - Iconos en Rutas del Mapa

## Visión General

El sistema de iconos en rutas mejorará significativamente la experiencia visual del mapa de RouWhite mediante la implementación de iconos informativos distribuidos a lo largo de las líneas de transporte. Esta funcionalidad utilizará Flutter Map con capas personalizadas para renderizar iconos dinámicos que proporcionen información contextual sobre las rutas.

## Arquitectura

### Componentes Principales

1. **IconoRutaManager**: Gestor principal de iconos en rutas
2. **IconoRutaRenderer**: Renderizador de iconos en el mapa
3. **IconoRutaConfig**: Configuración y preferencias de iconos
4. **IconoRutaAnimator**: Manejo de animaciones de iconos
5. **IconoRutaInteraction**: Gestión de interacciones con iconos

### Flujo de Datos

```
Usuario → Configuración → IconoRutaManager → IconoRutaRenderer → FlutterMap
                                        ↓
                        IconoRutaAnimator ← IconoRutaInteraction
```

## Componentes y Interfaces

### 1. IconoRutaManager

```dart
class IconoRutaManager {
  List<IconoRuta> generarIconosParaRuta(RutaTransporte ruta);
  void actualizarIconos(List<RutaTransporte> rutas);
  void aplicarFiltros(IconoRutaConfig config);
}
```

**Responsabilidades:**

- Generar iconos basados en datos de rutas
- Aplicar configuraciones de usuario
- Coordinar con otros componentes

### 2. IconoRutaRenderer

```dart
class IconoRutaRenderer extends StatelessWidget {
  Widget buildIconoLayer(List<IconoRuta> iconos);
  Widget buildIconoMarker(IconoRuta icono);
  void optimizarRenderizado(double zoom);
}
```

**Responsabilidades:**

- Renderizar iconos en FlutterMap
- Optimizar rendimiento según zoom
- Manejar densidad de iconos

### 3. IconoRutaConfig

```dart
class IconoRutaConfig {
  bool mostrarBuses;
  bool mostrarParadas;
  bool mostrarServicios;
  bool mostrarDirecciones;
  double densidadIconos;
  TemaIconos tema;
}
```

**Responsabilidades:**

- Almacenar preferencias de usuario
- Configurar tipos de iconos visibles
- Manejar temas y estilos

### 4. IconoRutaAnimator

```dart
class IconoRutaAnimator {
  Animation<double> crearAnimacionMovimiento();
  Animation<Color> crearAnimacionColor();
  void iniciarAnimacionBus(IconoRuta icono);
}
```

**Responsabilidades:**

- Crear animaciones fluidas
- Animar buses en movimiento
- Gestionar transiciones de estado

## Modelos de Datos

### IconoRuta

```dart
class IconoRuta {
  String id;
  TipoIcono tipo;
  LatLng posicion;
  IconData icono;
  Color color;
  double tamaño;
  String? tooltip;
  Map<String, dynamic>? datosAdicionales;
  bool animado;
  double rotacion;
}

enum TipoIcono {
  bus,
  parada,
  servicio,
  direccion,
  paradaImportante
}
```

### ConfiguracionIconos

```dart
class ConfiguracionIconos {
  Map<TipoIcono, bool> iconosVisibles;
  double densidadMinima;
  double densidadMaxima;
  TemaIconos temaActual;
  bool animacionesHabilitadas;
}
```

## Estrategia de Renderizado

### Optimización por Zoom

- **Zoom < 12**: Solo iconos de paradas importantes
- **Zoom 12-14**: Paradas + buses principales
- **Zoom > 14**: Todos los iconos con máximo detalle

### Distribución de Iconos

1. **Algoritmo de Espaciado**: Distribuir iconos uniformemente a lo largo de la polilínea
2. **Detección de Colisiones**: Evitar superposición de iconos cercanos
3. **Priorización**: Mostrar iconos más importantes cuando hay limitaciones de espacio

## Manejo de Errores

### Escenarios de Error

1. **Falta de Datos de Ruta**: Mostrar iconos genéricos
2. **Error de Renderizado**: Fallback a líneas simples
3. **Problemas de Rendimiento**: Reducir automáticamente densidad de iconos
4. **Memoria Insuficiente**: Implementar cache inteligente

### Estrategias de Recuperación

- Cache de iconos pre-renderizados
- Degradación gradual de calidad
- Reintentos automáticos con menor densidad

## Estrategia de Testing

### Tests Unitarios

- Generación correcta de iconos por ruta
- Aplicación de filtros y configuraciones
- Cálculos de posicionamiento
- Lógica de animaciones

### Tests de Integración

- Renderizado en FlutterMap
- Interacciones de usuario
- Rendimiento con múltiples rutas
- Comportamiento en diferentes niveles de zoom

### Tests de UI

- Visualización correcta de iconos
- Animaciones fluidas
- Responsividad en diferentes dispositivos
- Accesibilidad

## Consideraciones de Rendimiento

### Optimizaciones

1. **Lazy Loading**: Cargar iconos solo cuando son visibles
2. **Object Pooling**: Reutilizar objetos de iconos
3. **Culling**: No renderizar iconos fuera del viewport
4. **LOD (Level of Detail)**: Diferentes niveles de detalle según zoom

### Métricas de Rendimiento

- Tiempo de renderizado < 16ms (60 FPS)
- Uso de memoria < 50MB adicionales
- Tiempo de carga inicial < 2 segundos
- Fluidez de animaciones > 30 FPS

## Accesibilidad

### Características de Accesibilidad

- Tooltips descriptivos para lectores de pantalla
- Contraste adecuado en modo alto contraste
- Tamaños de iconos ajustables
- Navegación por teclado para iconos interactivos

## Internacionalización

### Soporte Multiidioma

- Tooltips traducibles
- Iconos culturalmente apropiados
- Formatos de texto localizados
- Direccionalidad RTL/LTR
