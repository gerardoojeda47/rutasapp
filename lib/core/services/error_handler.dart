import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/strings.dart';
import '../exceptions/app_exceptions.dart';
import '../exceptions/network_exceptions.dart';

/// Centralized error handling service
class ErrorHandler {
  /// Handles and displays errors to the user
  static void handleError(
    BuildContext context,
    dynamic error, {
    String? customMessage,
    VoidCallback? onRetry,
    bool showSnackBar = true,
  }) {
    final errorInfo = _getErrorInfo(error);
    final message = customMessage ?? errorInfo.message;

    // Log error for debugging
    logError(error, StackTrace.current);

    if (showSnackBar && context.mounted) {
      _showErrorSnackBar(
        context,
        message,
        errorInfo.color,
        onRetry,
      );
    }
  }

  /// Shows error dialog with detailed information
  static Future<void> showErrorDialog(
    BuildContext context,
    dynamic error, {
    String? title,
    String? customMessage,
    VoidCallback? onRetry,
  }) async {
    final errorInfo = _getErrorInfo(error);
    final message = customMessage ?? errorInfo.message;

    // Log error for debugging
    logError(error, StackTrace.current);

    if (!context.mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title ?? 'Error'),
          content: Text(message),
          actions: [
            if (onRetry != null)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onRetry();
                },
                child: const Text(AppStrings.retry),
              ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(AppStrings.ok),
            ),
          ],
        );
      },
    );
  }

  /// Gets user-friendly error message from exception
  static String getErrorMessage(dynamic error) {
    return _getErrorInfo(error).message;
  }

  /// Logs error for debugging purposes
  static void logError(dynamic error, StackTrace stackTrace) {
    if (error is AppException) {
      developer.log(
        'AppException: ${error.message}',
        name: 'ErrorHandler',
        error: error,
        stackTrace: stackTrace,
      );
    } else {
      developer.log(
        'Unexpected error: $error',
        name: 'ErrorHandler',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Shows error snackbar with appropriate styling
  static void _showErrorSnackBar(
    BuildContext context,
    String message,
    Color backgroundColor,
    VoidCallback? onRetry,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 4),
        action: onRetry != null
            ? SnackBarAction(
                label: AppStrings.retry,
                textColor: Colors.white,
                onPressed: onRetry,
              )
            : null,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Gets error information including message and color
  static _ErrorInfo _getErrorInfo(dynamic error) {
    if (error is ValidationException) {
      return _ErrorInfo(
        message: error.message,
        color: AppColors.warning,
      );
    } else if (error is AuthenticationException) {
      return _ErrorInfo(
        message: error.message,
        color: AppColors.error,
      );
    } else if (error is AuthorizationException) {
      return _ErrorInfo(
        message: error.message,
        color: AppColors.error,
      );
    } else if (error is NoInternetException) {
      return _ErrorInfo(
        message: AppStrings.networkError,
        color: AppColors.warning,
      );
    } else if (error is TimeoutException) {
      return _ErrorInfo(
        message: 'La solicitud ha tardado demasiado. Intenta nuevamente.',
        color: AppColors.warning,
      );
    } else if (error is ServerException) {
      return _ErrorInfo(
        message: _getServerErrorMessage(error.statusCode),
        color: AppColors.error,
      );
    } else if (error is NetworkException) {
      return _ErrorInfo(
        message: error.message,
        color: AppColors.warning,
      );
    } else if (error is StorageException) {
      return _ErrorInfo(
        message: 'Error al guardar datos. Intenta nuevamente.',
        color: AppColors.warning,
      );
    } else if (error is LocationException) {
      return _ErrorInfo(
        message: error.message,
        color: AppColors.info,
      );
    } else if (error is NotFoundException) {
      return _ErrorInfo(
        message: error.message,
        color: AppColors.warning,
      );
    } else if (error is AppException) {
      return _ErrorInfo(
        message: error.message,
        color: AppColors.error,
      );
    } else {
      return _ErrorInfo(
        message: AppStrings.unknownError,
        color: AppColors.error,
      );
    }
  }

  /// Gets server error message based on status code
  static String _getServerErrorMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Solicitud inválida. Verifica los datos ingresados.';
      case 401:
        return 'Sesión expirada. Inicia sesión nuevamente.';
      case 403:
        return 'No tienes permisos para realizar esta acción.';
      case 404:
        return 'El recurso solicitado no fue encontrado.';
      case 500:
        return 'Error interno del servidor. Intenta más tarde.';
      case 503:
        return 'Servicio temporalmente no disponible.';
      default:
        return AppStrings.serverError;
    }
  }
}

/// Internal class to hold error information
class _ErrorInfo {
  final String message;
  final Color color;

  const _ErrorInfo({
    required this.message,
    required this.color,
  });
}

/// Extension to add error handling methods to BuildContext
extension ErrorHandlerExtension on BuildContext {
  /// Shows error snackbar
  void showError(
    dynamic error, {
    String? customMessage,
    VoidCallback? onRetry,
  }) {
    ErrorHandler.handleError(
      this,
      error,
      customMessage: customMessage,
      onRetry: onRetry,
    );
  }

  /// Shows error dialog
  Future<void> showErrorDialog(
    dynamic error, {
    String? title,
    String? customMessage,
    VoidCallback? onRetry,
  }) {
    return ErrorHandler.showErrorDialog(
      this,
      error,
      title: title,
      customMessage: customMessage,
      onRetry: onRetry,
    );
  }

  /// Shows success snackbar
  void showSuccess(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// Shows info snackbar
  void showInfo(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.info,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

