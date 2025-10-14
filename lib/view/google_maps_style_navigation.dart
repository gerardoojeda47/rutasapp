import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

import '../core/services/navigation_service.dart';
import '../core/services/location_service_shared.dart';
import '../core/services/smart_notifications_service.dart';
import '../data/popayan_places_data.dart';

class GoogleMapsStyleNavigation extends StatefulWidget {
  final PopayanPlace destination;
  final LatLng userLocation;

  const GoogleMapsStyleNavigation({
    super.key,
    required this.destination,
    required this.userLocation,
  });

  @override
  State<GoogleMapsStyleNavigation> createState() =>
      _GoogleMapsStyleNavigationState();
}

class _GoogleMapsStyleNavigationState extends State<GoogleMapsStyleNavigation>
    with TickerProviderStateMixin {
  final fm.MapController _mapController = fm.MapController();
  final LocationServiceShared _locationService = LocationServiceShared();
  final SmartNotificationsService _notificationService =
      SmartNotificationsService();

  Position? _currentPosition;
  NavigationRouteInfo? _selectedRoute;
  List<NavigationRouteInfo> _availableRoutes = [];
  int _currentStepIndex = 0;

  // Animaciones
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;

  // Estados de navegación
  bool _isNavigating = false;
  double _distanceToNextPoint = 0.0;
  int _estimatedTimeToNext = 0;
  String _currentDirection = '';

  // Información de buses en tiempo real
  Timer? _busTrackingTimer;
  int _nextBusArrival = 8; // minutos

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _calculateRoutes();
    _startLocationTracking();
    _startBusTracking();

    // Inicializar notificaciones después del primer frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notificationService.initialize(context);
    });
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _pulseController.repeat(reverse: true);
    _slideController.forward();
  }

  void _calculateRoutes() {
    // Simular cálculo de rutas múltiples
    _availableRoutes = [
      NavigationRouteInfo(
        id: 'route_1',
        title: 'Ruta más rápida',
        duration: 25,
        walkingTime: 10,
        busTime: 15,
        cost: 2800,
        frequency: 10,
        busRoute: 'TRANSPUBENZA Ruta 1',
        steps: [
          NavigationStepInfo(
            type: NavigationStep.walkingToStop,
            duration: 3,
            distance: 150,
            instruction: 'Camina 150m hacia el norte',
            detail: 'Dirígete a la parada "La Esmeralda"',
          ),
          NavigationStepInfo(
            type: NavigationStep.waitingForBus,
            duration: 7,
            distance: 0,
            instruction: 'Espera el bus',
            detail: 'TRANSPUBENZA Ruta 1 - Sale cada 10 min',
          ),
          NavigationStepInfo(
            type: NavigationStep.onBus,
            duration: 15,
            distance: 3200,
            instruction: 'Viaja en TRANSPUBENZA Ruta 1',
            detail: 'Bájate en "Centro Histórico"',
          ),
        ],
        color: const Color(0xFF4285F4),
        isRecommended: true,
      ),
      NavigationRouteInfo(
        id: 'route_2',
        title: 'Menos caminata',
        duration: 32,
        walkingTime: 5,
        busTime: 27,
        cost: 2800,
        frequency: 15,
        busRoute: 'SOTRACAUCA Ruta 5',
        steps: [
          NavigationStepInfo(
            type: NavigationStep.walkingToStop,
            duration: 2,
            distance: 80,
            instruction: 'Camina 80m hacia el sur',
            detail: 'Dirígete a la parada "Morinda"',
          ),
          NavigationStepInfo(
            type: NavigationStep.waitingForBus,
            duration: 5,
            distance: 0,
            instruction: 'Espera el bus',
            detail: 'SOTRACAUCA Ruta 5 - Sale cada 15 min',
          ),
          NavigationStepInfo(
            type: NavigationStep.onBus,
            duration: 25,
            distance: 4100,
            instruction: 'Viaja en SOTRACAUCA Ruta 5',
            detail: 'Bájate en "Centro Histórico"',
          ),
        ],
        color: const Color(0xFF34A853),
        isRecommended: false,
      ),
    ];

    _selectedRoute = _availableRoutes.first;
  }

  void _startLocationTracking() {
    _locationService.locationStream.listen((Position? position) {
      if (mounted && position != null) {
        setState(() {
          _currentPosition = position;
        });
        _updateNavigationProgress();
      }
    });
  }

  void _startBusTracking() {
    _busTrackingTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) {
        _updateBusInformation();
      }
    });
  }

  void _updateBusInformation() {
    // Simular actualización de información de buses
    setState(() {
      _nextBusArrival = _nextBusArrival > 0 ? _nextBusArrival - 1 : 10;
    });

    // Notificar cuando el bus esté cerca
    if (_nextBusArrival <= 3 && _nextBusArrival > 0 && _isNavigating) {
      _notificationService.showBusArrivalNotification(
        _selectedRoute?.busRoute ?? 'Tu bus',
        _nextBusArrival,
      );
    }

    // Simular detección de ruta más rápida ocasionalmente
    if (_nextBusArrival == 7 && !_isNavigating) {
      _notificationService.showFasterRouteNotification(
        'SOTRACAUCA Ruta 3',
        5,
      );
    }
  }

  void _updateNavigationProgress() {
    if (_selectedRoute == null || _currentPosition == null) return;

    // Simular cálculo de distancia y dirección
    setState(() {
      _distanceToNextPoint = 150.0; // Ejemplo
      _estimatedTimeToNext = 2; // Ejemplo
      _currentDirection = 'norte';
    });
  }

  void _startNavigation() {
    setState(() {
      _isNavigating = true;
      _currentStepIndex = 0;
    });

    _showNavigationInstructions();

    // Mostrar primera instrucción como notificación
    if (_selectedRoute != null && _selectedRoute!.steps.isNotEmpty) {
      final firstStep = _selectedRoute!.steps[0];
      _notificationService.showStepInstructionNotification(
        firstStep.instruction,
        firstStep.detail,
      );
    }
  }

  void _showNavigationInstructions() {
    if (_selectedRoute == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🚶 ${_selectedRoute!.steps[0].instruction}'),
        backgroundColor: const Color(0xFF4285F4),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _slideController.dispose();
    _busTrackingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Cómo llegar a ${widget.destination.name}'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareRoute(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Mapa principal
          Expanded(
            flex: 3,
            child: _buildMap(),
          ),

          // Panel de información deslizable
          Expanded(
            flex: 2,
            child: _buildBottomPanel(),
          ),
        ],
      ),
      floatingActionButton:
          _isNavigating ? _buildNavigationFAB() : _buildStartNavigationFAB(),
    );
  }

  Widget _buildMap() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        child: fm.FlutterMap(
          mapController: _mapController,
          options: fm.MapOptions(
            initialCenter: widget.userLocation,
            initialZoom: 15.0,
            interactionOptions: const fm.InteractionOptions(
              flags: fm.InteractiveFlag.all,
            ),
          ),
          children: [
            fm.TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: const ['a', 'b', 'c'],
              userAgentPackageName: 'com.example.rouwhite',
            ),

            // Marcador de ubicación actual
            if (_currentPosition != null)
              fm.MarkerLayer(
                markers: [
                  fm.Marker(
                    width: 60,
                    height: 60,
                    point: LatLng(_currentPosition!.latitude,
                        _currentPosition!.longitude),
                    child: AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF4285F4)
                                  .withValues(alpha: 0.3),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.my_location,
                                color: Color(0xFF4285F4),
                                size: 30,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

            // Marcador de destino
            fm.MarkerLayer(
              markers: [
                fm.Marker(
                  width: 50,
                  height: 50,
                  point: widget.destination.coordinates,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFEA4335),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.place,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomPanel() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Expanded(
              child: _isNavigating
                  ? _buildNavigationPanel()
                  : _buildRouteSelection(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteSelection() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Opciones de ruta',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
        ),
        const SizedBox(height: 16),
        ..._availableRoutes.map((route) => _buildRouteCard(route)),
      ],
    );
  }

  Widget _buildRouteCard(NavigationRouteInfo route) {
    final isSelected = _selectedRoute?.id == route.id;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color:
            isSelected ? route.color.withValues(alpha: 0.1) : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? route.color : Colors.grey[300]!,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () => setState(() => _selectedRoute = route),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.directions_bus,
                    color: route.color,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              route.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            if (route.isRecommended) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  'Recomendada',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        Text(
                          '${route.duration} min',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Text(
                'Via ${route.busRoute}',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 8),

              // Línea de tiempo visual
              Row(
                children: [
                  _buildTimelineStep(
                      '🚶', '${route.steps[0].duration} min', true),
                  _buildTimelineArrow(),
                  _buildTimelineStep(
                      '🚌', '${route.steps[2].duration} min', false),
                  _buildTimelineArrow(),
                  _buildTimelineStep('🚶', '7 min', false),
                ],
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  Text(
                    'Caminar a',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 40),
                  Text(
                    'Bus hasta',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 40),
                  Text(
                    'Caminar a',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Text(
                    'parada',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 55),
                  Text(
                    'destino',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 50),
                  Text(
                    'destino',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Icon(
                    Icons.attach_money,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  Text(
                    '\$${route.cost}',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.schedule,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  Text(
                    'Sale cada ${route.frequency} min',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineStep(String emoji, String time, bool isFirst) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(
          time,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineArrow() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: const Icon(
        Icons.arrow_forward,
        size: 16,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildNavigationPanel() {
    if (_selectedRoute == null) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Estado actual
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF4285F4).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFF4285F4).withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🎯 Llegando a ${widget.destination.name}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4285F4),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '🚶 ${_distanceToNextPoint.toInt()} metros • ⏱️ $_estimatedTimeToNext minutos',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '🧭 Continúa hacia el $_currentDirection',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.directions_bus,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Próximo bus: $_nextBusArrival minutos',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.place,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Parada: ${widget.destination.name}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Instrucciones paso a paso
          Text(
            'Instrucciones',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: 12),

          ..._selectedRoute!.steps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            final isActive = index == _currentStepIndex;

            return _buildInstructionStep(step, index + 1, isActive);
          }),
        ],
      ),
    );
  }

  Widget _buildInstructionStep(
      NavigationStepInfo step, int stepNumber, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive ? Colors.blue[50] : Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive ? Colors.blue[200]! : Colors.grey[200]!,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isActive ? Colors.blue : Colors.grey[400],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                stepNumber.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_getStepEmoji(step.type)} ${step.instruction} (${step.duration} min)',
                  style: TextStyle(
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    color: isActive ? Colors.blue[800] : Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '→ ${step.detail}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getStepEmoji(NavigationStep step) {
    switch (step) {
      case NavigationStep.walkingToStop:
        return '🚶';
      case NavigationStep.waitingForBus:
        return '⏱️';
      case NavigationStep.onBus:
        return '🚌';
      case NavigationStep.walkingToDestination:
        return '🚶';
    }
  }

  Widget _buildStartNavigationFAB() {
    return FloatingActionButton.extended(
      onPressed: _startNavigation,
      backgroundColor: const Color(0xFF4285F4),
      icon: const Icon(Icons.navigation, color: Colors.white),
      label: const Text(
        'Iniciar',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildNavigationFAB() {
    return FloatingActionButton(
      onPressed: () => NavigationService.popSafely(context),
      backgroundColor: Colors.red,
      child: const Icon(Icons.stop, color: Colors.white),
    );
  }

  void _shareRoute() {
    // Implementar compartir ruta
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🔗 Enlace de ruta copiado'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

// Modelos de datos
class NavigationRouteInfo {
  final String id;
  final String title;
  final int duration;
  final int walkingTime;
  final int busTime;
  final int cost;
  final int frequency;
  final String busRoute;
  final List<NavigationStepInfo> steps;
  final Color color;
  final bool isRecommended;

  NavigationRouteInfo({
    required this.id,
    required this.title,
    required this.duration,
    required this.walkingTime,
    required this.busTime,
    required this.cost,
    required this.frequency,
    required this.busRoute,
    required this.steps,
    required this.color,
    required this.isRecommended,
  });
}

class NavigationStepInfo {
  final NavigationStep type;
  final int duration;
  final double distance;
  final String instruction;
  final String detail;

  NavigationStepInfo({
    required this.type,
    required this.duration,
    required this.distance,
    required this.instruction,
    required this.detail,
  });
}

enum NavigationStep {
  walkingToStop,
  waitingForBus,
  onBus,
  walkingToDestination,
}

class BusInfo {
  final String routeName;
  final int arrivalMinutes;
  final LatLng location;

  BusInfo({
    required this.routeName,
    required this.arrivalMinutes,
    required this.location,
  });
}

