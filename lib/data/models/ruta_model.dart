import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import 'package:rouwhite/domain/entities/ruta.dart';
import 'parada_model.dart';

/// Modelo de datos para Ruta con serialización JSON
class RutaModel extends Equatable {
  const RutaModel({
    required this.id,
    required this.nombre,
    required this.empresa,
    required this.paradas,
    required this.origenLat,
    required this.origenLng,
    required this.destinoLat,
    required this.destinoLng,
    required this.costo,
    required this.estado,
    this.descripcion,
    this.horarioInicio,
    this.horarioFin,
    this.frecuencia,
    this.distanciaTotal,
    this.tiempoEstimado,
    this.color,
    this.fechaCreacion,
    this.fechaActualizacion,
  });

  final String id;
  final String nombre;
  final String empresa;
  final List<ParadaModel> paradas;
  final double origenLat;
  final double origenLng;
  final double destinoLat;
  final double destinoLng;
  final double costo;
  final String estado;
  final String? descripcion;
  final String? horarioInicio;
  final String? horarioFin;
  final int? frecuencia;
  final double? distanciaTotal;
  final int? tiempoEstimado;
  final String? color;
  final DateTime? fechaCreacion;
  final DateTime? fechaActualizacion;

  /// Crea un RutaModel desde JSON
  factory RutaModel.fromJson(Map<String, dynamic> json) {
    return RutaModel(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      empresa: json['empresa'] as String,
      paradas: (json['paradas'] as List<dynamic>?)
              ?.map((p) => ParadaModel.fromJson(p as Map<String, dynamic>))
              .toList() ??
          [],
      origenLat: (json['origen_lat'] as num).toDouble(),
      origenLng: (json['origen_lng'] as num).toDouble(),
      destinoLat: (json['destino_lat'] as num).toDouble(),
      destinoLng: (json['destino_lng'] as num).toDouble(),
      costo: (json['costo'] as num).toDouble(),
      estado: json['estado'] as String,
      descripcion: json['descripcion'] as String?,
      horarioInicio: json['horario_inicio'] as String?,
      horarioFin: json['horario_fin'] as String?,
      frecuencia: json['frecuencia'] as int?,
      distanciaTotal: (json['distancia_total'] as num?)?.toDouble(),
      tiempoEstimado: json['tiempo_estimado'] as int?,
      color: json['color'] as String?,
      fechaCreacion: json['fecha_creacion'] != null
          ? DateTime.parse(json['fecha_creacion'] as String)
          : null,
      fechaActualizacion: json['fecha_actualizacion'] != null
          ? DateTime.parse(json['fecha_actualizacion'] as String)
          : null,
    );
  }

