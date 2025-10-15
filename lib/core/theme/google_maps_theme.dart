import 'package:flutter/material.dart';

class GoogleMapsTheme {
  // Colores principales inspirados en Google Maps
  static const Color primaryBlue = Color(0xFF4285F4);
  static const Color primaryGreen = Color(0xFF34A853);
  static const Color primaryRed = Color(0xFFEA4335);
  static const Color primaryYellow = Color(0xFFFBBC04);
  static const Color primaryOrange = Color(0xFFFF6D01);

  // Colores para transporte público
  static const Color busRouteBlue = Color(0xFF1976D2);
  static const Color busRouteGreen = Color(0xFF388E3C);
  static const Color busRouteOrange = Color(0xFFFF6A00);
  static const Color busRoutePurple = Color(0xFF7B1FA2);
  static const Color busRouteRed = Color(0xFFD32F2F);

  // Colores para estados
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color errorRed = Color(0xFFF44336);
  static const Color infoBlue = Color(0xFF2196F3);

  // Colores para el mapa
  static const Color userLocationBlue = Color(0xFF4285F4);
  static const Color destinationRed = Color(0xFFEA4335);
  static const Color routeLineBlue = Color(0xFF1976D2);
  static const Color walkingPathGreen = Color(0xFF34A853);
  static const Color busStopOrange = Color(0xFFFF6D01);

  // Colores para tráfico
  static const Color trafficGreen = Color(0xFF4CAF50);
  static const Color trafficYellow = Color(0xFFFFEB3B);
  static const Color trafficRed = Color(0xFFF44336);

  // Grises y neutros
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color mediumGrey = Color(0xFFE0E0E0);
  static const Color darkGrey = Color(0xFF757575);
  static const Color textGrey = Color(0xFF424242);

  // Gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, Color(0xFF1976D2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [primaryGreen, Color(0xFF2E7D32)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [primaryYellow, primaryOrange],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Sombras
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get elevatedShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.15),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  // Estilos de texto
  static const TextStyle headingLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
  );

  static const TextStyle headingSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: Colors.black87,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black87,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textGrey,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.normal,
    color: darkGrey,
  );

  // Decoraciones de contenedores
  static BoxDecoration get cardDecoration => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: cardShadow,
      );

  static BoxDecoration get elevatedCardDecoration => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: elevatedShadow,
      );

  static BoxDecoration routeCardDecoration(Color color, bool isSelected) =>
      BoxDecoration(
        color: isSelected ? color.withValues(alpha: 0.1) : lightGrey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? color : mediumGrey,
          width: isSelected ? 2 : 1,
        ),
      );

  // Decoraciones para botones
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: 4,
      );

  static ButtonStyle get secondaryButtonStyle => OutlinedButton.styleFrom(
        foregroundColor: primaryBlue,
        side: const BorderSide(color: primaryBlue, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      );

  // Colores por empresa de buses
  static Color getBusCompanyColor(String company) {
    switch (company.toUpperCase()) {
      case 'SOTRACAUCA':
        return busRouteGreen;
      case 'TRANSPUBENZA':
        return busRouteBlue;
      case 'TRANSLIBERTAD':
        return busRouteOrange;
      case 'TRANSTAMBO':
        return busRoutePurple;
      default:
        return darkGrey;
    }
  }

  // Colores para tipos de transporte
  static Color getTransportTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'bus':
        return busRouteBlue;
      case 'walking':
        return walkingPathGreen;
      case 'waiting':
        return warningOrange;
      default:
        return darkGrey;
    }
  }

  // Colores para prioridades
  static Color getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return errorRed;
      case 'medium':
        return warningOrange;
      case 'low':
        return infoBlue;
      default:
        return darkGrey;
    }
  }

  // Animaciones
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);

  static const Curve defaultCurve = Curves.easeInOutCubic;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve slideCurve = Curves.easeOutCubic;

  // Espaciado
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 12.0;
  static const double spacingL = 16.0;
  static const double spacingXL = 20.0;
  static const double spacingXXL = 24.0;

  // Radios de borde
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 20.0;

  // Tamaños de iconos
  static const double iconS = 16.0;
  static const double iconM = 20.0;
  static const double iconL = 24.0;
  static const double iconXL = 32.0;

  // Tema completo de la aplicación
  static ThemeData get lightTheme => ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: primaryBlue,
        scaffoldBackgroundColor: lightGrey,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: headingMedium,
        ),
        cardTheme: const CardTheme(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusM),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: primaryButtonStyle,
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: secondaryButtonStyle,
        ),
        textTheme: const TextTheme(
          headlineLarge: headingLarge,
          headlineMedium: headingMedium,
          headlineSmall: headingSmall,
          bodyLarge: bodyLarge,
          bodyMedium: bodyMedium,
          bodySmall: bodySmall,
          labelSmall: caption,
        ),
        colorScheme: const ColorScheme.light(
          primary: primaryBlue,
          secondary: primaryGreen,
          error: primaryRed,
          surface: Colors.white,
          onSurface: Colors.black87,
        ),
      );
}

