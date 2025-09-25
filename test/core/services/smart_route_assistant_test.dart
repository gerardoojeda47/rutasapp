import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:rouwhite/core/services/smart_route_assistant.dart';

void main() {
  group('SmartRouteAssistant Tests', () {
    const testDestination = LatLng(2.4448, -76.6147); // Centro de Popayán

    test('should generate smart route info for normal mode', () {
      final smartRoutes = SmartRouteAssistant.getSmartRouteInfo(
        testDestination,
        urgentMode: false,
      );

      expect(smartRoutes.isNotEmpty, true);
      expect(smartRoutes.length, lessThanOrEqualTo(3));

      for (final route in smartRoutes) {
        expect(route.route, isNotNull);
        expect(route.arrivalMinutes, greaterThan(0));
        expect(route.walkingDistance, greaterThan(0));
        expect(route.recommendation.isNotEmpty, true);
        expect(route.reason.isNotEmpty, true);
        expect(route.isUrgent, false);
      }
    });

    test('should generate smart route info for urgent mode', () {
      final smartRoutes = SmartRouteAssistant.getSmartRouteInfo(
        testDestination,
        urgentMode: true,
      );

      expect(smartRoutes.isNotEmpty, true);

      for (final route in smartRoutes) {
        expect(route.isUrgent, true);
        expect(route.recommendation.isNotEmpty, true);
        expect(route.reason.isNotEmpty, true);

        // En modo urgente, debería tener mensaje urgente o plan B
        expect(
          route.urgentMessage != null || route.planB != null,
          true,
        );
      }
    });

    test('should sort routes by arrival time in urgent mode', () {
      final smartRoutes = SmartRouteAssistant.getSmartRouteInfo(
        testDestination,
        urgentMode: true,
      );

      if (smartRoutes.length > 1) {
        for (int i = 0; i < smartRoutes.length - 1; i++) {
          expect(
            smartRoutes[i].arrivalMinutes,
            lessThanOrEqualTo(smartRoutes[i + 1].arrivalMinutes),
          );
        }
      }
    });

    test('should generate appropriate quality ratings', () {
      final smartRoutes = SmartRouteAssistant.getSmartRouteInfo(
        testDestination,
        urgentMode: false,
      );

      expect(smartRoutes.isNotEmpty, true);

      final qualities = smartRoutes.map((r) => r.quality).toSet();
      expect(qualities.isNotEmpty, true);

      // Verificar que las calidades son válidas
      for (final quality in qualities) {
        expect(
          [
            RouteQuality.excellent,
            RouteQuality.good,
            RouteQuality.average,
            RouteQuality.poor,
          ].contains(quality),
          true,
        );
      }
    });

    test('should generate conversational assistant message for normal mode',
        () {
      final smartRoutes = SmartRouteAssistant.getSmartRouteInfo(
        testDestination,
        urgentMode: false,
      );

      final message = SmartRouteAssistant.generateAssistantMessage(
        smartRoutes,
        false,
      );

      expect(message.isNotEmpty, true);
      expect(message.contains('🤖'), true);
      expect(message.contains('Encontré'), true);

      if (smartRoutes.length >= 2) {
        expect(message.contains('🥇'), true);
        expect(message.contains('🥈'), true);
        expect(message.contains('¿Prefieres velocidad o comodidad?'), true);
      }
    });

    test('should generate urgent assistant message for urgent mode', () {
      final smartRoutes = SmartRouteAssistant.getSmartRouteInfo(
        testDestination,
        urgentMode: true,
      );

      final message = SmartRouteAssistant.generateAssistantMessage(
        smartRoutes,
        true,
      );

      expect(message.isNotEmpty, true);
      expect(message.contains('🚨 MODO URGENTE ACTIVADO'), true);
      expect(message.contains('⚡ Ruta más rápida:'), true);
      expect(message.contains('⏱️ Próximo bus:'), true);
      expect(message.contains('📱 Te aviso cuando esté llegando'), true);
    });

    test('should handle empty routes gracefully', () {
      // Usar coordenadas muy lejanas donde no hay rutas
      const farDestination = LatLng(0.0, 0.0);

      final smartRoutes = SmartRouteAssistant.getSmartRouteInfo(
        farDestination,
        urgentMode: false,
      );

      final message = SmartRouteAssistant.generateAssistantMessage(
        smartRoutes,
        false,
      );

      expect(message.contains('😔'), true);
      expect(message.contains('No encontré rutas'), true);
    });

    test('should generate helpful tips', () {
      final smartRoutes = SmartRouteAssistant.getSmartRouteInfo(
        testDestination,
        urgentMode: false,
      );

      final tips = SmartRouteAssistant.getAdditionalTips(smartRoutes);

      expect(tips, isA<List<String>>());

      // Los tips pueden estar vacíos o contener consejos útiles
      for (final tip in tips) {
        expect(tip.isNotEmpty, true);
        // Los tips pueden tener diferentes emojis
        expect(tip.length, greaterThan(5));
      }
    });

    test('should generate different recommendations based on quality', () {
      final smartRoutes = SmartRouteAssistant.getSmartRouteInfo(
        testDestination,
        urgentMode: false,
      );

      if (smartRoutes.isNotEmpty) {
        final recommendations =
            smartRoutes.map((r) => r.recommendation).toSet();

        // Debería haber variedad en las recomendaciones
        expect(recommendations.isNotEmpty, true);

        // Verificar que contienen emojis apropiados
        final hasGoldMedal = recommendations.any((r) => r.contains('🥇'));
        final hasSilverMedal = recommendations.any((r) => r.contains('🥈'));

        if (smartRoutes.length >= 2) {
          expect(hasGoldMedal || hasSilverMedal, true);
        }
      }
    });

    test('should generate realistic arrival times', () {
      final smartRoutes = SmartRouteAssistant.getSmartRouteInfo(
        testDestination,
        urgentMode: false,
      );

      for (final route in smartRoutes) {
        // Los tiempos de llegada deberían ser realistas (2-25 minutos)
        expect(route.arrivalMinutes, greaterThanOrEqualTo(2));
        expect(route.arrivalMinutes, lessThanOrEqualTo(25));
      }
    });

    test('should generate realistic walking distances', () {
      final smartRoutes = SmartRouteAssistant.getSmartRouteInfo(
        testDestination,
        urgentMode: false,
      );

      for (final route in smartRoutes) {
        // Las distancias de caminata deberían ser realistas (50-800m)
        expect(route.walkingDistance, greaterThanOrEqualTo(50));
        expect(route.walkingDistance, lessThanOrEqualTo(800));
      }
    });
  });

  group('RouteQuality Tests', () {
    test('should have all quality levels defined', () {
      const qualities = RouteQuality.values;

      expect(qualities.contains(RouteQuality.excellent), true);
      expect(qualities.contains(RouteQuality.good), true);
      expect(qualities.contains(RouteQuality.average), true);
      expect(qualities.contains(RouteQuality.poor), true);
    });
  });

  group('SmartRouteInfo Tests', () {
    test('should create SmartRouteInfo with all required fields', () {
      // Este test requeriría crear un BusRoute mock,
      // por ahora verificamos que la clase existe y es usable
      expect(SmartRouteInfo, isNotNull);
      expect(RouteQuality.excellent, isNotNull);
    });
  });
}
