/// Application-wide constants
class AppConstants {
  // App Information
  static const String appName = 'RouWhite';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Rutas de Transporte Público - Popayán';

  // API Configuration
  static const String baseUrl = 'https://api.rouwhite.com';
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds

  // Storage Keys
  static const String favoritesKey = 'user_favorites';
  static const String userPreferencesKey = 'user_preferences';
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';

  // Map Configuration
  static const double defaultZoom = 15.0;
  static const double popayanLat = 2.444814;
  static const double popayanLng = -76.614739;

  // Animation Durations
  static const int shortAnimationDuration = 300;
  static const int mediumAnimationDuration = 500;
  static const int longAnimationDuration = 1000;

  // Validation Rules
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int maxEmailLength = 100;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double cardElevation = 4.0;

  // Error Messages
  static const String networkErrorMessage =
      'Error de conexión. Verifica tu internet.';
  static const String genericErrorMessage = 'Ha ocurrido un error inesperado.';
  static const String validationErrorMessage =
      'Por favor verifica los datos ingresados.';

  // Success Messages
  static const String loginSuccessMessage = 'Inicio de sesión exitoso';
  static const String favoriteAddedMessage = 'Ruta agregada a favoritos';
  static const String favoriteRemovedMessage = 'Ruta eliminada de favoritos';
}

