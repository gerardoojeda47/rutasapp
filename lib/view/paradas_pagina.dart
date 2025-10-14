import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart';
import 'dart:async';
import 'dart:math' as math;

// Clase para representar puntos de interés en el mapa
class PointOfInterest {
  final String name;
  final LatLng position;
  final POIType type;
  final String? description;

  PointOfInterest({
    required this.name,
    required this.position,
    required this.type,
    this.description,
  });
}

// Tipos de puntos de interés
enum POIType {
  hospital,
  school,
  university,
  park,
  church,
  mall,
  restaurant,
  bank,
  gasStation,
  police,
  hotel,
  museum,
  library,
  pharmacy,
  supermarket,
}

// Extensión para obtener el icono según el tipo de POI
extension POITypeExtension on POIType {
  IconData get icon {
    switch (this) {
      case POIType.hospital:
        return Icons.local_hospital;
      case POIType.school:
        return Icons.school;
      case POIType.university:
        return Icons.account_balance;
      case POIType.park:
        return Icons.park;
      case POIType.church:
        return Icons.church;
      case POIType.mall:
        return Icons.shopping_bag;
      case POIType.restaurant:
        return Icons.restaurant;
      case POIType.bank:
        return Icons.account_balance;
      case POIType.gasStation:
        return Icons.local_gas_station;
      case POIType.police:
        return Icons.local_police;
      case POIType.hotel:
        return Icons.hotel;
      case POIType.museum:
        return Icons.museum;
      case POIType.library:
        return Icons.local_library;
      case POIType.pharmacy:
        return Icons.local_pharmacy;
      case POIType.supermarket:
        return Icons.shopping_cart;
    }
  }

  Color get color {
    switch (this) {
      case POIType.hospital:
        return Colors.red;
      case POIType.school:
        return Colors.orange;
      case POIType.university:
        return Colors.deepPurple;
      case POIType.park:
        return Colors.green;
      case POIType.church:
        return Colors.indigo;
      case POIType.mall:
        return Colors.pink;
      case POIType.restaurant:
        return Colors.amber;
      case POIType.bank:
        return Colors.blue;
      case POIType.gasStation:
        return Colors.red.shade800;
      case POIType.police:
        return Colors.blue.shade900;
      case POIType.hotel:
        return Colors.teal;
      case POIType.museum:
        return Colors.brown;
      case POIType.library:
        return Colors.deepOrange;
      case POIType.pharmacy:
        return Colors.lightGreen;
      case POIType.supermarket:
        return Colors.cyan;
    }
  }
}

class ParadasPagina extends StatefulWidget {
  const ParadasPagina({super.key});

  @override
  State<ParadasPagina> createState() => _ParadasPaginaState();
}

