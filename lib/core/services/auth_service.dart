import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class AuthService {
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _usernameKey = 'username';
  static const String _userIdKey = 'userId';
  
  static final Logger _logger = Logger();

  // Verificar si el usuario está autenticado
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_isLoggedInKey) ?? false;
    } catch (e) {
      _logger.e('Error al verificar estado de autenticación: $e');
      return false;
    }
  }

  // Obtener el nombre de usuario actual
  static Future<String?> getCurrentUsername() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_usernameKey);
    } catch (e) {
      _logger.e('Error al obtener nombre de usuario: $e');
      return null;
    }
  }

  // Obtener el ID del usuario actual
  static Future<String?> getCurrentUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userIdKey);
    } catch (e) {
      _logger.e('Error al obtener ID de usuario: $e');
      return null;
    }
  }

  // Iniciar sesión
  static Future<bool> login({
    required String username,
    required String password,
    String? userId,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Aquí normalmente se haría la validación con el backend
      // Por ahora simulamos una autenticación exitosa
      await prefs.setBool(_isLoggedInKey, true);
      await prefs.setString(_usernameKey, username);
      if (userId != null) {
        await prefs.setString(_userIdKey, userId);
      }
      
      return true;
    } catch (e) {
      _logger.e('Error al iniciar sesión: $e');
      return false;
    }
  }

  // Cerrar sesión
  static Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_isLoggedInKey);
      await prefs.remove(_usernameKey);
      await prefs.remove(_userIdKey);
      
      return true;
    } catch (e) {
      _logger.e('Error al cerrar sesión: $e');
      return false;
    }
  }

  // Verificar credenciales (simulado)
  static Future<bool> validateCredentials({
    required String username,
    required String password,
  }) async {
    // Simular validación de credenciales
    // En una app real, esto se haría contra el backend
    await Future.delayed(const Duration(milliseconds: 1000));
    
    // Validación básica
    if (username.contains('@') && password.length >= 6) {
      return true;
    }
    
    return false;
  }

  // Obtener información completa del usuario autenticado
  static Future<Map<String, dynamic>?> getCurrentUserInfo() async {
    try {
      final userIsLoggedIn = await isLoggedIn();
      if (!userIsLoggedIn) return null;

      final username = await getCurrentUsername();
      final userId = await getCurrentUserId();

      return {
        'isLoggedIn': true,
        'username': username,
        'userId': userId,
        'loginTime': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      _logger.e('Error al obtener información del usuario: $e');
      return null;
    }
  }

  // Limpiar todos los datos de autenticación
  static Future<bool> clearAllAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_isLoggedInKey);
      await prefs.remove(_usernameKey);
      await prefs.remove(_userIdKey);
      
      return true;
    } catch (e) {
      _logger.e('Error al limpiar datos de autenticación: $e');
      return false;
    }
  }
}
