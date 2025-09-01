import 'package:dartz/dartz.dart';
import '../entities/usuario.dart';
import '../repositories/usuario_repository.dart';
import '../../core/utils/validators.dart';

/// Caso de uso para registrar un nuevo usuario
class RegistrarUsuarioUseCase {
  const RegistrarUsuarioUseCase(this._repository);

  final UsuarioRepository _repository;

  /// Ejecuta el caso de uso para registrar un usuario
  Future<Either<UsuarioFailure, AuthResult>> call(RegistroParams params) async {
    // Validaciones de entrada
    final emailValidation = Validators.validateEmail(params.email);
    if (emailValidation != null) {
      return Left(ValidationFailure(emailValidation));
    }

    final passwordValidation = Validators.validatePassword(params.password);
    if (passwordValidation != null) {
      return Left(WeakPasswordFailure());
    }

    final nombreValidation = Validators.validateName(params.nombre);
    if (nombreValidation != null) {
      return Left(ValidationFailure(nombreValidation));
    }

    if (params.apellido != null) {
      final apellidoValidation = Validators.validateName(params.apellido!);
      if (apellidoValidation != null) {
        return Left(ValidationFailure(apellidoValidation));
      }
    }

    if (params.telefono != null) {
      final telefonoValidation = Validators.validatePhone(params.telefono!);
      if (telefonoValidation != null) {
        return Left(ValidationFailure(telefonoValidation));
      }
    }

    // Verificar si el email ya existe
    final emailExistsResult = await _repository.emailExiste(params.email);
    return emailExistsResult.fold(
      (failure) => Left(failure),
      (exists) async {
        if (exists) {
          return Left(EmailAlreadyExistsFailure(params.email));
        }

        return await _repository.registrar(params);
      },
    );
  }
}

/// Caso de uso para iniciar sesión
class LoginUsuarioUseCase {
  const LoginUsuarioUseCase(this._repository);

  final UsuarioRepository _repository;

  /// Ejecuta el caso de uso para login
  Future<Either<UsuarioFailure, AuthResult>> call(LoginParams params) async {
    // Validaciones de entrada
    final emailValidation = Validators.validateEmail(params.email);
    if (emailValidation != null) {
      return Left(ValidationFailure(emailValidation));
    }

    if (params.password.isEmpty) {
      return const Left(ValidationFailure('La contraseña es requerida'));
    }

    return await _repository.login(params);
  }
}

/// Caso de uso para cerrar sesión
class LogoutUsuarioUseCase {
  const LogoutUsuarioUseCase(this._repository);

  final UsuarioRepository _repository;

  /// Ejecuta el caso de uso para logout
  Future<Either<UsuarioFailure, void>> call() async {
    return await _repository.logout();
  }
}

/// Caso de uso para obtener el usuario actual
class ObtenerUsuarioActualUseCase {
  const ObtenerUsuarioActualUseCase(this._repository);

  final UsuarioRepository _repository;

  /// Ejecuta el caso de uso para obtener el usuario actual
  Future<Either<UsuarioFailure, Usuario?>> call() async {
    return await _repository.obtenerUsuarioActual();
  }
}

/// Caso de uso para obtener un usuario por ID
class ObtenerUsuarioPorIdUseCase {
  const ObtenerUsuarioPorIdUseCase(this._repository);

  final UsuarioRepository _repository;

  /// Ejecuta el caso de uso para obtener un usuario por ID
  Future<Either<UsuarioFailure, Usuario>> call(String usuarioId) async {
    if (usuarioId.isEmpty) {
      return const Left(UsuarioNotFoundFailure(''));
    }

    return await _repository.obtenerUsuarioPorId(usuarioId);
  }
}

/// Caso de uso para actualizar el perfil del usuario
class ActualizarPerfilUseCase {
  const ActualizarPerfilUseCase(this._repository);

  final UsuarioRepository _repository;

