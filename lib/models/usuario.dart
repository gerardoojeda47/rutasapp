class Usuario {
  final String id;
  final String nombre;
  final String email;
  final String telefono;
  final DateTime fechaRegistro;
  final int viajesRealizados;
  final List<String> rutasFavoritas;
  final Map<String, bool> notificaciones;

  Usuario({
    required this.id,
    required this.nombre,
    required this.email,
    required this.telefono,
    required this.fechaRegistro,
    this.viajesRealizados = 0,
    this.rutasFavoritas = const [],
    this.notificaciones = const {
      'rutaAlertas': true,
      'actualizacionPrecios': true,
      'alertasServicio': true,
      'promociones': false,
    },
  });

  Usuario copyWith({
    String? id,
    String? nombre,
    String? email,
    String? telefono,
    DateTime? fechaRegistro,
    int? viajesRealizados,
    List<String>? rutasFavoritas,
    Map<String, bool>? notificaciones,
  }) {
    return Usuario(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      email: email ?? this.email,
      telefono: telefono ?? this.telefono,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
      viajesRealizados: viajesRealizados ?? this.viajesRealizados,
      rutasFavoritas: rutasFavoritas ?? this.rutasFavoritas,
      notificaciones: notificaciones ?? this.notificaciones,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'email': email,
      'telefono': telefono,
      'fechaRegistro': fechaRegistro.toIso8601String(),
      'viajesRealizados': viajesRealizados,
      'rutasFavoritas': rutasFavoritas,
      'notificaciones': notificaciones,
    };
  }

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nombre: json['nombre'],
      email: json['email'],
      telefono: json['telefono'],
      fechaRegistro: DateTime.parse(json['fechaRegistro']),
      viajesRealizados: json['viajesRealizados'] ?? 0,
      rutasFavoritas: List<String>.from(json['rutasFavoritas'] ?? []),
      notificaciones: Map<String, bool>.from(json['notificaciones'] ?? {}),
    );
  }
}