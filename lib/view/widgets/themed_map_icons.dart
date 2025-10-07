import 'package:flutter/material.dart';

class ThemedMapIcons extends StatefulWidget {
  final VoidCallback? onBusPressed;
  final VoidCallback? onTrafficPressed;
  final VoidCallback? onHealthPressed;
  final VoidCallback? onEducationPressed;
  final VoidCallback? onCommercePressed;
  final VoidCallback? onParksPressed;

  const ThemedMapIcons({
    super.key,
    this.onBusPressed,
    this.onTrafficPressed,
    this.onHealthPressed,
    this.onEducationPressed,
    this.onCommercePressed,
    this.onParksPressed,
  });

  @override
  State<ThemedMapIcons> createState() => _ThemedMapIconsState();
}

class _ThemedMapIconsState extends State<ThemedMapIcons>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _rotationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_rotationController);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Iconos del lado izquierdo
        Positioned(
          bottom: 20,
          left: 15,
          child: Column(
            children: [
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: _buildThemedIcon(
                      icon: Icons.directions_bus,
                      emoji: '🚌',
                      label: 'Buses',
                      color: const Color(0xFF4CAF50),
                      onTap: widget.onBusPressed,
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),
              _buildThemedIcon(
                icon: Icons.traffic,
                emoji: '🚦',
                label: 'Tráfico',
                color: const Color(0xFFFF9800),
                onTap: widget.onTrafficPressed,
              ),
            ],
          ),
        ),

        // Iconos del lado derecho
        Positioned(
          bottom: 20,
          right: 15,
          child: Column(
            children: [
              _buildThemedIcon(
                icon: Icons.local_hospital,
                emoji: '🏥',
                label: 'Salud',
                color: const Color(0xFFE91E63),
                onTap: widget.onHealthPressed,
              ),
              const SizedBox(height: 15),
              _buildThemedIcon(
                icon: Icons.school,
                emoji: '🎓',
                label: 'Educación',
                color: const Color(0xFF3F51B5),
                onTap: widget.onEducationPressed,
              ),
            ],
          ),
        ),

        // Iconos superiores
        Positioned(
          top: 80,
          right: 15,
          child: Column(
            children: [
              AnimatedBuilder(
                animation: _rotationAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationAnimation.value * 2 * 3.14159,
                    child: _buildThemedIcon(
                      icon: Icons.store,
                      emoji: '🛍️',
                      label: 'Comercio',
                      color: const Color(0xFF9C27B0),
                      onTap: widget.onCommercePressed,
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),
              _buildThemedIcon(
                icon: Icons.park,
                emoji: '🌳',
                label: 'Parques',
                color: const Color(0xFF4CAF50),
                onTap: widget.onParksPressed,
              ),
            ],
          ),
        ),

        // Icono central flotante (opcional)
        Positioned(
          top: 120,
          left: MediaQuery.of(context).size.width / 2 - 30,
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value * 0.8,
                child: _buildCentralIcon(),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildThemedIcon({
    required IconData icon,
    required String emoji,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(27.5),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: color.withValues(alpha: 0.4),
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            // Fondo con gradiente sutil
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.5),
                gradient: RadialGradient(
                  colors: [
                    color.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            // Icono principal
            Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 24),
              ),
            ),
            // Indicador de estado
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.5),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCentralIcon() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6A00).withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFFF6A00),
          width: 3,
        ),
      ),
      child: const Stack(
        children: [
          Center(
            child: Text(
              '🚍',
              style: TextStyle(fontSize: 28),
            ),
          ),
          Positioned(
            bottom: 2,
            right: 2,
            child: Text(
              '⚡',
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget para mostrar información contextual
class MapInfoOverlay extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback? onClose;

  const MapInfoOverlay({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 60,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            if (onClose != null)
              IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close),
                color: Colors.grey,
              ),
          ],
        ),
      ),
    );
  }
}