  /// Ejecuta el caso de uso para actualizar perfil
  Future<Either<UsuarioFailure, Usuario>> call(
    String usuarioId,
    ActualizarPerfilParams params,
  ) async {
    if (usuarioId.isEmpty) {
      return const Left(UsuarioUpdateFailure('ID de usuario requerido'));
    }

    if (params.isEmpty) {
      return const Left(UsuarioUpdateFailure('No hay datos para actualizar'));
    }

    // Validaciones de los campos a actualizar
    if (params.nombre != null) {
      final nombreValidation = Validators.validateName(params.nombre!);
      if (nombreValidation != null) {
        return Left(ValidationFailure(nombreValidation));
      }
    }

    if (params.apellido != null) {
      final apellidoValidation = Validators.validateName(params.apellido!);
      if (apellidoValidation != null) {
        return Left(ValidationFailure(apellidoValidation));
      }
    }

    if (params.telefono != null) {
      final telefonoValidation = Validators.validatePhone(params.telefono!);
      if (telefonoValidation != null) {
        return Left(ValidationFailure(telefonoValidation));
      }
    }

    return await _repository.actualizarPerfil(usuarioId, params);
  }
}

/// Caso de uso para cambiar contraseña
class CambiarPasswordUseCase {
  const CambiarPasswordUseCase(this._repository);

  final UsuarioRepository _repository;

  /// Ejecuta el caso de uso para cambiar contraseña
  Future<Either<UsuarioFailure, void>> call(
    String usuarioId,
    CambiarPasswordParams params,
  ) async {
    if (usuarioId.isEmpty) {
      return const Left(UsuarioUpdateFailure('ID de usuario requerido'));
    }

    // Validaciones
    if (params.passwordActual.isEmpty) {
      return const Left(ValidationFailure('La contraseña actual es requerida'));
    }

    final passwordValidation =
        Validators.validatePassword(params.passwordNuevo);
    if (passwordValidation != null) {
      return Left(WeakPasswordFailure());
    }

    if (params.passwordActual == params.passwordNuevo) {
      return const Left(ValidationFailure(
          'La nueva contraseña debe ser diferente a la actual'));
    }

    return await _repository.cambiarPassword(usuarioId, params);
  }
}

/// Caso de uso para subir foto de perfil
class SubirFotoPerfilUseCase {
  const SubirFotoPerfilUseCase(this._repository);

  final UsuarioRepository _repository;

  /// Ejecuta el caso de uso para subir foto de perfil
  Future<Either<UsuarioFailure, String>> call(
    String usuarioId,
    String rutaArchivo,
  ) async {
    if (usuarioId.isEmpty) {
      return const Left(UsuarioUpdateFailure('ID de usuario requerido'));
    }

    if (rutaArchivo.isEmpty) {
      return const Left(UsuarioUpdateFailure('Ruta del archivo requerida'));
    }

    return await _repository.subirFotoPerfil(usuarioId, rutaArchivo);
  }
}

/// Caso de uso para recuperar contraseña
class RecuperarPasswordUseCase {
  const RecuperarPasswordUseCase(this._repository);

  final UsuarioRepository _repository;

  /// Ejecuta el caso de uso para enviar email de recuperación
  Future<Either<UsuarioFailure, void>> call(String email) async {
    final emailValidation = Validators.validateEmail(email);
    if (emailValidation != null) {
      return Left(ValidationFailure(emailValidation));
    }

    return await _repository.enviarRecuperacionPassword(email);
  }
}

/// Caso de uso para restablecer contraseña
class RestablecerPasswordUseCase {
  const RestablecerPasswordUseCase(this._repository);

  final UsuarioRepository _repository;

  /// Ejecuta el caso de uso para restablecer contraseña
  Future<Either<UsuarioFailure, void>> call(
    String token,
    String nuevaPassword,
  ) async {
    if (token.isEmpty) {
      return const Left(ValidationFailure('Token requerido'));
    }

    final passwordValidation = Validators.validatePassword(nuevaPassword);
    if (passwordValidation != null) {
      return Left(WeakPasswordFailure());
    }

    return await _repository.restablecerPassword(token, nuevaPassword);
  }
}

/// Caso de uso para verificar email
class VerificarEmailUseCase {
  const VerificarEmailUseCase(this._repository);

  final UsuarioRepository _repository;

