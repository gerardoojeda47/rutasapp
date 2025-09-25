# Sistema de Predicción Inteligente de Buses - Popayán

## 🚌 Descripción General

El Sistema de Predicción Inteligente es una solución avanzada que utiliza algoritmos inteligentes para predecir con mayor precisión los tiempos de llegada de buses en Popayán. Va más allá de las estimaciones básicas al considerar múltiples factores como patrones históricos, condiciones de tráfico, confiabilidad de empresas, clima y ocupación de buses.

## 🎯 Características Principales

### ✨ Predicción Inteligente

- **Patrones Históricos**: Utiliza datos simulados basados en patrones reales de cada empresa de buses
- **Análisis por Hora**: Ajusta predicciones según hora pico, horario normal, noche y fines de semana
- **Factor Empresa**: Considera la confiabilidad histórica de cada empresa (SOTRACAUCA, TRANSPUBENZA, TRANSLIBERTAD, TRANSTAMBO)

### 🚦 Análisis de Tráfico

- **Detección de Zonas**: Identifica automáticamente zonas de alto tráfico (centro, campanario, terminal)
- **Hora Pico**: Ajusta predicciones durante horas de mayor congestión (7-9 AM, 5-7 PM)
- **Fines de Semana**: Considera patrones diferentes para sábados y domingos

### 🌧️ Factores Climáticos

- **Época de Lluvias**: Agrega delays adicionales durante abril-mayo y octubre-noviembre
- **Horario de Lluvia**: Mayor probabilidad de retrasos entre 2-6 PM durante época lluviosa

### 👥 Análisis de Ocupación

- **Estimación Inteligente**: Calcula ocupación basada en hora, día y popularidad de ruta
- **Impacto en Tiempos**: Buses más llenos tardan más tiempo en paradas

## 🏗️ Arquitectura del Sistema

### Servicios Principales

#### 1. `IntelligentPredictionService`

Núcleo del sistema de predicción inteligente.

```dart
// Predecir tiempo de llegada
final arrivalTime = IntelligentPredictionService.predictBusArrival(route, userLocation);

// Calcular métricas completas
final metrics = IntelligentPredictionService.calculateRouteMetrics(route, location, DateTime.now());
```

**Métricas Calculadas:**

- Velocidad promedio (km/h)
- Confiabilidad (0.0 - 1.0)
- Nivel de ocupación (0.0 - 1.0)
- Nivel de tráfico (low, medium, high, veryHigh)
- Delay climático (minutos)
- Distancia a parada más cercana (metros)

#### 2. `BusTrackingService`

Servicio mejorado que integra predicciones inteligentes.

```dart
// Obtener llegadas con predicciones inteligentes
final arrivals = BusTrackingService.getBusArrivals(location);

// Información de tráfico inteligente
final traffic = BusTrackingService.getTrafficInfo(location);
```

#### 3. `BusPredictionIntegration`

Servicio de alto nivel que combina todas las funcionalidades.

```dart
// Predicciones completas para una ubicación
final predictions = await BusPredictionIntegration.getPredictionsForLocation(location);

// Recomendaciones de rutas
final recommendations = BusPredictionIntegration.getRouteRecommendations(origin, destination);
```

## 📊 Modelos de Datos

### `RouteMetrics`

```dart
class RouteMetrics {
  final double averageSpeed;      // Velocidad promedio en km/h
  final double reliability;       // Confiabilidad 0.0-1.0
  final double crowdLevel;        // Nivel de ocupación 0.0-1.0
  final TrafficLevel trafficLevel; // Nivel de tráfico
  final int weatherDelay;         // Delay climático en minutos
  final double distanceToStop;    // Distancia a parada en metros
}
```

### `DetailedPrediction`

```dart
class DetailedPrediction {
  final BusArrivalInfo arrival;   // Información básica de llegada
  final RouteMetrics metrics;     // Métricas calculadas
  final BusRoute route;          // Información de la ruta
  final double confidence;        // Confianza de la predicción 0.0-1.0
  final int alternativeTime;      // Tiempo alternativo (rango)
}
```

### `RouteRecommendation`

```dart
class RouteRecommendation {
  final BusRoute route;          // Ruta recomendada
  final double score;            // Score 0-100
  final int totalTimeMinutes;    // Tiempo total del viaje
  final int waitTimeMinutes;     // Tiempo de espera
  final int travelTimeMinutes;   // Tiempo de viaje
  final String recommendation;   // Texto de recomendación
}
```

## 🎯 Algoritmos de Predicción

### 1. Predicción Base

```dart
// Obtener patrón histórico según empresa y hora
final basePattern = _getHistoricalPattern(route.company, now);
final baseTime = basePattern[random.nextInt(basePattern.length)];
```

### 2. Factores de Ajuste

```dart
double adjustedTime = baseTime.toDouble();

// Factor de distancia a la parada
adjustedTime += _calculateDistanceDelay(metrics.distanceToStop);

// Factor de tráfico
adjustedTime += _calculateTrafficDelay(metrics.trafficLevel);

// Factor de confiabilidad de la empresa
adjustedTime += _calculateReliabilityAdjustment(metrics.reliability);

// Factor de clima
adjustedTime += metrics.weatherDelay;

// Factor de ocupación
adjustedTime += _calculateCrowdDelay(metrics.crowdLevel);
```

### 3. Cálculo de Confianza

