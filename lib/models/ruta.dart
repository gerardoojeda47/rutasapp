class Ruta {
  final String id;
  final String nombre;
  final String empresa;
  final String trayecto;
  final List<String> paradas;
  final String horarioInicio;
  final String horarioFin;
  final double costo;
  final EstadoTrafico estadoTrafico;
  final int proximoBusMinutos;
  final String busId;

  Ruta({
    required this.id,
    required this.nombre,
    required this.empresa,
    required this.trayecto,
    required this.paradas,
    required this.horarioInicio,
    required this.horarioFin,
    required this.costo,
    required this.estadoTrafico,
    required this.proximoBusMinutos,
    required this.busId,
  });

  String get horarioCompleto => '$horarioInicio - $horarioFin';
  
  String get proximoBusTexto => '$proximoBusMinutos min';

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'empresa': empresa,
      'trayecto': trayecto,
      'paradas': paradas,
      'horarioInicio': horarioInicio,
      'horarioFin': horarioFin,
      'costo': costo,
      'estadoTrafico': estadoTrafico.name,
      'proximoBusMinutos': proximoBusMinutos,
      'busId': busId,
    };
  }

  factory Ruta.fromJson(Map<String, dynamic> json) {
    return Ruta(
      id: json['id'],
      nombre: json['nombre'],
      empresa: json['empresa'],
      trayecto: json['trayecto'],
      paradas: List<String>.from(json['paradas']),
      horarioInicio: json['horarioInicio'],
      horarioFin: json['horarioFin'],
      costo: json['costo'].toDouble(),
      estadoTrafico: EstadoTrafico.values.firstWhere(
        (e) => e.name == json['estadoTrafico'],
        orElse: () => EstadoTrafico.fluido,
      ),
      proximoBusMinutos: json['proximoBusMinutos'],
      busId: json['busId'],
    );
  }

  Ruta copyWith({
    String? id,
    String? nombre,
    String? empresa,
    String? trayecto,
    List<String>? paradas,
    String? horarioInicio,
    String? horarioFin,
    double? costo,
    EstadoTrafico? estadoTrafico,
    int? proximoBusMinutos,
    String? busId,
  }) {
    return Ruta(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      empresa: empresa ?? this.empresa,
      trayecto: trayecto ?? this.trayecto,
      paradas: paradas ?? this.paradas,
      horarioInicio: horarioInicio ?? this.horarioInicio,
      horarioFin: horarioFin ?? this.horarioFin,
      costo: costo ?? this.costo,
      estadoTrafico: estadoTrafico ?? this.estadoTrafico,
      proximoBusMinutos: proximoBusMinutos ?? this.proximoBusMinutos,
      busId: busId ?? this.busId,
    );
  }
}

enum EstadoTrafico {
  fluido,
  moderado,
  congestionado;

  String get displayName {
    switch (this) {
      case EstadoTrafico.fluido:
        return 'Fluido';
      case EstadoTrafico.moderado:
        return 'Moderado';
      case EstadoTrafico.congestionado:
        return 'Congestionado';
    }
  }
}