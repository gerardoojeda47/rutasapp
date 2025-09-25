import 'dart:math';
import 'package:latlong2/latlong.dart';
import '../../data/popayan_bus_routes.dart';
import 'intelligent_prediction_service.dart';
import 'bus_tracking_service.dart';

/// Servicio integrado que combina predicción inteligente con tracking de buses
class BusPredictionIntegration {
  /// Obtiene predicciones completas para una ubicación
  static Future<LocationPredictions> getPredictionsForLocation(
      LatLng location) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 500));

    final arrivals = BusTrackingService.getBusArrivals(location);
    final routes = BusTrackingService.getRoutesToDestination(location);
    final traffic = BusTrackingService.getTrafficInfo(location);

    // Calcular métricas adicionales
    final predictions = <DetailedPrediction>[];

    for (final arrival in arrivals) {
      final route = PopayanBusRoutes.routes.firstWhere(
        (r) => r.name == arrival.routeName,
        orElse: () => PopayanBusRoutes.routes.first,
      );

      final metrics = IntelligentPredictionService.calculateRouteMetrics(
          route, location, DateTime.now());

      predictions.add(DetailedPrediction(
        arrival: arrival,
        metrics: metrics,
        route: route,
        confidence: _calculateConfidence(metrics),
        alternativeTime:
            _calculateAlternativeTime(arrival.arrivalTimeMinutes, metrics),
      ));
    }

    return LocationPredictions(
      location: location,
      predictions: predictions,
      routes: routes,
      traffic: traffic,
      lastUpdated: DateTime.now(),
    );
  }

  /// Obtiene recomendaciones inteligentes de rutas
  static List<RouteRecommendation> getRouteRecommendations(
      LatLng origin, LatLng destination) {
    final routes = PopayanBusRoutes.findNearbyRoutes(origin, 5.0);
    final recommendations = <RouteRecommendation>[];

    for (final route in routes.take(5)) {
      final originMetrics = IntelligentPredictionService.calculateRouteMetrics(
          route, origin, DateTime.now());
      final destMetrics = IntelligentPredictionService.calculateRouteMetrics(
          route, destination, DateTime.now());

      final score = _calculateRouteScore(originMetrics, destMetrics);
      final totalTime =
          IntelligentPredictionService.predictBusArrival(route, origin) +
              _estimateTravelTime(route, origin, destination);

      recommendations.add(RouteRecommendation(
        route: route,
        score: score,
        totalTimeMinutes: totalTime,
        waitTimeMinutes:
            IntelligentPredictionService.predictBusArrival(route, origin),
        travelTimeMinutes: _estimateTravelTime(route, origin, destination),
        originMetrics: originMetrics,
        destinationMetrics: destMetrics,
        recommendation: _getRecommendationText(score, totalTime),
      ));
    }

    // Ordenar por score (mejor primero)
    recommendations.sort((a, b) => b.score.compareTo(a.score));
    return recommendations;
  }

  /// Calcula confianza de la predicción
  static double _calculateConfidence(RouteMetrics metrics) {
    double confidence = 0.8; // Base 80%

    // Ajustar por confiabilidad de empresa
    confidence += (metrics.reliability - 0.8) * 0.5;

    // Reducir por tráfico alto
    switch (metrics.trafficLevel) {
      case TrafficLevel.low:
        confidence += 0.1;
        break;
      case TrafficLevel.medium:
        break; // Sin cambio
      case TrafficLevel.high:
        confidence -= 0.1;
        break;
      case TrafficLevel.veryHigh:
        confidence -= 0.2;
        break;
    }

    // Reducir por clima
    if (metrics.weatherDelay > 0) {
      confidence -= 0.1;
    }

    return confidence.clamp(0.3, 0.95);
  }

  /// Calcula tiempo alternativo (rango)
  static int _calculateAlternativeTime(int baseTime, RouteMetrics metrics) {
    final variance = (1.0 - metrics.reliability) * 5; // 0-5 minutos de varianza
    return (baseTime + variance).round();
  }

  /// Calcula score de ruta (0-100)
  static double _calculateRouteScore(RouteMetrics origin, RouteMetrics dest) {
    double score = 50.0; // Base

    // Bonificar por confiabilidad
    score += (origin.reliability + dest.reliability) / 2 * 30;

    // Penalizar por tráfico
    final avgTrafficPenalty = (_getTrafficPenalty(origin.trafficLevel) +
            _getTrafficPenalty(dest.trafficLevel)) /
        2;
    score -= avgTrafficPenalty;

    // Penalizar por ocupación alta
    final avgCrowdPenalty = ((origin.crowdLevel + dest.crowdLevel) / 2) * 15;
    score -= avgCrowdPenalty;

    // Penalizar por delays climáticos
    score -= (origin.weatherDelay + dest.weatherDelay) * 0.5;

    return score.clamp(0.0, 100.0);
  }

  static double _getTrafficPenalty(TrafficLevel level) {
    switch (level) {
      case TrafficLevel.low:
        return 0;
      case TrafficLevel.medium:
        return 5;
      case TrafficLevel.high:
        return 15;
      case TrafficLevel.veryHigh:
        return 25;
    }
  }

  /// Estima tiempo de viaje en la ruta
  static int _estimateTravelTime(BusRoute route, LatLng origin, LatLng dest) {
    // Estimación simple basada en distancia
    final distance = _calculateDistance(origin, dest);
    const avgSpeed = 20.0; // km/h promedio en ciudad
    final timeHours = distance / 1000 / avgSpeed;
    return (timeHours * 60).round().clamp(5, 120); // 5-120 minutos
  }

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

  static String _getRecommendationText(double score, int totalTime) {
    if (score >= 80) {
      return 'Excelente opción - Rápido y confiable';
    } else if (score >= 60) {
      return 'Buena opción - Tiempo razonable';
    } else if (score >= 40) {
      return 'Opción regular - Posibles retrasos';
    } else {
      return 'Opción lenta - Considera alternativas';
    }
  }
}

