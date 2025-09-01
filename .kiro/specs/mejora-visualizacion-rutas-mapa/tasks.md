# Plan de Implementación - Mejora de Visualización de Rutas en Mapa

- [ ] 1. Crear servicios base y estructura de datos

  - Implementar modelos de datos mejorados para rutas y paradas
  - Crear RutaGeometryService con funciones básicas de interpolación
  - Establecer estructura de archivos y dependencias necesarias
  - _Requisitos: 1.1, 1.2, 6.3_

- [ ] 2. Implementar generación de rutas realistas

  - [ ] 2.1 Crear algoritmo de interpolación Catmull-Rom para suavizado de rutas

    - Implementar función de interpolación entre puntos de control
    - Agregar parámetros configurables para tensión de curvas
    - Crear tests unitarios para validar suavizado correcto
    - _Requisitos: 1.1, 1.2_

  - [ ] 2.2 Integrar servicio de routing externo (OpenRouteService)

    - Configurar cliente HTTP para OpenRouteService API
    - Implementar función para obtener geometría de rutas reales
    - Agregar manejo de errores y fallbacks para conectividad
    - _Requisitos: 1.1, 1.3_

  - [ ] 2.3 Crear sistema de waypoints intermedios
    - Generar puntos intermedios basados en calles de Popayán
    - Implementar validación de coordenadas dentro de límites de ciudad
    - Optimizar número de waypoints según distancia y complejidad
    - _Requisitos: 1.2, 1.3_

- [ ] 3. Desarrollar sistema de estilos visuales mejorados

  - [ ] 3.1 Implementar RutaStyleService con colores distintivos

    - Crear paleta de colores accesibles y contrastantes
    - Implementar generación automática de colores por empresa
    - Agregar soporte para temas claro y oscuro
    - _Requisitos: 2.2, 7.3_

  - [ ] 3.2 Crear efectos visuales de selección y resaltado

    - Implementar efecto glow para rutas seleccionadas
    - Agregar animaciones de transición entre estados
    - Crear sistema de opacidad para rutas no seleccionadas
    - _Requisitos: 2.3, 4.2_

  - [ ] 3.3 Implementar grosor adaptativo según zoom
    - Crear función de cálculo de grosor basado en nivel de zoom
    - Implementar transiciones suaves en cambios de zoom
    - Agregar configuración de grosor mínimo y máximo
    - _Requisitos: 2.5, 6.2_

- [ ] 4. Implementar sistema de guía visual con paradas numeradas

  - [ ] 4.1 Crear GuiaVisualService para rutas específicas

    - Implementar generación de marcadores numerados (1, 2, 3, 4, 5...)
    - Crear sistema de líneas guía punteadas que conecten paradas siguiendo calles (NUNCA líneas directas)
    - Desarrollar algoritmo de optimización para mostrar paradas principales
    - _Requisitos: 3.1, 3.2, 3.3_

  - [ ] 4.2 Desarrollar componentes visuales de la guía

    - Crear widget de marcador numerado con color de ruta
    - Implementar líneas punteadas/segmentadas para conexiones que sigan rutas de calles reales
    - Agregar efectos visuales para resaltar secuencia de paradas
    - _Requisitos: 3.2, 3.5_

  - [ ] 4.3 Implementar estrategia anti-líneas directas

    - Crear validación que detecte líneas que cruzan edificios o manzanas
    - Implementar algoritmo de routing que use solo calles transitables
    - Agregar fallback seguro cuando no hay ruta disponible (mostrar solo paradas)
    - _Requisitos: 3.3, 3.7, 1.3_

  - [ ] 4.4 Implementar interacciones con paradas numeradas
    - Desarrollar detección de toque en marcadores numerados
    - Crear popups específicos con información de parada y tiempo estimado
    - Agregar navegación entre paradas de la secuencia
    - _Requisitos: 3.4, 6.1_

- [ ] 5. Crear sistema de paradas generales complementario

  - [ ] 5.1 Implementar ParadaVisualizationService para vista general

    - Crear diferentes tipos de íconos para paradas (normal, terminal, intercambio)
    - Implementar generación de marcadores con información contextual
    - Agregar sistema de clustering para paradas cercanas en zoom bajo
    - _Requisitos: 4.1, 4.3_

  - [ ] 5.2 Desarrollar interacciones con paradas generales
    - Implementar detección de toque en marcadores de paradas generales
    - Crear popups informativos con datos de parada y rutas que pasan
    - Agregar navegación a detalles de parada desde popup
    - _Requisitos: 4.2, 6.1_

