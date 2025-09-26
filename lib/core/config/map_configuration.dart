import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Configuración optimizada para mapas de Popayán, Colombia
class MapConfiguration {
  // Coordenadas del centro de Popayán
  static const LatLng popayanCenter = LatLng(2.4389, -76.6064);

  // Límites geográficos de Popayán y área metropolitana
  static final LatLngBounds popayanBounds = LatLngBounds(
    const LatLng(2.3800, -76.6800), // Suroeste
    const LatLng(2.5000, -76.5300), // Noreste
  );

  // Niveles de zoom optimizados para Popayán
  static const double minZoomPopayan = 10.0; // Vista general de la ciudad
  static const double maxZoomPopayan =
      17.0; // Nivel máximo con tiles disponibles
  static const double defaultZoom = 15.0; // Zoom inicial óptimo

  /// Crea opciones de mapa optimizadas para Popayán
  static MapOptions createOptimizedMapOptions({
    LatLng? initialCenter,
    double? initialZoom,
  }) {
    return MapOptions(
      initialCenter: initialCenter ?? popayanCenter,
      initialZoom: initialZoom ?? defaultZoom,
      minZoom: minZoomPopayan,
      maxZoom: maxZoomPopayan,
      // Restringir la cámara al área de Popayán para mejor performance
      cameraConstraint: CameraConstraint.contain(
        bounds: popayanBounds,
      ),
      // Configuraciones de interacción optimizadas
      interactionOptions: const InteractionOptions(
        flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        enableMultiFingerGestureRace: true,
        scrollWheelVelocity: 0.005,
      ),
    );
  }

  /// Valida si un nivel de zoom es apropiado para Popayán
  static bool isValidZoomLevel(double zoom) {
    return zoom >= minZoomPopayan && zoom <= maxZoomPopayan;
  }

  /// Ajusta un nivel de zoom al rango válido
  static double clampZoomLevel(double zoom) {
    return zoom.clamp(minZoomPopayan, maxZoomPopayan);
  }

  /// Verifica si una coordenada está dentro del área de Popayán
  static bool isWithinPopayanBounds(LatLng position) {
    return popayanBounds.contains(position);
  }
}
