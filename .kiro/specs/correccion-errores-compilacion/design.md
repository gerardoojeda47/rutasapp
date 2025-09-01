# Design Document

## Overview

La aplicación RouWhite tiene errores críticos de compilación que se originan principalmente en el archivo `lib/data/popayan_places_data.dart`. Los errores incluyen sintaxis incorrecta de constructores, parámetros mal definidos, definiciones duplicadas, y problemas de tipos. El diseño se enfoca en corregir sistemáticamente estos problemas manteniendo la funcionalidad existente.

## Architecture

### Problema Principal Identificado

Los errores de análisis muestran que hay problemas graves en la estructura de datos:

1. **Sintaxis de constructores incorrecta**: Uso de `:` en lugar de `=` para valores por defecto
2. **Parámetros nombrados mal definidos**: Falta de llaves `{}` para parámetros nombrados
3. **Definiciones duplicadas**: Múltiples definiciones de la misma clase/función
4. **Valores no constantes**: Uso de valores no constantes como valores por defecto
5. **Estructura de archivo corrupta**: El archivo parece tener contenido duplicado o mal formateado

### Estrategia de Corrección

1. **Análisis completo del archivo**: Identificar todas las secciones problemáticas
2. **Reconstrucción limpia**: Crear una versión limpia del archivo de datos
3. **Validación de sintaxis**: Asegurar que toda la sintaxis de Dart sea correcta
4. **Pruebas de funcionalidad**: Verificar que todas las funciones trabajen correctamente

## Components and Interfaces

### 1. PopayanPlace Class

**Estado Actual**: Correctamente definida en las primeras líneas del archivo
**Acción**: Mantener la definición existente, es correcta

```dart
class PopayanPlace {
  final String id;
  final String name;
  final String category;
  final String address;
  final LatLng coordinates;
  final String description;
  final List<String> keywords;
  final String? phone;
  final String? website;
  final double rating;
  final List<String> photos;

  const PopayanPlace({
    required this.id,
    required this.name,
    required this.category,
    required this.address,
    required this.coordinates,
    required this.description,
    required this.keywords,
    this.phone,
    this.website,
    this.rating = 0.0,
    this.photos = const [],
  });
}
```

### 2. PopayanPlacesDatabase Class

**Estado Actual**: Definición correcta pero datos corruptos
**Acción**: Limpiar y reconstruir la lista de lugares

### 3. Funciones de Utilidad

**Estado Actual**: Definiciones duplicadas y errores de sintaxis
**Acción**: Mantener una sola definición limpia de cada función

## Data Models

### Estructura de Datos de Lugares

- **Lista principal**: `List<PopayanPlace> places` - debe ser estática y constante
- **Categorías**: Mantener las categorías existentes (Barrio, Centro Comercial, etc.)
- **Coordenadas**: Usar LatLng correctamente importado de latlong2
- **Ratings**: Valores double entre 0.0 y 5.0
- **Keywords**: Lista de strings para búsqueda

### Funciones de Búsqueda y Filtrado

```dart
static List<PopayanPlace> searchPlaces(String query)
static List<PopayanPlace> getPlacesByCategory(String category)
static PopayanPlace? getPlaceById(String id)
static List<PopayanPlace> getNearbyPlaces(LatLng location, double radiusKm)
static List<String> getCategories()
static List<String> getPopularSearches()
```

## Error Handling

### Tipos de Errores a Corregir

1. **Errores de Sintaxis**

   - `named_parameter_outside_group`: Parámetros nombrados sin llaves
   - `obsolete_colon_for_default_value`: Uso de `:` en lugar de `=`
   - `non_constant_default_value`: Valores por defecto no constantes
   - `missing_function_body`: Funciones sin cuerpo
   - `duplicate_definition`: Definiciones duplicadas

2. **Errores de Tipo**

   - `non_type_as_type_argument`: Uso incorrecto de tipos
   - `not_a_type`: Referencias a tipos inexistentes
   - `undefined_identifier`: Identificadores no definidos

3. **Errores de Estructura**
   - `expected_executable`: Declaraciones mal formadas
   - `unexpected_token`: Tokens inesperados
   - `extraneous_modifier`: Modificadores incorrectos

### Estrategia de Manejo

1. **Identificación**: Usar `flutter analyze` para identificar todos los errores
2. **Priorización**: Corregir errores críticos primero (sintaxis, tipos)
3. **Validación**: Verificar cada corrección individualmente
4. **Pruebas**: Ejecutar análisis después de cada grupo de correcciones

## Testing Strategy

### Fases de Prueba

1. **Análisis Estático**

   - Ejecutar `flutter analyze` después de cada corrección
   - Objetivo: 0 errores críticos

2. **Compilación**

   - Ejecutar `flutter build` para verificar compilación
   - Objetivo: Compilación exitosa

3. **Pruebas de Funcionalidad**

   - Verificar búsqueda de lugares
   - Verificar filtrado por categoría
   - Verificar navegación a detalles

4. **Pruebas de Integración**
   - Verificar que la aplicación inicie correctamente
   - Verificar que todas las páginas funcionen
   - Verificar que no haya crashes

### Criterios de Éxito

- ✅ `flutter analyze` sin errores críticos
- ✅ `flutter run` inicia la aplicación
- ✅ Búsqueda de lugares funciona
- ✅ Navegación entre páginas funciona
- ✅ No hay crashes durante uso normal

### Herramientas de Validación

- **Flutter Analyzer**: Para errores de sintaxis y tipos
- **Dart Formatter**: Para formateo consistente del código
- **Hot Reload**: Para pruebas rápidas durante desarrollo
- **Debug Console**: Para identificar errores en tiempo de ejecución
