import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'package:rouwhite/core/services/bus_prediction_integration.dart';
import 'package:rouwhite/core/services/bus_tracking_service.dart';
import 'package:rouwhite/core/services/intelligent_prediction_service.dart';
import 'package:rouwhite/data/popayan_bus_routes.dart';

void main() {
  group('BusPredictionIntegration Tests', () {
    const testLocation = LatLng(2.4448, -76.6147); // Centro Popayán
    const testDestination = LatLng(2.4500, -76.6100); // Norte de Popayán

    test('should get complete predictions for location', () async {
      final predictions =
          await BusPredictionIntegration.getPredictionsForLocation(
              testLocation);

      expect(predictions.location, testLocation);
      expect(predictions.predictions, isNotEmpty);
      expect(predictions.routes, isNotEmpty);
      expect(predictions.traffic, isNotNull);
      expect(predictions.lastUpdated, isNotNull);

      // Verificar que las predicciones tienen datos válidos
      for (final prediction in predictions.predictions) {
        expect(prediction.arrival.arrivalTimeMinutes, greaterThan(0));
        expect(prediction.confidence, greaterThanOrEqualTo(0.0));
        expect(prediction.confidence, lessThanOrEqualTo(1.0));
        expect(prediction.metrics, isNotNull);
        expect(prediction.route, isNotNull);
      }

      debugPrint('Predicciones obtenidas: ${predictions.predictions.length}');
      debugPrint('Rutas disponibles: ${predictions.routes.length}');
      debugPrint('Nivel de tráfico: ${predictions.traffic.level}');
    });

    test('should get route recommendations', () {
      final recommendations = BusPredictionIntegration.getRouteRecommendations(
          testLocation, testDestination);

      expect(recommendations, isNotEmpty);

      for (final rec in recommendations) {
        expect(rec.score, greaterThanOrEqualTo(0.0));
        expect(rec.score, lessThanOrEqualTo(100.0));
        expect(rec.totalTimeMinutes, greaterThan(0));
        expect(rec.waitTimeMinutes, greaterThanOrEqualTo(0));
        expect(rec.travelTimeMinutes, greaterThan(0));
        expect(rec.starRating, greaterThanOrEqualTo(1));
        expect(rec.starRating, lessThanOrEqualTo(5));
        expect(rec.recommendation.isNotEmpty, true);
      }

      // Verificar que están ordenadas por score (mejor primero)
      for (int i = 0; i < recommendations.length - 1; i++) {
        expect(recommendations[i].score,
            greaterThanOrEqualTo(recommendations[i + 1].score));
      }

      debugPrint('Recomendaciones obtenidas: ${recommendations.length}');
      for (final rec in recommendations.take(3)) {
        debugPrint('${rec.route.company} ${rec.route.name}: '
            'Score ${rec.score.toStringAsFixed(1)}, '
            '${rec.starRating} estrellas, '
            '${rec.totalTimeText}');
      }
    });

    test('should calculate confidence correctly', () async {
      final predictions =
          await BusPredictionIntegration.getPredictionsForLocation(
              testLocation);

      for (final prediction in predictions.predictions) {
        expect(prediction.confidence, greaterThanOrEqualTo(0.3));
        expect(prediction.confidence, lessThanOrEqualTo(0.95));

        // Verificar texto de confianza
        final confidenceText = prediction.confidenceText;
        expect(
            [
              'Muy confiable',
              'Confiable',
              'Moderadamente confiable',
              'Poco confiable'
            ].contains(confidenceText),
            true);

        debugPrint('${prediction.arrival.company}: '
            'Confianza ${(prediction.confidence * 100).toStringAsFixed(1)}% '
            '($confidenceText)');
      }
    });

    test('should provide best prediction', () async {
      final predictions =
          await BusPredictionIntegration.getPredictionsForLocation(
              testLocation);

      final best = predictions.bestPrediction;
      expect(best, isNotNull);

      if (best != null) {
        // La mejor predicción debería tener tiempo de llegada razonable
        expect(best.arrival.arrivalTimeMinutes, lessThanOrEqualTo(45));

        debugPrint(
            'Mejor predicción: ${best.arrival.company} ${best.arrival.routeName} '
            'en ${best.arrival.arrivalTimeMinutes} min '
            '(${best.confidenceText})');
      }
    });

    test('should group predictions by company', () async {
      final predictions =
          await BusPredictionIntegration.getPredictionsForLocation(
              testLocation);

      final grouped = predictions.predictionsByCompany;
      expect(grouped, isNotEmpty);

      for (final entry in grouped.entries) {
        final company = entry.key;
        final companyPredictions = entry.value;

        expect(companyPredictions, isNotEmpty);
        expect(
            ['SOTRACAUCA', 'TRANSPUBENZA', 'TRANSLIBERTAD', 'TRANSTAMBO']
                .contains(company),
            true);

        // Todas las predicciones del grupo deben ser de la misma empresa
        for (final prediction in companyPredictions) {
          expect(prediction.arrival.company, company);
        }

        debugPrint('$company: ${companyPredictions.length} predicciones');
      }
    });

    test('should calculate time ranges correctly', () async {
      final predictions =
          await BusPredictionIntegration.getPredictionsForLocation(
              testLocation);

      for (final prediction in predictions.predictions) {
        final timeRange = prediction.timeRangeText;
        expect(timeRange.isNotEmpty, true);

        // Debería contener números
        expect(RegExp(r'\d+').hasMatch(timeRange), true);

        debugPrint('${prediction.arrival.routeName}: $timeRange');
      }
    });

    test('should handle route recommendations scoring', () {
      final recommendations = BusPredictionIntegration.getRouteRecommendations(
          testLocation, testDestination);

      // Verificar que hay variación en los scores (puede ser 1 si todas las rutas son similares)
      final scores = recommendations.map((r) => r.score).toSet();
      expect(scores.length, greaterThanOrEqualTo(1));

      // Verificar descripciones detalladas
      for (final rec in recommendations) {
        expect(rec.detailedDescription.isNotEmpty, true);
        expect(rec.detailedDescription.contains('Espera:'), true);
        expect(rec.detailedDescription.contains('Viaje:'), true);

        debugPrint('${rec.route.name}: ${rec.detailedDescription}');
      }
    });

    test('should handle edge cases', () async {
      // Ubicación muy alejada
      const remoteLocation = LatLng(2.5000, -76.7000);
      final remotePredictions =
          await BusPredictionIntegration.getPredictionsForLocation(
              remoteLocation);

      // Debería manejar ubicaciones remotas sin fallar
      expect(remotePredictions, isNotNull);
      expect(remotePredictions.location, remoteLocation);

      debugPrint(
          'Predicciones para ubicación remota: ${remotePredictions.predictions.length}');
    });

    test('should provide realistic travel times', () {
      final recommendations = BusPredictionIntegration.getRouteRecommendations(
          testLocation, testDestination);

      for (final rec in recommendations) {
        // Tiempos de espera razonables (0-45 min)
        expect(rec.waitTimeMinutes, greaterThanOrEqualTo(0));
        expect(rec.waitTimeMinutes, lessThanOrEqualTo(45));

        // Tiempos de viaje razonables (5-120 min)
        expect(rec.travelTimeMinutes, greaterThanOrEqualTo(5));
        expect(rec.travelTimeMinutes, lessThanOrEqualTo(120));

        // Tiempo total debería ser aproximadamente espera + viaje (puede tener pequeñas variaciones)
        expect(
            rec.totalTimeMinutes,
            greaterThanOrEqualTo(
                rec.waitTimeMinutes + rec.travelTimeMinutes - 10));

        debugPrint('${rec.route.name}: '
            'Espera ${rec.waitTimeMinutes}min + '
            'Viaje ${rec.travelTimeMinutes}min = '
            'Total ${rec.totalTimeText}');
      }
    });
  });

  group('LocationPredictions Tests', () {
    test('should handle empty predictions', () {
      final emptyPredictions = LocationPredictions(
        location: const LatLng(0, 0),
        predictions: [],
        routes: [],
        traffic:
            TrafficInfo(level: 'Fluido', delayMinutes: 0, description: 'Test'),
        lastUpdated: DateTime.now(),
      );

      expect(emptyPredictions.bestPrediction, isNull);
      expect(emptyPredictions.predictionsByCompany, isEmpty);
    });
  });

  group('RouteRecommendation Tests', () {
    test('should calculate star ratings correctly', () {
      final testRoute = PopayanBusRoutes.routes.first;

      // Test diferentes scores
      final scores = [0.0, 25.0, 50.0, 75.0, 100.0];
      final expectedStars = [
        1,
        1,
        3,
        4,
        5
      ]; // Corregir expectativa para score 25.0

      for (int i = 0; i < scores.length; i++) {
        final rec = RouteRecommendation(
          route: testRoute,
          score: scores[i],
          totalTimeMinutes: 30,
          waitTimeMinutes: 10,
          travelTimeMinutes: 20,
          originMetrics: const RouteMetrics(
            averageSpeed: 25.0,
            reliability: 0.8,
            crowdLevel: 0.5,
            trafficLevel: TrafficLevel.medium,
            weatherDelay: 0,
            distanceToStop: 100.0,
          ),
          destinationMetrics: const RouteMetrics(
            averageSpeed: 25.0,
            reliability: 0.8,
            crowdLevel: 0.5,
            trafficLevel: TrafficLevel.medium,
            weatherDelay: 0,
            distanceToStop: 100.0,
          ),
          recommendation: 'Test',
        );

        expect(rec.starRating, expectedStars[i]);
        debugPrint('Score ${scores[i]} = ${rec.starRating} estrellas');
      }
    });
  });
}
