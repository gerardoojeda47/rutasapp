import 'package:equatable/equatable.dart';
import 'usuario.dart';

/// Resultado de autenticación
class AuthResult extends Equatable {
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

  /// Verifica si el token ha expirado
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// Verifica si el token está próximo a expirar (menos de 5 minutos)
  bool get isNearExpiry {
    if (expiresAt == null) return false;
    final fiveMinutesFromNow = DateTime.now().add(const Duration(minutes: 5));
    return expiresAt!.isBefore(fiveMinutesFromNow);
  }

  @override
  List<Object?> get props => [usuario, token, refreshToken, expiresAt];

  @override
  String toString() {
    return 'AuthResult(usuario: ${usuario.email}, token: ${token.substring(0, 10)}...)';
  }
}
