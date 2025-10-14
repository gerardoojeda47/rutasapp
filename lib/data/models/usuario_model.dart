import 'package:equatable/equatable.dart';
import 'package:rouwhite/domain/entities/usuario.dart';
import 'package:rouwhite/domain/entities/auth_result.dart';
import 'package:rouwhite/domain/usecases/params/auth_params.dart';

/// Modelo de datos para Usuario con serialización JSON
class UsuarioModel extends Equatable {
  const UsuarioModel({
    required this.id,
    required this.email,
    required this.nombre,
    required this.tipo,
    this.apellido,
    this.telefono,
    this.fechaNacimiento,
    this.fotoPerfil,
    this.fechaRegistro,
    this.ultimoAcceso,
    this.isActivo = true,
    this.preferencias = const {},
    this.fechaCreacion,
    this.fechaActualizacion,
  });

  final String id;
  final String email;
  final String nombre;
  final String tipo;
  final String? apellido;
  final String? telefono;
  final DateTime? fechaNacimiento;
  final String? fotoPerfil;
  final DateTime? fechaRegistro;
  final DateTime? ultimoAcceso;
  final bool isActivo;
  final Map<String, dynamic> preferencias;
  final DateTime? fechaCreacion;
  final DateTime? fechaActualizacion;

  /// Crea un UsuarioModel desde JSON
  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'] as String,
      email: json['email'] as String,
      nombre: json['nombre'] as String,
      tipo: json['tipo'] as String,
      apellido: json['apellido'] as String?,
      telefono: json['telefono'] as String?,
      fechaNacimiento: json['fecha_nacimiento'] != null
          ? DateTime.parse(json['fecha_nacimiento'] as String)
          : null,
      fotoPerfil: json['foto_perfil'] as String?,
      fechaRegistro: json['fecha_registro'] != null
          ? DateTime.parse(json['fecha_registro'] as String)
          : null,
      ultimoAcceso: json['ultimo_acceso'] != null
          ? DateTime.parse(json['ultimo_acceso'] as String)
          : null,
      isActivo: json['is_activo'] as bool? ?? true,
      preferencias: (json['preferencias'] as Map<String, dynamic>?) ?? {},
      fechaCreacion: json['fecha_creacion'] != null
          ? DateTime.parse(json['fecha_creacion'] as String)
          : null,
      fechaActualizacion: json['fecha_actualizacion'] != null
          ? DateTime.parse(json['fecha_actualizacion'] as String)
          : null,
    );
  }

  /// Convierte el UsuarioModel a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'nombre': nombre,
      'tipo': tipo,
      'apellido': apellido,
      'telefono': telefono,
      'fecha_nacimiento': fechaNacimiento?.toIso8601String(),
      'foto_perfil': fotoPerfil,
      'fecha_registro': fechaRegistro?.toIso8601String(),
      'ultimo_acceso': ultimoAcceso?.toIso8601String(),
      'is_activo': isActivo,
      'preferencias': preferencias,
      'fecha_creacion': fechaCreacion?.toIso8601String(),
      'fecha_actualizacion': fechaActualizacion?.toIso8601String(),
    };
  }

  /// Convierte el modelo a entidad de dominio
  Usuario toEntity() {
    return Usuario(
      id: id,
      email: email,
      nombre: nombre,
      tipo: TipoUsuario.fromString(tipo),
      apellido: apellido,
      telefono: telefono,
      fechaNacimiento: fechaNacimiento,
      fotoPerfil: fotoPerfil,
      fechaRegistro: fechaRegistro,
      ultimoAcceso: ultimoAcceso,
      isActivo: isActivo,
      preferencias: preferencias,
    );
  }

  /// Crea un UsuarioModel desde una entidad de dominio
  factory UsuarioModel.fromEntity(Usuario usuario) {
    return UsuarioModel(
      id: usuario.id,
      email: usuario.email,
      nombre: usuario.nombre,
      tipo: usuario.tipo.name,
      apellido: usuario.apellido,
      telefono: usuario.telefono,
      fechaNacimiento: usuario.fechaNacimiento,
      fotoPerfil: usuario.fotoPerfil,
      fechaRegistro: usuario.fechaRegistro,
      ultimoAcceso: usuario.ultimoAcceso,
      isActivo: usuario.isActivo,
      preferencias: usuario.preferencias,
      fechaCreacion: DateTime.now(),
      fechaActualizacion: DateTime.now(),
    );
  }

  /// Crea una copia del modelo con algunos campos modificados
  UsuarioModel copyWith({
    String? id,
    String? email,
    String? nombre,
    String? tipo,
    String? apellido,
    String? telefono,
    DateTime? fechaNacimiento,
    String? fotoPerfil,
    DateTime? fechaRegistro,
    DateTime? ultimoAcceso,
    bool? isActivo,
    Map<String, dynamic>? preferencias,
    DateTime? fechaCreacion,
    DateTime? fechaActualizacion,
  }) {
    return UsuarioModel(
      id: id ?? this.id,
      email: email ?? this.email,
      nombre: nombre ?? this.nombre,
      tipo: tipo ?? this.tipo,
      apellido: apellido ?? this.apellido,
      telefono: telefono ?? this.telefono,
      fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
      fotoPerfil: fotoPerfil ?? this.fotoPerfil,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
      ultimoAcceso: ultimoAcceso ?? this.ultimoAcceso,
      isActivo: isActivo ?? this.isActivo,
      preferencias: preferencias ?? this.preferencias,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaActualizacion: fechaActualizacion ?? this.fechaActualizacion,
    );
  }

  /// Actualiza las preferencias del usuario
  UsuarioModel actualizarPreferencias(Map<String, dynamic> nuevasPreferencias) {
    final preferenciasCombinadas = Map<String, dynamic>.from(preferencias);
    preferenciasCombinadas.addAll(nuevasPreferencias);

    return copyWith(
      preferencias: preferenciasCombinadas,
      fechaActualizacion: DateTime.now(),
    );
  }

  /// Actualiza una preferencia específica
  UsuarioModel actualizarPreferencia(String key, dynamic value) {
    return actualizarPreferencias({key: value});
  }

  /// Actualiza el último acceso
  UsuarioModel actualizarUltimoAcceso() {
    return copyWith(
      ultimoAcceso: DateTime.now(),
      fechaActualizacion: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        nombre,
        tipo,
        apellido,
        telefono,
        fechaNacimiento,
        fotoPerfil,
        fechaRegistro,
        ultimoAcceso,
        isActivo,
        preferencias,
        fechaCreacion,
        fechaActualizacion,
      ];

  @override
  String toString() {
    return 'UsuarioModel(id: $id, email: $email, nombre: $nombre, tipo: $tipo)';
  }
}

