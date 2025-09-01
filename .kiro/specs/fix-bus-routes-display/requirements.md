# Requirements Document

## Introduction

El usuario ha actualizado los datos de rutas de buses de Popayán en el archivo `popayan_bus_routes.dart` con nuevas rutas reales de SOTRACAUCA, pero estas no se muestran correctamente en la aplicación. El problema es que el código en `rutas_pagina.dart` está intentando acceder a las propiedades de la nueva clase `BusRoute` usando sintaxis de Map (`ruta['nombre']`) en lugar de usar las propiedades de la clase (`ruta.name`).

## Requirements

### Requirement 1

**User Story:** Como usuario de la aplicación, quiero ver las nuevas rutas de buses de Popayán cuando navego a la sección de rutas, para poder acceder a información actualizada y precisa del transporte público.

#### Acceptance Criteria

1. WHEN el usuario navega a la página de rutas THEN el sistema SHALL mostrar todas las rutas definidas en PopayanBusRoutes.getAllRoutes()
2. WHEN se muestran las rutas THEN el sistema SHALL mostrar correctamente el nombre de cada ruta usando ruta.name
3. WHEN se muestran las rutas THEN el sistema SHALL mostrar correctamente la empresa usando ruta.company
4. WHEN se muestran las rutas THEN el sistema SHALL mostrar correctamente los barrios usando ruta.neighborhoods
5. WHEN se muestran las rutas THEN el sistema SHALL mostrar correctamente el horario usando ruta.schedule
6. WHEN se muestran las rutas THEN el sistema SHALL mostrar correctamente la tarifa usando ruta.fare

### Requirement 2

**User Story:** Como usuario, quiero que la funcionalidad de favoritos funcione correctamente con las nuevas rutas, para poder marcar y desmarcar mis rutas preferidas.

#### Acceptance Criteria

1. WHEN el usuario hace clic en el ícono de favorito THEN el sistema SHALL agregar o quitar la ruta de favoritos correctamente
2. WHEN se agrega una ruta a favoritos THEN el sistema SHALL usar las propiedades correctas de la clase BusRoute
3. WHEN se muestra el estado de favorito THEN el sistema SHALL mostrar el ícono correcto (estrella llena o vacía)

### Requirement 3

**User Story:** Como usuario, quiero que los botones de "Ver mapa" y "Rastrear" funcionen correctamente con las nuevas rutas, para poder acceder a la funcionalidad completa de navegación.

#### Acceptance Criteria

1. WHEN el usuario hace clic en "Ver mapa" THEN el sistema SHALL navegar a MapaRutaPagina con el nombre correcto de la ruta
2. WHEN el usuario hace clic en "Ver mapa" THEN el sistema SHALL pasar las paradas correctas usando ruta.neighborhoods
3. WHEN el usuario hace clic en "Rastrear" THEN el sistema SHALL funcionar correctamente con los datos de la nueva clase BusRoute

### Requirement 4

**User Story:** Como desarrollador, quiero que el código sea compatible con la nueva estructura de datos BusRoute, para mantener la consistencia y evitar errores futuros.

#### Acceptance Criteria

1. WHEN se accede a propiedades de BusRoute THEN el sistema SHALL usar la sintaxis de propiedades de clase (ruta.property) en lugar de sintaxis de Map (ruta['key'])
2. WHEN se muestran campos que no existen en la nueva clase THEN el sistema SHALL manejar estos campos apropiadamente o usar valores por defecto
3. WHEN se compila el código THEN el sistema SHALL compilar sin errores relacionados con acceso a propiedades inexistentes
