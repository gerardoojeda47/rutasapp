import 'dart:math';
import 'package:latlong2/latlong.dart';
import '../../data/popayan_bus_routes.dart';

/// Información inteligente de ruta
class SmartRouteInfo {
  final BusRoute route;
  final int arrivalMinutes;
  final double walkingDistance;
  final String recommendation;
  final String reason;
  final RouteQuality quality;
  final bool isUrgent;
  final String? urgentMessage;
  final String? planB;

  const SmartRouteInfo({
    required this.route,
    required this.arrivalMinutes,
    required this.walkingDistance,
    required this.recommendation,
    required this.reason,
    required this.quality,
    this.isUrgent = false,
    this.urgentMessage,
    this.planB,
  });
}

/// Calidad de la ruta
enum RouteQuality { excellent, good, average, poor }

/// Asistente inteligente para rutas
class SmartRouteAssistant {
  static final Random _random = Random();

  /// Obtiene información inteligente de rutas para un destino
  static List<SmartRouteInfo> getSmartRouteInfo(LatLng destination,
      {bool urgentMode = false}) {
    final nearbyRoutes = PopayanBusRoutes.findNearbyRoutes(destination, 2.0);

    if (nearbyRoutes.isEmpty) {
      return [];
    }

    final smartRoutes = nearbyRoutes.map((route) {
      return _generateSmartInfo(route, destination, urgentMode);
    }).toList();

    // Ordenar por calidad y tiempo
    smartRoutes.sort((a, b) {
      if (urgentMode) {
        return a.arrivalMinutes.compareTo(b.arrivalMinutes);
      }
      return _getQualityScore(a.quality).compareTo(_getQualityScore(b.quality));
    });

    return smartRoutes.take(3).toList();
  }

  /// Genera información inteligente para una ruta específica
  static SmartRouteInfo _generateSmartInfo(
      BusRoute route, LatLng destination, bool urgentMode) {
    final arrivalMinutes = _generateArrivalTime();
    final walkingDistance = _calculateWalkingDistance(route, destination);
    final quality =
        _evaluateRouteQuality(route, arrivalMinutes, walkingDistance);

    String recommendation;
    String reason;
    String? urgentMessage;
    String? planB;

    if (urgentMode) {
      if (arrivalMinutes <= 5) {
        recommendation = "🚨 ¡CORRE! Bus llegando";
        reason = "Próximo bus en $arrivalMinutes minutos";
        urgentMessage =
            "🏃‍♂️ Corre ${walkingDistance.toInt()}m hasta la parada";
      } else {
        recommendation = "⏰ Espera este bus";
        reason = "Llegará en $arrivalMinutes minutos";
      }

      // Generar Plan B para modo urgente
      final alternativeRoutes =
          PopayanBusRoutes.findNearbyRoutes(destination, 3.0);
      if (alternativeRoutes.length > 1) {
        final alternative = alternativeRoutes.firstWhere(
          (r) => r.id != route.id,
          orElse: () => alternativeRoutes.first,
        );
        final altTime = _generateArrivalTime() + 5;
        planB = "🆘 Plan B: ${alternative.name} en $altTime minutos";
      }
    } else {
      recommendation = _generateRecommendation(route, quality, arrivalMinutes);
      reason = _generateReason(route, quality, arrivalMinutes, walkingDistance);
    }

    return SmartRouteInfo(
      route: route,
      arrivalMinutes: arrivalMinutes,
      walkingDistance: walkingDistance,
      recommendation: recommendation,
      reason: reason,
      quality: quality,
      isUrgent: urgentMode,
      urgentMessage: urgentMessage,
      planB: planB,
    );
  }

  /// Genera tiempo de llegada simulado
  static int _generateArrivalTime() {
    // Simular tiempos realistas entre 2 y 25 minutos
    final weights = [
      2, 3, 4, 5, 6, 7, 8, 9, 10, // Más probable: 2-10 min
      12, 15, 18, 20, 25 // Menos probable: 12-25 min
    ];
    return weights[_random.nextInt(weights.length)];
  }

  /// Calcula distancia de caminata aproximada
  static double _calculateWalkingDistance(BusRoute route, LatLng destination) {
    // Simular distancia entre 50m y 800m
    return 50 + _random.nextDouble() * 750;
  }

  /// Evalúa la calidad de la ruta
  static RouteQuality _evaluateRouteQuality(
      BusRoute route, int arrivalMinutes, double walkingDistance) {
    int score = 0;

    // Puntuación por tiempo de llegada
    if (arrivalMinutes <= 5)
      score += 3;
    else if (arrivalMinutes <= 10)
      score += 2;
    else if (arrivalMinutes <= 15) score += 1;

    // Puntuación por distancia de caminata
    if (walkingDistance <= 200)
      score += 3;
    else if (walkingDistance <= 400)
      score += 2;
    else if (walkingDistance <= 600) score += 1;

    // Puntuación por empresa (todas son confiables con diferentes características)
    switch (route.company) {
      case 'SOTRACAUCA':
        score += 2; // Muy confiable, servicio establecido
        break;
      case 'TRANSPUBENZA':
        score += 2; // Excelente cobertura y frecuencia
        break;
      case 'TRANSLIBERTAD':
        score += 1; // Buena cobertura, rutas específicas
        break;
      case 'TRANSTAMBO':
        score += 1; // Servicio confiable, rutas estratégicas
        break;
      default:
        score += 1; // Otras empresas
    }

    // Convertir puntuación a calidad
    if (score >= 7) return RouteQuality.excellent;
    if (score >= 5) return RouteQuality.good;
    if (score >= 3) return RouteQuality.average;
    return RouteQuality.poor;
  }

