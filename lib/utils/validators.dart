import '../constants/app_constants.dart';

class Validators {
  // Validar email
  static String? validarEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppTexts.errorCampoRequerido;
    }
    
    final emailRegex = RegExp(AppConstants.regexEmail);
    if (!emailRegex.hasMatch(value)) {
      return AppTexts.errorCorreoInvalido;
    }
    
    return null;
  }

  // Validar contraseña
  static String? validarContrasena(String? value) {
    if (value == null || value.isEmpty) {
      return AppTexts.errorCampoRequerido;
    }
    
    if (value.length < AppConstants.longitudMinimaPassword) {
      return AppTexts.errorContrasenaDebil;
    }
    
    return null;
  }

  // Validar confirmación de contraseña
  static String? validarConfirmacionContrasena(String? value, String? contrasenaOriginal) {
    if (value == null || value.isEmpty) {
      return AppTexts.errorCampoRequerido;
    }
    
    if (value != contrasenaOriginal) {
      return AppTexts.errorContrasenaNoCoincide;
    }
    
    return null;
  }

  // Validar nombre
  static String? validarNombre(String? value) {
    if (value == null || value.isEmpty) {
      return AppTexts.errorCampoRequerido;
    }
    
    if (value.length > AppConstants.longitudMaximaNombre) {
      return 'El nombre no puede exceder ${AppConstants.longitudMaximaNombre} caracteres';
    }
    
    if (value.trim().length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }
    
    return null;
  }

  // Validar teléfono colombiano
  static String? validarTelefono(String? value) {
    if (value == null || value.isEmpty) {
      return AppTexts.errorCampoRequerido;
    }
    
    // Remover espacios y caracteres especiales
    final telefonoLimpio = value.replaceAll(RegExp(r'[^\d]'), '');
    
    // Validar formato colombiano (10 dígitos o con código de país)
    if (telefonoLimpio.length == 10) {
      // Formato: 3123456789
      if (!telefonoLimpio.startsWith('3')) {
        return 'El número debe comenzar con 3 (celular)';
      }
    } else if (telefonoLimpio.length == 12) {
      // Formato: 573123456789
      if (!telefonoLimpio.startsWith('573')) {
        return 'Código de país inválido para Colombia';
      }
    } else {
      return 'Formato de teléfono inválido';
    }
    
    return null;
  }

  // Validar campo requerido genérico
  static String? validarCampoRequerido(String? value, [String? nombreCampo]) {
    if (value == null || value.trim().isEmpty) {
      return nombreCampo != null 
          ? '$nombreCampo es requerido'
          : AppTexts.errorCampoRequerido;
    }
    return null;
  }

  // Validar longitud mínima
  static String? validarLongitudMinima(String? value, int longitudMinima, [String? nombreCampo]) {
    if (value == null || value.isEmpty) {
      return AppTexts.errorCampoRequerido;
    }
    
    if (value.length < longitudMinima) {
      return nombreCampo != null
          ? '$nombreCampo debe tener al menos $longitudMinima caracteres'
          : 'Debe tener al menos $longitudMinima caracteres';
    }
    
    return null;
  }

  // Validar longitud máxima
  static String? validarLongitudMaxima(String? value, int longitudMaxima, [String? nombreCampo]) {
    if (value != null && value.length > longitudMaxima) {
      return nombreCampo != null
          ? '$nombreCampo no puede exceder $longitudMaxima caracteres'
          : 'No puede exceder $longitudMaxima caracteres';
    }
    
    return null;
  }

  // Validar solo números
  static String? validarSoloNumeros(String? value, [String? nombreCampo]) {
    if (value == null || value.isEmpty) {
      return AppTexts.errorCampoRequerido;
    }
    
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return nombreCampo != null
          ? '$nombreCampo debe contener solo números'
          : 'Debe contener solo números';
    }
    
    return null;
  }

  // Validar rango numérico
  static String? validarRangoNumerico(String? value, double minimo, double maximo, [String? nombreCampo]) {
    if (value == null || value.isEmpty) {
      return AppTexts.errorCampoRequerido;
    }
    
    final numero = double.tryParse(value);
    if (numero == null) {
      return 'Debe ser un número válido';
    }
    
    if (numero < minimo || numero > maximo) {
      return nombreCampo != null
          ? '$nombreCampo debe estar entre $minimo y $maximo'
          : 'Debe estar entre $minimo y $maximo';
    }
    
    return null;
  }

  // Combinar múltiples validadores
  static String? combinarValidadores(String? value, List<String? Function(String?)> validadores) {
    for (final validador in validadores) {
      final resultado = validador(value);
      if (resultado != null) {
        return resultado;
      }
    }
    return null;
  }
}