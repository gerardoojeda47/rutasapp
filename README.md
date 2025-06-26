# RouWhite - Aplicación de Rutas de Transporte Público

## 📱 Descripción

RouWhite es una aplicación móvil desarrollada en Flutter que proporciona información en tiempo real sobre las rutas de transporte público de Popayán, Colombia. La aplicación permite a los usuarios buscar rutas, rastrear buses, consultar paradas y gestionar su perfil de usuario.

## ✨ Características Principales

### 🏠 Página de Inicio
- **Historial de rutas**: Muestra las rutas utilizadas recientemente
- **Sección de turismo**: Información sobre lugares turísticos de Popayán
- **Búsqueda rápida**: Acceso directo a la búsqueda de rutas
- **Diseño moderno**: Interfaz atractiva con colores corporativos

### 🚌 Gestión de Rutas
- **Lista completa de rutas**: Todas las rutas disponibles en Popayán
- **Información detallada**: Horarios, costos, paradas y estado del tráfico
- **Sistema de favoritos**: Marcar rutas como favoritas
- **Rastreo de buses**: Seguimiento en tiempo real de buses específicos
- **Mapas de referencia**: Visualización de rutas en mapas

### 🔍 Búsqueda de Rutas
- **Búsqueda por origen y destino**: Encontrar la mejor ruta
- **Filtros avanzados**: Por tiempo, preferencias y transbordos
- **Información de ocupación**: Nivel de ocupación de los buses
- **Tiempos estimados**: Duración y tiempo de llegada

### 🚏 Gestión de Paradas
- **Organización por comunas**: Paradas organizadas por zonas
- **Búsqueda de barrios**: Encontrar paradas específicas
- **Información de rutas por parada**: Rutas que pasan por cada parada
- **Detalles completos**: Horarios, frecuencias y servicios

### 👤 Perfil de Usuario
- **Información personal**: Datos del usuario editables
- **Tarjeta de transporte**: Gestión de saldo y recargas
- **Rutas favoritas**: Acceso rápido a rutas preferidas
- **Historial de viajes**: Registro de viajes realizados
- **Configuraciones**: Notificaciones, idioma y tema

### 📍 Rastreo de Buses
- **Ubicación en tiempo real**: Seguimiento de buses específicos
- **Información del bus**: Velocidad, ocupación y temperatura
- **Próximas paradas**: Lista de paradas próximas
- **Detalles del conductor**: Información del servicio

## 🛠 Tecnologías Utilizadas

- **Flutter**: Framework de desarrollo móvil
- **Dart**: Lenguaje de programación
- **Material Design**: Sistema de diseño
- **Google Maps Flutter**: Integración de mapas
- **Provider**: Gestión de estado
- **Geolocator**: Servicios de ubicación

## 📦 Instalación

### Prerrequisitos
- Flutter SDK (versión 3.2.3 o superior)
- Dart SDK
- Android Studio / VS Code
- Dispositivo Android/iOS o emulador

### Pasos de instalación

1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/tu-usuario/rutasapp.git
   cd rutasapp
   ```

2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Ejecutar la aplicación**
   ```bash
   flutter run
   ```

## 🏗 Estructura del Proyecto

```
lib/
├── main.dart                 # Punto de entrada de la aplicación
└── view/                     # Páginas de la aplicación
    ├── HomePage.dart         # Página principal
    ├── RoutesPage.dart       # Gestión de rutas
    ├── RouteSearchPage.dart  # Búsqueda de rutas
    ├── StopsPage.dart        # Gestión de paradas
    ├── BusTrackingPage.dart  # Rastreo de buses
    └── ProfilePage.dart      # Perfil de usuario
```

## 🎨 Diseño y UI/UX

### Paleta de Colores
- **Color principal**: `#FF6A00` (Naranja)
- **Color secundario**: `#FF8C00` (Naranjo claro)
- **Colores de estado**:
  - Verde: Tráfico fluido
  - Naranja: Tráfico moderado
  - Rojo: Tráfico congestionado

### Características de Diseño
- **Material Design 3**: Diseño moderno y consistente
- **Responsive**: Adaptable a diferentes tamaños de pantalla
- **Accesible**: Cumple con estándares de accesibilidad
- **Intuitivo**: Navegación fácil y clara

## 📱 Funcionalidades por Página

### HomePage
- Dashboard principal con información resumida
- Acceso rápido a funcionalidades principales
- Sección de turismo con información local
- Búsqueda integrada

### RoutesPage
- Lista completa de rutas con información detallada
- Sistema de favoritos
- Visualización de mapas
- Rastreo de buses en tiempo real

### RouteSearchPage
- Búsqueda por origen y destino
- Filtros de tiempo y preferencias
- Información de ocupación
- Selección de rutas

### StopsPage
- Organización por comunas
- Búsqueda de barrios
- Información de rutas por parada
- Detalles de servicios

### BusTrackingPage
- Seguimiento en tiempo real
- Información del bus
- Próximas paradas
- Detalles del servicio

### ProfilePage
- Gestión de información personal
- Tarjeta de transporte
- Configuraciones de usuario
- Historial de viajes

## 🔧 Configuración

### Variables de Entorno
La aplicación utiliza las siguientes configuraciones:

```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  google_maps_flutter: ^2.5.3
  flutter_polyline_points: ^2.0.0
  geolocator: ^11.0.0
  flutter_animate: ^4.5.0
  latlong2: ^0.9.0
  provider: ^6.1.1
```

### Permisos Requeridos

#### Android (android/app/src/main/AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
```

#### iOS (ios/Runner/Info.plist)
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Esta aplicación necesita acceso a la ubicación para mostrar rutas cercanas.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>Esta aplicación necesita acceso a la ubicación para el rastreo de buses.</string>
```

## 🚀 Despliegue

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

## 👥 Autores

- **Tu Nombre** - *Desarrollo inicial* - [TuUsuario](https://github.com/TuUsuario)

## 🙏 Agradecimientos

- Equipo de desarrollo Flutter
- Comunidad de Popayán
- Usuarios beta de la aplicación

## 📞 Contacto

- **Email**: tu-email@ejemplo.com
- **GitHub**: [@TuUsuario](https://github.com/TuUsuario)
- **LinkedIn**: [Tu Perfil](https://linkedin.com/in/tu-perfil)

## 🔄 Versiones

### v1.0.0
- Funcionalidades básicas implementadas
- Interfaz de usuario completa
- Sistema de navegación funcional
- Gestión de rutas y paradas

### Próximas Versiones
- Integración con APIs reales
- Notificaciones push
- Modo offline
- Integración con pagos digitales
- Análisis de datos de uso

---

**RouWhite** - Haciendo el transporte público más accesible en Popayán 🚌✨