class _ParadasPaginaState extends State<ParadasPagina>
    with TickerProviderStateMixin {
  // API keys para mapas de alta calidad
  // Mapbox: https://account.mapbox.com/access-tokens/ (gratis hasta 50k requests/mes)
  // MapTiler: https://cloud.maptiler.com/account/keys/ (gratis hasta 100k tiles/mes)
  static const String _mapboxKey = '';
  static const String _mapTilerKey = '';
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
  static final LatLng _popayanCenter = LatLng(2.4448, -76.6147);

  // Lista de puntos de interés principales en Popayán
  final List<PointOfInterest> _pointsOfInterest = [
    // HOSPITALES
    PointOfInterest(
      name: 'Hospital Universitario San José',
      position: LatLng(2.4427, -76.6064),
      type: POIType.hospital,
      description: 'Hospital principal',
    ),
    PointOfInterest(
      name: 'Clínica La Estancia',
      position: LatLng(2.4489, -76.5972),
      type: POIType.hospital,
      description: 'Clínica privada',
    ),

    // UNIVERSIDADES
    PointOfInterest(
      name: 'Universidad del Cauca',
      position: LatLng(2.4448, -76.6060),
      type: POIType.university,
      description: 'Universidad pública',
    ),
    PointOfInterest(
      name: 'SENA Popayán',
      position: LatLng(2.4380, -76.6000),
      type: POIType.university,
      description: 'Formación técnica',
    ),

    // COLEGIOS
    PointOfInterest(
      name: 'Colegio INEM',
      position: LatLng(2.4550, -76.5950),
      type: POIType.school,
      description: 'Colegio público',
    ),
    PointOfInterest(
      name: 'Colegio Champagnat',
      position: LatLng(2.4380, -76.6120),
      type: POIType.school,
      description: 'Colegio privado',
    ),

    // PARQUES
    PointOfInterest(
      name: 'Parque Caldas',
      position: LatLng(2.4418, -76.6060),
      type: POIType.park,
      description: 'Parque principal',
    ),
    PointOfInterest(
      name: 'Parque de la Salud',
      position: LatLng(2.4520, -76.5980),
      type: POIType.park,
      description: 'Parque recreativo',
    ),

    // IGLESIAS
    PointOfInterest(
      name: 'Catedral Basílica',
      position: LatLng(2.4415, -76.6063),
      type: POIType.church,
      description: 'Catedral principal',
    ),
    PointOfInterest(
      name: 'Iglesia San Francisco',
      position: LatLng(2.4425, -76.6075),
      type: POIType.church,
      description: 'Iglesia colonial',
    ),

    // CENTROS COMERCIALES
    PointOfInterest(
      name: 'C.C. Campanario',
      position: LatLng(2.4550, -76.5920),
      type: POIType.mall,
      description: 'Centro comercial',
    ),
    PointOfInterest(
      name: 'C.C. Anarkos',
      position: LatLng(2.4420, -76.6055),
      type: POIType.mall,
      description: 'Centro del histórico',
    ),

    // BANCOS
    PointOfInterest(
      name: 'Banco de la República',
      position: LatLng(2.4415, -76.6050),
      type: POIType.bank,
      description: 'Banco central',
    ),
    PointOfInterest(
      name: 'Bancolombia',
      position: LatLng(2.4425, -76.6055),
      type: POIType.bank,
      description: 'Banco comercial',
    ),

    // RESTAURANTES
    PointOfInterest(
      name: 'La Cosecha',
      position: LatLng(2.4410, -76.6050),
      type: POIType.restaurant,
      description: 'Comida típica',
    ),
    PointOfInterest(
      name: 'Café Macondo',
      position: LatLng(2.4440, -76.6060),
      type: POIType.restaurant,
      description: 'Café cultural',
    ),

    // FARMACIAS
    PointOfInterest(
      name: 'Droguería La Rebaja',
      position: LatLng(2.4420, -76.6055),
      type: POIType.pharmacy,
      description: 'Farmacia',
    ),
    PointOfInterest(
      name: 'Cruz Verde',
      position: LatLng(2.4410, -76.6065),
      type: POIType.pharmacy,
      description: 'Farmacia',
    ),

    // SUPERMERCADOS
    PointOfInterest(
      name: 'Éxito',
      position: LatLng(2.4550, -76.5925),
      type: POIType.supermarket,
      description: 'Supermercado',
    ),
    PointOfInterest(
      name: 'Olímpica',
      position: LatLng(2.4430, -76.6030),
      type: POIType.supermarket,
      description: 'Supermercado',
    ),

    // ========== MÁS BANCOS POR TODA LA CIUDAD ==========
    PointOfInterest(
      name: 'Banco de Bogotá Norte',
      position: LatLng(2.4520, -76.5960),
      type: POIType.bank,
      description: 'Sucursal norte',
    ),
    PointOfInterest(
      name: 'BBVA Centro',
      position: LatLng(2.4440, -76.6035),
      type: POIType.bank,
      description: 'Banco internacional',
    ),
    PointOfInterest(
      name: 'Davivienda Sur',
      position: LatLng(2.4300, -76.6110),
      type: POIType.bank,
      description: 'Banco comercial sur',
    ),
    PointOfInterest(
      name: 'Banco Agrario',
      position: LatLng(2.4380, -76.5980),
      type: POIType.bank,
      description: 'Banco rural',
    ),
    PointOfInterest(
      name: 'Banco Popular Norte',
      position: LatLng(2.4480, -76.5970),
      type: POIType.bank,
      description: 'Sucursal norte',
    ),

    // ========== MÁS RESTAURANTES ==========
    PointOfInterest(
      name: 'McDonald\'s Campanario',
      position: LatLng(2.4545, -76.5915),
      type: POIType.restaurant,
      description: 'Comida rápida',
    ),
    PointOfInterest(
      name: 'KFC Norte',
      position: LatLng(2.4540, -76.5930),
      type: POIType.restaurant,
      description: 'Pollo frito',
    ),
    PointOfInterest(
      name: 'Subway',
      position: LatLng(2.4535, -76.5925),
      type: POIType.restaurant,
      description: 'Sándwiches',
    ),
    PointOfInterest(
      name: 'Frisby Centro',
      position: LatLng(2.4420, -76.6045),
      type: POIType.restaurant,
      description: 'Pollo broaster',
    ),
    PointOfInterest(
      name: 'El Corral',
      position: LatLng(2.4460, -76.6020),
      type: POIType.restaurant,
      description: 'Hamburguesas gourmet',
    ),
    PointOfInterest(
      name: 'Presto',
      position: LatLng(2.4380, -76.6040),
      type: POIType.restaurant,
      description: 'Comida rápida',
    ),
    PointOfInterest(
      name: 'Pollo Campero',
      position: LatLng(2.4350, -76.6080),
      type: POIType.restaurant,
      description: 'Pollo a la brasa',
    ),
    PointOfInterest(
      name: 'Domino\'s Pizza',
      position: LatLng(2.4470, -76.6010),
      type: POIType.restaurant,
      description: 'Pizza a domicilio',
    ),
    PointOfInterest(
      name: 'Papa John\'s',
      position: LatLng(2.4490, -76.5990),
      type: POIType.restaurant,
      description: 'Pizza artesanal',
    ),
    PointOfInterest(
      name: 'Crepes & Waffles',
      position: LatLng(2.4450, -76.6000),
      type: POIType.restaurant,
      description: 'Postres y café',
    ),

    // ========== MÁS FARMACIAS ==========
    PointOfInterest(
      name: 'Locatel Norte',
      position: LatLng(2.4500, -76.5950),
      type: POIType.pharmacy,
      description: 'Farmacia 24 horas',
    ),
    PointOfInterest(
      name: 'Farmatodo',
      position: LatLng(2.4460, -76.5980),
      type: POIType.pharmacy,
      description: 'Cadena farmacéutica',
    ),
    PointOfInterest(
      name: 'Cruz Verde Norte',
      position: LatLng(2.4520, -76.5940),
      type: POIType.pharmacy,
      description: 'Farmacia norte',
    ),
    PointOfInterest(
      name: 'La Rebaja Sur',
      position: LatLng(2.4320, -76.6090),
      type: POIType.pharmacy,
      description: 'Farmacia sur',
    ),
    PointOfInterest(
      name: 'Copidrogas',
      position: LatLng(2.4390, -76.6020),
      type: POIType.pharmacy,
      description: 'Farmacia cooperativa',
    ),
    PointOfInterest(
      name: 'Farmacia San Jorge Norte',
      position: LatLng(2.4480, -76.5960),
      type: POIType.pharmacy,
      description: 'Farmacia local',
    ),

    // ========== MÁS SUPERMERCADOS ==========
    PointOfInterest(
      name: 'Carulla Norte',
      position: LatLng(2.4460, -76.5980),
      type: POIType.supermarket,
      description: 'Supermercado premium',
    ),
    PointOfInterest(
      name: 'D1 Norte',
      position: LatLng(2.4480, -76.5990),
      type: POIType.supermarket,
      description: 'Tienda de descuento',
    ),
    PointOfInterest(
      name: 'Justo & Bueno Centro',
      position: LatLng(2.4400, -76.6040),
      type: POIType.supermarket,
      description: 'Conveniencia',
    ),
    PointOfInterest(
      name: 'Ara Sur',
      position: LatLng(2.4300, -76.6100),
      type: POIType.supermarket,
      description: 'Supermercado económico',
    ),
    PointOfInterest(
      name: 'Surtimax',
      position: LatLng(2.4350, -76.6070),
      type: POIType.supermarket,
      description: 'Cadena regional',
    ),
    PointOfInterest(
      name: 'Tiendas Ara Este',
      position: LatLng(2.4450, -76.5940),
      type: POIType.supermarket,
      description: 'Descuentos',
    ),
    PointOfInterest(
      name: 'Merquefácil',
      position: LatLng(2.4380, -76.6120),
      type: POIType.supermarket,
      description: 'Supermercado local',
    ),

    // ========== ESTACIONES DE GASOLINA ==========
    PointOfInterest(
      name: 'Terpel Norte',
      position: LatLng(2.4500, -76.5950),
      type: POIType.gasStation,
      description: 'Estación norte',
    ),
    PointOfInterest(
      name: 'Mobil Centro',
      position: LatLng(2.4420, -76.6080),
      type: POIType.gasStation,
      description: 'Combustibles centro',
    ),
    PointOfInterest(
      name: 'Esso Sur',
      position: LatLng(2.4300, -76.6120),
      type: POIType.gasStation,
      description: 'Estación sur',
    ),
    PointOfInterest(
      name: 'Petrobras Este',
      position: LatLng(2.4450, -76.5930),
      type: POIType.gasStation,
      description: 'Combustibles este',
    ),

    // ========== MÁS HOTELES ==========
    PointOfInterest(
      name: 'Hotel Los Balcones',
      position: LatLng(2.4415, -76.6055),
      type: POIType.hotel,
      description: 'Hotel tradicional',
    ),
    PointOfInterest(
      name: 'Hotel Casa Familiar',
      position: LatLng(2.4435, -76.6070),
      type: POIType.hotel,
      description: 'Hotel económico',
    ),
    PointOfInterest(
      name: 'Hotel Camino Real',
      position: LatLng(2.4390, -76.6060),
      type: POIType.hotel,
      description: 'Hotel de negocios',
    ),
  ];

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

  // Método para mostrar información de un punto de interés
  void _showPOIInfo(PointOfInterest poi) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icono y título
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: poi.type.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    poi.type.icon,
                    color: poi.type.color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        poi.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (poi.description != null)
                        Text(
                          poi.description!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Botón para cerrar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6A00),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Cerrar'),
              ),
            ),
          ],
        ),
      ),
    );
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
          coords: LatLng(2.4448, -76.6147),
          nombre: "Terminal de Transporte",
          codigo: "SOT-001",
          direccion: "Calle 5 # 8-08, Centro",
          empresa: "SOTRACAUCA",
          rutas: ["R1", "R2", "R3"],
          proximoBus: "2 min",
          tipo: TipoParada.terminal,
        ),
        ParadaInfo(
          coords: LatLng(2.4580, -76.6180),
          nombre: "La Esmeralda",
          codigo: "SOT-002",
          direccion: "Barrio La Esmeralda",
          empresa: "SOTRACAUCA",
          rutas: ["R1"],
          proximoBus: "5 min",
          tipo: TipoParada.barrio,
        ),
        ParadaInfo(
          coords: LatLng(2.4520, -76.6220),
          nombre: "Campanario",
          codigo: "SOT-003",
          direccion: "Barrio Campanario",
          empresa: "SOTRACAUCA",
          rutas: ["R1", "R2"],
          proximoBus: "3 min",
          tipo: TipoParada.barrio,
        ),
        ParadaInfo(
          coords: LatLng(2.4280, -76.6280),
          nombre: "Pomona",
          codigo: "SOT-004",
          direccion: "Barrio Pomona",
          empresa: "SOTRACAUCA",
          rutas: ["R1"],
          proximoBus: "8 min",
          tipo: TipoParada.barrio,
        ),
        ParadaInfo(
          coords: LatLng(2.4180, -76.6100),
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
          coords: LatLng(2.4320, -76.5980),
          nombre: "Lomas de Granada",
          codigo: "TPB-001",
          direccion: "Lomas de Granada",
          empresa: "TRANSPUBENZA",
          rutas: ["R4", "R8", "R12"],
          proximoBus: "4 min",
          tipo: TipoParada.barrio,
        ),
        ParadaInfo(
          coords: LatLng(2.4400, -76.6100),
          nombre: "Los Naranjos",
          codigo: "TPB-002",
          direccion: "Barrio Los Naranjos",
          empresa: "TRANSPUBENZA",
          rutas: ["R1", "R3", "R9"],
          proximoBus: "6 min",
          tipo: TipoParada.barrio,
        ),
        ParadaInfo(
          coords: LatLng(2.4450, -76.6000),
          nombre: "Tomás Cipriano",
          codigo: "TPB-003",
          direccion: "Barrio Tomás Cipriano",
          empresa: "TRANSPUBENZA",
          rutas: ["R1", "R2", "R5"],
          proximoBus: "7 min",
          tipo: TipoParada.barrio,
        ),
        ParadaInfo(
          coords: LatLng(2.4480, -76.5920),
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
          coords: LatLng(2.4419, -76.6066),
          nombre: "Parque Caldas",
          codigo: "TRL-001",
          direccion: "Centro Histórico",
          empresa: "TRANSLIBERTAD",
          rutas: ["R1", "R3"],
          proximoBus: "3 min",
          tipo: TipoParada.centro,
        ),
        ParadaInfo(
          coords: LatLng(2.4385, -76.6055),
          nombre: "Universidad del Cauca",
          codigo: "TRL-002",
          direccion: "Calle 5 # 4-70, Sector Tulcán",
          empresa: "TRANSLIBERTAD",
          rutas: ["R2", "R4"],
          proximoBus: "5 min",
          tipo: TipoParada.universidad,
        ),
        ParadaInfo(
          coords: LatLng(2.4350, -76.6120),
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
          coords: LatLng(2.4490, -76.6020),
          nombre: "Hospital Universitario",
          codigo: "TTB-001",
          direccion: "Carrera 6 # 9N-45",
          empresa: "TRANSTAMBO",
          rutas: ["R2"],
          proximoBus: "6 min",
          tipo: TipoParada.hospital,
        ),
        ParadaInfo(
          coords: LatLng(2.4380, -76.6120),
          nombre: "Villa Del Viento",
          codigo: "TTB-002",
          direccion: "Barrio Villa Del Viento",
          empresa: "TRANSTAMBO",
          rutas: ["R1"],
          proximoBus: "10 min",
          tipo: TipoParada.barrio,
        ),
        ParadaInfo(
          coords: LatLng(2.4550, -76.5950),
          nombre: "Las Guacas",
          codigo: "TTB-003",
          direccion: "Barrio Las Guacas",
          empresa: "TRANSTAMBO",
          rutas: ["R2"],
          proximoBus: "12 min",
          tipo: TipoParada.barrio,
        ),
        ParadaInfo(
          coords: LatLng(2.4200, -76.6200),
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
          coords: LatLng(2.4480, -76.5920),
          nombre: "C.C. Campanario",
          codigo: "COM-001",
          direccion: "Calle 5 # 38-95",
          empresa: "MULTIPLE",
          rutas: ["SOT-R2", "TPB-R12"],
          proximoBus: "4 min",
          tipo: TipoParada.comercial,
        ),
        ParadaInfo(
          coords: LatLng(2.4400, -76.6080),
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
      // Al cambiar de capa, ajustar límites de zoom para la nueva fuente
      final currentCenter = _mapController.camera.center;
      final currentZoom = _mapController.camera.zoom;
      final clampedZoom = _showSatellite
          ? currentZoom.clamp(10.0, 17.5)
          : currentZoom.clamp(10.0, 20.0);
      _mapController.move(currentCenter, clampedZoom);
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
              // Limitar el zoom máximo para evitar tiles en blanco
              minZoom: 10.0,
              maxZoom: 17.0,
              onMapEvent: (event) {
                // Forzar límites de zoom para evitar tiles en blanco
                final double maxZ = 17.0;
                final double minZ = 10.0;
                final double z = event.camera.zoom;
                if (z > maxZ || z < minZ) {
                  final clamped = z.clamp(minZ, maxZ);
                  if (clamped != z) {
                    _mapController.move(event.camera.center, clamped);
                  }
                }
              },
              interactionOptions: const fm.InteractionOptions(
                flags: fm.InteractiveFlag.all,
              ),
            ),
            children: [
              // Capa de tiles (Mapbox/MapTiler si hay API key; fallback OSM sin subdominios)
              fm.TileLayer(
                urlTemplate: _showSatellite
                    ? (_mapboxKey.isNotEmpty
                        ? "https://api.mapbox.com/styles/v1/mapbox/satellite-v9/tiles/256/{z}/{x}/{y}@2x?access_token=${_mapboxKey}"
                        : (_mapTilerKey.isNotEmpty
                            ? "https://api.maptiler.com/tiles/satellite/{z}/{x}/{y}.jpg?key=${_mapTilerKey}"
                            : "https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}"))
                    : (_mapboxKey.isNotEmpty
                        ? "https://api.mapbox.com/styles/v1/mapbox/streets-v12/tiles/256/{z}/{x}/{y}@2x?access_token=${_mapboxKey}"
                        : (_mapTilerKey.isNotEmpty
                            ? "https://api.maptiler.com/maps/streets-v2/256/{z}/{x}/{y}.png?key=${_mapTilerKey}"
                            : "https://tile.openstreetmap.org/{z}/{x}/{y}.png")),
                subdomains: const [],
                userAgentPackageName: 'com.example.rouwhite',
                // Zoom nativo alto para proveedores premium
                maxNativeZoom: _showSatellite
                    ? (_mapboxKey.isNotEmpty
                        ? 22
                        : (_mapTilerKey.isNotEmpty ? 20 : 17))
                    : (_mapboxKey.isNotEmpty
                        ? 22
                        : (_mapTilerKey.isNotEmpty ? 20 : 19)),
                maxZoom: _showSatellite
                    ? (_mapboxKey.isNotEmpty
                        ? 22.0
                        : (_mapTilerKey.isNotEmpty ? 20.0 : 17.5))
                    : (_mapboxKey.isNotEmpty
                        ? 22.0
                        : (_mapTilerKey.isNotEmpty ? 20.0 : 20.0)),
                minZoom: 10.0,
                // Mejor nitidez en pantallas HiDPI
                retinaMode: true,
                // Mantener más tiles en memoria durante zoom para evitar parpadeo
                keepBuffer: 4,
                // Callback de error para depurar en consola (alternativa a builder)
                errorTileCallback: (tile, error, stackTrace) {
                  // ignore: avoid_print
                  print(
                      'Tile error z:${tile.coordinates.z} x:${tile.coordinates.x} y:${tile.coordinates.y} -> $error');
                },
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

              // Marcadores de puntos de interés
              fm.MarkerLayer(
                markers: _pointsOfInterest.map((poi) {
                  return fm.Marker(
                    point: poi.position,
                    child: GestureDetector(
                      onTap: () => _showPOIInfo(poi),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Círculo de fondo con efecto de pulso
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Container(
                                width: 30 + (5 * _pulseController.value),
                                height: 30 + (5 * _pulseController.value),
                                decoration: BoxDecoration(
                                  color: poi.type.color.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                              );
                            },
                          ),
                          // Marcador principal
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: poi.type.color,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: poi.type.color.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                poi.type.icon,
                                color: poi.type.color,
                                size: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
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
          opacity: (_isLoading ? 0.0 : _fadeAnimation.value).clamp(0.0, 1.0),
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
          opacity: (_isLoading ? 0.0 : _fadeAnimation.value).clamp(0.0, 1.0),
          duration: const Duration(milliseconds: 800),
          child: Transform.translate(
            offset: Offset(_isLoading ? 50 : 0, 0),
            child: Column(
              children: [
                _buildAnimatedControlButton(
                  icon: Icons.add,
                  onPressed: () {
                    final maxZ = _showSatellite ? 17.5 : 20.0;
                    final target =
                        (_mapController.camera.zoom + 1).clamp(10.0, maxZ);
                    _mapController.move(_mapController.camera.center, target);
                  },
                  heroTag: "zoom_in",
                  delay: 0,
                ),
                const SizedBox(height: 8),
                _buildAnimatedControlButton(
                  icon: Icons.remove,
                  onPressed: () {
                    final minZ = 10.0;
                    final target = (_mapController.camera.zoom - 1)
                        .clamp(minZ, _showSatellite ? 17.5 : 20.0);
                    _mapController.move(_mapController.camera.center, target);
                  },
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
            opacity: value.clamp(0.0, 1.0),
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
