import 'dart:math';
import 'package:latlong2/latlong.dart';
import '../../data/popayan_bus_routes.dart';

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
        final arrivalTime = _random.nextInt(20) + 1; // 1-20 minutos
        final busNumber = _random.nextInt(999) + 100; // Número de bus 100-1098
        final capacity = _random.nextInt(20) + 5; // 5-25 pasajeros
        final isTranspubenza = _random.nextBool();
        
        arrivals.add(BusArrivalInfo(
          routeName: route.name,
          busNumber: busNumber.toString(),
          arrivalTimeMinutes: arrivalTime,
          currentPassengers: capacity,
          maxCapacity: 25,
          isTranspubenza: isTranspubenza,
          nextStop: _getRandomStop(route),
          status: _getRandomStatus(),
        ));
      }
    }
    
    // Ordenar por tiempo de llegada
    arrivals.sort((a, b) => a.arrivalTimeMinutes.compareTo(b.arrivalTimeMinutes));
    
    return arrivals;
  }
  
  /// Obtiene información detallada de rutas para un destino específico
  static List<RouteInfo> getRoutesToDestination(LatLng destination) {
    final routes = PopayanBusRoutes.findNearbyRoutes(destination, 3.0);
    final routeInfos = <RouteInfo>[];
    
    for (final route in routes.take(5)) {
      final distance = PopayanBusRoutes.getDistanceToNearestStop(route, destination);
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
        isTranspubenza: route.name.contains('Transpubenza'),
        stops: route.stops.length,
        nextBus: _getNextBusTime(),
      ));
    }
    
    return routeInfos;
  }
  
  /// Obtiene información de tráfico en tiempo real
  static TrafficInfo getTrafficInfo() {
    final trafficLevels = ['Fluido', 'Moderado', 'Congestionado'];
    final level = trafficLevels[_random.nextInt(trafficLevels.length)];
    final delay = _random.nextInt(10); // 0-10 minutos de retraso
    
    return TrafficInfo(
      level: level,
      delayMinutes: delay,
      description: _getTrafficDescription(level, delay),
    );
  }
  
  static String _getRandomStop(BusRoute route) {
    if (route.stops.isEmpty) return 'Parada Principal';
    final stop = route.stops[_random.nextInt(route.stops.length)];
    return 'Parada en (${stop.latitude.toStringAsFixed(4)}, ${stop.longitude.toStringAsFixed(4)})';
  }
  
  static String _getRandomStatus() {
    final statuses = ['En ruta', 'Llegando', 'En parada', 'Retrasado'];
    return statuses[_random.nextInt(statuses.length)];
  }
  
  static String _getRandomFare() {
    final fares = [r'$2.500', r'$3.000', r'$3.500', r'$4.000'];
    return fares[_random.nextInt(fares.length)];
  }
  
  static String _getRandomFrequency() {
    final frequencies = ['Cada 5 min', 'Cada 8 min', 'Cada 10 min', 'Cada 15 min'];
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
  
  static String _getTrafficDescription(String level, int delay) {
    switch (level) {
      case 'Fluido':
        return 'Tráfico normal, sin retrasos';
      case 'Moderado':
        return delay > 0 ? 'Ligero retraso de $delay min' : 'Tráfico moderado';
      case 'Congestionado':
        return 'Tráfico pesado, retraso de $delay min';
      default:
        return 'Información no disponible';
    }
  }
}

/// Información de llegada de bus
class BusArrivalInfo {
  final String routeName;
  final String busNumber;
  final int arrivalTimeMinutes;
  final int currentPassengers;
  final int maxCapacity;
  final bool isTranspubenza;
  final String nextStop;
  final String status;
  
  BusArrivalInfo({
    required this.routeName,
    required this.busNumber,
    required this.arrivalTimeMinutes,
    required this.currentPassengers,
    required this.maxCapacity,
    required this.isTranspubenza,
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
  final bool isTranspubenza;
  final int stops;
  final String nextBus;
  
  RouteInfo({
    required this.routeName,
    required this.routeNumber,
    required this.distance,
    required this.fare,
    required this.frequency,
    required this.duration,
    required this.isTranspubenza,
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
