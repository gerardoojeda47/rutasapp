import 'package:flutter/material.dart';
import 'dart:async';

class SmartNotificationsService {
  static final SmartNotificationsService _instance =
      SmartNotificationsService._internal();
  factory SmartNotificationsService() => _instance;
  SmartNotificationsService._internal();

  BuildContext? _context;
  Timer? _notificationTimer;

  void initialize(BuildContext context) {
    _context = context;
  }

  void showBusArrivalNotification(String routeName, int minutes) {
    final notification = SmartNotification(
      id: 'bus_arrival_${DateTime.now().millisecondsSinceEpoch}',
      type: NotificationType.busArrival,
      title: '🚌 Tu bus está llegando',
      message: '$routeName llega en $minutes minutos',
      icon: Icons.directions_bus,
      color: const Color(0xFF4285F4),
      duration: const Duration(seconds: 5),
      priority: NotificationPriority.high,
    );

    _showNotification(notification);
  }

  void showRouteChangeNotification(String newRoute, String reason) {
    final notification = SmartNotification(
      id: 'route_change_${DateTime.now().millisecondsSinceEpoch}',
      type: NotificationType.routeChange,
      title: '⚠️ Cambio de ruta detectado',
      message: 'Nueva ruta sugerida: $newRoute. $reason',
      icon: Icons.alt_route,
      color: const Color(0xFFFF9800),
      duration: const Duration(seconds: 6),
      priority: NotificationPriority.high,
      actions: [
        NotificationAction(
          label: 'Ver nueva ruta',
          onPressed: () => _handleRouteChange(newRoute),
        ),
        NotificationAction(
          label: 'Mantener actual',
          onPressed: () => _dismissNotification(),
        ),
      ],
    );

    _showNotification(notification);
  }

  void showArrivalNotification(String destinationName) {
    final notification = SmartNotification(
      id: 'arrival_${DateTime.now().millisecondsSinceEpoch}',
      type: NotificationType.arrival,
      title: '🎯 Has llegado a tu destino',
      message: '¡Bienvenido a $destinationName!',
      icon: Icons.celebration,
      color: const Color(0xFF34A853),
      duration: const Duration(seconds: 4),
      priority: NotificationPriority.medium,
      showConfetti: true,
    );

    _showNotification(notification);
  }

  void showFasterRouteNotification(String routeName, int timeSaved) {
    final notification = SmartNotification(
      id: 'faster_route_${DateTime.now().millisecondsSinceEpoch}',
      type: NotificationType.fasterRoute,
      title: '💡 Ruta más rápida disponible',
      message: '$routeName te ahorra $timeSaved minutos',
      icon: Icons.trending_up,
      color: const Color(0xFF9C27B0),
      duration: const Duration(seconds: 5),
      priority: NotificationPriority.medium,
      actions: [
        NotificationAction(
          label: 'Cambiar ruta',
          onPressed: () => _handleFasterRoute(routeName),
        ),
      ],
    );

    _showNotification(notification);
  }

  void showTrafficAlertNotification(String area, String severity) {
    final notification = SmartNotification(
      id: 'traffic_${DateTime.now().millisecondsSinceEpoch}',
      type: NotificationType.traffic,
      title: '🚦 Alerta de tráfico',
      message: 'Tráfico $severity en $area',
      icon: Icons.traffic,
      color: severity == 'pesado'
          ? const Color(0xFFEA4335)
          : const Color(0xFFFF9800),
      duration: const Duration(seconds: 4),
      priority: NotificationPriority.low,
    );

    _showNotification(notification);
  }

  void showStepInstructionNotification(String instruction, String detail) {
    final notification = SmartNotification(
      id: 'instruction_${DateTime.now().millisecondsSinceEpoch}',
      type: NotificationType.instruction,
      title: instruction,
      message: detail,
      icon: Icons.navigation,
      color: const Color(0xFF4285F4),
      duration: const Duration(seconds: 3),
      priority: NotificationPriority.medium,
      isMinimal: true,
    );

    _showNotification(notification);
  }

  void _showNotification(SmartNotification notification) {
    if (_context == null) return;

    // Cancelar notificaciones anteriores del mismo tipo si es necesario
    if (notification.type == NotificationType.instruction) {
      _dismissCurrentNotifications();
    }

    if (notification.isMinimal) {
      _showMinimalNotification(notification);
    } else {
      _showFullNotification(notification);
    }
  }

  void _showMinimalNotification(SmartNotification notification) {
    if (_context == null) return;

    ScaffoldMessenger.of(_context!).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              notification.icon,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    notification.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  if (notification.message.isNotEmpty)
                    Text(
                      notification.message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: notification.color,
        duration: notification.duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  void _showFullNotification(SmartNotification notification) {
    if (_context == null) return;

    showDialog(
      context: _context!,
      barrierDismissible: true,
      builder: (context) => _buildNotificationDialog(notification),
    );

    // Auto-dismiss después del tiempo especificado
    Timer(notification.duration, () {
      if (_context != null && Navigator.canPop(_context!)) {
        Navigator.pop(_context!);
      }
    });
  }

  Widget _buildNotificationDialog(SmartNotification notification) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ícono y título
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: notification.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    notification.icon,
                    color: notification.color,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (notification.message.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          notification.message,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            // Acciones
            if (notification.actions.isNotEmpty) ...[
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: notification.actions.map((action) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(_context!);
                        action.onPressed();
                      },
                      child: Text(
                        action.label,
                        style: TextStyle(
                          color: notification.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],

            // Confetti effect para celebraciones
            if (notification.showConfetti) ...[
              const SizedBox(height: 10),
              const Text(
                '🎉 🎊 ✨ 🎈 🎁',
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _dismissCurrentNotifications() {
    if (_context != null) {
      ScaffoldMessenger.of(_context!).clearSnackBars();
    }
  }

  void _dismissNotification() {
    if (_context != null && Navigator.canPop(_context!)) {
      Navigator.pop(_context!);
    }
  }

  void _handleRouteChange(String newRoute) {
    debugPrint('Cambiando a nueva ruta: $newRoute');
    // Implementar lógica de cambio de ruta
  }

  void _handleFasterRoute(String routeName) {
    debugPrint('Cambiando a ruta más rápida: $routeName');
    // Implementar lógica de ruta más rápida
  }

  void dispose() {
    _notificationTimer?.cancel();
    _context = null;
  }
}

// Modelos de datos
class SmartNotification {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final IconData icon;
  final Color color;
  final Duration duration;
  final NotificationPriority priority;
  final List<NotificationAction> actions;
  final bool showConfetti;
  final bool isMinimal;

  SmartNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
    required this.duration,
    required this.priority,
    this.actions = const [],
    this.showConfetti = false,
    this.isMinimal = false,
  });
}

class NotificationAction {
  final String label;
  final VoidCallback onPressed;

  NotificationAction({
    required this.label,
    required this.onPressed,
  });
}

enum NotificationType {
  busArrival,
  routeChange,
  arrival,
  fasterRoute,
  traffic,
  instruction,
}

enum NotificationPriority {
  low,
  medium,
  high,
}
