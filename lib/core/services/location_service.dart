import 'package:geolocator/geolocator.dart';
import '../exceptions/app_exceptions.dart';

/// Abstract interface for location services
abstract class LocationService {
  /// Gets the current location of the device
  Future<Position?> getCurrentLocation();

  /// Gets a stream of location updates
  Stream<Position> getLocationStream();

  /// Requests location permission from the user
  Future<bool> requestPermission();

  /// Checks if location services are enabled
  Future<bool> isLocationServiceEnabled();

  /// Checks current location permission status
  Future<LocationPermission> checkPermission();

  /// Opens location settings
  Future<bool> openLocationSettings();

  /// Opens app settings
  Future<bool> openAppSettings();

  /// Calculates distance between two positions in meters
  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  );

  /// Calculates bearing between two positions
  double calculateBearing(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  );
}

/// Implementation of LocationService using Geolocator
class GeolocatorLocationService implements LocationService {
  static const LocationSettings _locationSettings = LocationSettings(
    
    distanceFilter: 10, // Update every 10 meters
  );

  @override
  Future<Position?> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      final serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw const LocationException(
          'Los servicios de ubicación están deshabilitados',
          code: 'LOCATION_SERVICE_DISABLED',
        );
      }

      // Check and request permission
      final hasPermission = await requestPermission();
      if (!hasPermission) {
        throw const LocationException(
          'Permisos de ubicación denegados',
          code: 'LOCATION_PERMISSION_DENIED',
        );
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desired
          
        ),
      );

      return position;
    } on LocationServiceDisabledException {
      throw const LocationException(
        'Los servicios de ubicación están deshabilitados',
        code: 'LOCATION_SERVICE_DISABLED',
      );
    } on PermissionDeniedException {
      throw const LocationException(
        'Permisos de ubicación denegados',
        code: 'LOCATION_PERMISSION_DENIED',
      );
    } on PermissionDefinitionsNotFoundException {
      throw const LocationException(
        'Permisos de ubicación no definidos en la aplicación',
        code: 'LOCATION_PERMISSION_NOT_DEFINED',
      );
    } on PermissionRequestInProgressException {
      throw const LocationException(
        'Ya hay una solicitud de permisos en progreso',
        code: 'LOCATION_PERMISSION_REQUEST_IN_PROGRESS',
      );
    } catch (e) {
      throw LocationException(
        'Error al obtener la ubicación actual',
        originalError: e,
      );
    }
  }

  @override
  Stream<Position> getLocationStream() {
    return Geolocator.getPositionStream(locationSettings: _locationSettings)
        .handleError((error) {
      if (error is LocationServiceDisabledException) {
        throw const LocationException(
          'Los servicios de ubicación están deshabilitados',
          code: 'LOCATION_SERVICE_DISABLED',
        );
      } else if (error is PermissionDeniedException) {
        throw const LocationException(
          'Permisos de ubicación denegados',
          code: 'LOCATION_PERMISSION_DENIED',
        );
      } else {
        throw LocationException(
          'Error en el stream de ubicación',
          originalError: error,
        );
      }
    });
  }

  @override
  Future<bool> requestPermission() async {
    try {
      LocationPermission permission = await checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      return permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
    } catch (e) {
      throw LocationException(
        'Error al solicitar permisos de ubicación',
        originalError: e,
      );
    }
  }

  @override
  Future<bool> isLocationServiceEnabled() async {
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      throw LocationException(
        'Error al verificar si los servicios de ubicación están habilitados',
        originalError: e,
      );
    }
  }

  @override
  Future<LocationPermission> checkPermission() async {
    try {
      return await Geolocator.checkPermission();
    } catch (e) {
      throw LocationException(
        'Error al verificar permisos de ubicación',
        originalError: e,
      );
    }
  }

  @override
  Future<bool> openLocationSettings() async {
    try {
      return await Geolocator.openLocationSettings();
    } catch (e) {
      throw LocationException(
        'Error al abrir configuración de ubicación',
        originalError: e,
      );
    }
  }

  @override
  Future<bool> openAppSettings() async {
    try {
      return await Geolocator.openAppSettings();
    } catch (e) {
      throw LocationException(
        'Error al abrir configuración de la aplicación',
        originalError: e,
      );
    }
  }

  @override
  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    try {
      return Geolocator.distanceBetween(
        startLatitude,
        startLongitude,
        endLatitude,
        endLongitude,
      );
    } catch (e) {
      throw LocationException(
        'Error al calcular la distancia',
        originalError: e,
      );
    }
  }

  @override
  double calculateBearing(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    try {
      return Geolocator.bearingBetween(
        startLatitude,
        startLongitude,
        endLatitude,
        endLongitude,
      );
    } catch (e) {
      throw LocationException(
        'Error al calcular el rumbo',
        originalError: e,
      );
    }
  }
}

/// Mock implementation for testing
class MockLocationService implements LocationService {
  final Position? _mockPosition;
  final bool _mockServiceEnabled;
  final bool _mockPermissionGranted;

  const MockLocationService({
    Position? mockPosition,
    bool mockServiceEnabled = true,
    bool mockPermissionGranted = true,
  })  : _mockPosition = mockPosition,
        _mockServiceEnabled = mockServiceEnabled,
        _mockPermissionGranted = mockPermissionGranted;

  @override
  Future<Position?> getCurrentLocation() async {
    if (!_mockServiceEnabled) {
      throw const LocationException(
        'Los servicios de ubicación están deshabilitados',
        code: 'LOCATION_SERVICE_DISABLED',
      );
    }

    if (!_mockPermissionGranted) {
      throw const LocationException(
        'Permisos de ubicación denegados',
        code: 'LOCATION_PERMISSION_DENIED',
      );
    }

    return _mockPosition ??
        Position(
          latitude: 2.444814,
          longitude: -76.614739,
          timestamp: DateTime.now(),
          accuracy: 10.0,
          altitude: 1760.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
          altitudeAccuracy: 0.0,
          headingAccuracy: 0.0,
        );
  }

  @override
  Stream<Position> getLocationStream() {
    return Stream.periodic(
      const Duration(seconds: 5),
      (_) =>
          _mockPosition ??
          Position(
            latitude: 2.444814,
            longitude: -76.614739,
            timestamp: DateTime.now(),
            accuracy: 10.0,
            altitude: 1760.0,
            heading: 0.0,
            speed: 0.0,
            speedAccuracy: 0.0,
            altitudeAccuracy: 0.0,
            headingAccuracy: 0.0,
          ),
    );
  }

  @override
  Future<bool> requestPermission() async => _mockPermissionGranted;

  @override
  Future<bool> isLocationServiceEnabled() async => _mockServiceEnabled;

  @override
  Future<LocationPermission> checkPermission() async {
    return _mockPermissionGranted
        ? LocationPermission.whileInUse
        : LocationPermission.denied;
  }

  @override
  Future<bool> openLocationSettings() async => true;

  @override
  Future<bool> openAppSettings() async => true;

  @override
  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  @override
  double calculateBearing(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.bearingBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }
}

