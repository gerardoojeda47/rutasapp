import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Widget para marcador de ubicación actual con animación pulsante
class PulsingLocationMarker extends StatefulWidget {
  final double size;
  final Color color;
  final Color pulseColor;

  const PulsingLocationMarker({
    super.key,
    this.size = 40.0,
    this.color = const Color(0xFFFF6A00),
    this.pulseColor = const Color(0xFFFF6A00),
  });

  @override
  State<PulsingLocationMarker> createState() => _PulsingLocationMarkerState();
}

class _PulsingLocationMarkerState extends State<PulsingLocationMarker>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // Animación de pulso
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Animación de rotación sutil
    _rotationController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_rotationController);

    // Iniciar animaciones
    _pulseController.repeat(reverse: true);
    _rotationController.repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _rotationAnimation]),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Círculo de pulso exterior
            Transform.scale(
              scale: _pulseAnimation.value * 1.5,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.pulseColor.withValues(alpha: 0.3),
                ),
              ),
            ),
            // Círculo de pulso medio
            Transform.scale(
              scale: _pulseAnimation.value * 1.2,
              child: Container(
                width: widget.size * 0.8,
                height: widget.size * 0.8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.pulseColor.withValues(alpha: 0.5),
                ),
              ),
            ),
            // Marcador principal
            Transform.rotate(
              angle: _rotationAnimation.value * 0.1, // Rotación muy sutil
              child: Container(
                width: widget.size * 0.6,
                height: widget.size * 0.6,
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.my_location,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Widget para marcador de parada de bus animado
class AnimatedBusStopMarker extends StatefulWidget {
  final double size;
  final Color color;
  final bool isActive;
  final String? busId;

  const AnimatedBusStopMarker({
    super.key,
    this.size = 30.0,
    this.color = Colors.blue,
    this.isActive = false,
    this.busId,
  });

  @override
  State<AnimatedBusStopMarker> createState() => _AnimatedBusStopMarkerState();
}

class _AnimatedBusStopMarkerState extends State<AnimatedBusStopMarker>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _glowController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    // Animación de rebote
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    ));

    // Animación de brillo para paradas activas
    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _glowAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    // Iniciar animaciones
    _bounceController.forward();
    if (widget.isActive) {
      _glowController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_bounceAnimation, _glowAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _bounceAnimation.value,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Efecto de brillo para paradas activas
              if (widget.isActive)
                Container(
                  width: widget.size * 1.8,
                  height: widget.size * 1.8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color.withValues(
                      alpha: 0.3 * _glowAnimation.value,
                    ),
                  ),
                ),
              // Marcador principal
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.directions_bus,
                      color: Colors.white,
                      size: widget.size * 0.5,
                    ),
                    // Indicador de bus activo
                    if (widget.isActive)
                      Positioned(
                        top: 2,
                        right: 2,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Animación de bus si hay uno disponible
              if (widget.busId != null)
                Positioned(
                  bottom: -5,
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: Lottie.asset(
                      'assets/animaciones/bus.json',
                      repeat: true,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Widget para marcador de punto de interés
class InterestPointMarker extends StatefulWidget {
  final double size;
  final Color color;
  final IconData icon;
  final String label;

  const InterestPointMarker({
    super.key,
    this.size = 35.0,
    this.color = Colors.orange,
    this.icon = Icons.location_city,
    required this.label,
  });

  @override
  State<InterestPointMarker> createState() => _InterestPointMarkerState();
}

class _InterestPointMarkerState extends State<InterestPointMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.bounceOut,
    ));

    // Delay aleatorio para efecto escalonado
    Future.delayed(
      Duration(milliseconds: (widget.label.hashCode % 500).abs()),
      () {
        if (mounted) {
          _scaleController.forward();
        }
      },
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  widget.icon,
                  color: Colors.white,
                  size: widget.size * 0.6,
                ),
              ),
              // Etiqueta opcional
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Widget para marcador de navegación (origen/destino)
class NavigationMarker extends StatefulWidget {
  final double size;
  final Color color;
  final IconData icon;
  final bool isDestination;

  const NavigationMarker({
    super.key,
    this.size = 40.0,
    this.color = Colors.green,
    this.icon = Icons.play_arrow,
    this.isDestination = false,
  });

  @override
  State<NavigationMarker> createState() => _NavigationMarkerState();
}

class _NavigationMarkerState extends State<NavigationMarker>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _dropController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _dropAnimation;

  @override
  void initState() {
    super.initState();

    // Animación de caída
    _dropController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _dropAnimation = Tween<double>(
      begin: -100.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _dropController,
      curve: Curves.bounceOut,
    ));

    // Animación de pulso para destino
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.9,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Iniciar animaciones
    _dropController.forward();
    if (widget.isDestination) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _dropController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_dropAnimation, _pulseAnimation]),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _dropAnimation.value),
          child: Transform.scale(
            scale: widget.isDestination ? _pulseAnimation.value : 1.0,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(
                widget.icon,
                color: Colors.white,
                size: widget.size * 0.5,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Widget para marcador de instrucción numerada
class AnimatedInstructionMarker extends StatefulWidget {
  final int number;
  final Duration delay;
  final double size;
  final Color color;

  const AnimatedInstructionMarker({
    super.key,
    required this.number,
    this.delay = Duration.zero,
    this.size = 30.0,
    this.color = const Color(0xFFFF6A00),
  });

  @override
  State<AnimatedInstructionMarker> createState() =>
      _AnimatedInstructionMarkerState();
}

class _AnimatedInstructionMarkerState extends State<AnimatedInstructionMarker>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _glowController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    // Animación de escala con rebote
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    // Animación de brillo sutil
    _glowController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _glowAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    // Iniciar animaciones con delay
    Future.delayed(widget.delay, () {
      if (mounted) {
        _scaleController.forward();
        _glowController.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleAnimation, _glowAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Efecto de brillo
              Container(
                width: widget.size * 1.5,
                height: widget.size * 1.5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color.withValues(
                    alpha: 0.2 * _glowAnimation.value,
                  ),
                ),
              ),
              // Marcador principal
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '${widget.number}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: widget.size * 0.4,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
