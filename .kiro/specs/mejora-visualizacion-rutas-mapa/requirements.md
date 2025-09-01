# Documento de Requisitos - Mejora de Visualización de Rutas en Mapa

## Introducción

Este documento define los requisitos para mejorar significativamente la visualización de las rutas de transporte público en el mapa de RouWhite. El objetivo es crear una experiencia visual más profesional, realista y atractiva que represente mejor las rutas reales de transporte público, eliminando las líneas rectas poco realistas y agregando elementos visuales que mejoren la comprensión del usuario.

## Requisitos

### Requisito 1: Rutas Realistas con Trazado de Calles

**Historia de Usuario:** Como usuario de RouWhite, quiero ver las rutas de transporte siguiendo las calles reales de la ciudad, para que pueda entender mejor el recorrido real que hace el bus.

#### Criterios de Aceptación

1. CUANDO se muestre una ruta en el mapa ENTONCES la línea de la ruta DEBE seguir las calles y avenidas reales de Popayán
2. CUANDO se trace una ruta ENTONCES el sistema DEBE usar puntos de waypoints intermedios para crear curvas naturales
3. CUANDO se visualice una ruta ENTONCES NO DEBE aparecer como líneas rectas que atraviesen edificios o manzanas
4. CUANDO se cargue el mapa ENTONCES las rutas DEBEN renderizarse de forma suave y fluida

### Requisito 2: Estilo Visual Mejorado de las Rutas

**Historia de Usuario:** Como usuario, quiero que las rutas se vean más profesionales y fáciles de distinguir, para poder identificar rápidamente cada línea de transporte.

#### Criterios de Aceptación

1. CUANDO se muestre una ruta ENTONCES DEBE tener un grosor apropiado (entre 4-6 píxeles)
2. CUANDO se visualicen múltiples rutas ENTONCES cada una DEBE tener colores distintivos y contrastantes
3. CUANDO una ruta esté seleccionada ENTONCES DEBE resaltarse con un efecto visual (glow o borde)
4. CUANDO se muestre una ruta ENTONCES DEBE tener esquinas redondeadas y transiciones suaves
5. CUANDO el usuario haga zoom ENTONCES el grosor de las líneas DEBE ajustarse proporcionalmente

### Requisito 3: Sistema de Guía Visual de Paradas Numeradas

**Historia de Usuario:** Como usuario, quiero ver una guía visual clara que muestre el recorrido de cada ruta con paradas numeradas del 1 al 5 (o las que sean), para entender fácilmente la secuencia y dirección del recorrido sin líneas confusas que crucen el mapa.

#### Criterios de Aceptación

1. CUANDO se seleccione "Ver en Mapa" desde una ruta ENTONCES DEBE mostrar una guía visual con paradas numeradas secuencialmente
2. CUANDO se muestren las paradas ENTONCES DEBEN aparecer como círculos numerados (1, 2, 3, 4, 5...) con el color de la ruta
3. CUANDO se trace la guía ENTONCES DEBE conectar las paradas con una línea punteada o segmentada que siga las calles reales, NUNCA con líneas rectas directas
4. CUANDO se toque una parada numerada ENTONCES DEBE mostrar información específica (nombre de parada, tiempo estimado desde la anterior)
5. CUANDO se visualicen múltiples rutas ENTONCES cada una DEBE tener su propia numeración y color distintivo
6. CUANDO la ruta tenga más de 10 paradas ENTONCES DEBE mostrar solo las principales (inicio, intermedias clave, final) con numeración inteligente
7. CUANDO se muestre la guía visual ENTONCES NO DEBE mostrar líneas que crucen directamente de una parada a otra atravesando edificios o manzanas

### Requisito 4: Paradas de Bus Complementarias

**Historia de Usuario:** Como usuario, quiero ver información adicional de las paradas cuando sea necesario, para tener contexto completo del sistema de transporte.

#### Criterios de Aceptación

1. CUANDO se muestren todas las rutas ENTONCES DEBEN aparecer íconos de paradas generales en puntos correspondientes
2. CUANDO se toque una parada general ENTONCES DEBE mostrar qué rutas pasan por ahí
3. CUANDO se visualicen las paradas ENTONCES DEBEN tener íconos diferenciados por tipo (parada normal, terminal, intercambio)
4. CUANDO hay múltiples rutas en una parada ENTONCES DEBE indicarse visualmente con colores o números

### Requisito 5: Animaciones y Efectos Visuales

**Historia de Usuario:** Como usuario, quiero que la aplicación se sienta moderna y fluida, con animaciones que hagan la experiencia más agradable.

#### Criterios de Aceptación

1. CUANDO se seleccione "Ver en Mapa" ENTONCES la ruta DEBE aparecer con una animación de trazado progresivo
2. CUANDO se cambie entre rutas ENTONCES DEBE haber transiciones suaves entre colores y trazados
3. CUANDO se haga zoom o pan ENTONCES las rutas DEBEN mantener su calidad visual sin pixelarse
4. CUANDO se cargue el mapa ENTONCES las rutas DEBEN aparecer de forma escalonada para mejor percepción

### Requisito 6: Información Contextual en el Mapa

**Historia de Usuario:** Como usuario, quiero obtener información útil directamente desde el mapa, sin tener que navegar a otras pantallas.

#### Criterios de Aceptación

1. CUANDO se toque una ruta ENTONCES DEBE mostrar un popup con información básica (nombre, empresa, tarifa)
2. CUANDO se mantenga presionada una ruta ENTONCES DEBE mostrar el horario y frecuencia
3. CUANDO se visualice una ruta ENTONCES DEBE mostrar la dirección del recorrido con flechas sutiles
4. CUANDO hay congestión o problemas ENTONCES DEBE indicarse visualmente en la ruta

### Requisito 7: Optimización de Rendimiento

**Historia de Usuario:** Como usuario, quiero que el mapa funcione de forma fluida y rápida, sin importar cuántas rutas estén visibles.

#### Criterios de Aceptación

1. CUANDO se muestren múltiples rutas ENTONCES el mapa DEBE mantener 60 FPS de rendimiento
2. CUANDO se haga zoom out ENTONCES las rutas DEBEN simplificarse automáticamente para mejor rendimiento
3. CUANDO se carguen las rutas ENTONCES DEBE hacerse de forma asíncrona sin bloquear la UI
4. CUANDO el dispositivo tenga recursos limitados ENTONCES DEBE degradar graciosamente la calidad visual

### Requisito 8: Modo de Vista Mejorado

**Historia de Usuario:** Como usuario, quiero poder alternar entre diferentes modos de visualización según mis necesidades del momento.

#### Criterios de Aceptación

1. CUANDO esté en modo "Todas las rutas" ENTONCES DEBE mostrar todas las rutas con transparencia reducida
2. CUANDO seleccione una ruta específica ENTONCES DEBE resaltarla y atenuar las demás
3. CUANDO active "Modo nocturno" ENTONCES las rutas DEBEN adaptarse con colores apropiados
4. CUANDO esté en "Modo simplificado" ENTONCES DEBE mostrar solo las rutas principales con menos detalles