  /// Convierte el RutaModel a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'empresa': empresa,
      'paradas': paradas.map((p) => p.toJson()).toList(),
      'origen_lat': origenLat,
      'origen_lng': origenLng,
      'destino_lat': destinoLat,
      'destino_lng': destinoLng,
      'costo': costo,
      'estado': estado,
      'descripcion': descripcion,
      'horario_inicio': horarioInicio,
      'horario_fin': horarioFin,
      'frecuencia': frecuencia,
      'distancia_total': distanciaTotal,
      'tiempo_estimado': tiempoEstimado,
      'color': color,
      'fecha_creacion': fechaCreacion?.toIso8601String(),
      'fecha_actualizacion': fechaActualizacion?.toIso8601String(),
    };
  }

  /// Convierte el modelo a entidad de dominio
  Ruta toEntity() {
    return Ruta(
      id: id,
      nombre: nombre,
      empresa: empresa,
      paradas: paradas.map((p) => p.toEntity()).toList(),
      origen: LatLng(origenLat, origenLng),
      destino: LatLng(destinoLat, destinoLng),
      costo: costo,
      estado: EstadoRuta.fromString(estado),
      descripcion: descripcion,
      horarioInicio: horarioInicio,
      horarioFin: horarioFin,
      frecuencia: frecuencia,
      distanciaTotal: distanciaTotal,
      tiempoEstimado: tiempoEstimado,
      color: color,
    );
  }

  /// Crea un RutaModel desde una entidad de dominio
  factory RutaModel.fromEntity(Ruta ruta) {
    return RutaModel(
      id: ruta.id,
      nombre: ruta.nombre,
      empresa: ruta.empresa,
      paradas: ruta.paradas.map((p) => ParadaModel.fromEntity(p)).toList(),
      origenLat: ruta.origen.latitude,
      origenLng: ruta.origen.longitude,
      destinoLat: ruta.destino.latitude,
      destinoLng: ruta.destino.longitude,
      costo: ruta.costo,
      estado: ruta.estado.name,
      descripcion: ruta.descripcion,
      horarioInicio: ruta.horarioInicio,
      horarioFin: ruta.horarioFin,
      frecuencia: ruta.frecuencia,
      distanciaTotal: ruta.distanciaTotal,
      tiempoEstimado: ruta.tiempoEstimado,
      color: ruta.color,
      fechaCreacion: DateTime.now(),
      fechaActualizacion: DateTime.now(),
    );
  }

  /// Crea una copia del modelo con algunos campos modificados
  RutaModel copyWith({
    String? id,
    String? nombre,
    String? empresa,
    List<ParadaModel>? paradas,
    double? origenLat,
    double? origenLng,
    double? destinoLat,
    double? destinoLng,
    double? costo,
    String? estado,
    String? descripcion,
    String? horarioInicio,
    String? horarioFin,
    int? frecuencia,
    double? distanciaTotal,
    int? tiempoEstimado,
    String? color,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
  }) {
    return RutaModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      empresa: empresa ?? this.empresa,
      paradas: paradas ?? this.paradas,
      origenLat: origenLat ?? this.origenLat,
      origenLng: origenLng ?? this.origenLng,
      destinoLat: destinoLat ?? this.destinoLat,
      destinoLng: destinoLng ?? this.destinoLng,
      costo: costo ?? this.costo,
      estado: estado ?? this.estado,
      descripcion: descripcion ?? this.descripcion,
      horarioInicio: horarioInicio ?? this.horarioInicio,
      horarioFin: horarioFin ?? this.horarioFin,
      frecuencia: frecuencia ?? this.frecuencia,
      distanciaTotal: distanciaTotal ?? this.distanciaTotal,
      tiempoEstimado: tiempoEstimado ?? this.tiempoEstimado,
      color: color ?? this.color,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }

  @override
  List<Object?> get props => [
        id,
        nombre,
        empresa,
        paradas,
        origenLat,
        origenLng,
        destinoLat,
        destinoLng,
        costo,
        estado,
        descripcion,
        horarioInicio,
        horarioFin,
        frecuencia,
        distanciaTotal,
        tiempoEstimado,
        color,
        fechaCreacion,
        fechaActualizacion,
      ];

  @override
  String toString() {
    return 'RutaModel(id: $id, nombre: $nombre, empresa: $empresa, estado: $estado)';
  }
}

/// Lista de modelos de ruta con métodos de utilidad
class RutaModelList extends Equatable {
  const RutaModelList(this.rutas);

  final List<RutaModel> rutas;

  /// Crea desde JSON
  factory RutaModelList.fromJson(List<dynamic> json) {
    return RutaModelList(
      json.map((r) => RutaModel.fromJson(r as Map<String, dynamic>)).toList(),
    );
  }

  /// Convierte a JSON
  List<Map<String, dynamic>> toJson() {
    return rutas.map((r) => r.toJson()).toList();
  }

  /// Convierte a entidades de dominio
  List<Ruta> toEntities() {
    return rutas.map((r) => r.toEntity()).toList();
  }

  /// Filtra rutas por empresa
  RutaModelList filterByEmpresa(String empresa) {
    return RutaModelList(
      rutas
          .where((r) => r.empresa.toLowerCase().contains(empresa.toLowerCase()))
          .toList(),
    );
  }

  /// Filtra rutas por estado
  RutaModelList filterByEstado(String estado) {
    return RutaModelList(
      rutas.where((r) => r.estado == estado).toList(),
    );
  }

  /// Busca rutas por nombre
  RutaModelList searchByNombre(String query) {
    return RutaModelList(
      rutas
          .where((r) => r.nombre.toLowerCase().contains(query.toLowerCase()))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [rutas];
}
