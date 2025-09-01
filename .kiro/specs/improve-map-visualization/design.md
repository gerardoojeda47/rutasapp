# Design Document

## Overview

El objetivo es mejorar la visualización del mapa para que use las coordenadas reales de las rutas de SOTRACAUCA definidas en `BusRoute.stops`, implemente colores diferenciados por ruta usando `BusRoute.color`, y cree rutas realistas que sigan las calles y carreras de Popayán en lugar de líneas rectas entre paradas.

## Architecture

La arquitectura se mantiene igual:

- `MapaRutaPagina` recibe `routeName` y `stops` (neighborhoods)
- Se debe obtener la ruta completa de `BusRoute` para acceder a `stops` (coordenadas LatLng) y `color`
- El mapa renderiza marcadores, líneas y información de paradas

### Cambios principales:

1. **Fuente de datos**: Usar `BusRoute.stops` en lugar de coordenadas hardcodeadas
2. **Colores**: Usar `BusRoute.color` para líneas y marcadores
3. **Rutas realistas**: Crear puntos intermedios que sigan las calles reales de Popayán
4. **APIs**: Actualizar métodos deprecados de flutter_map

## Components and Interfaces

### MapaRutaPagina Updates

**Entrada actual:**

```dart
MapaRutaPagina({
  required String routeName,
  required List<String> stops, // neighborhoods
})
```

**Propuesta mejorada:**

```dart
MapaRutaPagina({
  required BusRoute route, // Pasar toda la ruta
})
```

**Alternativa (mantener compatibilidad):**

```dart
MapaRutaPagina({
  required String routeName,
  required List<String> stops,
  required List<LatLng> coordinates, // Nuevas coordenadas reales
  required String routeColor, // Color de la ruta
})
```

### BusRoute Integration

**Datos disponibles en BusRoute:**

- `stops: List<LatLng>` - Coordenadas reales de paradas
- `neighborhoods: List<String>` - Nombres de barrios/paradas
- `color: String` - Color hex de la ruta (ej: "#FF6B35")
- `name: String` - Nombre de la ruta
- `company: String` - Empresa (SOTRACAUCA)

## Data Models

### Rutas realistas por calles

Para crear rutas que sigan las calles reales de Popayán, necesitamos definir puntos intermedios entre las paradas principales que sigan las vías conocidas:

**Vías principales de Popayán:**

- **Carrera 5**: Eje central norte-sur (pasa por el centro histórico)
- **Carrera 6**: Zona bancaria y comercial
- **Carrera 9**: Conexión hacia el norte
- **Calle 5**: Eje central este-oeste
- **Avenida Panamericana**: Conexión hacia Terminal y sur
- **Vía al Norte**: Hacia barrios como La Paz, Los Sauces

**Estrategia de implementación:**

1. **Rutas del centro**: Usar Carrera 5, Carrera 6, Calle 5 como ejes principales
2. **Rutas hacia el norte**: Seguir Carrera 9 y Vía al Norte
3. **Rutas hacia el sur**: Usar Avenida Panamericana
4. **Conexiones entre barrios**: Crear puntos intermedios lógicos

### Mapeo de coordenadas:

**Antes (hardcodeado):**

```dart
final Map<String, LatLng> _stopCoordinates = {
  'Centro': const LatLng(2.4389, -76.6064),
  // ... más coordenadas hardcodeadas
};
```

**Después (desde BusRoute):**

```dart
// Usar directamente route.stops que ya contiene las coordenadas reales
List<LatLng> _routeStops = route.stops;
List<String> _stopNames = route.neighborhoods;
```

### Colores por ruta:

**Mapeo de colores de SOTRACAUCA:**

- Ruta 1: `#FF6B35` (naranja)
- Ruta 2: `#FF8C42` (naranja claro)
- Ruta 3: `#FFAA5A` (naranja amarillento)
- Ruta 4: `#FFC971` (amarillo naranja)
- Ruta 5: `#FFE66D` (amarillo)
- Ruta 6: `#A8E6CF` (verde claro)
- Ruta 7: `#88D8B0` (verde)
- Ruta 8: `#FFB3BA` (rosa claro)
- Ruta 9: `#BFACC8` (lila)

## Error Handling

### Coordenadas faltantes

- Si `route.stops` está vacío, usar coordenadas por defecto del centro de Popayán
- Si hay menos coordenadas que nombres de paradas, interpolar o usar la última coordenada conocida

### Colores inválidos

- Si `route.color` no es un color válido, usar color por defecto `#FF6A00`
- Validar formato hex antes de usar

### APIs deprecadas

- Reemplazar `withOpacity()` con `withValues(alpha:)`
- Reemplazar `fitBounds()` con `fitCamera(CameraFit.bounds())`

## Testing Strategy

### Visual Testing

- Verificar que cada ruta muestre su color específico
- Verificar que las coordenadas coincidan con ubicaciones reales de Popayán
- Verificar que las líneas conecten las paradas correctamente

### Functional Testing

- Probar navegación desde cada una de las 9 rutas
- Verificar que el zoom automático funcione correctamente
- Probar interacción con marcadores de paradas

### Performance Testing

- Verificar que el mapa cargue rápidamente con múltiples paradas
- Verificar que no haya memory leaks con cambios de ruta

## Implementation Notes

### Prioridades:

1. **Crítico**: Usar coordenadas reales de `BusRoute.stops`
2. **Importante**: Implementar colores diferenciados por ruta
3. **Importante**: Actualizar APIs deprecadas
4. **Opcional**: Mejorar animaciones y transiciones

### Consideraciones técnicas:

**Conversión de color:**

```dart
Color parseColor(String hexColor) {
  return Color(int.parse(hexColor.replaceFirst('#', '0xFF')));
}
```

**Actualización de fitBounds:**

```dart
// Antes
_mapController.fitBounds(bounds);

// Después
_mapController.fitCamera(CameraFit.bounds(bounds: bounds));
```

**Actualización de withOpacity:**

```dart
// Antes
color.withOpacity(0.7)

// Después
color.withValues(alpha: 0.7)
```

### Estructura de archivos:

- Mantener `mapa_ruta_pagina.dart` como archivo principal
- Considerar crear helper para conversión de colores si es necesario
- Actualizar llamadas desde `rutas_pagina.dart` para pasar datos adicionales
