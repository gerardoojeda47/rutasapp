/// Base class for all application exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException(
    this.message, {
    this.code,
    this.originalError,
  });

  @override
  String toString() {
    return 'AppException: $message${code != null ? ' (Code: $code)' : ''}';
  }
}

/// Exception thrown when validation fails
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  const ValidationException(
    String message, {
    String? code,
    this.fieldErrors,
    dynamic originalError,
  }) : super(message, code: code, originalError: originalError);

  @override
  String toString() {
    return 'ValidationException: $message${code != null ? ' (Code: $code)' : ''}';
  }
}

/// Exception thrown when authentication fails
class AuthenticationException extends AppException {
  const AuthenticationException(
    String message, {
    String? code,
    dynamic originalError,
  }) : super(message, code: code, originalError: originalError);

  @override
  String toString() {
    return 'AuthenticationException: $message${code != null ? ' (Code: $code)' : ''}';
  }
}

/// Exception thrown when authorization fails
class AuthorizationException extends AppException {
  const AuthorizationException(
    String message, {
    String? code,
    dynamic originalError,
  }) : super(message, code: code, originalError: originalError);

  @override
  String toString() {
    return 'AuthorizationException: $message${code != null ? ' (Code: $code)' : ''}';
  }
}

/// Exception thrown when data is not found
class NotFoundException extends AppException {
  const NotFoundException(
    String message, {
    String? code,
    dynamic originalError,
  }) : super(message, code: code, originalError: originalError);

  @override
  String toString() {
    return 'NotFoundException: $message${code != null ? ' (Code: $code)' : ''}';
  }
}

/// Exception thrown when storage operations fail
class StorageException extends AppException {
  const StorageException(
    String message, {
    String? code,
    dynamic originalError,
  }) : super(message, code: code, originalError: originalError);

  @override
  String toString() {
    return 'StorageException: $message${code != null ? ' (Code: $code)' : ''}';
  }
}

/// Exception thrown when location services fail
class LocationException extends AppException {
  const LocationException(
    String message, {
    String? code,
    dynamic originalError,
  }) : super(message, code: code, originalError: originalError);

  @override
  String toString() {
    return 'LocationException: $message${code != null ? ' (Code: $code)' : ''}';
  }
}

/// Exception thrown when cache operations fail
class CacheException extends AppException {
  const CacheException(
    String message, {
    String? code,
    dynamic originalError,
  }) : super(message, code: code, originalError: originalError);

  @override
  String toString() {
    return 'CacheException: $message${code != null ? ' (Code: $code)' : ''}';
  }
}

