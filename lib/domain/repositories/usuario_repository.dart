import 'package:dartz/dartz.dart';
import '../entities/usuario.dart';
import '../../core/exceptions/app_exceptions.dart';

/// Tipos de falla que pueden ocurrir en operaciones de usuario
abstract class UsuarioFailure extends AppException {
  const UsuarioFailure(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);
}

class UsuarioNotFoundFailure extends UsuarioFailure {
  const UsuarioNotFoundFailure(String usuarioId)
      : super('Usuario con ID $usuarioId no encontrado',
            code: 'USUARIO_NOT_FOUND');
}

class EmailAlreadyExistsFailure extends UsuarioFailure {
  const EmailAlreadyExistsFailure(String email)
      : super('El email $email ya está registrado', code: 'EMAIL_EXISTS');
}

class InvalidCredentialsFailure extends UsuarioFailure {
  const InvalidCredentialsFailure()
      : super('Credenciales inválidas', code: 'INVALID_CREDENTIALS');
}

class WeakPasswordFailure extends UsuarioFailure {
  const WeakPasswordFailure()
      : super('La contraseña es muy débil', code: 'WEAK_PASSWORD');
}

class UsuarioUpdateFailure extends UsuarioFailure {
  const UsuarioUpdateFailure(String message, {dynamic originalError})
      : super(message,
            code: 'USUARIO_UPDATE_ERROR', originalError: originalError);
}

class AuthenticationFailure extends UsuarioFailure {
  const AuthenticationFailure(String message, {dynamic originalError})
      : super(message, code: 'AUTH_ERROR', originalError: originalError);
}

/// Parámetros para registro de usuario
class RegistroParams {
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
}

/// Parámetros para login de usuario
class LoginParams {
  const LoginParams({
    required this.email,
    required this.password,
    this.recordarSesion = false,
  });

  final String email;
  final String password;
  final bool recordarSesion;
}

/// Parámetros para actualización de perfil
class ActualizarPerfilParams {
  const ActualizarPerfilParams({
    this.nombre,
    this.apellido,
    this.telefono,
    this.fechaNacimiento,
    this.fotoPerfil,
  });

  final String? nombre;
  final String? apellido;
  final String? telefono;
  final DateTime? fechaNacimiento;
  final String? fotoPerfil;

  bool get isEmpty =>
      nombre == null &&
      apellido == null &&
      telefono == null &&
      fechaNacimiento == null &&
      fotoPerfil == null;
}

/// Parámetros para cambio de contraseña
class CambiarPasswordParams {
  const CambiarPasswordParams({
    required this.passwordActual,
    required this.passwordNuevo,
  });

  final String passwordActual;
  final String passwordNuevo;
}

/// Resultado de operación de autenticación
class AuthResult {
  const AuthResult({
    required this.usuario,
    required this.token,
    this.refreshToken,
    this.expiresAt,
  });

  final Usuario usuario;
  final String token;
  final String? refreshToken;
  final DateTime? expiresAt;

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  Duration? get tiempoRestante {
    if (expiresAt == null) return null;
    final now = DateTime.now();
    if (now.isAfter(expiresAt!)) return Duration.zero;
    return expiresAt!.difference(now);
  }
}

/// Repositorio para operaciones relacionadas con usuarios
abstract class UsuarioRepository {
  /// Registra un nuevo usuario en el sistema
  Future<Either<UsuarioFailure, AuthResult>> registrar(RegistroParams params);

  /// Inicia sesión con email y contraseña
  Future<Either<UsuarioFailure, AuthResult>> login(LoginParams params);

  /// Cierra la sesión del usuario actual
  Future<Either<UsuarioFailure, void>> logout();

  /// Obtiene el usuario actualmente autenticado
  Future<Either<UsuarioFailure, Usuario?>> obtenerUsuarioActual();

  /// Obtiene un usuario por su ID
  Future<Either<UsuarioFailure, Usuario>> obtenerUsuarioPorId(String id);

