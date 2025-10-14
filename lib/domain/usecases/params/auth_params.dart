import 'package:equatable/equatable.dart';
import '../../entities/usuario.dart';

/// Parámetros para registro de usuario
class RegistroParams extends Equatable {
  const RegistroParams({
    required this.email,
    required this.password,
    required this.nombre,
    this.apellido,
    this.telefono,
    this.fechaNacimiento,
    this.tipo = TipoUsuario.pasajero,
  });

  final String email;
  final String password;
  final String nombre;
  final String? apellido;
  final String? telefono;
  final DateTime? fechaNacimiento;
  final TipoUsuario tipo;

  @override
  List<Object?> get props => [
        email,
        password,
        nombre,
        apellido,
        telefono,
        fechaNacimiento,
        tipo,
      ];

  @override
  String toString() {
    return 'RegistroParams(email: $email, nombre: $nombre, tipo: $tipo)';
  }
}

/// Parámetros para login de usuario
class LoginParams extends Equatable {
  const LoginParams({
    required this.email,
    required this.password,
    this.recordarSesion = false,
  });

  final String email;
  final String password;
  final bool recordarSesion;

  @override
  List<Object?> get props => [email, password, recordarSesion];

  @override
  String toString() {
    return 'LoginParams(email: $email, recordarSesion: $recordarSesion)';
  }
}