/// Predicciones completas para una ubicación
class LocationPredictions {
  final LatLng location;
  final List<DetailedPrediction> predictions;
  final List<RouteInfo> routes;
  final TrafficInfo traffic;
  final DateTime lastUpdated;

  LocationPredictions({
    required this.location,
    required this.predictions,
    required this.routes,
    required this.traffic,
    required this.lastUpdated,
  });

  /// Obtiene la mejor predicción disponible
  DetailedPrediction? get bestPrediction {
    if (predictions.isEmpty) return null;

    // Ordenar por tiempo de llegada y confianza
    final sorted = List<DetailedPrediction>.from(predictions);
    sorted.sort((a, b) {
      final timeComparison =
          a.arrival.arrivalTimeMinutes.compareTo(b.arrival.arrivalTimeMinutes);
      if (timeComparison != 0) return timeComparison;
      return b.confidence.compareTo(a.confidence);
    });

    return sorted.first;
  }

  /// Obtiene predicciones por empresa
  Map<String, List<DetailedPrediction>> get predictionsByCompany {
    final grouped = <String, List<DetailedPrediction>>{};

    for (final prediction in predictions) {
      final company = prediction.arrival.company;
      grouped.putIfAbsent(company, () => []).add(prediction);
    }

    return grouped;
  }
}

/// Predicción detallada con métricas
class DetailedPrediction {
  final BusArrivalInfo arrival;
  final RouteMetrics metrics;
  final BusRoute route;
  final double confidence;
  final int alternativeTime;

  DetailedPrediction({
    required this.arrival,
    required this.metrics,
    required this.route,
    required this.confidence,
    required this.alternativeTime,
  });

  /// Texto de confianza para mostrar al usuario
  String get confidenceText {
    if (confidence >= 0.9) return 'Muy confiable';
    if (confidence >= 0.7) return 'Confiable';
    if (confidence >= 0.5) return 'Moderadamente confiable';
    return 'Poco confiable';
  }

  /// Rango de tiempo estimado
  String get timeRangeText {
    if (alternativeTime == arrival.arrivalTimeMinutes) {
      return '${arrival.arrivalTimeMinutes} min';
    }
    final min = arrival.arrivalTimeMinutes;
    final max = alternativeTime;
    return '$min-$max min';
  }
}

/// Recomendación de ruta
class RouteRecommendation {
  final BusRoute route;
  final double score;
  final int totalTimeMinutes;
  final int waitTimeMinutes;
  final int travelTimeMinutes;
  final RouteMetrics originMetrics;
  final RouteMetrics destinationMetrics;
  final String recommendation;

  RouteRecommendation({
    required this.route,
    required this.score,
    required this.totalTimeMinutes,
    required this.waitTimeMinutes,
    required this.travelTimeMinutes,
    required this.originMetrics,
    required this.destinationMetrics,
    required this.recommendation,
  });

  /// Calificación en estrellas (1-5)
  int get starRating => ((score / 100) * 5).round().clamp(1, 5);

  /// Texto del tiempo total
  String get totalTimeText {
    if (totalTimeMinutes < 60) {
      return '${totalTimeMinutes} min';
    }
    final hours = totalTimeMinutes ~/ 60;
    final minutes = totalTimeMinutes % 60;
    return '${hours}h ${minutes}min';
  }

  /// Descripción detallada
  String get detailedDescription {
    return 'Espera: ${waitTimeMinutes} min, Viaje: ${travelTimeMinutes} min. '
        '${recommendation}';
  }
}
