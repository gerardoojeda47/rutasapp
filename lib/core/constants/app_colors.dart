import 'package:flutter/material.dart';

class AppColors {
  // Colores principales
  static const Color primary = Color(0xFFFF6A00);
  static const Color primaryLight = Color(0xFFFF8C42);
  static const Color primaryLighter = Color(0xFFFFB74D);
  static const Color primaryLightest = Color(0xFFFFE0B2);
  
  // Colores secundarios
  static const Color secondary = Color(0xFFFFA726);
  static const Color secondaryLight = Color(0xFFFFCC80);
  
  // Colores de fondo
  static const Color background = Color(0xFFF9F5FF);
  static const Color surface = Colors.white;
  
  // Colores de texto
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFFBDBDBD);
  
  // Colores de estado
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  
  // Colores de sombra
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowDark = Color(0x4D000000);
  
  // Gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      primary,
      primaryLight,
      primaryLighter,
      primaryLightest,
    ],
    stops: [0.0, 0.3, 0.7, 1.0],
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      secondary,
      secondaryLight,
    ],
  );
  
  // Colores con transparencia
  static Color primaryWithOpacity(double opacity) => primary.withValues(alpha: opacity);
  static Color secondaryWithOpacity(double opacity) => secondary.withValues(alpha: opacity);
  static Color whiteWithOpacity(double opacity) => Colors.white.withValues(alpha: opacity);
  static Color blackWithOpacity(double opacity) => Colors.black.withValues(alpha: opacity);
}

