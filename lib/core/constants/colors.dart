import 'package:flutter/material.dart';

/// Application color scheme and theme colors
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFFFF6A00);
  static const Color primaryLight = Color(0xFFFFA726);
  static const Color primaryDark = Color(0xFFE65100);

  // Secondary Colors
  static const Color secondary = Color(0xFF2196F3);
  static const Color secondaryLight = Color(0xFF64B5F6);
  static const Color secondaryDark = Color(0xFF1976D2);

  // Background Colors
  static const Color background = Color(0xFFF9F5FF);
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF5F5F5);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFF9E9E9E);
  static const Color textOnPrimary = Colors.white;

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Traffic Status Colors
  static const Color trafficGood = Color(0xFF4CAF50);
  static const Color trafficModerate = Color(0xFFFF9800);
  static const Color trafficHeavy = Color(0xFFF44336);

  // Map Colors
  static const Color userLocationMarker = primary;
  static const Color busStopMarker = Color(0xFF2196F3);
  static const Color routePolyline = primary;
  static const Color selectedRoutePolyline = primaryDark;

  // UI Element Colors
  static const Color divider = Color(0xFFE0E0E0);
  static const Color shadow = Color(0x1F000000);
  static const Color overlay = Color(0x80000000);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [background, surface],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Material Color Swatch for Theme
  static const MaterialColor primarySwatch = MaterialColor(
    0xFFFF6A00,
    <int, Color>{
      50: Color(0xFFFFF3E0),
      100: Color(0xFFFFE0B2),
      200: Color(0xFFFFCC80),
      300: Color(0xFFFFB74D),
      400: Color(0xFFFFA726),
      500: Color(0xFFFF6A00),
      600: Color(0xFFFF8F00),
      700: Color(0xFFFF6F00),
      800: Color(0xFFEF6C00),
      900: Color(0xFFE65100),
    },
  );

  // Color Scheme for Material 3
  static ColorScheme get lightColorScheme => ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
      );

  static ColorScheme get darkColorScheme => ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.dark,
      );
}
