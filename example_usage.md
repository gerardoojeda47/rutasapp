# 🎨 Ejemplos de Uso - Integración HTML en ROUWHITE

## 🚀 Cómo usar los componentes HTML

### 1. **Banner Animado**

```dart
// Uso básico
HtmlBannerWidget(
  title: 'POPAYÁN',
  subtitle: 'Tu ciudad conectada',
)

// Con colores personalizados
HtmlBannerWidget(
  title: 'BIENVENIDO',
  subtitle: 'Transporte inteligente',
  primaryColor: Color(0xFF667eea),
  secondaryColor: Color(0xFF764ba2),
)
```

### 2. **Estadísticas en Tiempo Real**

```dart
HtmlStatsWidget(
  activeBuses: 45,        // Buses activos
  totalRoutes: 12,        // Rutas disponibles
  busStops: 89,          // Paradas de bus
  cityName: 'Popayán',   // Nombre de la ciudad
)
```

### 3. **Clima y Tráfico**

```dart
HtmlWeatherTrafficWidget(
  temperature: '24',                    // Temperatura actual
  weatherCondition: 'Parcialmente nublado', // Condición del clima
  trafficStatus: 'Fluido',             // Estado del tráfico
  trafficLevel: 2,                     // Nivel 1-5 (1=fluido, 5=congestionado)
)
```

### 4. **Noticias del Transporte**

```dart
HtmlNewsWidget(
  newsItems: [
    NewsItem(
      icon: '🚌',
      title: 'Nueva ruta disponible',
      description: 'Ruta Centro - Universidad del Cauca ahora activa',
      timeAgo: 'Hace 5 min',
    ),
    NewsItem(
      icon: '⚠️',
      title: 'Desvío temporal',
      description: 'Calle 5 cerrada por obras hasta las 6 PM',
      timeAgo: 'Hace 15 min',
    ),
    // Más noticias...
  ],
)
```

## 🎯 Integración Completa

### Página Principal Mejorada

```dart
class MiPaginaPrincipal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // Banner de bienvenida
            HtmlBannerWidget(
              title: 'POPAYÁN',
              subtitle: 'Transporte inteligente',
            ),

            SizedBox(height: 20),

            // Información del clima y tráfico
            HtmlWeatherTrafficWidget(
              temperature: '26',
              weatherCondition: 'Soleado',
              trafficStatus: 'Moderado',
              trafficLevel: 3,
            ),

            SizedBox(height: 20),

            // Estadísticas
            HtmlStatsWidget(
              activeBuses: 52,
              totalRoutes: 15,
              busStops: 94,
              cityName: 'Popayán',
            ),

            SizedBox(height: 20),

            // Noticias
            HtmlNewsWidget(
              newsItems: _obtenerNoticias(),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 🛠️ Configuración Inicial

### 1. Agregar dependencia

```yaml
# pubspec.yaml
dependencies:
  webview_flutter: ^4.10.0
```

### 2. Instalar dependencias

```bash
flutter pub get
```

### 3. Importar widgets

```dart
import 'package:tu_app/view/widgets/html_banner_widget.dart';
import 'package:tu_app/view/widgets/html_stats_widget.dart';
import 'package:tu_app/view/widgets/html_weather_traffic_widget.dart';
import 'package:tu_app/view/widgets/html_news_widget.dart';
```

## 🎨 Personalización Avanzada

### Colores Dinámicos

```dart
// Cambiar colores según la hora del día
Color _getPrimaryColor() {
  final hour = DateTime.now().hour;
  if (hour >= 6 && hour < 12) {
    return Color(0xFFFFB366); // Mañana - Naranja claro
  } else if (hour >= 12 && hour < 18) {
    return Color(0xFFFF6A00); // Tarde - Naranja
  } else {
    return Color(0xFF667eea); // Noche - Azul
  }
}
```

### Datos Dinámicos

```dart
// Obtener estadísticas reales
Future<Map<String, int>> _obtenerEstadisticas() async {
  // Llamada a API o base de datos
  return {
    'buses': await _contarBusesActivos(),
    'rutas': await _contarRutas(),
    'paradas': await _contarParadas(),
  };
}

// Usar en el widget
FutureBuilder<Map<String, int>>(
  future: _obtenerEstadisticas(),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return HtmlStatsWidget(
        activeBuses: snapshot.data!['buses']!,
        totalRoutes: snapshot.data!['rutas']!,
        busStops: snapshot.data!['paradas']!,
        cityName: 'Popayán',
      );
    }
    return CircularProgressIndicator();
  },
)
```

## 📱 Responsive Design

### Adaptación a diferentes tamaños

```dart
Widget _buildResponsiveLayout(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;

  if (screenWidth > 768) {
    // Tablet/Desktop - Layout horizontal
    return Row(
      children: [
        Expanded(child: HtmlBannerWidget(...)),
        SizedBox(width: 20),
        Expanded(child: HtmlStatsWidget(...)),
      ],
    );
  } else {
    // Mobile - Layout vertical
    return Column(
      children: [
        HtmlBannerWidget(...),
        SizedBox(height: 20),
        HtmlStatsWidget(...),
      ],
    );
  }
}
```

## 🔄 Actualización en Tiempo Real

### Stream de datos

```dart
class RealTimeHomepage extends StatefulWidget {
  @override
  _RealTimeHomepageState createState() => _RealTimeHomepageState();
}

class _RealTimeHomepageState extends State<RealTimeHomepage> {
  late Stream<TransportData> _dataStream;

  @override
  void initState() {
    super.initState();
    // Stream que se actualiza cada 30 segundos
    _dataStream = Stream.periodic(
      Duration(seconds: 30),
      (_) => _obtenerDatosTransporte(),
    ).asyncMap((future) => future);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TransportData>(
      stream: _dataStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HtmlStatsWidget(
            activeBuses: snapshot.data!.activeBuses,
            totalRoutes: snapshot.data!.totalRoutes,
            busStops: snapshot.data!.busStops,
            cityName: 'Popayán',
          );
        }
        return _buildLoadingWidget();
      },
    );
  }
}
```

## 🎉 Resultado Final

Con estos componentes HTML integrados, tu página de inicio tendrá:

✅ **Diseño moderno** con animaciones CSS suaves  
✅ **Información en tiempo real** visualmente atractiva  
✅ **Componentes reutilizables** fáciles de personalizar  
✅ **Performance optimizada** con WebView nativo  
✅ **Responsive design** que se adapta a cualquier pantalla

¡Tu app ROUWHITE ahora tiene una interfaz mucho más atractiva y profesional! 🚀
