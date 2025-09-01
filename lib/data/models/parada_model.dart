import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import 'package:rouwhite/domain/entities/parada.dart';

/// Modelo de datos para Parada con serialización JSON
class ParadaModel extends Equatable {
  const ParadaModel({
    required this.id,
    required this.nombre,
    required this.latitud,
    required this.longitud,
    required this.tipo,
    this.direccion,
    this.barrio,
    this.comuna,
    this.descripcion,
    this.tieneCobertura = false,
    this.tieneBanco = false,
    this.tieneIluminacion = false,
    this.esAccesible = false,
    this.rutasQueParanAqui = const [],
    this.fechaCreacion,
    this.fechaActualizacion,
  });

  final String id;
  final String nombre;
  final double latitud;
  final double longitud;
  final String tipo;
  final String? direccion;
  final String? barrio;
  final String? comuna;
  final String? descripcion;
  final bool tieneCobertura;
  final bool tieneBanco;
  final bool tieneIluminacion;
  final bool esAccesible;
  final List<String> rutasQueParanAqui;
  final DateTime? fechaCreacion;
  final DateTime? fechaActualizacion;

  /// Crea un ParadaModel desde JSON
  factory ParadaModel.fromJson(Map<String, dynamic> json) {
    return ParadaModel(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      latitud: (json['latitud'] as num).toDouble(),
      longitud: (json['longitud'] as num).toDouble(),
      tipo: json['tipo'] as String,
      direccion: json['direccion'] as String?,
      barrio: json['barrio'] as String?,
      comuna: json['comuna'] as String?,
      descripcion: json['descripcion'] as String?,
      tieneCobertura: json['tiene_cobertura'] as bool? ?? false,
      tieneBanco: json['tiene_banco'] as bool? ?? false,
      tieneIluminacion: json['tiene_iluminacion'] as bool? ?? false,
      esAccesible: json['es_accesible'] as bool? ?? false,
      rutasQueParanAqui: (json['rutas_que_paran_aqui'] as List<dynamic>?)
              ?.map((r) => r as String)
              .toList() ??
          [],
      fechaCreacion: json['fecha_creacion'] != null
          ? DateTime.parse(json['fecha_creacion'] as String)
          : null,
      fechaActualizacion: json['fecha_actualizacion'] != null
          ? DateTime.parse(json['fecha_actualizacion'] as String)
          : null,
    );
  }

  /// Convierte el ParadaModel a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'latitud': latitud,
      'longitud': longitud,
      'tipo': tipo,
      'direccion': direccion,
      'barrio': barrio,
      'comuna': comuna,
      'descripcion': descripcion,
      'tiene_cobertura': tieneCobertura,
      'tiene_banco': tieneBanco,
      'tiene_iluminacion': tieneIluminacion,
      'es_accesible': esAccesible,
      'rutas_que_paran_aqui': rutasQueParanAqui,
      'fecha_creacion': fechaCreacion?.toIso8601String(),
      'fecha_actualizacion': fechaActualizacion?.toIso8601String(),
    };
  }

  /// Convierte el modelo a entidad de dominio
  Parada toEntity() {
    return Parada(
      id: id,
      nombre: nombre,
      coordenadas: LatLng(latitud, longitud),
      tipo: TipoParada.fromString(tipo),
      direccion: direccion,
      barrio: barrio,
      comuna: comuna,
      descripcion: descripcion,
      tieneCobertura: tieneCobertura,
      tieneBanco: tieneBanco,
      tieneIluminacion: tieneIluminacion,
      esAccesible: esAccesible,
      rutasQueParanAqui: rutasQueParanAqui,
    );
  }

  /// Crea un ParadaModel desde una entidad de dominio
  factory ParadaModel.fromEntity(Parada parada) {
    return ParadaModel(
      id: parada.id,
      nombre: parada.nombre,
      latitud: parada.coordenadas.latitude,
      longitud: parada.coordenadas.longitude,
      tipo: parada.tipo.name,
      direccion: parada.direccion,
      barrio: parada.barrio,
      comuna: parada.comuna,
      descripcion: parada.descripcion,
      tieneCobertura: parada.tieneCobertura,
      tieneBanco: parada.tieneBanco,
      tieneIluminacion: parada.tieneIluminacion,
      esAccesible: parada.esAccesible,
      rutasQueParanAqui: parada.rutasQueParanAqui,
      fechaCreacion: DateTime.now(),
      fechaActualizacion: DateTime.now(),
    );
  }

  /// Crea una copia del modelo con algunos campos modificados
  ParadaModel copyWith({
    String? id,
    String? nombre,
    double? latitud,
    double? longitud,
    String? tipo,
    String? direccion,
    String? barrio,
    String? comuna,
    String? descripcion,
    bool? tieneCobertura,
    bool? tieneBanco,
    bool? tieneIluminacion,
    bool? esAccesible,
    List<String>? rutasQueParanAqui,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
  }) {
    return ParadaModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      tipo: tipo ?? this.tipo,
      direccion: direccion ?? this.direccion,
      barrio: barrio ?? this.barrio,
      comuna: comuna ?? this.comuna,
      descripcion: descripcion ?? this.descripcion,
      tieneCobertura: tieneCobertura ?? this.tieneCobertura,
      tieneBanco: tieneBanco ?? this.tieneBanco,
      tieneIluminacion: tieneIluminacion ?? this.tieneIluminacion,
      esAccesible: esAccesible ?? this.esAccesible,
      rutasQueParanAqui: rutasQueParanAqui ?? this.rutasQueParanAqui,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }

  @override
  List<Object?> get props => [
        id,
        nombre,
        latitud,
        longitud,
        tipo,
        direccion,
        barrio,
        comuna,
        descripcion,
        tieneCobertura,
        tieneBanco,
        tieneIluminacion,
        esAccesible,
        rutasQueParanAqui,
        fechaCreacion,
        fechaActualizacion,
      ];

  @override
  String toString() {
    return 'ParadaModel(id: $id, nombre: $nombre, tipo: $tipo, coordenadas: ($latitud, $longitud))';
  }
}