  /// Obtiene un usuario por su email
  Future<Either<UsuarioFailure, Usuario>> obtenerUsuarioPorEmail(String email);

  /// Actualiza el perfil del usuario
  Future<Either<UsuarioFailure, Usuario>> actualizarPerfil(
    String usuarioId,
    ActualizarPerfilParams params,
  );

  /// Actualiza las preferencias del usuario
  Future<Either<UsuarioFailure, Usuario>> actualizarPreferencias(
    String usuarioId,
    Map<String, dynamic> preferencias,
  );

  /// Cambia la contraseña del usuario
  Future<Either<UsuarioFailure, void>> cambiarPassword(
    String usuarioId,
    CambiarPasswordParams params,
  );

  /// Sube una foto de perfil
  Future<Either<UsuarioFailure, String>> subirFotoPerfil(
    String usuarioId,
    String rutaArchivo,
  );

  /// Elimina la foto de perfil
  Future<Either<UsuarioFailure, void>> eliminarFotoPerfil(String usuarioId);

  /// Verifica si un email ya está registrado
  Future<Either<UsuarioFailure, bool>> emailExiste(String email);

  /// Envía email de recuperación de contraseña
  Future<Either<UsuarioFailure, void>> enviarRecuperacionPassword(String email);

  /// Restablece la contraseña con un token
  Future<Either<UsuarioFailure, void>> restablecerPassword(
    String token,
    String nuevaPassword,
  );

  /// Verifica el email del usuario
  Future<Either<UsuarioFailure, void>> verificarEmail(String token);

  /// Reenvía el email de verificación
  Future<Either<UsuarioFailure, void>> reenviarVerificacionEmail(String email);

  /// Actualiza el último acceso del usuario
  Future<Either<UsuarioFailure, void>> actualizarUltimoAcceso(String usuarioId);

  /// Desactiva la cuenta del usuario
  Future<Either<UsuarioFailure, void>> desactivarCuenta(String usuarioId);

  /// Reactiva la cuenta del usuario
  Future<Either<UsuarioFailure, void>> reactivarCuenta(String usuarioId);

  /// Elimina permanentemente la cuenta del usuario
  Future<Either<UsuarioFailure, void>> eliminarCuenta(String usuarioId);

  /// Refresca el token de autenticación
  Future<Either<UsuarioFailure, AuthResult>> refrescarToken(
      String refreshToken);

  /// Valida si el token actual es válido
  Future<Either<UsuarioFailure, bool>> validarToken(String token);

  /// Stream del usuario actual para actualizaciones en tiempo real
  Stream<Either<UsuarioFailure, Usuario?>> watchUsuarioActual();

  /// Obtiene estadísticas del usuario
  Future<Either<UsuarioFailure, UsuarioEstadisticas>> obtenerEstadisticas(
      String usuarioId);

  /// Exporta los datos del usuario
  Future<Either<UsuarioFailure, Map<String, dynamic>>> exportarDatos(
      String usuarioId);

  /// Importa datos del usuario
  Future<Either<UsuarioFailure, Usuario>> importarDatos(
    String usuarioId,
    Map<String, dynamic> datos,
  );
}

/// Estadísticas del usuario
class UsuarioEstadisticas {
  const UsuarioEstadisticas({
    required this.diasRegistrado,
    required this.ultimoAcceso,
    required this.numeroFavoritos,
    required this.rutasMasUsadas,
    required this.tiempoPromedioSesion,
    required this.totalSesiones,
  });

  final int diasRegistrado;
  final DateTime? ultimoAcceso;
  final int numeroFavoritos;
  final List<String> rutasMasUsadas;
  final Duration? tiempoPromedioSesion;
  final int totalSesiones;

  bool get esUsuarioActivo =>
      ultimoAcceso != null &&
      DateTime.now().difference(ultimoAcceso!).inDays < 7;

  bool get esUsuarioNuevo => diasRegistrado < 7;

  double get sesionesPromedioPorDia =>
      diasRegistrado > 0 ? totalSesiones / diasRegistrado : 0;
}