- [ ] 6. Implementar sistema de animaciones

  - [ ] 6.1 Crear AnimationService para efectos fluidos

    - Implementar animación de trazado progresivo de rutas
    - Crear transiciones suaves entre selección de rutas
    - Agregar animaciones de entrada para nuevas rutas cargadas
    - _Requisitos: 4.1, 4.2, 4.4_

  - [ ] 6.2 Optimizar animaciones para rendimiento
    - Implementar control de frame rate para dispositivos lentos
    - Crear sistema de degradación automática de calidad
    - Agregar configuración de usuario para habilitar/deshabilitar animaciones
    - _Requisitos: 4.3, 6.1, 6.4_

- [ ] 7. Desarrollar sistema de información contextual

  - [ ] 7.1 Implementar popups informativos para rutas

    - Crear componente de popup con información básica de ruta
    - Implementar detección de toque en líneas de ruta
    - Agregar información de tarifa, empresa y estado en tiempo real
    - _Requisitos: 6.1, 6.2_

  - [ ] 7.2 Agregar indicadores de dirección en rutas
    - Implementar flechas direccionales sutiles en rutas
    - Crear sistema de espaciado automático de flechas
    - Agregar configuración para mostrar/ocultar indicadores
    - _Requisitos: 6.3_

- [ ] 8. Implementar optimizaciones de rendimiento

  - [ ] 8.1 Crear sistema de cache para geometrías calculadas

    - Implementar RouteCache con límites de memoria
    - Agregar persistencia local de rutas frecuentemente usadas
    - Crear sistema de invalidación automática de cache
    - _Requisitos: 7.3, 7.1_

  - [ ] 8.2 Implementar Level of Detail (LOD) dinámico
    - Crear simplificación automática de rutas según zoom
    - Implementar culling de elementos fuera del viewport
    - Agregar sistema de priorización de rutas por importancia
    - _Requisitos: 7.2, 7.4_

- [ ] 9. Desarrollar modos de visualización

  - [ ] 9.1 Implementar modo "Todas las rutas"

    - Crear vista general con todas las rutas visibles
    - Implementar transparencia reducida para evitar saturación visual
    - Agregar filtros rápidos por empresa o tipo de ruta
    - _Requisitos: 8.1_

  - [ ] 9.2 Crear modo de ruta individual seleccionada
    - Implementar resaltado de ruta específica
    - Agregar atenuación de rutas no seleccionadas
    - Crear transiciones suaves entre modos de vista
    - _Requisitos: 8.2_

- [ ] 10. Integrar mejoras en páginas existentes

  - [ ] 10.1 Actualizar PrincipalPagina con nuevo sistema de rutas

    - Reemplazar PolylineLayer simple con sistema de rutas mejorado
    - Integrar nuevos servicios en el widget principal
    - Mantener compatibilidad con funcionalidad existente
    - _Requisitos: 1.1, 2.1, 3.1_

  - [ ] 10.2 Mejorar funcionalidad "Ver en Mapa" en RutasPagina
    - Implementar navegación mejorada desde lista de rutas
    - Agregar preselección de ruta al abrir mapa con guía visual numerada
    - Crear animación de enfoque en ruta seleccionada con paradas numeradas
    - _Requisitos: 3.1, 5.1, 8.2_

- [ ] 11. Implementar tests y validación

  - [ ] 11.1 Crear tests unitarios para servicios principales

    - Escribir tests para RutaGeometryService y funciones de interpolación
    - Crear tests para GuiaVisualService y generación de paradas numeradas
    - Implementar tests de rendimiento para operaciones críticas
    - _Requisitos: 7.1, 7.3_

  - [ ] 11.2 Desarrollar tests de integración para UI
    - Crear tests de widget para componentes de mapa mejorados
    - Implementar tests de interacción para toques y gestos en paradas numeradas
    - Agregar tests de accesibilidad para lectores de pantalla
    - _Requisitos: 3.4, 6.1_

- [ ] 12. Configuración y personalización final

  - [ ] 12.1 Implementar configuraciones de usuario

    - Crear pantalla de configuración para opciones de mapa
    - Implementar persistencia de preferencias de usuario
    - Agregar opciones de accesibilidad y rendimiento
    - _Requisitos: 8.3, 8.4, 7.4_

  - [ ] 12.2 Optimizar para diferentes dispositivos
    - Ajustar configuraciones por defecto según capacidad del dispositivo
    - Implementar detección automática de rendimiento
    - Crear perfiles de configuración para gama alta/baja
    - _Requisitos: 7.4, 5.2_
