import 'dart:math';
import 'package:latlong2/latlong.dart';
import '../../data/popayan_bus_routes.dart';
import 'intelligent_prediction_service.dart';

/// Servicio para simular el seguimiento de buses en tiempo real
class BusTrackingService {
  static final Random _random = Random();

  /// Simula información de buses en tiempo real para una ubicación
  static List<BusArrivalInfo> getBusArrivals(LatLng location) {
    final nearbyRoutes = PopayanBusRoutes.findNearbyRoutes(location, 2.0);
    final arrivals = <BusArrivalInfo>[];

    for (final route in nearbyRoutes.take(3)) {
      // Simular diferentes buses de la misma ruta
      final busCount = _random.nextInt(2) + 1; // 1-2 buses por ruta

      for (int i = 0; i < busCount; i++) {
        // Usar predicción inteligente en lugar de tiempo aleatorio
        final arrivalTime =
            IntelligentPredictionService.predictBusArrival(route, location);
        final busNumber = _random.nextInt(999) + 100;

        // Calcular métricas para ocupación realista
        final metrics = IntelligentPredictionService.calculateRouteMetrics(
            route, location, DateTime.now());
        final capacity = (metrics.crowdLevel * 25).round();

        arrivals.add(BusArrivalInfo(
          routeName: route.name,
          busNumber: busNumber.toString(),
          arrivalTimeMinutes: arrivalTime,
          currentPassengers: capacity,
          maxCapacity: 25,
          company: route.company,
          nextStop: _getRandomStop(route),
          status: _getIntelligentStatus(metrics),
        ));
      }
    }

    // Ordenar por tiempo de llegada
    arrivals
        .sort((a, b) => a.arrivalTimeMinutes.compareTo(b.arrivalTimeMinutes));

    return arrivals;
  }

  /// Obtiene información detallada de rutas para un destino específico
  static List<RouteInfo> getRoutesToDestination(LatLng destination) {
    final routes = PopayanBusRoutes.findNearbyRoutes(destination, 3.0);
    final routeInfos = <RouteInfo>[];

    for (final route in routes.take(5)) {
      final distance =
          PopayanBusRoutes.getDistanceToNearestStop(route, destination);
      final fare = _getRandomFare();
      final frequency = _getRandomFrequency();
      final duration = _calculateDuration(distance);

      routeInfos.add(RouteInfo(
        routeName: route.name,
        routeNumber: route.name.split(' ').last,
        distance: distance,
        fare: fare,
        frequency: frequency,
        duration: duration,
        company: route.company,
        stops: route.stops.length,
        nextBus: _getNextBusTime(),
      ));
    }

    return routeInfos;
  }

  /// Obtiene información de tráfico inteligente
  static TrafficInfo getTrafficInfo([LatLng? location]) {
    final now = DateTime.now();
    final defaultLocation =
        location ?? LatLng(2.4448, -76.6147); // Centro Popayán

    // Crear una ruta temporal para obtener métricas
    final tempRoute = PopayanBusRoutes.routes.first;
    final metrics = IntelligentPredictionService.calculateRouteMetrics(
        tempRoute, defaultLocation, now);

    final levelText = IntelligentPredictionService.getTrafficDescription(
        metrics.trafficLevel);
    final delay = _calculateTrafficDelayFromLevel(metrics.trafficLevel);

    return TrafficInfo(
      level: levelText,
      delayMinutes: delay,
      description:
          _getIntelligentTrafficDescription(metrics.trafficLevel, delay, now),
    );
  }

