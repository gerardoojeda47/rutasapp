# Design Document

## Overview

El problema principal es una incompatibilidad entre la nueva estructura de datos `BusRoute` (clase con propiedades) y el código existente en `rutas_pagina.dart` que espera un `Map<String, dynamic>`. La solución implica actualizar el código para usar las propiedades correctas de la clase `BusRoute` y manejar campos que no existen en la nueva estructura.

## Architecture

La arquitectura actual se mantiene igual:

- `PopayanBusRoutes` proporciona los datos a través de `getAllRoutes()`
- `RutasPagina` consume estos datos y los muestra en la UI
- La navegación a `MapaRutaPagina` se mantiene igual

El cambio principal es en la capa de presentación (`RutasPagina`) para usar correctamente las propiedades de `BusRoute`.

## Components and Interfaces

### BusRoute Class (Existing)

```dart
class BusRoute {
  final String id;
  final String name;
  final String company;
  final List<LatLng> stops;
  final List<String> neighborhoods;
  final String schedule;
  final String fare;
  final String color;
  final String? description;
  final List<String>? pointsOfInterest;
  final List<String>? services;
  final double? distance;
  final int? estimatedTime;
}
```

### RutasPagina Updates

El componente `RutasPagina` necesita ser actualizado para:

1. **Mapeo de propiedades**: Cambiar de sintaxis de Map a propiedades de clase
2. **Campos faltantes**: Manejar campos que existían en el formato anterior pero no en `BusRoute`
3. **Navegación**: Actualizar parámetros de navegación para usar las propiedades correctas

## Data Models

### Mapeo de campos antiguos a nuevos:

| Campo Anterior     | Campo Nuevo                      | Tipo         | Notas                         |
| ------------------ | -------------------------------- | ------------ | ----------------------------- |
| `ruta['nombre']`   | `ruta.name`                      | String       | Directo                       |
| `ruta['empresa']`  | `ruta.company`                   | String       | Directo                       |
| `ruta['trayecto']` | `ruta.neighborhoods.join(' - ')` | String       | Calculado                     |
| `ruta['paradas']`  | `ruta.neighborhoods`             | List<String> | Directo                       |
| `ruta['horario']`  | `ruta.schedule`                  | String       | Directo                       |
| `ruta['costo']`    | `ruta.fare`                      | String       | Directo                       |
| `ruta['trafico']`  | N/A                              | String       | Valor por defecto: "moderado" |
| `ruta['proxBus']`  | N/A                              | String       | Valor por defecto: "5 min"    |
| `ruta['favorito']` | N/A                              | bool         | Manejado por estado local     |

### Campos que requieren valores por defecto:

- **Tráfico**: No existe en `BusRoute`, usar "moderado" como valor por defecto
- **Próximo Bus**: No existe en `BusRoute`, usar "5 min" como valor por defecto
- **Favorito**: Manejado por el estado local `_favoritos`

## Error Handling

### Compilación

- Eliminar todos los accesos con `[]` que causan errores de compilación
- Reemplazar con acceso a propiedades de clase

### Runtime

- Manejar casos donde propiedades opcionales pueden ser null
- Proporcionar valores por defecto para campos que no existen en la nueva estructura

### Navegación

- Asegurar que los parámetros pasados a `MapaRutaPagina` sean del tipo correcto
- Usar `ruta.neighborhoods` en lugar de `ruta['paradas']`

## Testing Strategy

### Unit Tests

- Verificar que `PopayanBusRoutes.getAllRoutes()` retorna las rutas correctas
- Verificar que el mapeo de propiedades funciona correctamente

### Integration Tests

- Verificar que la página de rutas se carga sin errores
- Verificar que la navegación a mapa funciona correctamente
- Verificar que la funcionalidad de favoritos funciona

### Manual Testing

- Verificar visualmente que todas las rutas de SOTRACAUCA se muestran
- Verificar que los datos se muestran correctamente (nombre, empresa, horarios, etc.)
- Verificar que los botones de "Ver mapa" y "Rastrear" funcionan
- Verificar que la funcionalidad de favoritos funciona correctamente

## Implementation Notes

### Prioridades de cambio:

1. **Crítico**: Cambiar accesos `ruta['property']` a `ruta.property`
2. **Importante**: Manejar campos faltantes con valores por defecto
3. **Importante**: Actualizar navegación para usar propiedades correctas
4. **Opcional**: Mejorar la presentación de datos usando las nuevas propiedades disponibles

### Consideraciones especiales:

- El campo `trayecto` debe ser calculado como `ruta.neighborhoods.join(' - ')`
- Los campos `trafico` y `proxBus` necesitan valores por defecto ya que no existen en `BusRoute`
- La funcionalidad de favoritos debe adaptarse para usar `ruta.id` como identificador único
