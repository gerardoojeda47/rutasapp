# Design Document

## Overview

La aplicación RouWhite tiene más de 100 errores críticos de compilación que se originan principalmente en el archivo `lib/view/paradas_pagina.dart` que contiene código corrupto y sintaxis mezclada. Los errores incluyen variables no definidas, definiciones duplicadas, sintaxis incorrecta, y problemas estructurales graves. También hay problemas menores en otros archivos como imports relativos, métodos deprecados, y uso de print. El diseño se enfoca en corregir sistemáticamente estos problemas manteniendo la funcionalidad existente.

## Architecture

### Problemas Principales Identificados

Los errores de análisis muestran que hay problemas graves en múltiples archivos:

1. **Código corrupto en paradas_pagina.dart**: Sintaxis mezclada, líneas 1326-1348 con código malformado
2. **Variables no definidas**: \_fadeAnimation, \_isLoading, \_mapController, \_pulseAnimation no están declaradas
3. **Definiciones duplicadas**: Múltiples definiciones de \_buildLeyendaItem, ParadaInfo, TipoParada
4. **Sintaxis incorrecta**: Métodos const mal definidos, parámetros incorrectos, tokens inesperados
5. **Variables final no inicializadas**: Campos marcados como final sin inicialización
6. **Imports relativos**: Uso de imports relativos en lugar de imports de paquete
7. **Métodos deprecados**: Uso de groupValue y onChanged en Radio widgets
8. **Print en producción**: Uso extensivo de print() en lugar de logging apropiado

### Estrategia de Corrección

1. **Análisis y backup**: Identificar secciones problemáticas y crear respaldos
2. **Limpieza de código corrupto**: Remover código malformado en paradas_pagina.dart
3. **Definición de variables faltantes**: Declarar todas las variables no definidas
4. **Eliminación de duplicados**: Remover definiciones duplicadas manteniendo las correctas
5. **Corrección de sintaxis**: Arreglar todos los errores de sintaxis de Dart
6. **Actualización de imports**: Cambiar imports relativos por imports de paquete
7. **Actualización de métodos deprecados**: Reemplazar métodos obsoletos
8. **Limpieza de warnings**: Remover prints y aplicar mejores prácticas

## Components and Interfaces

### 1. ParadasPagina Class (lib/view/paradas_pagina.dart)

**Estado Actual**: Código corrupto con sintaxis mezclada y variables no definidas
**Acción**: Limpiar código corrupto y definir variables faltantes

**Variables faltantes a definir**:

```dart
late AnimationController _fadeAnimation;
late AnimationController _pulseAnimation;
MapController? _mapController;
bool _isLoading = false;
bool _showSatellite = false;
```

**Métodos duplicados a limpiar**:

- \_buildLeyendaItem (múltiples definiciones incorrectas)
- Definiciones corruptas en líneas 1326-1348

### 2. ParadaInfo Class

**Estado Actual**: Definición duplicada
**Acción**: Mantener una sola definición correcta

### 3. TipoParada Enum

**Estado Actual**: Definición duplicada
**Acción**: Mantener una sola definición correcta

### 4. Archivos con Imports Relativos

**Archivos afectados**:

- example/intelligent_prediction_example.dart
- test/core/services/bus_companies_test.dart
- test/core/services/smart_route_assistant_test.dart
- test/data/popayan_neighborhoods_data_test.dart
- test/data/popayan_places_integration_test.dart
- test/view/company_colors_test.dart
- test/view/smart_search_neighborhoods_test.dart

**Acción**: Cambiar imports relativos por imports de paquete

## Data Models

### Estructura de Estado en ParadasPagina

**Variables de animación**:

```dart
late AnimationController _fadeAnimation;
late AnimationController _pulseAnimation;
```

**Variables de control de mapa**:

```dart
MapController? _mapController;
bool _showSatellite = false;
```

**Variables de estado**:

```dart
bool _isLoading = false;
```

### Clases de Datos

**ParadaInfo** (una sola definición):

```dart
class ParadaInfo {
  final String id;
  final String nombre;
  final LatLng coordenadas;
  final TipoParada tipo;
  // otros campos necesarios
}
```

**TipoParada** (una sola definición):

```dart
enum TipoParada {
  principal,
  secundaria,
  temporal
}
```

## Error Handling

### Tipos de Errores a Corregir

1. **Errores Críticos en paradas_pagina.dart**

   - `assignment_to_final`: Asignación a variable final
   - `expected_token`: Tokens faltantes (punto y coma)
   - `missing_const_final_var_or_type`: Variables sin declaración de tipo
   - `expected_class_member`: Código fuera de contexto de clase
   - `final_not_initialized_constructor`: Variables final sin inicializar
   - `missing_method_parameters`: Métodos sin parámetros
   - `invalid_constructor_name`: Nombres de constructor incorrectos
   - `undefined_identifier`: Variables no definidas
   - `duplicate_definition`: Definiciones duplicadas

2. **Errores de Imports**

   - `avoid_relative_lib_imports`: Imports relativos en lugar de paquete

3. **Errores de Métodos Deprecados**

   - `deprecated_member_use`: groupValue y onChanged en Radio
   - `deprecated_member_use`: activeColor en Switch

4. **Warnings de Calidad**
   - `avoid_print`: Uso de print en producción
   - `prefer_const_declarations`: Variables que pueden ser const
   - `unused_element`: Elementos no utilizados

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
