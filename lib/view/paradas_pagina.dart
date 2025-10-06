import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart';
import 'dart:async';
import 'dart:math' as math;

class ParadasPagina extends StatefulWidget {
  const ParadasPagina({super.key});

  @override
  State<ParadasPagina> createState() => _ParadasPaginaState();
}

class _ParadasPaginaState extends State<ParadasPagina>
    with TickerProviderStateMixin {
  final fm.MapController _mapController = fm.MapController();
  bool _isLoading = true;
  bool _showSatellite = false;

  // Controladores de animación
  late AnimationController _pulseController;
  late AnimationController _appearanceController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  // Timer para actualizar tiempos
  Timer? _updateTimer;

  // Lista de paradas con estado de animación
  List<ParadaInfo> _paradasList = [];
  Map<String, bool> _paradaVisible = {};

  // Coordenadas de Popayán
  static const LatLng _popayanCenter = LatLng(2.4448, -76.6147);

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeMap();
    _startUpdateTimer();
  }

  void _initializeAnimations() {
    // Animación de pulso para marcadores
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.3,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Animación de aparición
    _appearanceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _appearanceController,
      curve: Curves.elasticOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _appearanceController,
      curve: Curves.easeInOut,
    ));

    // Iniciar animación de pulso
    _pulseController.repeat(reverse: true);
  }

  Future<void> _initializeMap() async {
    // Simular carga del mapa
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      setState(() {
        _isLoading = false;
        _paradasList = _paradas;
      });

      // Iniciar animación de aparición
      _appearanceController.forward();

      // Mostrar paradas con efecto escalonado
      _showParadasWithDelay();
    }
  }

  void _showParadasWithDelay() async {
    for (int i = 0; i < _paradasList.length; i++) {
      await Future.delayed(Duration(milliseconds: 200 + (i * 150)));
      if (mounted) {
        setState(() {
          _paradaVisible[_paradasList[i].codigo] = true;
        });
      }
    }
  }

  void _startUpdateTimer() {
    _updateTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) {
        setState(() {
          // Actualizar tiempos de buses (simulado)
          for (var parada in _paradasList) {
            final currentTime =
                int.tryParse(parada.proximoBus.split(' ')[0]) ?? 5;
            if (currentTime > 1) {
              parada.proximoBus = '${currentTime - 1} min';
            } else {
              parada.proximoBus = '${(2 + (parada.codigo.hashCode % 15))} min';
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _appearanceController.dispose();
    _updateTimer?.cancel();
    super.dispose();
  }

  // Datos de paradas de buses organizadas por empresa
  List<ParadaInfo> get _paradas => [
        // SOTRACAUCA (Verde)
        ParadaInfo(
          coords: const LatLng(2.4448, -76.6147),
          nombre: "Terminal de Transporte",
          codigo: "SOT-001",
          direccion: "Calle 5 # 8-08, Centro",
          empresa: "SOTRACAUCA",
          rutas: ["R1", "R2", "R3"],
          proximoBus: "2 min",
          tipo: TipoParada.terminal,
        ),
        ParadaInfo(
          coords: const LatLng(2.4580, -76.6180),
          nombre: "La Esmeralda",
          codigo: "SOT-002",
          direccion: "Barrio La Esmeralda",
          empresa: "SOTRACAUCA",
          rutas: ["R1"],
          proximoBus: "5 min",
          tipo: TipoParada.barrio,
        ),
        ParadaInfo(
          coords: const LatLng(2.4520, -76.6220),
          nombre: "Campanario",
          codigo: "SOT-003",
          direccion: "Barrio Campanario",
          empresa: "SOTRACAUCA",
          rutas: ["R1", "R2"],
          proximoBus: "3 min",
          tipo: TipoParada.barrio,
        ),
        ParadaInfo(
          coords: const LatLng(2.4280, -76.6280),
          nombre: "Pomona",
          codigo: "SOT-004",
          direccion: "Barrio Pomona",
          empresa: "SOTRACAUCA",
          rutas: ["R1"],
          proximoBus: "8 min",
          tipo: TipoParada.barrio,
        ),
        ParadaInfo(
          coords: const LatLng(2.4180, -76.6100),
          nombre: "Chirimía",
          codigo: "SOT-005",
          direccion: "Barrio Chirimía",
          empresa: "SOTRACAUCA",
          rutas: ["R1", "R3"],
          proximoBus: "12 min",
          tipo: TipoParada.barrio,
        ),

        // TRANSPUBENZA (Azul)
        ParadaInfo(
          coords: const LatLng(2.4320, -76.5980),
          nombre: "Lomas de Granada",
          codigo: "TPB-001",
          direccion: "Lomas de Granada",
          empresa: "TRANSPUBENZA",
          rutas: ["R4", "R8", "R12"],
          proximoBus: "4 min",
          tipo: TipoParada.barrio,
        ),
        ParadaInfo(
          coords: const LatLng(2.4400, -76.6100),
          nombre: "Los Naranjos",
          codigo: "TPB-002",
          direccion: "Barrio Los Naranjos",
          empresa: "TRANSPUBENZA",
          rutas: ["R1", "R3", "R9"],
          proximoBus: "6 min",
          tipo: TipoParada.barrio,
        ),
        ParadaInfo(
          coords: const LatLng(2.4450, -76.6000),
          nombre: "Tomás Cipriano",
          codigo: "TPB-003",
          direccion: "Barrio Tomás Cipriano",
          empresa: "TRANSPUBENZA",
          rutas: ["R1", "R2", "R5"],
          proximoBus: "7 min",
          tipo: TipoParada.barrio,
        ),
        ParadaInfo(
          coords: const LatLng(2.4480, -76.5920),
          nombre: "Piscinas Comfa",
          codigo: "TPB-004",
          direccion: "Sector Piscinas Comfa",
          empresa: "TRANSPUBENZA",
          rutas: ["R4", "R7"],
          proximoBus: "9 min",
          tipo: TipoParada.comercial,
        ),

        // TRANSLIBERTAD (Naranja)
        ParadaInfo(
          coords: const LatLng(2.4419, -76.6066),
          nombre: "Parque Caldas",
          codigo: "TRL-001",
          direccion: "Centro Histórico",
          empresa: "TRANSLIBERTAD",
          rutas: ["R1", "R3"],
          proximoBus: "3 min",
          tipo: TipoParada.centro,
        ),
        ParadaInfo(
          coords: const LatLng(2.4385, -76.6055),
          nombre: "Universidad del Cauca",
          codigo: "TRL-002",
          direccion: "Calle 5 # 4-70, Sector Tulcán",
          empresa: "TRANSLIBERTAD",
          rutas: ["R2", "R4"],
          proximoBus: "5 min",
          tipo: TipoParada.universidad,
        ),
        ParadaInfo(
          coords: const LatLng(2.4350, -76.6120),
          nombre: "Carrera 9 Norte",
          codigo: "TRL-003",
          direccion: "Carrera 9 Norte",
          empresa: "TRANSLIBERTAD",
          rutas: ["R2", "R3"],
          proximoBus: "8 min",
          tipo: TipoParada.centro,
        ),

        // TRANSTAMBO (Púrpura)
        ParadaInfo(
          coords: const LatLng(2.4490, -76.6020),
          nombre: "Hospital Universitario",
          codigo: "TTB-001",
          direccion: "Carrera 6 # 9N-45",
          empresa: "TRANSTAMBO",
          rutas: ["R2"],
          proximoBus: "6 min",
          tipo: TipoParada.hospital,
        ),
        ParadaInfo(
          coords: const LatLng(2.4380, -76.6120),
          nombre: "Villa Del Viento",
          codigo: "TTB-002",
          direccion: "Barrio Villa Del Viento",
          empresa: "TRANSTAMBO",
          rutas: ["R1"],
          proximoBus: "10 min",
          tipo: TipoParada.barrio,
        ),
        ParadaInfo(
          coords: const LatLng(2.4550, -76.5950),
          nombre: "Las Guacas",
          codigo: "TTB-003",
          direccion: "Barrio Las Guacas",
          empresa: "TRANSTAMBO",
          rutas: ["R2"],
          proximoBus: "12 min",
          tipo: TipoParada.barrio,
        ),
        ParadaInfo(
          coords: const LatLng(2.4200, -76.6200),
          nombre: "Los Llanos",
          codigo: "TTB-004",
          direccion: "Barrio Los Llanos",
          empresa: "TRANSTAMBO",
          rutas: ["R4", "R6"],
          proximoBus: "15 min",
          tipo: TipoParada.barrio,
        ),

        // Paradas adicionales
        ParadaInfo(
          coords: const LatLng(2.4480, -76.5920),
          nombre: "C.C. Campanario",
          codigo: "COM-001",
          direccion: "Calle 5 # 38-95",
          empresa: "MULTIPLE",
          rutas: ["SOT-R2", "TPB-R12"],
          proximoBus: "4 min",
          tipo: TipoParada.comercial,
        ),
        ParadaInfo(
          coords: const LatLng(2.4400, -76.6080),
          nombre: "Catedral Basílica",
          codigo: "CTR-001",
          direccion: "Calle 5 # 4-08",
          empresa: "MULTIPLE",
          rutas: ["SOT-R4", "TRL-R1"],
          proximoBus: "3 min",
          tipo: TipoParada.centro,
        ),
      ];

  Color _getEmpresaColor(String empresa) {
    switch (empresa) {
      case 'SOTRACAUCA':
        return const Color(0xFF22c55e); // Verde
      case 'TRANSPUBENZA':
        return const Color(0xFF3b82f6); // Azul
      case 'TRANSLIBERTAD':
        return const Color(0xFFff6b35); // Naranja
      case 'TRANSTAMBO':
        return const Color(0xFF8b5cf6); // Púrpura
      default:
        return const Color(0xFF6b7280); // Gris
    }
  }

  IconData _getTipoIcon(TipoParada tipo) {
    switch (tipo) {
      case TipoParada.terminal:
        return Icons.directions_bus;
      case TipoParada.hospital:
        return Icons.local_hospital;
      case TipoParada.universidad:
        return Icons.school;
      case TipoParada.centro:
        return Icons.location_city;
      case TipoParada.comercial:
        return Icons.shopping_bag;
      case TipoParada.barrio:
        return Icons.home;
    }
  }

  void _mostrarInfoParada(ParadaInfo parada) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getEmpresaColor(parada.empresa),
                    _getEmpresaColor(parada.empresa).withValues(alpha: 0.8),
                  ],
                ),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getTipoIcon(parada.tipo),
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          parada.nombre,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          parada.codigo,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Contenido
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Información básica
                    _buildInfoRow(
                        Icons.location_on, 'Dirección', parada.direccion),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.business, 'Empresa', parada.empresa),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                        Icons.access_time, 'Próximo bus', parada.proximoBus),

                    const SizedBox(height: 20),
                    const Text(
                      'Rutas disponibles',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Rutas
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: parada.rutas
                          .map((ruta) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: _getEmpresaColor(parada.empresa)
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: _getEmpresaColor(parada.empresa)
                                        .withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Text(
                                  '${parada.empresa} $ruta',
                                  style: TextStyle(
                                    color: _getEmpresaColor(parada.empresa),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ))
                          .toList(),
                    ),

                    const SizedBox(height: 20),

                    // Estado en tiempo real
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFdbeafe),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF3b82f6)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF22c55e),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.directions_bus,
                            color: Color(0xFF1e40af),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Próximo bus en ${parada.proximoBus}',
                            style: const TextStyle(
                              color: Color(0xFF1e40af),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  void _centrarMapa() {
    _mapController.move(_popayanCenter, 14.0);
  }

  void _toggleCapas() {
    setState(() {
      _showSatellite = !_showSatellite;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Container(
          color: const Color(0xFFFF6A00),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 4,
                ),
                SizedBox(height: 20),
                Text(
                  'Cargando mapa de paradas...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Preparando ubicaciones de Popayán',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // Mapa
          fm.FlutterMap(
            mapController: _mapController,
            options: fm.MapOptions(
              initialCenter: _popayanCenter,
              initialZoom: 14.0,
              interactionOptions: const fm.InteractionOptions(
                flags: fm.InteractiveFlag.all,
              ),
            ),
            children: [
              // Capa de tiles
              fm.TileLayer(
                urlTemplate: _showSatellite
                    ? "https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}"
                    : "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: _showSatellite ? const [] : const ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.rouwhite',
              ),

              // Marcadores de paradas animados
              fm.MarkerLayer(
                markers: _paradasList
                    .map((parada) => fm.Marker(
                          width: 60,
                          height: 60,
                          point: parada.coords,
                          child: _buildAnimatedMarker(parada),
                        ))
                    .toList(),
              ),

              // Marcador de ubicación actual animado
              fm.MarkerLayer(
                markers: [
                  fm.Marker(
                    width: 40,
                    height: 40,
                    point: _popayanCenter,
                    child: _buildPulsingLocationMarker(),
                  ),
                ],
              ),
            ],
          ),

          // Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFFFF6A00).withValues(alpha: 0.9),
                    const Color(0xFFFF6A00).withValues(alpha: 0.7),
                    const Color(0xFFFF6A00).withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'POPAYÁN',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 4,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Paradas de buses en tiempo real',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 2,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Controles flotantes animados
          Positioned(
            bottom: 30,
            right: 20,
            child: _buildAnimatedControls(),
          ),

          // Leyenda de empresas animada
          Positioned(
            bottom: 30,
            left: 20,
            child: _buildAnimatedLeyenda(),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedMarker(ParadaInfo parada) {
    final isVisible = _paradaVisible[parada.codigo] ?? false;
    final empresaColor = _getEmpresaColor(parada.empresa);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: isVisible ? _scaleAnimation.value : 0.0,
          child: AnimatedOpacity(
            opacity: isVisible ? _fadeAnimation.value : 0.0,
            duration: const Duration(milliseconds: 300),
            child: GestureDetector(
              onTap: () => _mostrarInfoParada(parada),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Anillo de pulso exterior
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Container(
                        width: 50 * _pulseAnimation.value,
                        height: 50 * _pulseAnimation.value,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: empresaColor.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                      );
                    },
                  ),

                  // Anillo de pulso medio
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Container(
                        width: 40 * (1.0 + (_pulseAnimation.value - 1.0) * 0.5),
                        height:
                            40 * (1.0 + (_pulseAnimation.value - 1.0) * 0.5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: empresaColor.withValues(alpha: 0.5),
                            width: 1,
                          ),
                        ),
                      );
                    },
                  ),

                  // Marcador principal con forma de pin y bus
                  SizedBox(
                    width: 44,
                    height: 52,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: empresaColor,
                          size: 44,
                        ),
                        Positioned(
                          top: 8,
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.directions_bus_filled,
                              color: empresaColor,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Etiqueta flotante con nombre
                  if (isVisible)
                    Positioned(
                      top: -35,
                      child: AnimatedOpacity(
                        opacity: 0.9,
                        duration: const Duration(milliseconds: 500),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: empresaColor.withValues(alpha: 0.5),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            parada.codigo,
                            style: TextStyle(
                              color: empresaColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
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

  Widget _buildAnimatedLeyenda() {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return AnimatedOpacity(
          opacity: _isLoading ? 0.0 : _fadeAnimation.value,
          duration: const Duration(milliseconds: 800),
          child: Transform.translate(
            offset: Offset(0, _isLoading ? 50 : 0),
            child: Container(
              padding: const EdgeInsets.all(12),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Empresas',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildLeyendaItem('SOTRACAUCA', const Color(0xFF22c55e)),
                  _buildLeyendaItem('TRANSPUBENZA', const Color(0xFF3b82f6)),
                  _buildLeyendaItem('TRANSLIBERTAD', const Color(0xFFff6b35)),
                  _buildLeyendaItem('TRANSTAMBO', const Color(0xFF8b5cf6)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPulsingLocationMarker() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Anillo exterior pulsante
            Container(
              width: 30 * _pulseAnimation.value,
              height: 30 * _pulseAnimation.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF3b82f6).withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
            ),

            // Anillo medio
            Container(
              width: 20 * (1.0 + (_pulseAnimation.value - 1.0) * 0.3),
              height: 20 * (1.0 + (_pulseAnimation.value - 1.0) * 0.3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF3b82f6).withValues(alpha: 0.2),
              ),
            ),

            // Punto central
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: const Color(0xFF3b82f6),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF3b82f6).withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAnimatedControls() {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return AnimatedOpacity(
          opacity: _isLoading ? 0.0 : _fadeAnimation.value,
          duration: const Duration(milliseconds: 800),
          child: Transform.translate(
            offset: Offset(_isLoading ? 50 : 0, 0),
            child: Column(
              children: [
                _buildAnimatedControlButton(
                  icon: Icons.add,
                  onPressed: () => _mapController.move(
                    _mapController.camera.center,
                    _mapController.camera.zoom + 1,
                  ),
                  heroTag: "zoom_in",
                  delay: 0,
                ),
                const SizedBox(height: 8),
                _buildAnimatedControlButton(
                  icon: Icons.remove,
                  onPressed: () => _mapController.move(
                    _mapController.camera.center,
                    _mapController.camera.zoom - 1,
                  ),
                  heroTag: "zoom_out",
                  delay: 100,
                ),
                const SizedBox(height: 8),
                _buildAnimatedControlButton(
                  icon: Icons.my_location,
                  onPressed: _centrarMapa,
                  heroTag: "center_map",
                  delay: 200,
                ),
                const SizedBox(height: 8),
                _buildAnimatedControlButton(
                  icon: _showSatellite ? Icons.map : Icons.satellite,
                  onPressed: _toggleCapas,
                  heroTag: "toggle_layer",
                  delay: 300,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String heroTag,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 600 + delay),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: FloatingActionButton(
            heroTag: heroTag,
            mini: true,
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFFFF6A00),
            elevation: 4,
            onPressed: onPressed,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                icon,
                key: ValueKey(icon.codePoint),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLeyendaItem(String empresa, Color color) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(-20 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.4),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    empresa,
                    style: const TextStyle(
                      fontSize: 10,
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

// Widget personalizado para efectos de escaneo
class ScanningEffect extends StatefulWidget {
  final Widget child;
  final Color scanColor;
  final Duration duration;

  const ScanningEffect({
    super.key,
    required this.child,
    required this.scanColor,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<ScanningEffect> createState() => _ScanningEffectState();
}

class _ScanningEffectState extends State<ScanningEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          children: [
            widget.child,
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: CustomPaint(
                  painter: ScanLinePainter(
                    progress: _animation.value,
                    color: widget.scanColor,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ScanLinePainter extends CustomPainter {
  final double progress;
  final Color color;

  ScanLinePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        color.withValues(alpha: 0.0),
        color.withValues(alpha: 0.3),
        color.withValues(alpha: 0.0),
      ],
    );

    final rect = Rect.fromLTWH(
      0,
      size.height * progress,
      size.width,
      size.height * 0.1,
    );

    paint.shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Widget para efectos de partículas flotantes
class FloatingParticles extends StatefulWidget {
  final int particleCount;
  final Color particleColor;
  final double maxSize;

  const FloatingParticles({
    super.key,
    this.particleCount = 20,
    this.particleColor = Colors.white,
    this.maxSize = 4.0,
  });

  @override
  State<FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<FloatingParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

    particles = List.generate(widget.particleCount, (index) => Particle());
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlePainter(
            particles: particles,
            progress: _controller.value,
            color: widget.particleColor,
            maxSize: widget.maxSize,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class Particle {
  late double x;
  late double y;
  late double size;
  late double speed;
  late double opacity;

  Particle() {
    reset();
  }

  void reset() {
    x = math.Random().nextDouble();
    y = math.Random().nextDouble();
    size = math.Random().nextDouble() * 3 + 1;
    speed = math.Random().nextDouble() * 0.02 + 0.01;
    opacity = math.Random().nextDouble() * 0.5 + 0.2;
  }

  void update() {
    y -= speed;
    if (y < 0) {
      reset();
      y = 1.0;
    }
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;
  final Color color;
  final double maxSize;

  ParticlePainter({
    required this.particles,
    required this.progress,
    required this.color,
    required this.maxSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    for (final particle in particles) {
      particle.update();

      paint.color = color.withValues(alpha: particle.opacity);

      canvas.drawCircle(
        Offset(
          particle.x * size.width,
          particle.y * size.height,
        ),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Modelos de datos
class ParadaInfo {
  final LatLng coords;
  final String nombre;
  final String codigo;
  final String direccion;
  final String empresa;
  final List<String> rutas;
  String proximoBus;
  final TipoParada tipo;

  ParadaInfo({
    required this.coords,
    required this.nombre,
    required this.codigo,
    required this.direccion,
    required this.empresa,
    required this.rutas,
    required this.proximoBus,
    required this.tipo,
  });
}

enum TipoParada {
  terminal,
  hospital,
  universidad,
  centro,
  comercial,
  barrio,
}
