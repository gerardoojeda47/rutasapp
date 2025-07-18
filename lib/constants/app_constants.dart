import 'package:flutter/material.dart';

class AppConstants {
  // Colores de la aplicación
  static const Color colorPrimario = Color(0xFFFF6A00);
  static const Color colorSecundario = Color(0xFFFF8C00);
  static const Color colorFondo = Color(0xFFF9F5FF);
  static const Color colorTexto = Color(0xFF333333);
  static const Color colorTextoSecundario = Color(0xFF666666);
  
  // Colores de estado
  static const Color colorExito = Color(0xFF4CAF50);
  static const Color colorAdvertencia = Color(0xFFFF9800);
  static const Color colorError = Color(0xFFF44336);
  static const Color colorInfo = Color(0xFF2196F3);

  // Espaciado
  static const double espaciadoPequeno = 8.0;
  static const double espaciadoMedio = 16.0;
  static const double espaciadoGrande = 24.0;
  static const double espaciadoExtraGrande = 32.0;

  // Tamaños de fuente
  static const double tamanotTitulo = 24.0;
  static const double tamanotSubtitulo = 18.0;
  static const double tamanotCuerpo = 16.0;
  static const double tamanotPequeno = 14.0;
  static const double tamanotCaption = 12.0;

  // Radios de borde
  static const double radioBotonPequeno = 8.0;
  static const double radioBotonMedio = 12.0;
  static const double radioBotonGrande = 20.0;
  static const double radioTarjeta = 15.0;

  // Duraciones de animación
  static const Duration animacionRapida = Duration(milliseconds: 200);
  static const Duration animacionMedia = Duration(milliseconds: 300);
  static const Duration animacionLenta = Duration(milliseconds: 500);

  // Mensajes de la aplicación
  static const String appName = 'RouWhite';
  static const String appSubtitle = 'Rutas Popayán';
  static const String mensajeErrorGenerico = 'Ha ocurrido un error inesperado';
  static const String mensajeNoInternet = 'No hay conexión a internet';
  static const String mensajeCargando = 'Cargando...';

  // Validaciones
  static const int longitudMinimaPassword = 6;
  static const int longitudMaximaNombre = 50;
  static const String regexEmail = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

  // URLs y endpoints (para futuras implementaciones)
  static const String baseUrl = 'https://api.rouwhite.com';
  static const String endpointRutas = '/rutas';
  static const String endpointUsuarios = '/usuarios';
  static const String endpointAutenticacion = '/auth';

  // Configuración de mapa
  static const double popayánLatitud = 2.444814;
  static const double popayánLongitud = -76.614739;
  static const double zoomInicialMapa = 13.5;
  static const double zoomDetalleMapa = 16.0;

  // Límites de la aplicación
  static const int maxRutasFavoritas = 10;
  static const int maxHistorialBusquedas = 20;
  static const double distanciaMaximaCaminata = 1000.0; // metros
}

class AppTexts {
  // Textos de autenticación
  static const String iniciarSesion = 'Iniciar Sesión';
  static const String registrarse = 'Registrarse';
  static const String correoElectronico = 'Correo electrónico';
  static const String contrasena = 'Contraseña';
  static const String confirmarContrasena = 'Confirmar contraseña';
  static const String noTienesCuenta = '¿No tienes cuenta? Regístrate';
  static const String yaTienesCuenta = '¿Ya tienes cuenta? Inicia sesión';

  // Textos de navegación
  static const String inicio = 'Inicio';
  static const String rutas = 'Rutas';
  static const String paradas = 'Paradas';
  static const String perfil = 'Perfil';

  // Textos de búsqueda
  static const String buscarRuta = 'Buscar Ruta';
  static const String desdeDonde = '¿Desde dónde?';
  static const String aDondeQuieres = '¿A dónde quieres ir?';
  static const String buscarRutaODestino = 'Buscar ruta o destino...';

  // Textos de estado
  static const String fluido = 'Fluido';
  static const String moderado = 'Moderado';
  static const String congestionado = 'Congestionado';

  // Mensajes de validación
  static const String errorCorreoInvalido = 'Correo inválido';
  static const String errorContrasenaDebil = 'Contraseña débil';
  static const String errorContrasenaNoCoincide = 'Las contraseñas no coinciden';
  static const String errorCampoRequerido = 'Este campo es requerido';
}