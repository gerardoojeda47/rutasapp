import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import 'parada.dart';

/// Estados posibles de una ruta
enum EstadoRuta {
  activa,
  inactiva,
  mantenimiento,
  suspendida;

  /// Convierte un string a EstadoRuta
  static EstadoRuta fromString(String estado) {
    switch (estado.toLowerCase()) {
      case 'activa':
        return EstadoRuta.activa;
      case 'inactiva':
        return EstadoRuta.inactiva;
      case 'mantenimiento':
        return EstadoRuta.mantenimiento;
      case 'suspendida':
        return EstadoRuta.suspendida;
      default:
        return EstadoRuta.inactiva;
    }
  }

  /// Convierte EstadoRuta a string
  String get displayName {
    switch (this) {
      case EstadoRuta.activa:
        return 'Activa';
      case EstadoRuta.inactiva:
        return 'Inactiva';
      case EstadoRuta.mantenimiento:
        return 'En Mantenimiento';
      case EstadoRuta.suspendida:
        return 'Suspendida';
    }
  }

  /// Indica si la ruta está operativa
  bool get isOperativa => this == EstadoRuta.activa;
}

/// Entidad que representa una ruta de transporte público
class Ruta extends Equatable {
  const Ruta({
    required this.id,
    required this.nombre,
    required this.empresa,
    required this.paradas,
    required this.origen,
    required this.destino,
    required this.costo,
    required this.estado,
    this.descripcion,
    this.horarioInicio,
    this.horarioFin,
    this.frecuencia,
    this.distanciaTotal,
    this.tiempoEstimado,
    this.color,
  });

  /// Identificador único de la ruta
  final String id;

  /// Nombre de la ruta (ej: "Ruta 1", "Centro - Terminal")
  final String nombre;

  /// Empresa operadora de la ruta
  final String empresa;

  /// Lista de paradas de la ruta en orden
  final List<Parada> paradas;

  /// Coordenadas del punto de origen
  final LatLng origen;

  /// Coordenadas del punto de destino
  final LatLng destino;

  /// Costo del pasaje en pesos colombianos
  final double costo;

  /// Estado actual de la ruta
  final EstadoRuta estado;

  /// Descripción opcional de la ruta
  final String? descripcion;

  /// Hora de inicio de operación (formato HH:mm)
  final String? horarioInicio;

  /// Hora de fin de operación (formato HH:mm)
  final String? horarioFin;

  /// Frecuencia de buses en minutos
  final int? frecuencia;

  /// Distancia total de la ruta en metros
  final double? distanciaTotal;

  /// Tiempo estimado de recorrido en minutos
  final int? tiempoEstimado;

  /// Color representativo de la ruta (hex)
  final String? color;

  /// Obtiene el nombre completo de la ruta
  String get nombreCompleto {
    if (descripcion != null && descripcion!.isNotEmpty) {
      return '$nombre - $descripcion';
    }
    return nombre;
  }

  /// Indica si la ruta está actualmente operativa
  bool get isOperativa => estado.isOperativa;

  /// Obtiene la primera parada (origen)
  Parada? get paradaOrigen {
    return paradas.isNotEmpty ? paradas.first : null;
  }

  /// Obtiene la última parada (destino)
  Parada? get paradaDestino {
    return paradas.isNotEmpty ? paradas.last : null;
  }

  /// Obtiene el número total de paradas
  int get numeroParadas => paradas.length;

  /// Verifica si la ruta pasa por una parada específica
  bool pasaPorParada(String paradaId) {
    return paradas.any((parada) => parada.id == paradaId);
  }

  /// Obtiene las paradas entre dos puntos específicos
  List<Parada> getParadasEntre(String origenId, String destinoId) {
    final indexOrigen = paradas.indexWhere((p) => p.id == origenId);
    final indexDestino = paradas.indexWhere((p) => p.id == destinoId);

    if (indexOrigen == -1 ||
        indexDestino == -1 ||
        indexOrigen >= indexDestino) {
      return [];
    }

    return paradas.sublist(indexOrigen, indexDestino + 1);
  }

  /// Calcula la distancia aproximada entre dos paradas
  double? getDistanciaEntre(String origenId, String destinoId) {
    final paradaOrigen = paradas.where((p) => p.id == origenId).firstOrNull;
    final paradaDestino = paradas.where((p) => p.id == destinoId).firstOrNull;

    if (paradaOrigen == null || paradaDestino == null) {
      return null;
    }

    return paradaOrigen.distanciaA(paradaDestino);
  }

  /// Crea una copia de la ruta con algunos campos modificados
  Ruta copyWith({
    String? id,
    String? nombre,
    String? empresa,
    List<Parada>? paradas,
    LatLng? origen,
    LatLng? destino,
    double? costo,
    EstadoRuta? estado,
    String? descripcion,
    String? horarioInicio,
    String? horarioFin,
    int? frecuencia,
    double? distanciaTotal,
    int? tiempoEstimado,
    String? color,
  }) {
    return Ruta(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      empresa: empresa ?? this.empresa,
      paradas: paradas ?? this.paradas,
      origen: origen ?? this.origen,
      destino: destino ?? this.destino,
      costo: costo ?? this.costo,
      estado: estado ?? this.estado,
      descripcion: descripcion ?? this.descripcion,
      horarioInicio: horarioInicio ?? this.horarioInicio,
      horarioFin: horarioFin ?? this.horarioFin,
      frecuencia: frecuencia ?? this.frecuencia,
      distanciaTotal: distanciaTotal ?? this.distanciaTotal,
      tiempoEstimado: tiempoEstimado ?? this.tiempoEstimado,
      color: color ?? this.color,
    );
  }

  @override
  List<Object?> get props => [
        id,
        nombre,
        empresa,
        paradas,
        origen,
        destino,
        costo,
        estado,
        descripcion,
        horarioInicio,
        horarioFin,
        frecuencia,
        distanciaTotal,
        tiempoEstimado,
        color,
      ];

  @override
  String toString() {
    return 'Ruta(id: $id, nombre: $nombre, empresa: $empresa, estado: $estado)';
  }
}
