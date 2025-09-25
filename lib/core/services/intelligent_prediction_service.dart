import 'dart:math';
import 'package:latlong2/latlong.dart';
import '../../data/popayan_bus_routes.dart';

/// Niveles de tráfico en Popayán
enum TrafficLevel { low, medium, high, veryHigh }

/// Métricas de ruta calculadas
class RouteMetrics {
  final double averageSpeed; // km/h
  final double reliability; // 0.0 - 1.0
  final double crowdLevel; // 0.0 - 1.0
  final TrafficLevel trafficLevel;
  final int weatherDelay; // minutos adicionales
  final double distanceToStop; // metros

  const RouteMetrics({
    required this.averageSpeed,
    required this.reliability,
    required this.crowdLevel,
    required this.trafficLevel,
    required this.weatherDelay,
    required this.distanceToStop,
  });
}

/// Predicción inteligente de tiempos de bus
class IntelligentPredictionService {
  static final Random _random = Random();

  // Patrones históricos simulados basados en datos reales de Popayán
  static final Map<String, Map<String, List<int>>> _historicalPatterns = {
    'SOTRACAUCA': {
      'morning_rush': [8, 12, 15, 18, 22, 25], // 7-9 AM
      'midday': [10, 15, 20, 25, 30], // 10-16
      'evening_rush': [12, 18, 22, 28, 35], // 17-19
      'night': [15, 20, 25, 30, 35], // 20-22
      'weekend': [12, 18, 25, 30, 35], // Sábados y domingos
    },
    'TRANSPUBENZA': {
      'morning_rush': [6, 10, 14, 16, 20, 24],
      'midday': [8, 12, 16, 20, 25],
      'evening_rush': [10, 15, 20, 25, 30],
      'night': [12, 18, 22, 28, 32],
      'weekend': [10, 15, 22, 28, 32],
    },
    'TRANSLIBERTAD': {
      'morning_rush': [10, 15, 18, 22, 28, 32],
      'midday': [12, 18, 22, 28, 35],
      'evening_rush': [15, 20, 25, 32, 38],
      'night': [18, 25, 30, 35, 40],
      'weekend': [15, 22, 28, 35, 40],
    },
    'TRANSTAMBO': {
      'morning_rush': [8, 12, 16, 20, 25, 28],
      'midday': [10, 15, 20, 25, 30],
      'evening_rush': [12, 18, 24, 28, 35],
      'night': [15, 22, 28, 32, 38],
      'weekend': [12, 20, 25, 32, 38],
    },
  };

  /// Predice el tiempo de llegada de un bus de manera inteligente
  static int predictBusArrival(BusRoute route, LatLng userLocation) {
    final now = DateTime.now();
    final metrics = calculateRouteMetrics(route, userLocation, now);

    // Obtener patrón base según empresa y hora
    final basePattern = _getHistoricalPattern(route.company, now);
    final baseTime = basePattern[_random.nextInt(basePattern.length)];

    // Aplicar factores de corrección
    double adjustedTime = baseTime.toDouble();

    // Factor de distancia a la parada
    adjustedTime += _calculateDistanceDelay(metrics.distanceToStop);

    // Factor de tráfico
    adjustedTime += _calculateTrafficDelay(metrics.trafficLevel);

    // Factor de confiabilidad de la empresa
    adjustedTime += _calculateReliabilityAdjustment(metrics.reliability);

    // Factor de clima (simulado)
    adjustedTime += metrics.weatherDelay;

    // Factor de ocupación
    adjustedTime += _calculateCrowdDelay(metrics.crowdLevel);

    // Asegurar que esté en un rango realista
    return adjustedTime.round().clamp(2, 45);
  }

  /// Calcula métricas completas de una ruta
  static RouteMetrics calculateRouteMetrics(
      BusRoute route, LatLng userLocation, DateTime time) {
    return RouteMetrics(
      averageSpeed: _calculateAverageSpeed(route, time),
      reliability: _calculateReliability(route.company),
      crowdLevel: _estimateCrowdLevel(route, time),
      trafficLevel: _getTrafficLevel(userLocation, time),
      weatherDelay: _getWeatherDelay(time),
      distanceToStop: _calculateDistanceToNearestStop(route, userLocation),
    );
  }

