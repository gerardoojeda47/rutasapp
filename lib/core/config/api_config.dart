/// Configuración de APIs externas
class ApiConfig {
  // OpenRouteService API Key
  // Para obtener una clave gratuita, regístrate en: https://openrouteservice.org/dev/#/signup
  static const String openRouteServiceApiKey = 'TU_API_KEY_AQUI';

  // URLs base
  static const String openRouteServiceBaseUrl =
      'https://api.openrouteservice.org/v2';

  // Límites de uso (plan gratuito)
  static const int requestsPerDay = 2000;
  static const int requestsPerMinute = 40;

  // Configuración de timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Configuración de área de Popayán
  static const double popayanMinLat = 2.3;
  static const double popayanMaxLat = 2.6;
  static const double popayanMinLng = -76.7;
  static const double popayanMaxLng = -76.5;
}