```dart
double confidence = 0.8; // Base 80%

// Ajustar por confiabilidad de empresa
confidence += (metrics.reliability - 0.8) * 0.5;

// Reducir por tráfico alto
switch (metrics.trafficLevel) {
  case TrafficLevel.high: confidence -= 0.1; break;
  case TrafficLevel.veryHigh: confidence -= 0.2; break;
}

// Reducir por clima
if (metrics.weatherDelay > 0) confidence -= 0.1;
```

## 📈 Patrones Históricos por Empresa

### SOTRACAUCA (Confiabilidad: 88%)

- **Hora Pico Matutina**: 8-25 minutos
- **Horario Normal**: 10-30 minutos
- **Hora Pico Vespertina**: 12-35 minutos

### TRANSPUBENZA (Confiabilidad: 92%)

- **Hora Pico Matutina**: 6-24 minutos
- **Horario Normal**: 8-25 minutos
- **Hora Pico Vespertina**: 10-30 minutos

### TRANSLIBERTAD (Confiabilidad: 85%)

- **Hora Pico Matutina**: 10-32 minutos
- **Horario Normal**: 12-35 minutos
- **Hora Pico Vespertina**: 15-38 minutos

### TRANSTAMBO (Confiabilidad: 90%)

- **Hora Pico Matutina**: 8-28 minutos
- **Horario Normal**: 10-30 minutos
- **Hora Pico Vespertina**: 12-35 minutos

## 🚦 Niveles de Tráfico

| Nivel        | Descripción       | Delay Adicional | Color       |
| ------------ | ----------------- | --------------- | ----------- |
| **Low**      | Fluido            | 0 min           | 🟢 Verde    |
| **Medium**   | Moderado          | 2 min           | 🟡 Amarillo |
| **High**     | Congestionado     | 5 min           | 🟠 Naranja  |
| **VeryHigh** | Muy congestionado | 8 min           | 🔴 Rojo     |

## 🌍 Zonas de Tráfico en Popayán

- **Centro**: Tráfico muy alto (2.440-2.450 lat, -76.620--76.610 lng)
- **Norte (Campanario/Terminal)**: Tráfico alto (lat > 2.450)
- **Sur**: Tráfico bajo
- **Otras zonas**: Tráfico medio

## 🕐 Patrones Horarios

### Hora Pico Matutina (7:00-9:00 AM)

- Velocidad reducida (-8 km/h)
- Mayor ocupación (80%)
- Tráfico incrementado

### Horario Normal (10:00-16:00)

- Velocidad base (25 km/h)
- Ocupación media (40%)
- Tráfico normal

### Hora Pico Vespertina (17:00-19:00)

- Velocidad reducida (-8 km/h)
- Mayor ocupación (80%)
- Tráfico incrementado

### Horario Nocturno (20:00-22:00)

- Velocidad incrementada (+5 km/h)
- Menor ocupación (30%)
- Menos tráfico

### Fines de Semana

- Ocupación reducida (30%)
- Tráfico disminuido
- Patrones más relajados

## 🧪 Testing

El sistema incluye pruebas exhaustivas:

```bash
# Ejecutar pruebas del servicio de predicción
flutter test test/core/services/intelligent_prediction_test.dart

# Ejecutar pruebas del servicio de integración
flutter test test/core/services/bus_prediction_integration_test.dart
```

### Cobertura de Pruebas

- ✅ Predicciones realistas (2-45 minutos)
- ✅ Cálculo preciso de métricas
- ✅ Variación por hora del día
- ✅ Diferencias por empresa
- ✅ Patrones de fin de semana
- ✅ Cálculo de distancias
- ✅ Delays climáticos
- ✅ Descripciones de tráfico
- ✅ Predicciones por empresa
- ✅ Recomendaciones de rutas
- ✅ Cálculo de confianza

## 📱 Ejemplo de Uso

```dart
import 'package:latlong2/latlong.dart';
import 'package:rouwhite/core/services/bus_prediction_integration.dart';

void main() async {
  const location = LatLng(2.4448, -76.6147); // Centro Popayán

  // Obtener predicciones completas
  final predictions = await BusPredictionIntegration
      .getPredictionsForLocation(location);

  print('Próximos buses:');
  for (final pred in predictions.predictions.take(3)) {
    print('${pred.arrival.company} - ${pred.arrival.routeName}');
    print('Llega en: ${pred.arrival.arrivalTimeMinutes} min');
    print('Confianza: ${pred.confidenceText}');
    print('---');
  }

  // Mejor opción
  final best = predictions.bestPrediction;
  if (best != null) {
    print('Mejor opción: ${best.arrival.routeName} '
          'en ${best.arrival.arrivalTimeMinutes} min');
  }
}
```

## 🔮 Futuras Mejoras

### Versión 2.0

- [ ] Integración con APIs reales de tráfico
- [ ] Machine Learning para patrones más precisos
- [ ] Datos históricos reales de las empresas
- [ ] Predicciones basadas en eventos especiales
- [ ] Integración con sensores IoT en buses

### Versión 3.0

- [ ] Predicciones en tiempo real con GPS
- [ ] Análisis de sentimientos de usuarios
- [ ] Optimización de rutas dinámicas
- [ ] Integración con sistemas de pago
- [ ] Notificaciones push inteligentes

## 🤝 Contribuciones

Para contribuir al sistema:

1. Fork el repositorio
2. Crea una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. Ejecuta las pruebas (`flutter test`)
4. Commit tus cambios (`git commit -am 'Agregar nueva funcionalidad'`)
5. Push a la rama (`git push origin feature/nueva-funcionalidad`)
6. Crea un Pull Request

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver `LICENSE` para más detalles.

---

**Desarrollado con ❤️ para mejorar el transporte público en Popayán** 🚌✨