  /// Obtiene el patrón histórico según empresa y hora
  static List<int> _getHistoricalPattern(String company, DateTime time) {
    final patterns =
        _historicalPatterns[company] ?? _historicalPatterns['SOTRACAUCA']!;
    final timeKey = _getTimeOfDayKey(time);
    return patterns[timeKey] ?? patterns['midday']!;
  }

  /// Determina la clave de tiempo del día
  static String _getTimeOfDayKey(DateTime time) {
    final hour = time.hour;
    final isWeekend = time.weekday >= 6;

    if (isWeekend) return 'weekend';

    if (hour >= 7 && hour <= 9) return 'morning_rush';
    if (hour >= 17 && hour <= 19) return 'evening_rush';
    if (hour >= 20 && hour <= 22) return 'night';
    return 'midday';
  }

  /// Calcula velocidad promedio según ruta y hora
  static double _calculateAverageSpeed(BusRoute route, DateTime time) {
    double baseSpeed = 25.0; // km/h base en Popayán

    // Ajuste por empresa (algunas son más rápidas)
    switch (route.company) {
      case 'TRANSPUBENZA':
        baseSpeed += 3.0;
        break;
      case 'SOTRACAUCA':
        baseSpeed += 1.0;
        break;
      case 'TRANSTAMBO':
        baseSpeed += 2.0;
        break;
    }

    // Ajuste por hora del día
    final hour = time.hour;
    if (hour >= 7 && hour <= 9 || hour >= 17 && hour <= 19) {
      baseSpeed -= 8.0; // Hora pico
    } else if (hour >= 22 || hour <= 6) {
      baseSpeed += 5.0; // Noche, menos tráfico
    }

    return baseSpeed.clamp(10.0, 40.0);
  }

  /// Calcula confiabilidad por empresa
  static double _calculateReliability(String company) {
    switch (company) {
      case 'TRANSPUBENZA':
        return 0.92; // Muy confiable
      case 'SOTRACAUCA':
        return 0.88; // Confiable
      case 'TRANSTAMBO':
        return 0.90; // Muy confiable
      case 'TRANSLIBERTAD':
        return 0.85; // Bastante confiable
      default:
        return 0.80;
    }
  }

  /// Estima nivel de ocupación
  static double _estimateCrowdLevel(BusRoute route, DateTime time) {
    final hour = time.hour;
    final isWeekend = time.weekday >= 6;

    double baseCrowd = 0.4; // 40% ocupación base

    // Hora pico
    if (!isWeekend && (hour >= 7 && hour <= 9 || hour >= 17 && hour <= 19)) {
      baseCrowd = 0.8; // 80% en hora pico
    }

    // Fin de semana
    if (isWeekend) {
      baseCrowd = 0.3; // 30% los fines de semana
    }

    // Rutas populares
    if (route.neighborhoods.contains('Centro') ||
        route.neighborhoods.contains('Terminal') ||
        route.neighborhoods.contains('Campanario')) {
      baseCrowd += 0.1;
    }

    return baseCrowd.clamp(0.1, 0.95);
  }

  /// Determina nivel de tráfico por ubicación y hora
  static TrafficLevel _getTrafficLevel(LatLng location, DateTime time) {
    final hour = time.hour;
    final isWeekend = time.weekday >= 6;

    // Base por zona geográfica
    TrafficLevel baseLevel = TrafficLevel.low;

    // Centro de Popayán (aproximado)
    if (location.latitude >= 2.440 &&
        location.latitude <= 2.450 &&
        location.longitude >= -76.620 &&
        location.longitude <= -76.610) {
      baseLevel = TrafficLevel.high;
    }

    // Zona norte (Campanario, Terminal)
    if (location.latitude > 2.450) {
      baseLevel = TrafficLevel.medium;
    }

    // Ajuste por hora
    if (!isWeekend && (hour >= 7 && hour <= 9 || hour >= 17 && hour <= 19)) {
      // Incrementar nivel en hora pico
      switch (baseLevel) {
        case TrafficLevel.low:
          return TrafficLevel.medium;
        case TrafficLevel.medium:
          return TrafficLevel.high;
        case TrafficLevel.high:
          return TrafficLevel.veryHigh;
        case TrafficLevel.veryHigh:
          return TrafficLevel.veryHigh;
      }
    }

    // Fin de semana - reducir tráfico
    if (isWeekend && baseLevel != TrafficLevel.low) {
      switch (baseLevel) {
        case TrafficLevel.veryHigh:
          return TrafficLevel.medium;
        case TrafficLevel.high:
          return TrafficLevel.low;
        case TrafficLevel.medium:
          return TrafficLevel.low;
        case TrafficLevel.low:
          return TrafficLevel.low;
      }
    }

    return baseLevel;
  }

