# Design Document

## Overview

El diseño se enfoca en corregir las coordenadas GPS y trazados de las rutas de buses en Popayán para que coincidan con los mapas oficiales proporcionados. El análisis de los mapas reales muestra que:

1. **Ruta 1 - La Paz/Campanario/Pomona/Chirimía**: Necesita corrección de coordenadas para seguir el trazado real
2. **TP2BT**: Requiere verificación y posible creación/corrección como ruta separada

## Architecture

La arquitectura se mantiene igual, pero los datos se actualizarán:

```
PopayanBusRoutes (Data Layer)
├── BusRoute objects con coordenadas corregidas
├── Paradas con ubicaciones GPS reales
└── Trazados que siguen calles reales

RutasPagina (Presentation Layer)
├── Muestra rutas con datos corregidos
└── Navegación a mapas con coordenadas precisas

MapaRutaPagina (Map Layer)
├── Renderiza trazados corregidos
└── Muestra paradas en ubicaciones reales
```

## Components and Interfaces

### BusRoute Data Corrections

#### Ruta 1 - Correcciones Identificadas:

**Análisis del mapa oficial:**

- La ruta sigue un patrón más complejo que el actual
- Pasa por el centro de Popayán (área del Parque Caldas)
- El trazado hacia Chirimía es más directo
- Las paradas están ubicadas en puntos estratégicos de la ciudad

**Coordenadas corregidas necesarias:**

```dart
// Ruta 1 corregida basada en mapa oficial
stops: [
  LatLng(2.4490, -76.6080), // La Paz (mantener)
  LatLng(2.4475, -76.6095), // Conexión hacia centro
  LatLng(2.4448, -76.6147), // Centro - Parque Caldas
  LatLng(2.4445, -76.6145), // Campanario área
  LatLng(2.4430, -76.6160), // Pomona
  LatLng(2.4415, -76.6175), // Hacia Chirimía
  LatLng(2.4400, -76.6190), // Chirimía terminal
]
```

#### TP2BT Route Analysis:

**Del mapa oficial TP2BT:**

- Ruta que conecta Tomas C. con Jardines De Paz
- Pasa por Chirimía, Craó, Campanario
- Trazado diferente a Ruta 1
- Puede ser una ruta existente que necesita ser agregada o corregida

**Coordenadas propuestas para TP2BT:**

```dart
BusRoute(
  id: 'tp2bt_tomas_jardines',
  name: 'TP2BT - Tomas C./Chirimía/Craó/Campanario/Jardines De Paz',
  company: 'SOTRACAUCA',
  stops: [
    LatLng(2.4400, -76.6080), // Tomas Cipriano
    LatLng(2.4410, -76.6120), // Hacia Chirimía
    LatLng(2.4420, -76.6140), // Chirimía
    LatLng(2.4435, -76.6155), // Craó área
    LatLng(2.4448, -76.6147), // Campanario
    LatLng(2.4460, -76.6130), // Hacia Jardines
    LatLng(2.4480, -76.6110), // Jardines De Paz
  ],
  neighborhoods: ['Tomas Cipriano', 'Chirimía', 'Craó', 'Campanario', 'Jardines De Paz'],
  // ... otros campos
)
```

## Data Models

### Coordinate Correction Strategy

1. **Análisis de mapas reales**: Usar los mapas proporcionados como referencia
2. **Verificación GPS**: Asegurar que las coordenadas corresponden a ubicaciones reales en Popayán
3. **Validación de trazados**: Verificar que las rutas siguen calles existentes
4. **Consistencia de datos**: Mantener formato consistente con otras rutas

### Route Validation Rules

```dart
// Reglas de validación para coordenadas
class RouteValidator {
  // Popayán bounds aproximados
  static const double minLat = 2.42;
  static const double maxLat = 2.47;
  static const double minLng = -76.65;
  static const double maxLng = -76.59;

  static bool isValidCoordinate(LatLng coord) {
    return coord.latitude >= minLat &&
           coord.latitude <= maxLat &&
           coord.longitude >= minLng &&
           coord.longitude <= maxLng;
  }
}
```

### Distance and Time Recalculation

Con las coordenadas corregidas, se deben recalcular:

- **Distancias**: Usar fórmula de Haversine con coordenadas reales
- **Tiempos estimados**: Basados en distancias reales y velocidad promedio urbana
- **Paradas intermedias**: Agregar paradas que falten en el recorrido real

## Error Handling

### Coordinate Validation

- Verificar que todas las coordenadas estén dentro de los límites de Popayán
- Validar que las coordenadas correspondan a ubicaciones accesibles
- Manejar casos donde las coordenadas originales sean completamente incorrectas

### Route Consistency

- Asegurar que el orden de paradas siga la lógica del recorrido
- Verificar que los barrios listados correspondan a las coordenadas
- Validar que las distancias calculadas sean razonables

### Backward Compatibility

- Mantener los IDs de rutas existentes cuando sea posible
- Preservar la estructura de datos BusRoute
- Asegurar que las correcciones no rompan funcionalidad existente

## Testing Strategy

### Data Validation Tests

```dart
// Tests para validar coordenadas corregidas
test('Ruta 1 coordinates are within Popayán bounds', () {
  final ruta1 = PopayanBusRoutes.getRouteById('sotracauca_ruta_1');
  for (final stop in ruta1.stops) {
    expect(RouteValidator.isValidCoordinate(stop), isTrue);
  }
});

test('TP2BT route has correct neighborhoods', () {
  final tp2bt = PopayanBusRoutes.getRouteById('tp2bt_tomas_jardines');
  expect(tp2bt.neighborhoods, contains('Tomas Cipriano'));
  expect(tp2bt.neighborhoods, contains('Jardines De Paz'));
});
```

### Visual Verification

- Verificar visualmente en el mapa que las rutas siguen trazados lógicos
- Comparar con los mapas oficiales proporcionados
- Validar que las paradas estén en ubicaciones accesibles

### Integration Tests

- Verificar que MapaRutaPagina muestra las rutas corregidas correctamente
- Validar que la navegación funciona con las nuevas coordenadas
- Probar que los cálculos de distancia son precisos

## Implementation Notes

### Priority Order

1. **Crítico**: Corregir coordenadas de Ruta 1 basándose en mapa oficial
2. **Importante**: Verificar si TP2BT es ruta existente o nueva
3. **Importante**: Recalcular distancias y tiempos con coordenadas corregidas
4. **Opcional**: Agregar más paradas intermedias si se identifican en mapas

### Research Needed

- Verificar nombres exactos de barrios en Popayán
- Confirmar si "Craó" es nombre correcto del barrio
- Validar si "Jardines De Paz" es ubicación real
- Investigar si TP2BT es código oficial de ruta

### Coordinate Sources

- Mapas oficiales proporcionados por el usuario
- Google Maps para verificación de ubicaciones
- OpenStreetMap para validar calles y trazados
- Datos oficiales de SOTRACAUCA si están disponibles
