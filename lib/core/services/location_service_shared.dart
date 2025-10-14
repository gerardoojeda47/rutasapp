import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';

class LocationServiceShared {
  static final LocationServiceShared _instance =
      LocationServiceShared._internal();
  factory LocationServiceShared() => _instance;
  LocationServiceShared._internal();

  Position? _currentPosition;
  bool _isLocationEnabled = false;
  bool _isLoading = false;
  StreamSubscription<Position>? _positionStream;

  // Stream controller para notificar cambios
  final StreamController<Position?> _locationController =
      StreamController<Position?>.broadcast();
  Stream<Position?> get locationStream => _locationController.stream;

  Position? get currentPosition => _currentPosition;
  bool get isLocationEnabled => _isLocationEnabled;
  bool get isLoading => _isLoading;

  /// Obtiene la ubicación actual, reutilizando si ya está disponible
  Future<Position?> getCurrentLocation({bool forceRefresh = false}) async {
    // Si ya tenemos ubicación y no se fuerza refresh, devolver la existente
    if (_currentPosition != null && !forceRefresh) {
      debugPrint(
          '📍 Reutilizando ubicación existente: ${_currentPosition!.latitude}, ${_currentPosition!.longitude}');
      return _currentPosition;
    }

    if (_isLoading) {
      debugPrint('⏳ Ya hay una solicitud de ubicación en progreso...');
      // Esperar a que termine la solicitud actual
      await Future.delayed(const Duration(milliseconds: 500));
      return _currentPosition;
    }

    _isLoading = true;
    _notifyListeners();

    try {
      debugPrint('🔍 Iniciando obtención de ubicación...');

      // Verificar si el servicio de ubicación está habilitado
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('❌ Servicio de ubicación deshabilitado');
        _isLoading = false;
        _isLocationEnabled = false;
        _notifyListeners();
        throw Exception('Servicio de ubicación deshabilitado');
      }

      // Verificar permisos
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('❌ Permisos de ubicación denegados');
          _isLoading = false;
          _isLocationEnabled = false;
          _notifyListeners();
          throw Exception('Permisos de ubicación denegados');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('🚫 Permisos de ubicación denegados permanentemente');
        _isLoading = false;
        _isLocationEnabled = false;
        _notifyListeners();
        throw Exception('Permisos de ubicación denegados permanentemente');
      }

      // Intentar obtener ubicación con múltiples configuraciones
      Position? position;

      try {
        // Primer intento: Alta precisión
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 8),
        ).timeout(const Duration(seconds: 10));
      } catch (e) {
        debugPrint('⚠️ Primer intento falló, probando con precisión media: $e');

        try {
          // Segundo intento: Precisión media
          position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.medium,
            timeLimit: const Duration(seconds: 8),
          ).timeout(const Duration(seconds: 10));
        } catch (e2) {
          debugPrint(
              '⚠️ Segundo intento falló, probando con precisión baja: $e2');

          // Tercer intento: Precisión baja
          position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low,
            timeLimit: const Duration(seconds: 5),
          ).timeout(const Duration(seconds: 8));
        }
      }

      _currentPosition = position;
      _isLocationEnabled = true;
      _isLoading = false;

      debugPrint(
          '✅ Ubicación obtenida: ${position?.latitude}, ${position?.longitude}');
      debugPrint('📏 Precisión: ${position?.accuracy} metros');

      _notifyListeners();
      return position;
    } catch (e) {
      debugPrint('💥 Error al obtener ubicación: $e');
      _isLoading = false;
      _isLocationEnabled = false;
      _notifyListeners();
      rethrow;
    }
  }

  /// Inicia el seguimiento continuo de ubicación
  void startLocationTracking() {
    if (_positionStream != null) {
      debugPrint('📡 Ya hay seguimiento de ubicación activo');
      return;
    }

    debugPrint('📡 Iniciando seguimiento continuo de ubicación...');

    const locationSettings = LocationSettings(
      distanceFilter: 10, // Actualizar cada 10 metros
    );

    _positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      (Position position) {
        _currentPosition = position;
        _isLocationEnabled = true;
        _notifyListeners();
        debugPrint(
            '📍 Ubicación actualizada: ${position.latitude}, ${position.longitude}');
      },
      onError: (error) {
        debugPrint('❌ Error en seguimiento de ubicación: $error');
      },
    );
  }

  /// Detiene el seguimiento de ubicación
  void stopLocationTracking() {
    _positionStream?.cancel();
    _positionStream = null;
    debugPrint('🛑 Seguimiento de ubicación detenido');
  }

  /// Convierte Position a LatLng
  LatLng? get currentLatLng {
    if (_currentPosition == null) return null;
    return LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
  }

  /// Notifica a todos los listeners sobre cambios
  void _notifyListeners() {
    if (!_locationController.isClosed) {
      _locationController.add(_currentPosition);
    }
  }

  /// Limpia los recursos
  void dispose() {
    stopLocationTracking();
    _locationController.close();
  }

  /// Resetea el estado (útil para testing)
  void reset() {
    stopLocationTracking();
    _currentPosition = null;
    _isLocationEnabled = false;
    _isLoading = false;
    _notifyListeners();
  }
}