  /// Calcula delay por clima (simulado)
  static int _getWeatherDelay(DateTime time) {
    // Simular condiciones climáticas de Popayán
    final month = time.month;
    final hour = time.hour;

    // Época de lluvias (abril-mayo, octubre-noviembre)
    if ((month >= 4 && month <= 5) || (month >= 10 && month <= 11)) {
      // Más probabilidad de lluvia en la tarde
      if (hour >= 14 && hour <= 18) {
        return _random.nextBool() ? _random.nextInt(8) + 2 : 0; // 0-10 min
      }
    }

    return 0;
  }

  /// Calcula distancia a la parada más cercana
  static double _calculateDistanceToNearestStop(
      BusRoute route, LatLng userLocation) {
    double minDistance = double.infinity;

    for (final stop in route.stops) {
      final distance = _calculateDistance(userLocation, stop);
      if (distance < minDistance) {
        minDistance = distance;
      }
    }

    return minDistance;
  }

  /// Calcula distancia entre dos puntos (Haversine)
  static double _calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadius = 6371000; // metros

    final lat1Rad = point1.latitude * (pi / 180);
    final lat2Rad = point2.latitude * (pi / 180);
    final deltaLatRad = (point2.latitude - point1.latitude) * (pi / 180);
    final deltaLngRad = (point2.longitude - point1.longitude) * (pi / 180);

    final a = sin(deltaLatRad / 2) * sin(deltaLatRad / 2) +
        cos(lat1Rad) *
            cos(lat2Rad) *
            sin(deltaLngRad / 2) *
            sin(deltaLngRad / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  /// Calcula delay adicional por distancia a parada
  static double _calculateDistanceDelay(double distanceMeters) {
    if (distanceMeters <= 100) return 0; // Muy cerca
    if (distanceMeters <= 300) return 1; // Cerca
    if (distanceMeters <= 500) return 2; // Medio
    return 3; // Lejos
  }

  /// Calcula delay por tráfico
  static double _calculateTrafficDelay(TrafficLevel level) {
    switch (level) {
      case TrafficLevel.low:
        return 0;
      case TrafficLevel.medium:
        return 2;
      case TrafficLevel.high:
        return 5;
      case TrafficLevel.veryHigh:
        return 8;
    }
  }

  /// Ajuste por confiabilidad de empresa
  static double _calculateReliabilityAdjustment(double reliability) {
    // Empresas menos confiables tienden a llegar más tarde
    return (1.0 - reliability) * 5; // 0-5 minutos adicionales
  }

  /// Delay por ocupación del bus
  static double _calculateCrowdDelay(double crowdLevel) {
    // Buses más llenos tardan más en paradas
    return crowdLevel * 3; // 0-3 minutos adicionales
  }

  /// Obtiene descripción del nivel de tráfico
  static String getTrafficDescription(TrafficLevel level) {
    switch (level) {
      case TrafficLevel.low:
        return 'Fluido';
      case TrafficLevel.medium:
        return 'Moderado';
      case TrafficLevel.high:
        return 'Congestionado';
      case TrafficLevel.veryHigh:
        return 'Muy congestionado';
    }
  }

  /// Obtiene color para el nivel de tráfico
  static int getTrafficColor(TrafficLevel level) {
    switch (level) {
      case TrafficLevel.low:
        return 0xFF4CAF50; // Verde
      case TrafficLevel.medium:
        return 0xFFFF9800; // Naranja
      case TrafficLevel.high:
        return 0xFFFF5722; // Rojo naranja
      case TrafficLevel.veryHigh:
        return 0xFFF44336; // Rojo
    }
  }
}