/// Modelo para respuesta de autenticación
class AuthResponseModel extends Equatable {
  const AuthResponseModel({
    required this.usuario,
    required this.token,
    this.refreshToken,
    this.expiresAt,
  });

  final UsuarioModel usuario;
  final String token;
  final String? refreshToken;
  final DateTime? expiresAt;

  /// Crea desde JSON
  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      usuario: UsuarioModel.fromJson(json['usuario'] as Map<String, dynamic>),
      token: json['token'] as String,
      refreshToken: json['refresh_token'] as String?,
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'] as String)
          : null,
    );
  }

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'usuario': usuario.toJson(),
      'token': token,
      'refresh_token': refreshToken,
      'expires_at': expiresAt?.toIso8601String(),
    };
  }

  /// Convierte a entidad de dominio
  AuthResult toEntity() {
    return AuthResult(
      usuario: usuario.toEntity(),
      token: token,
      refreshToken: refreshToken,
      expiresAt: expiresAt,
    );
  }

  @override
  List<Object?> get props => [usuario, token, refreshToken, expiresAt];
}

/// Modelo para solicitud de registro
class RegistroRequestModel extends Equatable {
  const RegistroRequestModel({
    required this.email,
    required this.password,
    required this.nombre,
    this.apellido,
    this.telefono,
    this.fechaNacimiento,
    this.tipo = 'pasajero',
  });

  final String email;
  final String password;
  final String nombre;
  final String? apellido;
  final String? telefono;
  final DateTime? fechaNacimiento;
  final String tipo;

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'nombre': nombre,
      'apellido': apellido,
      'telefono': telefono,
      'fecha_nacimiento': fechaNacimiento?.toIso8601String(),
      'tipo': tipo,
    };
  }

  /// Crea desde parámetros de dominio
  factory RegistroRequestModel.fromParams(RegistroParams params) {
    return RegistroRequestModel(
      email: params.email,
      password: params.password,
      nombre: params.nombre,
      apellido: params.apellido,
      telefono: params.telefono,
      fechaNacimiento: params.fechaNacimiento,
      tipo: params.tipo.name,
    );
  }

  @override
  List<Object?> get props =>
      [email, password, nombre, apellido, telefono, fechaNacimiento, tipo];
}

/// Modelo para solicitud de login
class LoginRequestModel extends Equatable {
  const LoginRequestModel({
    required this.email,
    required this.password,
    this.recordarSesion = false,
  });

  final String email;
  final String password;
  final bool recordarSesion;

  /// Convierte a JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'recordar_sesion': recordarSesion,
    };
  }

  /// Crea desde parámetros de dominio
  factory LoginRequestModel.fromParams(LoginParams params) {
    return LoginRequestModel(
      email: params.email,
      password: params.password,
      recordarSesion: params.recordarSesion,
    );
  }

  @override
  List<Object?> get props => [email, password, recordarSesion];
}