  /// Calcula delay basado en nivel de tráfico
  static int _calculateTrafficDelayFromLevel(TrafficLevel level) {
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

  /// Genera descripción inteligente del tráfico
  static String _getIntelligentTrafficDescription(
      TrafficLevel level, int delay, DateTime time) {
    final hour = time.hour;
    final isWeekend = time.weekday >= 6;

    switch (level) {
      case TrafficLevel.low:
        return isWeekend ? 'Fin de semana tranquilo' : 'Vías despejadas';
      case TrafficLevel.medium:
        return 'Tráfico normal para esta hora';
      case TrafficLevel.high:
        if (hour >= 7 && hour <= 9) return 'Hora pico matutina';
        if (hour >= 17 && hour <= 19) return 'Hora pico vespertina';
        return 'Tráfico denso en el centro';
      case TrafficLevel.veryHigh:
        return 'Congestión severa - considera rutas alternas';
    }
  }

  static String _getRandomStop(BusRoute route) {
    if (route.stops.isEmpty) return 'Parada Principal';
    final stop = route.stops[_random.nextInt(route.stops.length)];
    return 'Parada en (${stop.latitude.toStringAsFixed(4)}, ${stop.longitude.toStringAsFixed(4)})';
  }

  /// Genera estado inteligente basado en métricas
  static String _getIntelligentStatus(RouteMetrics metrics) {
    // Estado basado en confiabilidad y tráfico
    if (metrics.reliability > 0.9 && metrics.trafficLevel == TrafficLevel.low) {
      return 'Puntual';
    } else if (metrics.trafficLevel == TrafficLevel.veryHigh) {
      return 'Retrasado';
    } else if (metrics.crowdLevel > 0.8) {
      return 'En parada'; // Bus lleno, para más tiempo
    } else {
      return 'En ruta';
    }
  }

  static String _getRandomFare() {
    final fares = [r'$2.500', r'$3.000', r'$3.500', r'$4.000'];
    return fares[_random.nextInt(fares.length)];
  }

  static String _getRandomFrequency() {
    final frequencies = [
      'Cada 5 min',
      'Cada 8 min',
      'Cada 10 min',
      'Cada 15 min'
    ];
    return frequencies[_random.nextInt(frequencies.length)];
  }

  static int _calculateDuration(double distanceKm) {
    // Aproximadamente 1 minuto por cada 0.5 km
    return (distanceKm / 0.5).round().clamp(5, 60);
  }

  static String _getNextBusTime() {
    final minutes = _random.nextInt(15) + 1;
    return 'En $minutes min';
  }
}

/// Información de llegada de bus
class BusArrivalInfo {
  final String routeName;
  final String busNumber;
  final int arrivalTimeMinutes;
  final int currentPassengers;
  final int maxCapacity;
  final String company;
  final String nextStop;
  final String status;

  BusArrivalInfo({
    required this.routeName,
    required this.busNumber,
    required this.arrivalTimeMinutes,
    required this.currentPassengers,
    required this.maxCapacity,
    required this.company,
    required this.nextStop,
    required this.status,
  });

  double get occupancyRate => currentPassengers / maxCapacity;

  String get occupancyText {
    if (occupancyRate < 0.5) return 'Disponible';
    if (occupancyRate < 0.8) return 'Ocupado';
    return 'Lleno';
  }

  String get arrivalText {
    if (arrivalTimeMinutes == 1) return 'Llega en 1 minuto';
    return 'Llega en $arrivalTimeMinutes minutos';
  }
}

/// Información de ruta
class RouteInfo {
  final String routeName;
  final String routeNumber;
  final double distance;
  final String fare;
  final String frequency;
  final int duration;
  final String company;
  final int stops;
  final String nextBus;

  RouteInfo({
    required this.routeName,
    required this.routeNumber,
    required this.distance,
    required this.fare,
    required this.frequency,
    required this.duration,
    required this.company,
    required this.stops,
    required this.nextBus,
  });

  String get distanceText {
    if (distance < 1.0) {
      return '${(distance * 1000).round()}m';
    }
    return '${distance.toStringAsFixed(1)}km';
  }

  String get durationText {
    if (duration < 60) {
      return '${duration} min';
    }
    final hours = duration ~/ 60;
    final minutes = duration % 60;
    return '${hours}h ${minutes}min';
  }
}

/// Información de tráfico
class TrafficInfo {
  final String level;
  final int delayMinutes;
  final String description;

  TrafficInfo({
    required this.level,
    required this.delayMinutes,
    required this.description,
  });

  String get levelText {
    switch (level) {
      case 'Fluido':
        return 'Fluido';
      case 'Moderado':
        return 'Moderado';
      case 'Congestionado':
        return 'Congestionado';
      default:
        return 'Desconocido';
    }
  }
}

