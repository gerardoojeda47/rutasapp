# 🗺️ Funcionalidad de Mapa para Rutas de Bus

## 📱 Descripción

Se ha implementado una funcionalidad completa de mapa para la aplicación de rutas de bus de Popayán. Ahora cuando los usuarios presionen el botón **"Rastrear"** en cualquier ruta, se abrirá una página de mapa interactiva que muestra:

- 📍 **Ubicación actual del usuario** (con permisos de GPS)
- 🚌 **Ruta completa** con todas las paradas marcadas
- 🎯 **Marcadores numerados** para cada parada
- 🛣️ **Línea de ruta** que conecta todas las paradas
- 📍 **Información detallada** de cada parada al tocarla

## 🚀 Características Implementadas

### 1. **Mapa Interactivo**
- Mapa base de OpenStreetMap
- Zoom y navegación táctil
- Centrado automático en la ruta completa

### 2. **Ubicación del Usuario**
- Detección automática de ubicación GPS
- Marcador azul con icono de persona
- Botón para centrar en ubicación actual

### 3. **Marcadores de Paradas**
- Numeración secuencial (1, 2, 3...)
- Color naranja (#FF6A00) consistente con la app
- Información detallada al tocar cada marcador

### 4. **Visualización de Ruta**
- Línea naranja que conecta todas las paradas
- Vista automática que muestra toda la ruta
- Botón flotante para ajustar vista de ruta

### 5. **Información de Paradas**
- Modal inferior con detalles de cada parada
- Coordenadas GPS precisas
- Botón para centrar mapa en la parada seleccionada

## 🔧 Dependencias Utilizadas

```yaml
dependencies:
  flutter_map: ^6.0.0          # Mapa interactivo
  latlong2: ^0.9.0             # Coordenadas geográficas
  geolocator: ^11.0.0          # Ubicación GPS
```

## 📍 Coordenadas de Paradas

Se han configurado coordenadas simuladas para las principales paradas de Popayán:

- **Centro**: 2.4389, -76.6064
- **La Paz**: 2.4450, -76.6100
- **Jose María Obando**: 2.4400, -76.6000
- **San Camilo**: 2.4350, -76.6050
- **Terminal**: 2.4300, -76.5900
- **Bello Horizonte**: 2.4650, -76.6300
- Y muchas más...

## 🎯 Cómo Usar

### Para Usuarios:
1. **Seleccionar una ruta** en la página principal
2. **Presionar "Rastrear"** (botón azul)
3. **Ver el mapa** con la ruta completa
4. **Tocar marcadores** para ver información de paradas
5. **Usar botones** para navegar por el mapa

### Para Desarrolladores:
1. **Importar dependencias** en `pubspec.yaml`
2. **Configurar permisos** de ubicación en Android/iOS
3. **Usar `MapaRutaPagina`** pasando nombre de ruta y paradas
4. **Personalizar coordenadas** según necesidades reales

## 📱 Permisos Requeridos

### Android (`android/app/src/main/AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

### iOS (`ios/Runner/Info.plist`):
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Esta app necesita acceso a ubicación para mostrar rutas de bus</string>
```

## 🎨 Personalización

### Colores:
- **Color principal**: #FF6A00 (naranja de la app)
- **Marcador usuario**: Azul
- **Marcadores paradas**: Naranja
- **Línea de ruta**: Naranja con transparencia

### Estilos:
- **Bordes redondeados**: 16px
- **Sombras sutiles**: Para profundidad visual
- **Iconos descriptivos**: Para cada funcionalidad

## 🔄 Flujo de Navegación

```
Página Principal → Seleccionar Ruta → Botón "Rastrear" → MapaRutaPagina
                                                      ↓
                                              Mapa con ruta completa
                                                      ↓
                                              Interacción con marcadores
                                                      ↓
                                              Información detallada
```

## 🚧 Próximas Mejoras

- [ ] **Rutas en tiempo real** con API de buses
- [ ] **Estimación de llegada** a paradas
- [ ] **Notificaciones** de proximidad a paradas
- [ ] **Historial** de rutas utilizadas
- [ ] **Favoritos** con ubicación guardada

## 📞 Soporte

Para cualquier pregunta o problema con la funcionalidad del mapa, revisar:
1. **Permisos de ubicación** en el dispositivo
2. **Conexión a internet** para cargar el mapa
3. **Versiones de dependencias** en `pubspec.yaml`
4. **Configuración de coordenadas** en el código

---

*Desarrollado para la aplicación de rutas de bus de Popayán* 🚌🗺️