  /// Genera recomendación basada en calidad
  static String _generateRecommendation(
      BusRoute route, RouteQuality quality, int arrivalMinutes) {
    final companyName = route.company;
    final routeDescription =
        route.name.contains(' - ') ? route.name.split(' - ').last : route.name;

    switch (quality) {
      case RouteQuality.excellent:
        return "🥇 Te recomiendo $companyName - $routeDescription";
      case RouteQuality.good:
        return "🥈 Buena opción: $companyName - $routeDescription";
      case RouteQuality.average:
        return "🥉 Opción disponible: $companyName - $routeDescription";
      case RouteQuality.poor:
        return "⚠️ Última opción: $companyName - $routeDescription";
    }
  }

  /// Genera razón de la recomendación
  static String _generateReason(BusRoute route, RouteQuality quality,
      int arrivalMinutes, double walkingDistance) {
    final reasons = <String>[];

    if (arrivalMinutes <= 5) {
      reasons.add("llega muy pronto");
    } else if (arrivalMinutes <= 10) {
      reasons.add("llega en $arrivalMinutes minutos");
    } else {
      reasons.add("tendrás que esperar $arrivalMinutes min");
    }

    if (walkingDistance <= 200) {
      reasons.add("parada muy cerca");
    } else if (walkingDistance <= 400) {
      reasons.add("caminata corta");
    } else {
      reasons.add("parada un poco lejos");
    }

    // Razones específicas por empresa
    switch (route.company) {
      case 'SOTRACAUCA':
        reasons.add("empresa tradicional y confiable");
        break;
      case 'TRANSPUBENZA':
        reasons.add("excelente cobertura urbana");
        break;
      case 'TRANSLIBERTAD':
        reasons.add("rutas directas y eficientes");
        break;
      case 'TRANSTAMBO':
        reasons.add("servicio moderno y puntual");
        break;
      default:
        reasons.add("servicio disponible");
    }

    // Razones por calidad
    switch (quality) {
      case RouteQuality.excellent:
        reasons.add("la mejor opción");
        break;
      case RouteQuality.good:
        reasons.add("buena alternativa");
        break;
      case RouteQuality.average:
        reasons.add("opción estándar");
        break;
      case RouteQuality.poor:
        reasons.add("no es ideal pero funciona");
        break;
    }

    return "¿Por qué? ${reasons.take(2).join(' y ')}";
  }

  /// Obtiene puntuación numérica de calidad
  static int _getQualityScore(RouteQuality quality) {
    switch (quality) {
      case RouteQuality.excellent:
        return 4;
      case RouteQuality.good:
        return 3;
      case RouteQuality.average:
        return 2;
      case RouteQuality.poor:
        return 1;
    }
  }

  /// Genera mensaje conversacional del asistente
  static String generateAssistantMessage(
      List<SmartRouteInfo> routes, bool urgentMode) {
    if (routes.isEmpty) {
      return "😔 No encontré rutas disponibles para este destino";
    }

    if (urgentMode) {
      final fastest = routes.first;
      return "🚨 MODO URGENTE ACTIVADO\n"
          "⚡ Ruta más rápida: ${fastest.route.name}\n"
          "⏱️ Próximo bus: ${fastest.arrivalMinutes} minutos\n"
          "${fastest.urgentMessage ?? ''}\n"
          "📱 Te aviso cuando esté llegando\n"
          "${fastest.planB ?? ''}";
    }

    final count = routes.length;
    String message =
        "🤖 Encontré $count ruta${count > 1 ? 's' : ''} para ti:\n\n";

    for (int i = 0; i < routes.length && i < 3; i++) {
      final route = routes[i];
      final medal = i == 0
          ? "🥇"
          : i == 1
              ? "🥈"
              : "🥉";

      message += "$medal ${route.recommendation}\n";
      message += "   ${route.reason}\n";
      if (i < routes.length - 1) message += "\n";
    }

    if (routes.length >= 2) {
      message += "\n❓ ¿Prefieres velocidad o comodidad?";
    }

    return message;
  }

  /// Obtiene consejos adicionales
  static List<String> getAdditionalTips(List<SmartRouteInfo> routes) {
    final tips = <String>[];

    if (routes.isNotEmpty) {
      final best = routes.first;

      if (best.walkingDistance > 500) {
        tips.add("💡 Tip: Sal con 5 minutos extra por la caminata");
      }

      if (best.arrivalMinutes > 15) {
        tips.add("☕ Tip: Tienes tiempo para un café mientras esperas");
      }

      if (routes.length > 1) {
        tips.add(
            "🔄 Tip: Si pierdes el primero, tienes ${routes.length - 1} alternativa${routes.length > 2 ? 's' : ''}");
      }
    }

    return tips;
  }
}
