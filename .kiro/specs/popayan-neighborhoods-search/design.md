# Design Document

## Overview

El diseño expandirá el sistema de búsqueda existente de la aplicación RouWhite para incluir una base de datos completa de todos los barrios de Popayán organizados por comunas. Se integrará con la funcionalidad de búsqueda actual (`SmartSearchPage`) y los datos de lugares (`PopayanPlacesDatabase`) para proporcionar navegación hacia cualquier barrio de la ciudad.

## Architecture

### Data Layer

- **PopayanNeighborhoodsDatabase**: Nueva clase que contendrá todos los barrios organizados por comunas
- **PopayanPlace**: Se extenderá para incluir barrios con categoría "Barrio" y metadatos de comuna
- **Integration**: Los datos de barrios se integrarán con `PopayanPlacesDatabase` existente

### Search Integration

- **SmartSearchPage**: Se modificará para incluir búsqueda de barrios
- **Category Search**: Se agregará nueva categoría "Barrios por Comuna"
- **Rural Search**: Se agregará categoría "Sector Rural"

### Navigation Integration

- **Coordinate Mapping**: Cada barrio tendrá coordenadas aproximadas basadas en su ubicación geográfica
- **Route Integration**: Los barrios se conectarán con el sistema de rutas de bus existente

## Components and Interfaces

### 1. PopayanNeighborhood Data Model

```dart
class PopayanNeighborhood {
  final String id;
  final String name;
  final String comuna; // "Comuna 1", "Comuna 2", etc. o "Sector Rural"
  final LatLng coordinates;
  final String type; // "Barrio", "Corregimiento", "Vereda"
  final List<String> keywords;
  final String? description;
}
```

### 2. PopayanNeighborhoodsDatabase

```dart
class PopayanNeighborhoodsDatabase {
  static List<PopayanNeighborhood> getAllNeighborhoods();
  static List<PopayanNeighborhood> getNeighborhoodsByComuna(String comuna);
  static List<PopayanNeighborhood> getRuralAreas();
  static List<PopayanNeighborhood> searchNeighborhoods(String query);
  static List<String> getComunas();
}
```

### 3. Search Integration Methods

```dart
// En PopayanPlacesDatabase
static List<PopayanPlace> searchPlacesIncludingNeighborhoods(String query);
static List<PopayanPlace> getPlacesByCategory(String category); // Extendido para barrios
```

## Data Models

### Neighborhood Organization

**Comuna 1:**

- Modelo, Loma Linda, Prados del Norte, Alfonso López, Las Américas, Bello Horizonte, Campo Alegre, La Esmeralda, El Recuerdo, Villa del Norte, Los Alpes, Villa Esperanza, El Mirador

**Comuna 2:**

- Villa Melisa, Esperanza, Canterbury, La Maria, Villa del Prado, Los Robles, Pomona, La Castellana, Urb. La Castellana, Villa Docente, Villa del Carmen, Los Nogales, El Lago, Villa Country, Altos de Palermo, Altos de la Maria, Villa Alejandría, Villa Universidad

**Comuna 3:**

- Bolívar, Ciudad Jardín, Periodistas, Villa Blanca, La Campiña, La Colina, El Tablazo, Villa Victoria, Los Libertadores, San Rafael, Villa de Los Alpes, Los Comuneros, El Empedrado

**Comuna 4 (Centro Histórico):**

- Centro, El Callejón, San José, Barrio Obrero, Caldas, San Francisco, Los Balcones, La Carrera, Santo Domingo, Belgica, La Ermita

**Comuna 5:**

- La Ladera, Alfonso López Pumarejo, El Cadillal, Las Ferias, José Hilario López, El Jarillón, Villa Hortensia, La Rivera, El Uvo, Villa Anita, San Fernando, Villa María

**Comuna 6:**

- Los Hoyos, El Popular, Nueva Esperanza, Las Palmas, Villa Rica, La Aldea, El Progreso, Santa Elena, La Independencia, Villa del Rio, Los Sauces

**Comuna 7:**

- Junín, Camino Real, Samuel Silverio, La Paz, San Camilo, Villa Luz, El Carmen, San Isidro, La Unión, Villa del Campo, El Pedregal

**Comuna 8:**

- Chirimía, El Arenillo, Villa del Sur, Santa Bárbara, La Esperanza del Sur, Villa Esperanza del Sur, San Bernardino, Villa Nueva, El Paraíso, La Primavera, Villa del Rosario

**Comuna 9:**

- La Capilla, Villa Occidente, Lomas de Granada, Torres del Sur, San Agustín, Villa Alexandra, El Rincón, Santa Ana, Villa del Pinar, Altos del Sur

**Sector Rural:**

- Corregimientos: Los Cerillos, La Yunga, Julumito, San Bernardino, Los Cerrillos, La Rejoya, San Rafael, Las Piedras, Figueroa
- Veredas: Vereda Los Cerillos, Vereda La Yunga, Vereda San Bernardino, Vereda Julumito, Vereda Las Piedras, Vereda La Rejoya, Vereda San Rafael, Vereda Figueroa

### Coordinate Mapping Strategy

Las coordenadas se asignarán basándose en:

1. **Centro de Popayán**: LatLng(2.4448, -76.6147) como referencia
2. **Distribución geográfica**:
   - Norte: Comunas 1, 2, 7, 9 (latitud > 2.445)
   - Centro: Comunas 3, 4 (latitud ≈ 2.444)
   - Sur: Comunas 5, 6, 8 (latitud < 2.443)
   - Rural: Coordenadas más alejadas del centro

## Error Handling

### Search Errors

- **No Results Found**: Mensaje claro cuando no se encuentran barrios
- **Invalid Comuna**: Validación de comunas existentes
- **Coordinate Errors**: Fallback a coordenadas del centro de la comuna

### Navigation Errors

- **Missing Coordinates**: Usar coordenadas aproximadas del centro de comuna
- **GPS Issues**: Integrar con manejo de errores existente de ubicación

## Testing Strategy

### Unit Tests

1. **PopayanNeighborhoodsDatabase Tests**:

   - Verificar que todos los barrios estén incluidos
   - Validar organización por comunas
   - Probar búsqueda por texto parcial

2. **Search Integration Tests**:

   - Verificar integración con búsqueda existente
   - Probar categorías de barrios
   - Validar resultados de búsqueda rural

3. **Data Integrity Tests**:
   - Verificar que todos los barrios tengan coordenadas
   - Validar que no haya duplicados
   - Confirmar estructura de comunas

### Integration Tests

1. **Search Flow Tests**:

   - Buscar barrio → Ver resultados → Navegar
   - Buscar por comuna → Seleccionar barrio → Navegar
   - Buscar sector rural → Seleccionar ubicación → Navegar

2. **UI Integration Tests**:
   - Verificar que aparezcan nuevas categorías
   - Probar flujo de navegación completo
   - Validar manejo de errores en UI

### Performance Tests

1. **Search Performance**: Búsqueda rápida con 200+ barrios
2. **Memory Usage**: Verificar uso eficiente de memoria con datos expandidos
3. **Load Time**: Tiempo de carga inicial de datos de barrios
