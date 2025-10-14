import 'package:flutter/material.dart';

enum TransitionType { slide, fade, scale, slideUp, slideDown }

class NavigationService {
  static const Duration _defaultDuration = Duration(milliseconds: 300);
  static const Duration _safeDuration = Duration(milliseconds: 800);

  // Contador para detectar navegaciones fallidas consecutivas
  static int _failureCount = 0;
  static const int _maxFailures = 3;

  /// Navega a una nueva página con transición segura
  static Future<T?> pushWithSafeTransition<T>(
    BuildContext context,
    Widget destination, {
    TransitionType type = TransitionType.slide,
    Duration duration = _defaultDuration,
  }) async {
    if (!context.mounted) {
      debugPrint('NavigationService: Context not mounted, aborting navigation');
      return null;
    }

    try {
      final result = await Navigator.of(context).push<T>(
        _createRoute<T>(destination, type, duration),
      );

      // Reset failure count on successful navigation
      _failureCount = 0;
      return result;
    } catch (e) {
      _failureCount++;
      debugPrint(
          'NavigationService: Error in pushWithSafeTransition (attempt $_failureCount): $e');

      // Si hay muchos fallos consecutivos, usar navegación más simple
      if (_failureCount >= _maxFailures) {
        debugPrint(
            'NavigationService: Too many failures, using simple navigation');
        try {
          return await Navigator.of(context).push<T>(
            MaterialPageRoute(builder: (_) => destination),
          );
        } catch (fallbackError) {
          debugPrint(
              'NavigationService: Fallback navigation also failed: $fallbackError');
          _showNavigationError(context);
          return null;
        }
      }

      // Retry con transición más simple
      try {
        return await Navigator.of(context).push<T>(
          _createRoute<T>(destination, TransitionType.fade, _defaultDuration),
        );
      } catch (retryError) {
        debugPrint(
            'NavigationService: Retry with fade transition failed: $retryError');
        return await Navigator.of(context).push<T>(
          MaterialPageRoute(builder: (_) => destination),
        );
      }
    }
  }

  /// Reemplaza la página actual con transición segura
  static Future<T?> pushReplacementWithSafeTransition<T>(
    BuildContext context,
    Widget destination, {
    TransitionType type = TransitionType.fade,
    Duration duration = _safeDuration,
  }) async {
    if (!context.mounted) {
      debugPrint(
          'NavigationService: Context not mounted, aborting replacement navigation');
      return null;
    }

    try {
      final result = await Navigator.of(context).pushReplacement<T, dynamic>(
        _createRoute<T>(destination, type, duration),
      );

      // Reset failure count on successful navigation
      _failureCount = 0;
      return result;
    } catch (e) {
      _failureCount++;
      debugPrint(
          'NavigationService: Error in pushReplacementWithSafeTransition (attempt $_failureCount): $e');

      // Si hay muchos fallos consecutivos, usar navegación más simple
      if (_failureCount >= _maxFailures) {
        debugPrint(
            'NavigationService: Too many failures, using simple replacement navigation');
        try {
          return await Navigator.of(context).pushReplacement<T, dynamic>(
            MaterialPageRoute(builder: (_) => destination),
          );
        } catch (fallbackError) {
          debugPrint(
              'NavigationService: Fallback replacement navigation also failed: $fallbackError');
          _showNavigationError(context);
          return null;
        }
      }

      // Retry con transición más simple
      try {
        return await Navigator.of(context).pushReplacement<T, dynamic>(
          _createRoute<T>(destination, TransitionType.fade, _defaultDuration),
        );
      } catch (retryError) {
        debugPrint(
            'NavigationService: Retry replacement with fade transition failed: $retryError');
        return await Navigator.of(context).pushReplacement<T, dynamic>(
          MaterialPageRoute(builder: (_) => destination),
        );
      }
    }
  }

  /// Crea una ruta personalizada con la transición especificada
  static PageRouteBuilder<T> _createRoute<T>(
    Widget destination,
    TransitionType type,
    Duration duration,
  ) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => destination,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return _buildTransition(type, animation, secondaryAnimation, child);
      },
      transitionDuration: duration,
      reverseTransitionDuration: duration,
    );
  }

  /// Construye la transición basada en el tipo especificado
  static Widget _buildTransition(
    TransitionType type,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    switch (type) {
      case TransitionType.fade:
        return FadeTransition(
          opacity: animation,
          child: child,
        );

      case TransitionType.scale:
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.8,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubic,
          )),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );

      case TransitionType.slideUp:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubic,
          )),
          child: child,
        );

      case TransitionType.slideDown:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, -1.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubic,
          )),
          child: child,
        );

      case TransitionType.slide:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubic,
          )),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
    }
  }

  /// Verifica si el contexto es válido para navegación
  static bool isContextValid(BuildContext context) {
    return context.mounted && Navigator.canPop(context) ||
        Navigator.of(context).canPop();
  }

  /// Navega hacia atrás de forma segura
  static void popSafely(BuildContext context, [dynamic result]) {
    if (context.mounted && Navigator.canPop(context)) {
      Navigator.of(context).pop(result);
    }
  }

  /// Muestra un error de navegación al usuario
  static void _showNavigationError(BuildContext context) {
    if (!context.mounted) return;

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error de navegación. Intenta nuevamente.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      debugPrint('NavigationService: Could not show error message: $e');
    }
  }

  /// Resetea el contador de fallos (útil para testing o reinicio manual)
  static void resetFailureCount() {
    _failureCount = 0;
  }

  /// Obtiene el número actual de fallos consecutivos
  static int get currentFailureCount => _failureCount;
}

