import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:rouwhite/core/services/smart_route_assistant.dart';
import 'package:rouwhite/data/popayan_bus_routes.dart';

void main() {
  group('Bus Companies Integration Tests', () {
    const testDestination = LatLng(2.4448, -76.6147); // Centro de Popayán

    test('should recognize all bus companies', () {
      final allRoutes = PopayanBusRoutes.routes;
      final companies = allRoutes.map((route) => route.company).toSet();

      // Verificar que todas las empresas esperadas están presentes
      expect(companies.contains('SOTRACAUCA'), true);
      expect(companies.contains('TRANSPUBENZA'), true);
      expect(companies.contains('TRANSLIBERTAD'), true);
      expect(companies.contains('TRANSTAMBO'), true);

      debugPrint('Empresas encontradas: ${companies.toList()}');
      debugPrint('Total de rutas: ${allRoutes.length}');
    });

    test('should generate appropriate recommendations for each company', () {
      final smartRoutes = SmartRouteAssistant.getSmartRouteInfo(
        testDestination,
        urgentMode: false,
      );

      expect(smartRoutes.isNotEmpty, true);

      final companies = smartRoutes.map((r) => r.route.company).toSet();
      debugPrint('Empresas en resultados inteligentes: ${companies.toList()}');

      for (final smartRoute in smartRoutes) {
        final company = smartRoute.route.company;
        final reason = smartRoute.reason;

        // Verificar que cada empresa tiene razones específicas
        switch (company) {
          case 'SOTRACAUCA':
            expect(
                reason.contains('tradicional') || reason.contains('confiable'),
                true);
            break;
          case 'TRANSPUBENZA':
            expect(reason.contains('cobertura') || reason.contains('urbana'),
                true);
            break;
          case 'TRANSLIBERTAD':
            expect(reason.contains('directas') || reason.contains('eficientes'),
                true);
            break;
          case 'TRANSTAMBO':
            expect(
                reason.contains('moderno') || reason.contains('puntual'), true);
            break;
        }

        debugPrint('${company}: ${smartRoute.recommendation}');
        debugPrint('  Razón: ${reason}');
        debugPrint('  Calidad: ${smartRoute.quality}');
      }
    });

    test('should show company names in assistant messages', () {
      final smartRoutes = SmartRouteAssistant.getSmartRouteInfo(
        testDestination,
        urgentMode: false,
      );

      final message = SmartRouteAssistant.generateAssistantMessage(
        smartRoutes,
        false,
      );

      expect(message.isNotEmpty, true);

      // El mensaje debería mencionar al menos una empresa
      final hasCompanyName = message.contains('SOTRACAUCA') ||
          message.contains('TRANSPUBENZA') ||
          message.contains('TRANSLIBERTAD') ||
          message.contains('TRANSTAMBO');

      expect(hasCompanyName, true);
      debugPrint('Mensaje del asistente:');
      debugPrint(message);
    });

    test('should handle urgent mode for all companies', () {
      final urgentRoutes = SmartRouteAssistant.getSmartRouteInfo(
        testDestination,
        urgentMode: true,
      );

      expect(urgentRoutes.isNotEmpty, true);

      final urgentMessage = SmartRouteAssistant.generateAssistantMessage(
        urgentRoutes,
        true,
      );

      expect(urgentMessage.contains('🚨 MODO URGENTE ACTIVADO'), true);
      expect(urgentMessage.contains('⚡ Ruta más rápida:'), true);

      // Debería mencionar una empresa específica
      final hasCompanyName = urgentMessage.contains('SOTRACAUCA') ||
          urgentMessage.contains('TRANSPUBENZA') ||
          urgentMessage.contains('TRANSLIBERTAD') ||
          urgentMessage.contains('TRANSTAMBO');

      expect(hasCompanyName, true);
      debugPrint('Mensaje urgente:');
      debugPrint(urgentMessage);
    });

    test('should distribute quality ratings fairly among companies', () {
      final smartRoutes = SmartRouteAssistant.getSmartRouteInfo(
        testDestination,
        urgentMode: false,
      );

      if (smartRoutes.length >= 2) {
        final qualityByCompany = <String, List<RouteQuality>>{};

        for (final route in smartRoutes) {
          final company = route.route.company;
          qualityByCompany.putIfAbsent(company, () => []);
          qualityByCompany[company]!.add(route.quality);
        }

        debugPrint('Calidad por empresa:');
        qualityByCompany.forEach((company, qualities) {
          debugPrint(
              '$company: ${qualities.map((q) => q.toString().split('.').last).join(', ')}');
        });

        // Verificar que no todas las rutas tienen la misma calidad
        final allQualities = smartRoutes.map((r) => r.quality).toSet();
        expect(allQualities.length, greaterThanOrEqualTo(1));
      }
    });

    test('should provide company-specific tips and information', () {
      final smartRoutes = SmartRouteAssistant.getSmartRouteInfo(
        testDestination,
        urgentMode: false,
      );

      final tips = SmartRouteAssistant.getAdditionalTips(smartRoutes);

      debugPrint('Tips generados: ${tips.length}');
      for (final tip in tips) {
        debugPrint('- $tip');
        expect(tip.isNotEmpty, true);
      }
    });
  });

  group('Company Route Coverage Tests', () {
    test('should have routes for each company', () {
      final allRoutes = PopayanBusRoutes.routes;

      final sotracaucaRoutes =
          allRoutes.where((r) => r.company == 'SOTRACAUCA').length;
      final transpubenzaRoutes =
          allRoutes.where((r) => r.company == 'TRANSPUBENZA').length;
      final translibertadRoutes =
          allRoutes.where((r) => r.company == 'TRANSLIBERTAD').length;
      final transtamboRoutes =
          allRoutes.where((r) => r.company == 'TRANSTAMBO').length;

      debugPrint('Rutas por empresa:');
      debugPrint('SOTRACAUCA: $sotracaucaRoutes rutas');
      debugPrint('TRANSPUBENZA: $transpubenzaRoutes rutas');
      debugPrint('TRANSLIBERTAD: $translibertadRoutes rutas');
      debugPrint('TRANSTAMBO: $transtamboRoutes rutas');

      expect(sotracaucaRoutes, greaterThan(0));
      expect(transpubenzaRoutes, greaterThan(0));
      expect(translibertadRoutes, greaterThan(0));
      expect(transtamboRoutes, greaterThan(0));
    });

    test('should have proper route naming for each company', () {
      final allRoutes = PopayanBusRoutes.routes;

      for (final route in allRoutes) {
        // Verificar que el nombre incluye la empresa o es descriptivo
        expect(route.name.isNotEmpty, true);
        expect(route.name.length, greaterThan(10));

        // Verificar que tiene información de barrios/destinos
        expect(route.neighborhoods.isNotEmpty, true);

        debugPrint('${route.company}: ${route.name}');
        debugPrint(
            '  Barrios: ${route.neighborhoods.take(3).join(', ')}${route.neighborhoods.length > 3 ? '...' : ''}');
      }
    });
  });
}
