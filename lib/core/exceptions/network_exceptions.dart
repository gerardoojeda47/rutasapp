import 'app_exceptions.dart';

/// Base class for network-related exceptions
abstract class NetworkException extends AppException {
  const NetworkException(
    String message, {
    String? code,
    dynamic originalError,
  }) : super(message, code: code, originalError: originalError);
}

/// Exception thrown when there's no internet connection
class NoInternetException extends NetworkException {
  const NoInternetException({
    String message = 'No hay conexión a internet',
    String? code,
    dynamic originalError,
  }) : super(message, code: code, originalError: originalError);

  @override
  String toString() {
    return 'NoInternetException: $message${code != null ? ' (Code: $code)' : ''}';
  }
}

/// Exception thrown when request times out
class TimeoutException extends NetworkException {
  const TimeoutException({
    String message = 'La solicitud ha expirado',
    String? code,
    dynamic originalError,
  }) : super(message, code: code, originalError: originalError);

  @override
  String toString() {
    return 'TimeoutException: $message${code != null ? ' (Code: $code)' : ''}';
  }
}

/// Exception thrown when server returns an error
class ServerException extends NetworkException {
  final int? statusCode;

  const ServerException({
    String message = 'Error del servidor',
    this.statusCode,
    String? code,
    dynamic originalError,
  }) : super(message, code: code, originalError: originalError);

  @override
  String toString() {
    return 'ServerException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}${code != null ? ' (Code: $code)' : ''}';
  }
}

/// Exception thrown when API returns bad request (400)
class BadRequestException extends ServerException {
  const BadRequestException({
    String message = 'Solicitud inválida',
    String? code,
    dynamic originalError,
  }) : super(
          message: message,
          statusCode: 400,
          code: code,
          originalError: originalError,
        );
}

/// Exception thrown when API returns unauthorized (401)
class UnauthorizedException extends ServerException {
  const UnauthorizedException({
    String message = 'No autorizado',
    String? code,
    dynamic originalError,
  }) : super(
          message: message,
          statusCode: 401,
          code: code,
          originalError: originalError,
        );
}

/// Exception thrown when API returns forbidden (403)
class ForbiddenException extends ServerException {
  const ForbiddenException({
    String message = 'Acceso prohibido',
    String? code,
    dynamic originalError,
  }) : super(
          message: message,
          statusCode: 403,
          code: code,
          originalError: originalError,
        );
}

/// Exception thrown when API returns not found (404)
class NotFoundApiException extends ServerException {
  const NotFoundApiException({
    String message = 'Recurso no encontrado',
    String? code,
    dynamic originalError,
  }) : super(
          message: message,
          statusCode: 404,
          code: code,
          originalError: originalError,
        );
}

/// Exception thrown when API returns internal server error (500)
class InternalServerException extends ServerException {
  const InternalServerException({
    String message = 'Error interno del servidor',
    String? code,
    dynamic originalError,
  }) : super(
          message: message,
          statusCode: 500,
          code: code,
          originalError: originalError,
        );
}

/// Exception thrown when API returns service unavailable (503)
class ServiceUnavailableException extends ServerException {
  const ServiceUnavailableException({
    String message = 'Servicio no disponible',
    String? code,
    dynamic originalError,
  }) : super(
          message: message,
          statusCode: 503,
          code: code,
          originalError: originalError,
        );
}

/// Exception thrown when response parsing fails
class ParseException extends NetworkException {
  const ParseException({
    String message = 'Error al procesar la respuesta',
    String? code,
    dynamic originalError,
  }) : super(message, code: code, originalError: originalError);

  @override
  String toString() {
    return 'ParseException: $message${code != null ? ' (Code: $code)' : ''}';
  }
}

/// Factory class to create network exceptions from HTTP status codes
class NetworkExceptionFactory {
  static NetworkException fromStatusCode(int statusCode,
      {String? message, dynamic originalError}) {
    switch (statusCode) {
      case 400:
        return BadRequestException(
          message: message ?? 'Solicitud inválida',
          originalError: originalError,
        );
      case 401:
        return UnauthorizedException(
          message: message ?? 'No autorizado',
          originalError: originalError,
        );
      case 403:
        return ForbiddenException(
          message: message ?? 'Acceso prohibido',
          originalError: originalError,
        );
      case 404:
        return NotFoundApiException(
          message: message ?? 'Recurso no encontrado',
          originalError: originalError,
        );
      case 500:
        return InternalServerException(
          message: message ?? 'Error interno del servidor',
          originalError: originalError,
        );
      case 503:
        return ServiceUnavailableException(
          message: message ?? 'Servicio no disponible',
          originalError: originalError,
        );
      default:
        return ServerException(
          message: message ?? 'Error del servidor',
          statusCode: statusCode,
          originalError: originalError,
        );
    }
  }
}

