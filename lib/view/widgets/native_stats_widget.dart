import 'package:flutter/material.dart';

class NativeStatsWidget extends StatefulWidget {
  final int activeBuses;
  final int totalRoutes;
  final int busStops;
  final String cityName;

  const NativeStatsWidget({
    super.key,
    required this.activeBuses,
    required this.totalRoutes,
    required this.busStops,
    required this.cityName,
  });

  @override
  State<NativeStatsWidget> createState() => _NativeStatsWidgetState();
}

class _NativeStatsWidgetState extends State<NativeStatsWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<AnimationController> _cardControllers;
  late List<Animation<double>> _cardAnimations;
  late List<Animation<double>> _numberAnimations;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _cardControllers = List.generate(
        3,
        (index) => AnimationController(
              duration: const Duration(milliseconds: 600),
              vsync: this,
            ));

    _cardAnimations = _cardControllers
        .map((controller) => Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeOut)))
        .toList();

    _numberAnimations = [
      Tween<double>(begin: 0.0, end: widget.activeBuses.toDouble()).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut)),
      Tween<double>(begin: 0.0, end: widget.totalRoutes.toDouble()).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut)),
      Tween<double>(begin: 0.0, end: widget.busStops.toDouble()).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut)),
    ];

    // Iniciar animaciones escalonadas
    for (int i = 0; i < _cardControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        _cardControllers[i].forward();
      });
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (var controller in _cardControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Text(
            widget.cityName.toUpperCase(),
            style: const TextStyle(
              fontSize: 24,
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
          const SizedBox(height: 5),
          Text(
            'Estadísticas en Tiempo Real',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 25),

          // Stats Cards
          Row(
            children: [
              Expanded(child: _buildStatCard(0, '🚌', 'Buses Activos', true)),
              const SizedBox(width: 15),
              Expanded(
                  child: _buildStatCard(1, '🛣️', 'Rutas Disponibles', false)),
              const SizedBox(width: 15),
              Expanded(child: _buildStatCard(2, '🚏', 'Paradas de Bus', false)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(int index, String icon, String label, bool isPulsing) {
    return AnimatedBuilder(
      animation: _cardAnimations[index],
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - _cardAnimations[index].value)),
          child: Opacity(
            opacity: _cardAnimations[index].value,
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    icon,
                    style: const TextStyle(fontSize: 28),
                  ),
                  const SizedBox(height: 8),
                  AnimatedBuilder(
                    animation: _numberAnimations[index],
                    builder: (context, child) {
                      return AnimatedScale(
                        scale: isPulsing ? 1.1 : 1.0,
                        duration: const Duration(milliseconds: 1000),
                        child: Text(
                          '${_numberAnimations[index].value.round()}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF6A00),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 5),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

