import 'package:flutter/material.dart';
import 'dart:math' as math;

class NativeBannerWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  final Color primaryColor;
  final Color secondaryColor;

  const NativeBannerWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.primaryColor = const Color(0xFFFF6A00),
    this.secondaryColor = const Color(0xFFFFB366),
  });

  @override
  State<NativeBannerWidget> createState() => _NativeBannerWidgetState();
}

class _NativeBannerWidgetState extends State<NativeBannerWidget>
    with TickerProviderStateMixin {
  late AnimationController _titleController;
  late AnimationController _subtitleController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;

  late Animation<double> _titleAnimation;
  late Animation<double> _subtitleAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _titleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _subtitleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _titleAnimation = Tween<double>(
      begin: -50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _titleController,
      curve: Curves.easeOut,
    ));

    _subtitleAnimation = Tween<double>(
      begin: 30.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _subtitleController,
      curve: Curves.easeOut,
    ));

    _floatingAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _floatingController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.5,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Iniciar animaciones
    _titleController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _subtitleController.forward();
    });
    _floatingController.repeat();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [widget.primaryColor, widget.secondaryColor],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            // Iconos flotantes
            ..._buildFloatingIcons(),

            // Efecto de pulso
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Positioned(
                  top: 100 - (100 * _pulseAnimation.value),
                  left: 100 - (100 * _pulseAnimation.value),
                  child: Container(
                    width: 200 * _pulseAnimation.value,
                    height: 200 * _pulseAnimation.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 2,
                      ),
                    ),
                  ),
                );
              },
            ),

            // Contenido principal
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _titleAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _titleAnimation.value),
                        child: Opacity(
                          opacity: _titleController.value,
                          child: Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black54,
                                  blurRadius: 4,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  AnimatedBuilder(
                    animation: _subtitleAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _subtitleAnimation.value),
                        child: Opacity(
                          opacity: _subtitleController.value,
                          child: Text(
                            widget.subtitle,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.9),
                              shadows: const [
                                Shadow(
                                  color: Colors.black54,
                                  blurRadius: 2,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFloatingIcons() {
    final icons = ['🚌', '📍', '🗺️', '⏰', '🚏'];
    final positions = [
      const Offset(0.1, 0.2),
      const Offset(0.8, 0.6),
      const Offset(0.2, 0.8),
      const Offset(0.7, 0.3),
      const Offset(0.5, 0.7),
    ];

    return List.generate(icons.length, (index) {
      return AnimatedBuilder(
        animation: _floatingAnimation,
        builder: (context, child) {
          final offset = math.sin(_floatingAnimation.value + index) * 10;
          return Positioned(
            left: positions[index].dx * 300,
            top: positions[index].dy * 200 + offset,
            child: Opacity(
              opacity: 0.3,
              child: Text(
                icons[index],
                style: const TextStyle(fontSize: 24),
              ),
            ),
          );
        },
      );
    });
  }
}

