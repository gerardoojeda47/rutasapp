# Requirements Document

## Introduction

El usuario quiere mejorar la funcionalidad "Ver mapa" para que muestre las paradas con líneas bonitas para cada una de las 9 rutas de SOTRACAUCA. Actualmente el mapa usa coordenadas hardcodeadas que no coinciden con las coordenadas reales de las rutas definidas en `BusRoute.stops`, y tiene algunos métodos deprecados.

## Requirements

### Requirement 1

**User Story:** Como usuario, quiero ver las paradas reales de cada ruta de SOTRACAUCA en el mapa con rutas que sigan las calles y carreras reales, para tener una representación precisa de cómo se mueven los buses por la ciudad.

#### Acceptance Criteria

1. WHEN el usuario hace clic en "Ver mapa" de cualquier ruta THEN el sistema SHALL mostrar las coordenadas reales de `BusRoute.stops`
2. WHEN se muestran las paradas THEN el sistema SHALL usar las coordenadas LatLng definidas en cada ruta de SOTRACAUCA
3. WHEN se carga el mapa THEN el sistema SHALL mostrar todas las paradas de la ruta seleccionada con marcadores numerados
4. WHEN se dibuja la ruta THEN el sistema SHALL crear una línea que siga las calles, carreras y avenidas reales de Popayán entre paradas
5. WHEN se conectan las paradas THEN el sistema SHALL evitar líneas rectas que atraviesen edificios o áreas no transitables

### Requirement 2

**User Story:** Como usuario, quiero ver líneas de ruta diferenciadas por colores que sigan las vías reales de Popayán, para poder distinguir visualmente entre diferentes rutas y entender el recorrido real.

#### Acceptance Criteria

1. WHEN se muestra una ruta en el mapa THEN el sistema SHALL usar el color específico definido en `BusRoute.color`
2. WHEN se dibuja la línea de ruta THEN el sistema SHALL seguir las calles principales como Carrera 5, Carrera 6, Carrera 9, Calle 5, etc.
3. WHEN se muestran marcadores de paradas THEN el sistema SHALL usar colores consistentes con el color de la ruta
4. WHEN la ruta pasa por el centro THEN el sistema SHALL seguir las vías del centro histórico de Popayán
5. WHEN la ruta va hacia barrios THEN el sistema SHALL seguir las avenidas y calles principales que conectan con esos sectores

### Requirement 3

**User Story:** Como usuario, quiero información detallada de cada parada cuando hago clic en ella, para conocer más sobre la ubicación y servicios disponibles.

#### Acceptance Criteria

1. WHEN el usuario hace clic en un marcador de parada THEN el sistema SHALL mostrar información detallada de la parada
2. WHEN se muestra información de parada THEN el sistema SHALL incluir el nombre del barrio/zona
3. WHEN se muestra información de parada THEN el sistema SHALL mostrar el número de parada en la secuencia
4. WHEN se muestra información de parada THEN el sistema SHALL permitir centrar el mapa en esa ubicación

### Requirement 4

**User Story:** Como desarrollador, quiero que el código use las APIs más recientes de Flutter Map, para evitar warnings de deprecación y mejorar el rendimiento.

#### Acceptance Criteria

1. WHEN se compila el código THEN el sistema SHALL no mostrar warnings de métodos deprecados
2. WHEN se usa transparencia en colores THEN el sistema SHALL usar `withValues(alpha:)` en lugar de `withOpacity()`
3. WHEN se ajusta la vista del mapa THEN el sistema SHALL usar `fitCamera` en lugar de `fitBounds`
4. WHEN se inicializa el mapa THEN el sistema SHALL usar las APIs más recientes de flutter_map

### Requirement 5

**User Story:** Como usuario, quiero que el mapa se ajuste automáticamente para mostrar toda la ruta, para tener una vista completa del recorrido sin tener que hacer zoom manual.

#### Acceptance Criteria

1. WHEN se carga el mapa de una ruta THEN el sistema SHALL ajustar automáticamente el zoom para mostrar todas las paradas
2. WHEN se ajusta la vista THEN el sistema SHALL incluir un margen apropiado alrededor de la ruta
3. WHEN la ruta tiene muchas paradas THEN el sistema SHALL encontrar el nivel de zoom óptimo
4. WHEN la ruta es muy larga THEN el sistema SHALL priorizar mostrar toda la ruta sobre el detalle individual
