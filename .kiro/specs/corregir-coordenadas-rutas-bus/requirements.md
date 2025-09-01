# Requirements Document

## Introduction

El usuario ha identificado que las coordenadas y trazados de las rutas de buses en el archivo `popayan_bus_routes.dart` no coinciden con las rutas reales mostradas en los mapas oficiales de transporte público de Popayán. Específicamente, se han proporcionado mapas reales que muestran:

1. **Ruta 1 - La Paz/Campanario/Pomona/Chirimía**: El trazado actual necesita ser corregido para reflejar la ruta real
2. **TP2BT - Tomas C./Chirimía/Craó/Campanario/Jardines De Paz**: Esta ruta puede no existir o tener coordenadas incorrectas

## Requirements

### Requirement 1

**User Story:** Como usuario de la aplicación de transporte, quiero que las rutas de buses mostradas en el mapa coincidan exactamente con las rutas reales que operan en Popayán, para poder planificar mis viajes de manera precisa y confiable.

#### Acceptance Criteria

1. WHEN se muestra la Ruta 1 en el mapa THEN el sistema SHALL mostrar el trazado correcto que va desde La Paz, pasa por Campanario, Pomona y termina en Chirimía
2. WHEN se visualiza el recorrido de la Ruta 1 THEN el sistema SHALL mostrar las coordenadas que coinciden con el mapa oficial proporcionado
3. WHEN se muestran las paradas de la Ruta 1 THEN el sistema SHALL incluir todas las paradas reales en el orden correcto del recorrido

### Requirement 2

**User Story:** Como usuario, quiero que la información de la ruta TP2BT (Tomas C./Chirimía/Craó/Campanario/Jardines De Paz) sea precisa y refleje la operación real del transporte público.

#### Acceptance Criteria

1. WHEN se busca la ruta TP2BT THEN el sistema SHALL mostrar la ruta con el nombre correcto y las paradas reales
2. WHEN se visualiza el trazado de TP2BT THEN el sistema SHALL mostrar las coordenadas que coinciden con el mapa oficial proporcionado
3. WHEN se muestran los barrios servidos THEN el sistema SHALL incluir: Tomas C., Chirimía, Craó, Campanario, Jardines De Paz

### Requirement 3

**User Story:** Como desarrollador del sistema, quiero que todas las coordenadas de rutas estén basadas en datos geográficos reales y verificados, para mantener la precisión y confiabilidad de la aplicación.

#### Acceptance Criteria

1. WHEN se definen coordenadas de paradas THEN el sistema SHALL usar coordenadas GPS reales de Popayán
2. WHEN se crean trazados de rutas THEN el sistema SHALL seguir las calles y avenidas reales de la ciudad
3. WHEN se actualiza información de rutas THEN el sistema SHALL mantener consistencia con los mapas oficiales de transporte público

### Requirement 4

**User Story:** Como usuario, quiero que la información de barrios y paradas sea completa y precisa para cada ruta corregida.

#### Acceptance Criteria

1. WHEN se muestran los barrios servidos por una ruta THEN el sistema SHALL mostrar todos los barrios por los que realmente pasa la ruta
2. WHEN se listan las paradas THEN el sistema SHALL incluir las coordenadas exactas de cada parada real
3. WHEN se calcula la distancia de la ruta THEN el sistema SHALL usar las coordenadas corregidas para obtener distancias precisas
4. WHEN se estima el tiempo de viaje THEN el sistema SHALL basarse en el recorrido real de la ruta
