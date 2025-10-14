import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WelcomeAnimationProWidget extends StatefulWidget {
  final VoidCallback? onFinish;
  final String appName;
  final Color primary;
  final Color secondary;
  final List<String> coolMessages; // mensajes rotativos
  final String lottieAssetPath;

  const WelcomeAnimationProWidget({
    super.key,
    this.onFinish,
    required this.appName,
    required this.primary,
    required this.secondary,
    required this.coolMessages,
    required this.lottieAssetPath,
  });

  @override
  State<WelcomeAnimationProWidget> createState() =>
      _WelcomeAnimationProWidgetState();
}

class _WelcomeAnimationProWidgetState extends State<WelcomeAnimationProWidget>
    with TickerProviderStateMixin {
  late final AnimationController _bgCtrl;
  late final Animation<double> _bgAnim;
  late final AnimationController _logoCtrl;
  late final AnimationController _scanCtrl;
  late final AnimationController _msgCtrl; // controla tipeo de mensajes
  late final AnimationController _busEmphasisCtrl; // pulso/balanceo del bus

  int _msgIndex = 0;
  String _typedText = '';

  @override
  void initState() {
    super.initState();
    _bgCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 6))
          ..repeat(reverse: true);
    _bgAnim = CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut);

    _logoCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2200))
      ..forward();

    _scanCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800))
      ..repeat(reverse: true);

    _msgCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1600));

    // Control del énfasis del bus (pulso + balanceo sutil)
    _busEmphasisCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    // Arranca el ciclo de mensajes
    _startMessagesCycle();
  }

  Future<void> _startMessagesCycle() async {
    // Muestra 3-4 mensajes rápidos y termina
    final cycles = widget.coolMessages.isEmpty
        ? 0
        : (widget.coolMessages.length.clamp(1, 4));
    for (int i = 0; i < cycles; i++) {
      await _typeMessage(widget.coolMessages[_msgIndex]);
      await Future.delayed(const Duration(milliseconds: 600));
      await _deleteMessage();
      _msgIndex = (_msgIndex + 1) % widget.coolMessages.length;
    }
    // Mensaje final fijo
    await _typeMessage('Listo para explorar Popayán 🚀');
    await Future.delayed(const Duration(milliseconds: 800));
    widget.onFinish?.call();
  }

  Future<void> _typeMessage(String text) async {
    _typedText = '';
    for (int i = 0; i <= text.length; i++) {
      await Future.delayed(const Duration(milliseconds: 28));
      if (!mounted) return;
      setState(() => _typedText = text.substring(0, i));
    }
  }

  Future<void> _deleteMessage() async {
    for (int i = _typedText.length; i >= 0; i--) {
      await Future.delayed(const Duration(milliseconds: 12));
      if (!mounted) return;
      setState(() => _typedText = _typedText.substring(0, i));
    }
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _logoCtrl.dispose();
    _scanCtrl.dispose();
    _msgCtrl.dispose();
    _busEmphasisCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fondo neon + grilla + destellos
        AnimatedBuilder(
          animation: _bgAnim,
          builder: (_, __) => CustomPaint(
            size: Size.infinite,
            painter: _NeonGridBackground(
              primary: widget.primary,
              secondary: widget.secondary,
              t: _bgAnim.value,
            ),
          ),
        ),

        // Contenido centrado
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),

            // Logo con halo y escaneo
            AnimatedBuilder(
              animation: _logoCtrl,
              builder: (_, __) {
                final scale = Tween(begin: 0.8, end: 1.0)
                    .chain(CurveTween(curve: Curves.elasticOut))
                    .evaluate(_logoCtrl);
                final opacity = Tween(begin: 0.0, end: 1.0)
                    .chain(CurveTween(
                        curve: const Interval(0.2, 1.0, curve: Curves.easeIn)))
                    .evaluate(_logoCtrl);
                return Opacity(
                  opacity: opacity,
                  child: Transform.scale(
                    scale: scale,
                    child: SizedBox(
                      width: 220, // más grande
                      height: 220,
                      child: AnimatedBuilder(
                        animation: _busEmphasisCtrl,
                        builder: (_, child) {
                          // Pulso (escala) y balanceo (rotación leve)
                          final pulse = 1.0 +
                              0.06 *
                                  math.sin(
                                      _busEmphasisCtrl.value * 2 * math.pi);
                          final tilt = 0.02 *
                              math.sin(_busEmphasisCtrl.value * 2 * math.pi);
                          return Transform.scale(
                            scale: pulse,
                            child: Transform.rotate(
                              angle: tilt,
                              child: child,
                            ),
                          );
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Halo reforzado
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        widget.primary.withValues(alpha: 0.45),
                                    blurRadius: 80,
                                    spreadRadius: 28,
                                  ),
                                ],
                              ),
                            ),
                            // Órbitas
                            _OrbitRing(
                                color: widget.secondary.withValues(alpha: 0.7),
                                size: 208,
                                stroke: 2.2),
                            _OrbitRing(
                                color: widget.primary.withValues(alpha: 0.8),
                                size: 184,
                                stroke: 2.2),

                            // Lottie bus más grande
                            Padding(
                              padding: const EdgeInsets.all(24),
                              child: Lottie.asset(
                                widget.lottieAssetPath,
                                fit: BoxFit.contain,
                                repeat: true,
                              ),
                            ),

                            // Barrido de escaneo ajustado
                            AnimatedBuilder(
                              animation: _scanCtrl,
                              builder: (_, __) {
                                final y = 220 * (0.2 + 0.6 * _scanCtrl.value);
                                return IgnorePointer(
                                  child: CustomPaint(
                                    size: const Size(220, 220),
                                    painter: _ScanPainter(
                                      color:
                                          Colors.white.withValues(alpha: 0.10),
                                      y: y,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 40),

            // Título App
            Text(
              widget.appName,
              style: const TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.w800,
                letterSpacing: 4,
                color: Colors.white,
                shadows: [
                  Shadow(
                      color: Colors.black54,
                      blurRadius: 8,
                      offset: Offset(2, 3)),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Mensajes cheveres tipo máquina de escribir
            _TypewriterLine(text: _typedText, accent: widget.secondary),

            const Spacer(flex: 3),
          ],
        ),
      ],
    );
  }
}

class _TypewriterLine extends StatelessWidget {
  final String text;
  final Color accent;
  const _TypewriterLine({required this.text, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 120),
            transitionBuilder: (child, anim) =>
                FadeTransition(opacity: anim, child: child),
            child: Text(
              text,
              key: ValueKey(text),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        // Cursor
        _BlinkCursor(color: accent),
      ],
    );
  }
}

class _BlinkCursor extends StatefulWidget {
  final Color color;
  const _BlinkCursor({required this.color});

  @override
  State<_BlinkCursor> createState() => _BlinkCursorState();
}

class _BlinkCursorState extends State<_BlinkCursor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 700))
    ..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _c,
      child: Container(
        width: 8,
        height: 22,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _NeonGridBackground extends CustomPainter {
  final Color primary;
  final Color secondary;
  final double t;

  _NeonGridBackground(
      {required this.primary, required this.secondary, required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    // Gradiente neon
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.lerp(primary, secondary, 0.25 + 0.2 * t)!,
        Color.lerp(secondary, Colors.white, 0.1 + 0.1 * (1 - t))!,
      ],
    );
    final rect = Offset.zero & size;
    final bg = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, bg);

    // Grilla inclinada
    final grid = Paint()
      ..color = Colors.white.withValues(alpha: 0.07)
      ..strokeWidth = 1;

    const spacing = 28.0;
    for (double x = -size.height; x < size.width + size.height; x += spacing) {
      final offset = 18 * (t - 0.5);
      canvas.drawLine(
        Offset(x + offset, 0),
        Offset(x - size.height + offset, size.height),
        grid,
      );
    }
    for (double x = size.width + size.height; x > -size.height; x -= spacing) {
      final offset = 18 * (0.5 - t);
      canvas.drawLine(
        Offset(x + offset, 0),
        Offset(x - size.height + offset, size.height),
        grid,
      );
    }

    // Glows
    final glow = Paint()
      ..color = primary.withValues(alpha: 0.16)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);
    canvas.drawCircle(
        Offset(size.width * 0.25, size.height * (0.32 + 0.05 * t)), 120, glow);
    glow.color = secondary.withValues(alpha: 0.13);
    canvas.drawCircle(
        Offset(size.width * 0.78, size.height * (0.7 - 0.05 * t)), 150, glow);
  }

  @override
  bool shouldRepaint(covariant _NeonGridBackground oldDelegate) =>
      oldDelegate.t != t ||
      oldDelegate.primary != primary ||
      oldDelegate.secondary != secondary;
}

class _ScanPainter extends CustomPainter {
  final Color color;
  final double y;
  _ScanPainter({required this.color, required this.y});

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final rect = Rect.fromLTWH(0, y.clamp(0, size.height - 1), size.width, 8);
    canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(8)), p);
  }

  @override
  bool shouldRepaint(covariant _ScanPainter oldDelegate) =>
      oldDelegate.y != y || oldDelegate.color != color;
}

class _OrbitRing extends StatelessWidget {
  final Color color;
  final double size;
  final double stroke;
  const _OrbitRing(
      {required this.color, required this.size, required this.stroke});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _OrbitPainter(color: color, stroke: stroke),
      ),
    );
  }
}

class _OrbitPainter extends CustomPainter {
  final Color color;
  final double stroke;
  _OrbitPainter({required this.color, required this.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(0.28);
    final rect = Rect.fromCenter(
        center: Offset.zero,
        width: size.width * 0.92,
        height: size.height * 0.64);
    canvas.drawOval(rect, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _OrbitPainter oldDelegate) => false;
}

