# Documento de Requerimientos

## Introducción

Esta funcionalidad mejorará la experiencia visual del mapa en RouWhite agregando iconos informativos a lo largo de las líneas de rutas de transporte. Los usuarios podrán ver de manera más clara y atractiva las rutas disponibles, con iconos que indiquen información relevante como dirección del bus, paradas importantes, y estado del servicio.

## Requerimientos

### Requerimiento 1

**Historia de Usuario:** Como usuario de RouWhite, quiero ver iconos informativos a lo largo de las líneas de rutas en el mapa, para poder entender mejor la dirección y características de cada ruta de transporte.

#### Criterios de Aceptación

1. CUANDO el usuario visualice el mapa ENTONCES el sistema DEBERÁ mostrar iconos de buses a lo largo de las líneas de rutas
2. CUANDO una ruta esté activa ENTONCES el sistema DEBERÁ mostrar iconos de buses en movimiento con animación sutil
3. CUANDO el usuario haga zoom en el mapa ENTONCES el sistema DEBERÁ ajustar la densidad y tamaño de los iconos apropiadamente
4. CUANDO una ruta tenga múltiples buses ENTONCES el sistema DEBERÁ mostrar múltiples iconos distribuidos a lo largo de la línea

### Requerimiento 2

**Historia de Usuario:** Como usuario, quiero ver iconos diferenciados por tipo de información en las rutas, para poder identificar rápidamente paradas importantes, direcciones y servicios disponibles.

#### Criterios de Aceptación

1. CUANDO una ruta pase por una parada importante ENTONCES el sistema DEBERÁ mostrar un icono distintivo en esa ubicación
2. CUANDO una ruta tenga dirección específica ENTONCES el sistema DEBERÁ mostrar flechas direccionales a lo largo de la línea
3. CUANDO una ruta ofrezca servicios especiales ENTONCES el sistema DEBERÁ mostrar iconos específicos (WiFi, aire acondicionado, accesibilidad)
4. CUANDO el usuario toque un icono ENTONCES el sistema DEBERÁ mostrar información detallada en un popup

### Requerimiento 3

**Historia de Usuario:** Como usuario, quiero que los iconos en las rutas sean visualmente atractivos y no interfieran con la legibilidad del mapa, para tener una experiencia de usuario óptima.

#### Criterios de Aceptación

1. CUANDO se muestren múltiples iconos ENTONCES el sistema DEBERÁ evitar la superposición visual
2. CUANDO el mapa esté en modo nocturno ENTONCES el sistema DEBERÁ ajustar los colores de los iconos apropiadamente
3. CUANDO haya muchas rutas visibles ENTONCES el sistema DEBERÁ priorizar la claridad sobre la cantidad de iconos
4. CUANDO el usuario interactúe con el mapa ENTONCES los iconos DEBERÁN responder de manera fluida sin lag

### Requerimiento 4

**Historia de Usuario:** Como usuario, quiero poder personalizar qué tipos de iconos ver en las rutas, para adaptar la visualización a mis necesidades específicas.

#### Criterios de Aceptación

1. CUANDO el usuario acceda a configuración de mapa ENTONCES el sistema DEBERÁ permitir activar/desactivar diferentes tipos de iconos
2. CUANDO el usuario desactive un tipo de icono ENTONCES el sistema DEBERÁ ocultarlo inmediatamente del mapa
3. CUANDO el usuario seleccione una ruta específica ENTONCES el sistema DEBERÁ mostrar solo los iconos de esa ruta
4. CUANDO el usuario guarde sus preferencias ENTONCES el sistema DEBERÁ recordarlas para futuras sesiones
