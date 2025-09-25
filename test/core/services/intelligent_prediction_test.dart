import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:rouwhite/core/services/intelligent_prediction_service.dart';
import 'package:rouwhite/data/popayan_bus_routes.dart';

void main() {
  group('IntelligentPredictionService Tests', () {
    const testLocation = LatLng(2.4448, -76.6147); // Centro Popayán
    final testRoute = PopayanBusRoutes.routes.first;

    test('should predict realistic bus arrival times', () {
      final arrivalTime = IntelligentPredictionService.predictBusArrival(
          testRoute, testLocation);

      // Los tiempos deben estar en un rango realista
      expect(arrivalTime, greaterThanOrEqualTo(2));
      expect(arrivalTime, lessThanOrEqualTo(45));

      debugPrint(
          'Tiempo predicho para ${testRoute.company}: $arrivalTime minutos');
    });

    test('should calculate route metrics accurately', () {
      final metrics = IntelligentPredictionService.calculateRouteMetrics(
          testRoute, testLocation, DateTime.now());

      expect(metrics.averageSpeed, greaterThan(10.0));
      expect(metrics.averageSpeed, lessThan(40.0));
      expect(metrics.reliability, greaterThanOrEqualTo(0.0));
      expect(metrics.reliability, lessThanOrEqualTo(1.0));
      expect(metrics.crowdLevel, greaterThanOrEqualTo(0.0));
      expect(metrics.crowdLevel, lessThanOrEqualTo(1.0));
      expect(metrics.weatherDelay, greaterThanOrEqualTo(0));
      expect(metrics.distanceToStop, greaterThanOrEqualTo(0));

      debugPrint('Métricas para ${testRoute.company}:');
      debugPrint(
          '  Velocidad promedio: ${metrics.averageSpeed.toStringAsFixed(1)} km/h');
      debugPrint(
          '  Confiabilidad: ${(metrics.reliability * 100).toStringAsFixed(1)}%');
      debugPrint(
          '  Ocupación: ${(metrics.crowdLevel * 100).toStringAsFixed(1)}%');
      debugPrint('  Tráfico: ${metrics.trafficLevel}');
    });

    test('should vary predictions by time of day', () {
      // Probar diferentes horas del día
      final morningTime = DateTime(2024, 1, 15, 8, 0); // 8 AM - hora pico
      final afternoonTime = DateTime(2024, 1, 15, 14, 0); // 2 PM - normal
      final eveningTime = DateTime(2024, 1, 15, 18, 0); // 6 PM - hora pico

      final morningMetrics = IntelligentPredictionService.calculateRouteMetrics(
          testRoute, testLocation, morningTime);
      final afternoonMetrics =
          IntelligentPredictionService.calculateRouteMetrics(
              testRoute, testLocation, afternoonTime);
      final eveningMetrics = IntelligentPredictionService.calculateRouteMetrics(
          testRoute, testLocation, eveningTime);

      debugPrint('Variación por hora del día:');
      debugPrint(
          'Mañana (8 AM): Velocidad ${morningMetrics.averageSpeed.toStringAsFixed(1)} km/h, Tráfico ${morningMetrics.trafficLevel}');
      debugPrint(
          'Tarde (2 PM): Velocidad ${afternoonMetrics.averageSpeed.toStringAsFixed(1)} km/h, Tráfico ${afternoonMetrics.trafficLevel}');
      debugPrint(
          'Noche (6 PM): Velocidad ${eveningMetrics.averageSpeed.toStringAsFixed(1)} km/h, Tráfico ${eveningMetrics.trafficLevel}');

      // Las velocidades deberían ser diferentes en hora pico vs normal
      expect(morningMetrics.averageSpeed,
          isNot(equals(afternoonMetrics.averageSpeed)));
    });

    test('should vary predictions by company reliability', () {
      final companies = [
        'SOTRACAUCA',
        'TRANSPUBENZA',
        'TRANSLIBERTAD',
        'TRANSTAMBO'
      ];
      final reliabilities = <String, double>{};

      for (final company in companies) {
        final testRouteForCompany = PopayanBusRoutes.routes.firstWhere(
          (route) => route.company == company,
          orElse: () => testRoute,
        );

        final metrics = IntelligentPredictionService.calculateRouteMetrics(
            testRouteForCompany, testLocation, DateTime.now());

        reliabilities[company] = metrics.reliability;
      }

      debugPrint('Confiabilidad por empresa:');
      reliabilities.forEach((company, reliability) {
        debugPrint('$company: ${(reliability * 100).toStringAsFixed(1)}%');
      });

      // Todas las empresas deberían tener confiabilidad > 80%
      for (final reliability in reliabilities.values) {
        expect(reliability, greaterThan(0.8));
      }
    });

    test('should handle weekend vs weekday differences', () {
      final weekday = DateTime(2024, 1, 15, 14, 0); // Lunes 2 PM
      final weekend = DateTime(2024, 1, 13, 14, 0); // Sábado 2 PM

      final weekdayMetrics = IntelligentPredictionService.calculateRouteMetrics(
          testRoute, testLocation, weekday);
      final weekendMetrics = IntelligentPredictionService.calculateRouteMetrics(
          testRoute, testLocation, weekend);

      debugPrint('Diferencias fin de semana:');
      debugPrint(
          'Entre semana: Ocupación ${(weekdayMetrics.crowdLevel * 100).toStringAsFixed(1)}%');
      debugPrint(
          'Fin de semana: Ocupación ${(weekendMetrics.crowdLevel * 100).toStringAsFixed(1)}%');

      // Los fines de semana deberían tener menos ocupación
      expect(weekendMetrics.crowdLevel, lessThan(weekdayMetrics.crowdLevel));
    });

    test('should calculate distance to stops accurately', () {
      final metrics = IntelligentPredictionService.calculateRouteMetrics(
          testRoute, testLocation, DateTime.now());

      expect(metrics.distanceToStop, greaterThanOrEqualTo(0));
      expect(metrics.distanceToStop, lessThan(5000)); // Menos de 5km

      debugPrint(
          'Distancia a parada más cercana: ${metrics.distanceToStop.toStringAsFixed(0)}m');
    });

    test('should provide realistic weather delays', () {
      // Probar diferentes meses (época de lluvias vs seca)
      final drySeasonTime = DateTime(2024, 2, 15, 15, 0); // Febrero - seco
      final rainySeasonTime =
          DateTime(2024, 10, 15, 16, 0); // Octubre - lluvioso

      final dryMetrics = IntelligentPredictionService.calculateRouteMetrics(
          testRoute, testLocation, drySeasonTime);
      final rainyMetrics = IntelligentPredictionService.calculateRouteMetrics(
          testRoute, testLocation, rainySeasonTime);

      debugPrint('Delays por clima:');
      debugPrint('Época seca: ${dryMetrics.weatherDelay} min');
      debugPrint('Época lluviosa: ${rainyMetrics.weatherDelay} min');

      // En época lluviosa podría haber más delays
      expect(dryMetrics.weatherDelay, greaterThanOrEqualTo(0));
      expect(rainyMetrics.weatherDelay, greaterThanOrEqualTo(0));
    });

    test('should generate consistent traffic descriptions', () {
      const levels = TrafficLevel.values;

      for (final level in levels) {
        final description =
            IntelligentPredictionService.getTrafficDescription(level);
        final color = IntelligentPredictionService.getTrafficColor(level);

        expect(description.isNotEmpty, true);
        expect(color, greaterThan(0));

        debugPrint(
            '${level.toString().split('.').last}: $description (Color: 0x${color.toRadixString(16).toUpperCase()})');
      }
    });

    test('should predict different times for different companies', () {
      final companies = [
        'SOTRACAUCA',
        'TRANSPUBENZA',
        'TRANSLIBERTAD',
        'TRANSTAMBO'
      ];
      final predictions = <String, List<int>>{};

      for (final company in companies) {
        final companyRoute = PopayanBusRoutes.routes.firstWhere(
          (route) => route.company == company,
          orElse: () => testRoute,
        );

        // Hacer múltiples predicciones para ver variación
        final times = List.generate(
            5,
            (_) => IntelligentPredictionService.predictBusArrival(
                companyRoute, testLocation));

        predictions[company] = times;
      }

      debugPrint('Predicciones por empresa (5 muestras):');
      predictions.forEach((company, times) {
        final avg = times.reduce((a, b) => a + b) / times.length;
        debugPrint(
            '$company: ${times.join(', ')} min (Promedio: ${avg.toStringAsFixed(1)} min)');
      });

      // Verificar que hay variación entre empresas
      final allTimes = predictions.values.expand((times) => times).toList();
      final uniqueTimes = allTimes.toSet();
      expect(uniqueTimes.length, greaterThan(1));
    });
  });

  group('Traffic Level Tests', () {
    test('should have all traffic levels defined', () {
      const levels = TrafficLevel.values;

      expect(levels.contains(TrafficLevel.low), true);
      expect(levels.contains(TrafficLevel.medium), true);
      expect(levels.contains(TrafficLevel.high), true);
      expect(levels.contains(TrafficLevel.veryHigh), true);
    });
  });

  group('RouteMetrics Tests', () {
    test('should create RouteMetrics with all required fields', () {
      const metrics = RouteMetrics(
        averageSpeed: 25.0,
        reliability: 0.85,
        crowdLevel: 0.6,
        trafficLevel: TrafficLevel.medium,
        weatherDelay: 2,
        distanceToStop: 150.0,
      );

      expect(metrics.averageSpeed, 25.0);
      expect(metrics.reliability, 0.85);
      expect(metrics.crowdLevel, 0.6);
      expect(metrics.trafficLevel, TrafficLevel.medium);
      expect(metrics.weatherDelay, 2);
      expect(metrics.distanceToStop, 150.0);
    });
  });
}
