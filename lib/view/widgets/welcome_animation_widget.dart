import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WelcomeAnimationWidget extends StatefulWidget {
  final VoidCallback? onAnimationComplete;
  final String title;
  final String subtitle;
  final String message;
  final String lottieAssetPath;
  final Color primaryColor;
  final Color secondaryColor;

  const WelcomeAnimationWidget({
    super.key,
    this.onAnimationComplete,
    required this.title,
    required this.subtitle,
    required this.message,
    required this.lottieAssetPath,
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  State<WelcomeAnimationWidget> createState() => _WelcomeAnimationWidgetState();
}

class _WelcomeAnimationWidgetState extends State<WelcomeAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _messageController;
  late AnimationController _particlesController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _messageOpacityAnimation;
  late Animation<Offset> _messageSlideAnimation;
  late Animation<double> _particlesOpacityAnimation;

  bool _showParticles = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    // Controlador para el logo
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    // Controlador para el texto principal
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    // Controlador para el mensaje
    _messageController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Controlador para partículas
    _particlesController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Animaciones del logo
    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    _logoRotationAnimation = Tween<double>(
      begin: -0.2,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOutBack,
    ));

    // Animaciones del texto
    _textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    ));

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.8),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutBack,
    ));

    // Animaciones del mensaje
    _messageOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _messageController,
      curve: Curves.easeIn,
    ));

    _messageSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _messageController,
      curve: Curves.easeOutCubic,
    ));

    // Animación de partículas
    _particlesOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _particlesController,
      curve: Curves.easeIn,
    ));
  }

  void _startAnimationSequence() async {
    // Iniciar animación del logo
    _logoController.forward();

    // Esperar y mostrar partículas
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      setState(() {
        _showParticles = true;
      });
      _particlesController.forward();
    }

    // Esperar y iniciar animación del texto
    await Future.delayed(const Duration(milliseconds: 700));
    _textController.forward();

    // Esperar y iniciar animación del mensaje
    await Future.delayed(const Duration(milliseconds: 600));
    _messageController.forward();

    // Notificar que la animación ha terminado
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted && widget.onAnimationComplete != null) {
      widget.onAnimationComplete!();
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _messageController.dispose();
    _particlesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Partículas de fondo
        if (_showParticles)
          AnimatedBuilder(
            animation: _particlesController,
            builder: (context, child) {
              return Opacity(
                opacity: _particlesOpacityAnimation.value,
                child: _buildParticles(),
              );
            },
          ),

        // Contenido principal
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),

            // Logo animado con Lottie
            AnimatedBuilder(
              animation: _logoController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _logoScaleAnimation.value,
                  child: Transform.rotate(
                    angle: _logoRotationAnimation.value,
                    child: Opacity(
                      opacity: _logoOpacityAnimation.value,
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: widget.primaryColor.withValues(alpha: 0.4),
                              blurRadius: 40,
                              offset: const Offset(0, 20),
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(25),
                          child: Lottie.asset(
                            widget.lottieAssetPath,
                            fit: BoxFit.contain,
                            repeat: true,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 60),

            // Título principal
            AnimatedBuilder(
              animation: _textController,
              builder: (context, child) {
                return SlideTransition(
                  position: _textSlideAnimation,
                  child: Opacity(
                    opacity: _textOpacityAnimation.value,
                    child: Column(
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 4,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                offset: const Offset(3, 3),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.subtitle,
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 2,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                offset: const Offset(2, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 50),

            // Mensaje de bienvenida
            AnimatedBuilder(
              animation: _messageController,
              builder: (context, child) {
                return SlideTransition(
                  position: _messageSlideAnimation,
                  child: Opacity(
                    opacity: _messageOpacityAnimation.value,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(35),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.4),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Text(
                        widget.message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              },
            ),

            const Spacer(flex: 2),
          ],
        ),
      ],
    );
  }

  Widget _buildParticles() {
    return CustomPaint(
      size: Size.infinite,
      painter: ParticlesPainter(
        color: widget.secondaryColor,
        animationValue: _particlesController.value,
      ),
    );
  }
}

class ParticlesPainter extends CustomPainter {
  final Color color;
  final double animationValue;

  const ParticlesPainter({
    required this.color,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    final random = DateTime.now().millisecondsSinceEpoch;
    const particleCount = 20;

    for (int i = 0; i < particleCount; i++) {
      final x = (random + i * 123) % size.width;
      final y = (random + i * 456) % size.height;
      final radius = 2.0 + (random + i * 789) % 3.0;
      final opacity = 0.1 + (random + i * 321) % 0.3;

      paint.color = color.withValues(alpha: opacity);
      canvas.drawCircle(
        Offset(x, y),
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