  /// Ejecuta el caso de uso para verificar email
  Future<Either<UsuarioFailure, void>> call(String token) async {
    if (token.isEmpty) {
      return const Left(ValidationFailure('Token requerido'));
    }

    return await _repository.verificarEmail(token);
  }
}

/// Caso de uso para reenviar verificación de email
class ReenviarVerificacionEmailUseCase {
  const ReenviarVerificacionEmailUseCase(this._repository);

  final UsuarioRepository _repository;

  /// Ejecuta el caso de uso para reenviar verificación
  Future<Either<UsuarioFailure, void>> call(String email) async {
    final emailValidation = Validators.validateEmail(email);
    if (emailValidation != null) {
      return Left(ValidationFailure(emailValidation));
    }

    return await _repository.reenviarVerificacionEmail(email);
  }
}

/// Caso de uso para actualizar preferencias
class ActualizarPreferenciasUseCase {
  const ActualizarPreferenciasUseCase(this._repository);

  final UsuarioRepository _repository;

  /// Ejecuta el caso de uso para actualizar preferencias
  Future<Either<UsuarioFailure, Usuario>> call(
    String usuarioId,
    Map<String, dynamic> preferencias,
  ) async {
    if (usuarioId.isEmpty) {
      return const Left(UsuarioUpdateFailure('ID de usuario requerido'));
    }

    if (preferencias.isEmpty) {
      return const Left(
          UsuarioUpdateFailure('No hay preferencias para actualizar'));
    }

    return await _repository.actualizarPreferencias(usuarioId, preferencias);
  }
}

/// Caso de uso para refrescar token
class RefrescarTokenUseCase {
  const RefrescarTokenUseCase(this._repository);

  final UsuarioRepository _repository;

  /// Ejecuta el caso de uso para refrescar token
  Future<Either<UsuarioFailure, AuthResult>> call(String refreshToken) async {
    if (refreshToken.isEmpty) {
      return const Left(AuthenticationFailure('Refresh token requerido'));
    }

    return await _repository.refrescarToken(refreshToken);
  }
}

/// Caso de uso para validar token
class ValidarTokenUseCase {
  const ValidarTokenUseCase(this._repository);

  final UsuarioRepository _repository;

  /// Ejecuta el caso de uso para validar token
  Future<Either<UsuarioFailure, bool>> call(String token) async {
    if (token.isEmpty) {
      return const Right(false);
    }

    return await _repository.validarToken(token);
  }
}

/// Caso de uso para obtener estadísticas del usuario
class ObtenerEstadisticasUsuarioUseCase {
  const ObtenerEstadisticasUsuarioUseCase(this._repository);

  final UsuarioRepository _repository;

  /// Ejecuta el caso de uso para obtener estadísticas
  Future<Either<UsuarioFailure, UsuarioEstadisticas>> call(
      String usuarioId) async {
    if (usuarioId.isEmpty) {
      return const Left(UsuarioNotFoundFailure(''));
    }

    return await _repository.obtenerEstadisticas(usuarioId);
  }
}

/// Caso de uso compuesto para autenticación completa
class AutenticarUsuarioUseCase {
  const AutenticarUsuarioUseCase({
    required this.registrar,
    required this.login,
    required this.logout,
    required this.obtenerUsuarioActual,
    required this.actualizarPerfil,
    required this.cambiarPassword,
    required this.recuperarPassword,
    required this.verificarEmail,
    required this.refrescarToken,
    required this.validarToken,
  });

  final RegistrarUsuarioUseCase registrar;
  final LoginUsuarioUseCase login;
  final LogoutUsuarioUseCase logout;
  final ObtenerUsuarioActualUseCase obtenerUsuarioActual;
  final ActualizarPerfilUseCase actualizarPerfil;
  final CambiarPasswordUseCase cambiarPassword;
  final RecuperarPasswordUseCase recuperarPassword;
  final VerificarEmailUseCase verificarEmail;
  final RefrescarTokenUseCase refrescarToken;
  final ValidarTokenUseCase validarToken;
}

/// Falla de validación personalizada
class ValidationFailure extends UsuarioFailure {
  const ValidationFailure(String message)
      : super(message, code: 'VALIDATION_ERROR');
}
