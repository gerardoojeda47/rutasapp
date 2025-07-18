import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primarySwatch: Colors.orange,
      primaryColor: AppConstants.colorPrimario,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppConstants.colorPrimario,
        brightness: Brightness.light,
      ),
      
      // Configuración de AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppConstants.colorPrimario,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: AppConstants.tamanotSubtitulo,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),

      // Configuración de botones elevados
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.colorPrimario,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.espaciadoMedio,
            vertical: AppConstants.espaciadoPequeno,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radioBotonMedio),
          ),
          textStyle: const TextStyle(
            fontSize: AppConstants.tamanotCuerpo,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Configuración de botones de texto
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppConstants.colorPrimario,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.espaciadoMedio,
            vertical: AppConstants.espaciadoPequeno,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radioBotonMedio),
          ),
          textStyle: const TextStyle(
            fontSize: AppConstants.tamanotCuerpo,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Configuración de botones outlined
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppConstants.colorPrimario,
          side: const BorderSide(color: AppConstants.colorPrimario),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.espaciadoMedio,
            vertical: AppConstants.espaciadoPequeno,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radioBotonMedio),
          ),
          textStyle: const TextStyle(
            fontSize: AppConstants.tamanotCuerpo,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Configuración de campos de texto
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radioBotonMedio),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radioBotonMedio),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radioBotonMedio),
          borderSide: const BorderSide(color: AppConstants.colorPrimario, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radioBotonMedio),
          borderSide: const BorderSide(color: AppConstants.colorError),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radioBotonMedio),
          borderSide: const BorderSide(color: AppConstants.colorError, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.espaciadoMedio,
          vertical: AppConstants.espaciadoPequeno,
        ),
        labelStyle: TextStyle(
          color: Colors.grey[600],
          fontSize: AppConstants.tamanotCuerpo,
        ),
        hintStyle: TextStyle(
          color: Colors.grey[400],
          fontSize: AppConstants.tamanotCuerpo,
        ),
        errorStyle: const TextStyle(
          color: AppConstants.colorError,
          fontSize: AppConstants.tamanotPequeno,
        ),
      ),

      // Configuración de tarjetas
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radioTarjeta),
        ),
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),

      // Configuración de chips
      chipTheme: ChipThemeData(
        backgroundColor: AppConstants.colorPrimario.withOpacity(0.1),
        labelStyle: const TextStyle(
          color: AppConstants.colorPrimario,
          fontSize: AppConstants.tamanotPequeno,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radioBotonPequeno),
        ),
      ),

      // Configuración de BottomNavigationBar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppConstants.colorPrimario,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Configuración de FloatingActionButton
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppConstants.colorPrimario,
        foregroundColor: Colors.white,
      ),

      // Configuración de SnackBar
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppConstants.colorPrimario,
        contentTextStyle: TextStyle(
          color: Colors.white,
          fontSize: AppConstants.tamanotCuerpo,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppConstants.radioBotonMedio),
          ),
        ),
      ),

      // Configuración de texto
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppConstants.colorTexto,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppConstants.colorTexto,
        ),
        displaySmall: TextStyle(
          fontSize: AppConstants.tamanotTitulo,
          fontWeight: FontWeight.bold,
          color: AppConstants.colorTexto,
        ),
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppConstants.colorTexto,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppConstants.colorTexto,
        ),
        headlineSmall: TextStyle(
          fontSize: AppConstants.tamanotSubtitulo,
          fontWeight: FontWeight.w600,
          color: AppConstants.colorTexto,
        ),
        titleLarge: TextStyle(
          fontSize: AppConstants.tamanotCuerpo,
          fontWeight: FontWeight.w600,
          color: AppConstants.colorTexto,
        ),
        titleMedium: TextStyle(
          fontSize: AppConstants.tamanotPequeno,
          fontWeight: FontWeight.w500,
          color: AppConstants.colorTexto,
        ),
        titleSmall: TextStyle(
          fontSize: AppConstants.tamanotCaption,
          fontWeight: FontWeight.w500,
          color: AppConstants.colorTextoSecundario,
        ),
        bodyLarge: TextStyle(
          fontSize: AppConstants.tamanotCuerpo,
          color: AppConstants.colorTexto,
        ),
        bodyMedium: TextStyle(
          fontSize: AppConstants.tamanotPequeno,
          color: AppConstants.colorTexto,
        ),
        bodySmall: TextStyle(
          fontSize: AppConstants.tamanotCaption,
          color: AppConstants.colorTextoSecundario,
        ),
        labelLarge: TextStyle(
          fontSize: AppConstants.tamanotPequeno,
          fontWeight: FontWeight.w600,
          color: AppConstants.colorTexto,
        ),
        labelMedium: TextStyle(
          fontSize: AppConstants.tamanotCaption,
          fontWeight: FontWeight.w500,
          color: AppConstants.colorTextoSecundario,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: AppConstants.colorTextoSecundario,
        ),
      ),

      // Configuración de iconos
      iconTheme: const IconThemeData(
        color: AppConstants.colorTextoSecundario,
        size: 24,
      ),

      // Configuración de scaffolds
      scaffoldBackgroundColor: AppConstants.colorFondo,

      // Configuración de dividers
      dividerTheme: DividerThemeData(
        color: Colors.grey[300],
        thickness: 1,
        space: 1,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      primarySwatch: Colors.orange,
      primaryColor: AppConstants.colorPrimario,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppConstants.colorPrimario,
        brightness: Brightness.dark,
      ),
      
      // Usar configuraciones similares al tema claro pero adaptadas para modo oscuro
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1F1F1F),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      
      scaffoldBackgroundColor: const Color(0xFF121212),
      
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radioTarjeta),
        ),
        color: const Color(0xFF1F1F1F),
      ),
    );
  }
}