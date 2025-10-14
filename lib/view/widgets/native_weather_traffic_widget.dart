import 'package:flutter/material.dart';

class NativeWeatherTrafficWidget extends StatefulWidget {
  final String temperature;
  final String weatherCondition;
  final String trafficStatus;
  final int trafficLevel; // 1-5 scale

  const NativeWeatherTrafficWidget({
    super.key,
    required this.temperature,
    required this.weatherCondition,
    required this.trafficStatus,
    required this.trafficLevel,
  });

  @override
  State<NativeWeatherTrafficWidget> createState() =>
      _NativeWeatherTrafficWidgetState();
}

class _NativeWeatherTrafficWidgetState extends State<NativeWeatherTrafficWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  String _getWeatherIcon() {
    switch (widget.weatherCondition.toLowerCase()) {
      case 'soleado':
      case 'despejado':
        return '☀️';
      case 'nublado':
      case 'parcialmente nublado':
        return '⛅';
      case 'lluvia':
      case 'llovizna':
        return '🌧️';
      case 'tormenta':
        return '⛈️';
      default:
        return '🌤️';
    }
  }

  Color _getTrafficColor() {
    switch (widget.trafficLevel) {
      case 1:
        return const Color(0xFF4CAF50); // Verde
      case 2:
        return const Color(0xFF8BC34A); // Verde claro
      case 3:
        return const Color(0xFFFFC107); // Amarillo
      case 4:
        return const Color(0xFFFF9800); // Naranja
      case 5:
        return const Color(0xFFF44336); // Rojo
      default:
        return const Color(0xFF4CAF50);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF6A00), Color(0xFFFFB366)],
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
      child: Column(
        children: [
          // Header
          const Text(
            '🌤️ Condiciones Actuales',
            style: TextStyle(
              fontSize: 20,
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
            'Popayán, Cauca',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 20),

          // Cards
          Row(
            children: [
              Expanded(child: _buildWeatherCard()),
              const SizedBox(width: 20),
              Expanded(child: _buildTrafficCard()),
            ],
          ),

          const SizedBox(height: 15),

          // Update time
          Text(
            'Actualizado hace 2 minutos',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherCard() {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(-30 * (1 - _slideAnimation.value), 0),
          child: Opacity(
            opacity: _slideAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95),
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
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Text(
                          _getWeatherIcon(),
                          style: const TextStyle(fontSize: 40),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${widget.temperature}°C',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2d3436),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.weatherCondition,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
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

  Widget _buildTrafficCard() {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(30 * (1 - _slideAnimation.value), 0),
          child: Opacity(
            opacity: _slideAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.95),
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
                  const Text(
                    '🚦',
                    style: TextStyle(fontSize: 40),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.trafficStatus,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _getTrafficColor(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildTrafficBars(),
                  const SizedBox(height: 8),
                  Text(
                    'Nivel de tráfico',
                    style: TextStyle(
                      fontSize: 12,
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

  Widget _buildTrafficBars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final isActive = index < widget.trafficLevel;
        return AnimatedContainer(
          duration: Duration(milliseconds: 300 + (index * 100)),
          margin: const EdgeInsets.symmetric(horizontal: 2),
          width: 8,
          height: 20,
          decoration: BoxDecoration(
            color: isActive ? _getTrafficColor() : Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

