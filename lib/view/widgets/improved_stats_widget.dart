import 'package:flutter/material.dart';
import 'enhanced_stats_card.dart';

class ImprovedStatsWidget extends StatefulWidget {
  final int activeBuses;
  final int totalRoutes;
  final int busStops;
  final String cityName;

  const ImprovedStatsWidget({
    super.key,
    required this.activeBuses,
    required this.totalRoutes,
    required this.busStops,
    required this.cityName,
  });

  @override
  State<ImprovedStatsWidget> createState() => _ImprovedStatsWidgetState();
}

class _ImprovedStatsWidgetState extends State<ImprovedStatsWidget>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late Animation<double> _headerAnimation;

  @override
  void initState() {
    super.initState();

    _headerController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _headerAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOut,
    ));

    _headerController.forward();
  }

  @override
  void dispose() {
    _headerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFF6A00),
            Color(0xFFFFB366),
            Color(0xFFFF6A00),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6A00).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header animado
          AnimatedBuilder(
            animation: _headerAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, -20 * (1 - _headerAnimation.value)),
                child: Opacity(
                  opacity: _headerAnimation.value,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.analytics_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              widget.cityName.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Estadísticas en Tiempo Real',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        width: 60,
                        height: 3,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.white,
                              Colors.transparent,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 30),

          // Stats Cards
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                // Layout horizontal para pantallas grandes
                return Row(
                  children: [
                    Expanded(
                      child: EnhancedStatsCard(
                        icon: '🚌',
                        value: widget.activeBuses,
                        label: 'Buses Activos',
                        color: const Color(0xFFFF6A00),
                        isPulsing: true,
                        animationDelay: 0,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: EnhancedStatsCard(
                        icon: '🛣️',
                        value: widget.totalRoutes,
                        label: 'Rutas Disponibles',
                        color: const Color(0xFF4CAF50),
                        animationDelay: 200,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: EnhancedStatsCard(
                        icon: '🚏',
                        value: widget.busStops,
                        label: 'Paradas de Bus',
                        color: const Color(0xFF2196F3),
                        animationDelay: 400,
                      ),
                    ),
                  ],
                );
              } else {
                // Layout vertical para pantallas pequeñas
                return Column(
                  children: [
                    EnhancedStatsCard(
                      icon: '🚌',
                      value: widget.activeBuses,
                      label: 'Buses Activos',
                      color: const Color(0xFFFF6A00),
                      isPulsing: true,
                      animationDelay: 0,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: EnhancedStatsCard(
                            icon: '🛣️',
                            value: widget.totalRoutes,
                            label: 'Rutas Disponibles',
                            color: const Color(0xFF4CAF50),
                            animationDelay: 200,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: EnhancedStatsCard(
                            icon: '🚏',
                            value: widget.busStops,
                            label: 'Paradas de Bus',
                            color: const Color(0xFF2196F3),
                            animationDelay: 400,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
            },
          ),

          const SizedBox(height: 20),

          // Footer con información adicional
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.update,
                  color: Colors.white.withValues(alpha: 0.8),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Actualizado hace 2 minutos',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
