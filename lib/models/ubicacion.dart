import 'package:latlong2/latlong.dart';

class Ubicacion {
  final String nombre;
  final TipoUbicacion tipo;
  final String comuna;
  final LatLng coordenadas;

  Ubicacion({
    required this.nombre,
    required this.tipo,
    required this.comuna,
    required this.coordenadas,
  });

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'tipo': tipo.name,
      'comuna': comuna,
      'latitud': coordenadas.latitude,
      'longitud': coordenadas.longitude,
    };
  }

  factory Ubicacion.fromJson(Map<String, dynamic> json) {
    return Ubicacion(
      nombre: json['nombre'],
      tipo: TipoUbicacion.values.firstWhere(
        (e) => e.name == json['tipo'],
        orElse: () => TipoUbicacion.barrio,
      ),
      comuna: json['comuna'],
      coordenadas: LatLng(json['latitud'], json['longitud']),
    );
  }
}

enum TipoUbicacion {
  barrio,
  zona,
  terminal,
  universidad,
  hospital,
  centroComercial,
  mercado,
  parque,
  museo,
  iglesia,
  monumento,
  aeropuerto,
  vereda;

  String get displayName {
    switch (this) {
      case TipoUbicacion.barrio:
        return 'Barrio';
      case TipoUbicacion.zona:
        return 'Zona';
      case TipoUbicacion.terminal:
        return 'Terminal';
      case TipoUbicacion.universidad:
        return 'Universidad';
      case TipoUbicacion.hospital:
        return 'Hospital';
      case TipoUbicacion.centroComercial:
        return 'Centro Comercial';
      case TipoUbicacion.mercado:
        return 'Mercado';
      case TipoUbicacion.parque:
        return 'Parque';
      case TipoUbicacion.museo:
        return 'Museo';
      case TipoUbicacion.iglesia:
        return 'Iglesia';
      case TipoUbicacion.monumento:
        return 'Monumento';
      case TipoUbicacion.aeropuerto:
        return 'Aeropuerto';
      case TipoUbicacion.vereda:
        return 'Vereda';
    }
  }
}