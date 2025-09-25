import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'package:rouwhite/core/services/bus_prediction_integration.dart';
import 'package:rouwhite/core/services/intelligent_prediction_service.dart';
import 'package:rouwhite/core/services/bus_tracking_service.dart';
import 'package:rouwhite/data/popayan_bus_routes.dart';

/// Ejemplo de uso del sistema de predicción inteligente de buses
void main() async {
  debugPrint('🚌 Sistema de Predicción Inteligente de Buses - Popayán');
  debugPrint('=' * 60);

  // Ubicación de ejemplo: Centro de Popayán
  const userLocation = LatLng(2.4448, -76.6147);
  const destination = LatLng(2.4500, -76.6100); // Norte de Popayán

  debugPrint('\n📍 Ubicación del usuario: Centro de Popayán');
  debugPrint('🎯 Destino: Norte de Popayán');

  // 1. Obtener predicciones completas para la ubicación actual
  debugPrint('\n🔮 Obteniendo predicciones inteligentes...');
  final predictions =
      await BusPredictionIntegration.getPredictionsForLocation(userLocation);

  debugPrint('\n📊 PREDICCIONES PARA TU UBICACIÓN:');
  debugPrint('─' * 50);
  debugPrint(
      '🕐 Última actualización: ${predictions.lastUpdated.toString().substring(11, 19)}');
  debugPrint(
      '🚦 Tráfico: ${predictions.traffic.level} (${predictions.traffic.description})');

  if (predictions.traffic.delayMinutes > 0) {
    debugPrint('⏰ Retraso estimado: ${predictions.traffic.delayMinutes} min');
  }

  debugPrint('\n🚌 PRÓXIMOS BUSES:');
  for (int i = 0; i < predictions.predictions.take(5).length; i++) {
    final pred = predictions.predictions[i];
    final arrival = pred.arrival;

    debugPrint('\n${i + 1}. ${arrival.company} - ${arrival.routeName}');
    debugPrint('   ⏱️  ${arrival.arrivalText}');
    debugPrint('   🚌 Bus #${arrival.busNumber} (${arrival.occupancyText})');
    debugPrint(
        '   📊 ${pred.confidenceText} (${(pred.confidence * 100).toStringAsFixed(1)}%)');
    debugPrint('   📍 ${arrival.nextStop}');
    debugPrint('   ⚡ ${arrival.status}');

    if (pred.timeRangeText != '${arrival.arrivalTimeMinutes} min') {
      debugPrint('   📈 Rango: ${pred.timeRangeText}');
    }
  }

  // 2. Mostrar la mejor predicción
  final best = predictions.bestPrediction;
  if (best != null) {
    debugPrint('\n⭐ MEJOR OPCIÓN:');
    debugPrint('   ${best.arrival.company} - ${best.arrival.routeName}');
    debugPrint('   Llega en ${best.arrival.arrivalTimeMinutes} minutos');
    debugPrint('   Confianza: ${best.confidenceText}');
  }

  // 3. Agrupar por empresa
  debugPrint('\n🏢 PREDICCIONES POR EMPRESA:');
  final grouped = predictions.predictionsByCompany;
  for (final entry in grouped.entries) {
    final company = entry.key;
    final companyPreds = entry.value;
    final avgTime = companyPreds
            .map((p) => p.arrival.arrivalTimeMinutes)
            .reduce((a, b) => a + b) /
        companyPreds.length;

    debugPrint(
        '   $company: ${companyPreds.length} buses (promedio: ${avgTime.toStringAsFixed(1)} min)');
  }

  // 4. Obtener recomendaciones de rutas para un destino
  debugPrint('\n🗺️  RECOMENDACIONES DE RUTAS AL DESTINO:');
  debugPrint('─' * 50);
  final recommendations = BusPredictionIntegration.getRouteRecommendations(
      userLocation, destination);

  for (int i = 0; i < recommendations.take(3).length; i++) {
    final rec = recommendations[i];
    debugPrint('\n${i + 1}. ${rec.route.company} - ${rec.route.name}');
    debugPrint(
        '   ⭐ ${rec.starRating}/5 estrellas (Score: ${rec.score.toStringAsFixed(1)})');
    debugPrint('   ⏱️  ${rec.totalTimeText} total');
    debugPrint('   📝 ${rec.detailedDescription}');
    debugPrint('   💡 ${rec.recommendation}');
  }

  // 5. Mostrar métricas detalladas de una ruta específica
  debugPrint('\n📈 ANÁLISIS DETALLADO DE RUTA:');
  debugPrint('─' * 50);
  final sampleRoute = PopayanBusRoutes.routes.first;
  final metrics = IntelligentPredictionService.calculateRouteMetrics(
      sampleRoute, userLocation, DateTime.now());

  debugPrint('🚌 Ruta: ${sampleRoute.company} - ${sampleRoute.name}');
  debugPrint('📊 Métricas:');
  debugPrint(
      '   🏃 Velocidad promedio: ${metrics.averageSpeed.toStringAsFixed(1)} km/h');
  debugPrint(
      '   ✅ Confiabilidad: ${(metrics.reliability * 100).toStringAsFixed(1)}%');
  debugPrint(
      '   👥 Ocupación: ${(metrics.crowdLevel * 100).toStringAsFixed(1)}%');
  debugPrint(
      '   🚦 Tráfico: ${IntelligentPredictionService.getTrafficDescription(metrics.trafficLevel)}');
  debugPrint('   🌧️  Delay climático: ${metrics.weatherDelay} min');
  debugPrint(
      '   📍 Distancia a parada: ${metrics.distanceToStop.toStringAsFixed(0)}m');

  // 6. Información de tráfico general
  debugPrint('\n🚦 INFORMACIÓN DE TRÁFICO:');
  debugPrint('─' * 50);
  final traffic = BusTrackingService.getTrafficInfo(userLocation);
  debugPrint('📊 Nivel: ${traffic.level}');
  debugPrint('⏰ Retraso: ${traffic.delayMinutes} minutos');
  debugPrint('📝 ${traffic.description}');

  // 7. Consejos basados en las condiciones actuales
  debugPrint('\n💡 CONSEJOS INTELIGENTES:');
  debugPrint('─' * 50);

  final now = DateTime.now();
  final hour = now.hour;
  final isWeekend = now.weekday >= 6;

  if (!isWeekend && (hour >= 7 && hour <= 9 || hour >= 17 && hour <= 19)) {
    debugPrint(
        '⚠️  Hora pico detectada - Considera salir un poco antes o después');
  }

  if (traffic.delayMinutes > 5) {
    debugPrint(
        '🚨 Tráfico congestionado - Agrega ${traffic.delayMinutes} min extra a tu viaje');
  }

  if (metrics.weatherDelay > 0) {
    debugPrint(
        '🌧️  Posible lluvia - Los buses pueden retrasarse ${metrics.weatherDelay} min adicionales');
  }

  final highOccupancyRoutes = predictions.predictions
      .where((p) => p.arrival.occupancyRate > 0.8)
      .length;
  if (highOccupancyRoutes > 0) {
    debugPrint(
        '👥 $highOccupancyRoutes buses están muy llenos - Considera esperar el siguiente');
  }

  debugPrint('\n✨ ¡Que tengas un buen viaje!');
}

/// Función auxiliar para mostrar colores de tráfico
String getTrafficEmoji(TrafficLevel level) {
  switch (level) {
    case TrafficLevel.low:
      return '🟢';
    case TrafficLevel.medium:
      return '🟡';
    case TrafficLevel.high:
      return '🟠';
    case TrafficLevel.veryHigh:
      return '🔴';
  }
}

/// Función auxiliar para mostrar estado del bus
String getBusStatusEmoji(String status) {
  switch (status.toLowerCase()) {
    case 'puntual':
      return '✅';
    case 'en ruta':
      return '🚌';
    case 'llegando':
      return '🏃';
    case 'en parada':
      return '🚏';
    case 'retrasado':
      return '⏰';
    default:
      return '🚌';
  }
}