/// Lista de modelos de parada con métodos de utilidad
class ParadaModelList extends Equatable {
  const ParadaModelList(this.paradas);

  final List<ParadaModel> paradas;

  /// Crea desde JSON
  factory ParadaModelList.fromJson(List<dynamic> json) {
    return ParadaModelList(
      json.map((p) => ParadaModel.fromJson(p as Map<String, dynamic>)).toList(),
    );
  }

  /// Convierte a JSON
  List<Map<String, dynamic>> toJson() {
    return paradas.map((p) => p.toJson()).toList();
  }

  /// Convierte a entidades de dominio
  List<Parada> toEntities() {
    return paradas.map((p) => p.toEntity()).toList();
  }

  /// Filtra paradas por tipo
  ParadaModelList filterByTipo(String tipo) {
    return ParadaModelList(
      paradas.where((p) => p.tipo == tipo).toList(),
    );
  }

  /// Filtra paradas por barrio
  ParadaModelList filterByBarrio(String barrio) {
    return ParadaModelList(
      paradas
          .where((p) =>
              p.barrio?.toLowerCase().contains(barrio.toLowerCase()) ?? false)
          .toList(),
    );
  }

  /// Filtra paradas por comuna
  ParadaModelList filterByComuna(String comuna) {
    return ParadaModelList(
      paradas.where((p) => p.comuna == comuna).toList(),
    );
  }

  /// Busca paradas por nombre
  ParadaModelList searchByNombre(String query) {
    return ParadaModelList(
      paradas
          .where((p) => p.nombre.toLowerCase().contains(query.toLowerCase()))
          .toList(),
    );
  }

  /// Filtra paradas con amenidades específicas
  ParadaModelList filterByAmenidades({
    bool? tieneCobertura,
    bool? tieneBanco,
    bool? tieneIluminacion,
    bool? esAccesible,
  }) {
    return ParadaModelList(
      paradas.where((p) {
        if (tieneCobertura != null && p.tieneCobertura != tieneCobertura) {
          return false;
        }
        if (tieneBanco != null && p.tieneBanco != tieneBanco) {
          return false;
        }
        if (tieneIluminacion != null &&
            p.tieneIluminacion != tieneIluminacion) {
          return false;
        }
        if (esAccesible != null && p.esAccesible != esAccesible) {
          return false;
        }
        return true;
      }).toList(),
    );
  }

  @override
  List<Object?> get props => [paradas];
}
