import '../constants/app_constants.dart';
import '../constants/strings.dart';

/// Utility class for form validation
class Validators {
  /// Validates email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }

    if (value.length > AppConstants.maxEmailLength) {
      return 'El correo no puede tener más de ${AppConstants.maxEmailLength} caracteres';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return AppStrings.invalidEmail;
    }

    return null;
  }

  /// Validates password strength
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }

    if (value.length < AppConstants.minPasswordLength) {
      return AppStrings.passwordTooShort;
    }

    if (value.length > AppConstants.maxPasswordLength) {
      return 'La contraseña no puede tener más de ${AppConstants.maxPasswordLength} caracteres';
    }

    return null;
  }

  /// Validates password confirmation
  static String? validatePasswordConfirmation(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }

    if (value != password) {
      return AppStrings.passwordsDoNotMatch;
    }

    return null;
  }

  /// Validates required fields
  static String? validateRequired(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null
          ? '$fieldName es requerido'
          : AppStrings.fieldRequired;
    }
    return null;
  }

  /// Validates name fields
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }

    if (value.trim().length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }

    if (value.trim().length > 50) {
      return 'El nombre no puede tener más de 50 caracteres';
    }

    final nameRegex = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$');
    if (!nameRegex.hasMatch(value.trim())) {
      return 'El nombre solo puede contener letras y espacios';
    }

    return null;
  }

  /// Validates phone number
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Phone is optional
    }

    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[\s\-\(\)]'), ''))) {
      return 'Número de teléfono inválido';
    }

    return null;
  }

  /// Validates search query
  static String? validateSearchQuery(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ingresa un término de búsqueda';
    }

    if (value.trim().length < 2) {
      return 'La búsqueda debe tener al menos 2 caracteres';
    }

    return null;
  }

  /// Validates route name
  static String? validateRouteName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }

    if (value.trim().length < 3) {
      return 'El nombre de la ruta debe tener al menos 3 caracteres';
    }

    return null;
  }

  /// Validates numeric input
  static String? validateNumeric(String? value, {double? min, double? max}) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }

    final numericValue = double.tryParse(value);
    if (numericValue == null) {
      return 'Debe ser un número válido';
    }

    if (min != null && numericValue < min) {
      return 'El valor debe ser mayor o igual a $min';
    }

    if (max != null && numericValue > max) {
      return 'El valor debe ser menor o igual a $max';
    }

    return null;
  }

  /// Validates URL format
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null; // URL is optional
    }

    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(value)) {
      return 'URL inválida';
    }

    return null;
  }
}
