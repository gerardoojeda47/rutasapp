import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../domain/entities/ruta_detallada.dart';
import '../domain/usecases/obtener_ruta_detallada_usecase.dart';
import '../data/repositories/routing_repository_impl.dart';
import '../data/repositories/routing_repository_mock.dart';
import '../core/services/routing_service.dart';
import '../core/services/voice_navigation_service.dart';
import '../core/config/api_config.dart';
import 'widgets/navegacion_paso_a_paso.dart';
import 'widgets/voice_settings_widget.dart';
import 'widgets/animated_markers.dart';

/// Página de navegación detallada con instrucciones paso a paso
class NavegacionDetalladaPagina extends StatefulWidget {
  final LatLng origen;
  final LatLng destino;
  final String? nombreOrigen;
  final String? nombreDestino;

  const NavegacionDetalladaPagina({
    super.key,
    required this.origen,
    required this.destino,
    this.nombreOrigen,
    this.nombreDestino,
  });

  @override
  State<NavegacionDetalladaPagina> createState() =>
      _NavegacionDetalladaPaginaState();
}

class _NavegacionDetalladaPaginaState extends State<NavegacionDetalladaPagina> {
  final fm.MapController _mapController = fm.MapController();

  RutaDetallada? _rutaActual;
  List<RutaDetallada>? _rutasAlternativas;
  Position? _posicionActual;
  bool _isLoading = true;
  String? _error;
  bool _siguiendoUbicacion = true;
  bool _mostrarAlternativas = false;
  int _rutaSeleccionada = 0;

  // Servicios
  late final ObtenerRutaDetalladaUseCase _obtenerRutaUseCase;
  final VoiceNavigationService _voiceService = VoiceNavigationService();
  bool _voiceEnabled = true;
  VoiceSettings _voiceSettings = const VoiceSettings();

  // Stream subscription para ubicación
  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _initializeVoiceNavigation();
    _obtenerRuta();
    _iniciarSeguimientoUbicacion();
  }

  void _initializeServices() {
    // Usar servicio mock si no hay API key configurada
    const useMock = ApiConfig.openRouteServiceApiKey == 'TU_API_KEY_AQUI';

    if (useMock) {
      // Usar servicio mock para demo
      _obtenerRutaUseCase = ObtenerRutaDetalladaUseCase(
        RoutingRepositoryMock(),
      );
    } else {
      // Usar servicio real
      final routingService = RoutingService();
      final routingRepository = RoutingRepositoryImpl(
        routingService: routingService,
      );
      _obtenerRutaUseCase = ObtenerRutaDetalladaUseCase(routingRepository);
    }
  }

  /// Inicializa el servicio de navegación por voz
  Future<void> _initializeVoiceNavigation() async {
    try {
      await _voiceService.initializeVoice(_voiceSettings);

      // Mensaje de bienvenida
      if (_voiceEnabled && _voiceService.isInitialized) {
        await Future.delayed(const Duration(seconds: 1));
        await _voiceService.speakMessage(
            'Navegación por voz activada. Calculando la mejor ruta para usted.');
      }
    } catch (e) {
      debugPrint('Error inicializando navegación por voz: $e');
    }
  }

  /// Reproduce instrucciones de voz para la navegación
  void _speakNavigationInstruction(InstruccionNavegacion instruccion) {
    if (!_voiceEnabled || !_voiceService.isInitialized) return;

    final voiceInstruction = NavigationInstruction(
      type: _mapInstructionType(instruccion.tipo),
      streetName: instruccion.calle,
      distanceInMeters: instruccion.distancia,
      landmark: _detectLandmark(instruccion.calle),
    );

    _voiceService.speakInstruction(voiceInstruction);
  }

  /// Mapea tipos de instrucción a tipos de voz
  String _mapInstructionType(TipoInstruccion tipo) {
    switch (tipo) {
      case TipoInstruccion.girarIzquierda:
        return 'turn_left';
      case TipoInstruccion.girarDerecha:
        return 'turn_right';
      case TipoInstruccion.continuar:
        return 'continue_straight';
      case TipoInstruccion.girarLigeroIzquierda:
        return 'slight_left';
      case TipoInstruccion.girarLigeroDerecha:
        return 'slight_right';
      case TipoInstruccion.uturn:
        return 'u_turn';
      case TipoInstruccion.llegada:
        return 'arrive';
      case TipoInstruccion.rotonda:
      case TipoInstruccion.salirRotonda:
        return 'continue_straight';
      case TipoInstruccion.mantenerDerecha:
        return 'slight_right';
      case TipoInstruccion.mantenerIzquierda:
        return 'slight_left';
      case TipoInstruccion.salida:
        return 'continue_straight';
    }
  }

  /// Detecta puntos de referencia conocidos en Popayán
  String? _detectLandmark(String streetName) {
    final street = streetName.toLowerCase();

    if (street.contains('galeria') || street.contains('galería')) {
      return 'galeria_central';
    } else if (street.contains('centro') || street.contains('histórico')) {
      return 'centro_historico';
    } else if (street.contains('terminal')) {
      return 'terminal_transportes';
    } else if (street.contains('universidad') || street.contains('unicauca')) {
      return 'universidad_cauca';
    } else if (street.contains('hospital') || street.contains('san josé')) {
      return 'hospital_san_jose';
    }

    return null;
  }

  /// Muestra configuración de voz
  void _showVoiceSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => VoiceSettingsWidget(
        initialSettings: _voiceSettings,
        onSettingsChanged: (newSettings) {
          setState(() {
            _voiceSettings = newSettings;
          });
          _voiceService.updateSettings(newSettings);
        },
      ),
    );
  }

  Future<void> _obtenerRuta() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final params = ObtenerRutaDetalladaParams(
      origen: widget.origen,
      destino: widget.destino,
      perfil: 'driving-car',
      incluirAlternativas: true,
      numeroAlternativas: 3,
    );

    final result = await _obtenerRutaUseCase(params);

    result.fold(
      (error) {
        setState(() {
          _error = error.message;
          _isLoading = false;
        });
      },
      (rutas) {
        setState(() {
          _rutasAlternativas = rutas;
          _rutaActual = rutas.isNotEmpty ? rutas.first : null;
          _isLoading = false;
        });

        if (_rutaActual != null) {
          _centrarMapaEnRuta();
        }
      },
    );
  }

  Future<void> _iniciarSeguimientoUbicacion() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        // Obtener posición inicial
        final position = await Geolocator.getCurrentPosition();
        setState(() {
          _posicionActual = position;
        });

        // Seguimiento continuo
        _positionStreamSubscription = Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10, // Actualizar cada 10 metros
          ),
        ).listen((position) {
          if (mounted) {
            setState(() {
              _posicionActual = position;
            });

            if (_siguiendoUbicacion) {
              _centrarMapaEnPosicionActual();
            }
          }
        });
      }
    } catch (e) {
      debugPrint('Error al obtener ubicación: $e');
    }
  }

  void _centrarMapaEnRuta() {
    if (_rutaActual == null) return;

    _mapController.fitCamera(
      fm.CameraFit.bounds(
        bounds: _rutaActual!.bounds,
        padding: const EdgeInsets.all(50),
      ),
    );
  }

  void _centrarMapaEnPosicionActual() {
    if (_posicionActual == null) return;

    _mapController.move(
      LatLng(_posicionActual!.latitude, _posicionActual!.longitude),
      17.0,
    );
  }

  void _seleccionarRuta(int index) {
    if (_rutasAlternativas == null || index >= _rutasAlternativas!.length) {
      return;
    }

    setState(() {
      _rutaSeleccionada = index;
      _rutaActual = _rutasAlternativas![index];
    });

    _centrarMapaEnRuta();
  }

  void _onInstruccionSeleccionada(InstruccionNavegacion instruccion) {
    _mapController.move(instruccion.posicion, 16.0);
    setState(() {
      _siguiendoUbicacion = false;
    });

    // Reproducir instrucción por voz
    _speakNavigationInstruction(instruccion);
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _voiceService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navegación'),
        backgroundColor: const Color(0xFFFF6A00),
        elevation: 0,
        actions: [
          // Botón de configuración de voz
          IconButton(
            onPressed: _showVoiceSettings,
            icon: Icon(
              _voiceEnabled ? Icons.record_voice_over : Icons.voice_over_off,
              color: _voiceEnabled ? Colors.white : Colors.white70,
            ),
            tooltip: 'Configurar voz',
          ),

          // Botón de activar/desactivar voz
          IconButton(
            onPressed: () {
              setState(() {
                _voiceEnabled = !_voiceEnabled;
              });

              if (_voiceEnabled) {
                _voiceService.speakMessage('Navegación por voz activada');
              } else {
                _voiceService.stop();
              }
            },
            icon: Icon(
              _voiceEnabled ? Icons.volume_up : Icons.volume_off,
              color: _voiceEnabled ? Colors.white : Colors.white70,
            ),
            tooltip: _voiceEnabled ? 'Desactivar voz' : 'Activar voz',
          ),

          if (_rutasAlternativas != null && _rutasAlternativas!.length > 1)
            IconButton(
              onPressed: () {
                setState(() {
                  _mostrarAlternativas = !_mostrarAlternativas;
                });
              },
              icon: Icon(
                _mostrarAlternativas ? Icons.close : Icons.alt_route,
              ),
            ),
          IconButton(
            onPressed: () {
              setState(() {
                _siguiendoUbicacion = true;
              });
              _centrarMapaEnPosicionActual();
            },
            icon: Icon(
              _siguiendoUbicacion
                  ? Icons.my_location
                  : Icons.location_searching,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Mapa
          _buildMapa(),

          // Indicador de carga
          if (_isLoading) _buildLoadingIndicator(),

          // Error
          if (_error != null) _buildErrorWidget(),

          // Rutas alternativas
          if (_mostrarAlternativas && _rutasAlternativas != null)
            _buildRutasAlternativas(),
        ],
      ),
      bottomSheet: _rutaActual != null
          ? NavegacionPasoAPaso(
              ruta: _rutaActual!,
              posicionActual: _posicionActual != null
                  ? LatLng(
                      _posicionActual!.latitude, _posicionActual!.longitude)
                  : null,
              onCerrar: () => Navigator.pop(context),
              onInstruccionSeleccionada: _onInstruccionSeleccionada,
            )
          : null,
    );
  }

  Widget _buildMapa() {
    return fm.FlutterMap(
      mapController: _mapController,
      options: fm.MapOptions(
        initialCenter: widget.origen,
        initialZoom: 13.0,
        interactionOptions: const fm.InteractionOptions(
          flags: fm.InteractiveFlag.all,
        ),
      ),
      children: [
        // Capa de tiles
        fm.TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: const ['a', 'b', 'c'],
          userAgentPackageName: 'com.example.rouwhite',
        ),

        // Rutas alternativas (más tenues)
        if (_rutasAlternativas != null && _mostrarAlternativas)
          ..._rutasAlternativas!.asMap().entries.map((entry) {
            final index = entry.key;
            final ruta = entry.value;

            if (index == _rutaSeleccionada) return const SizedBox.shrink();

            return fm.PolylineLayer(
              polylines: [
                fm.Polyline(
                  points: ruta.puntos,
                  color: Colors.grey.withValues(alpha: 0.6),
                  strokeWidth: 4.0,
                ),
              ],
            );
          }).toList(),

        // Ruta principal
        if (_rutaActual != null)
          fm.PolylineLayer(
            polylines: [
              fm.Polyline(
                points: _rutaActual!.puntos,
                color: const Color(0xFFFF6A00),
                strokeWidth: 6.0,
              ),
            ],
          ),

        // Marcadores animados de instrucciones
        if (_rutaActual != null)
          fm.MarkerLayer(
            markers: _rutaActual!.instrucciones.asMap().entries.map((entry) {
              final index = entry.key;
              final instruccion = entry.value;

              return fm.Marker(
                width: 35,
                height: 35,
                point: instruccion.posicion,
                child: GestureDetector(
                  onTap: () => _onInstruccionSeleccionada(instruccion),
                  child: AnimatedInstructionMarker(
                    number: index + 1,
                    delay: Duration(milliseconds: index * 200),
                  ),
                ),
              );
            }).toList(),
          ),

        // Marcador animado de origen
        fm.MarkerLayer(
          markers: [
            fm.Marker(
              width: 50,
              height: 50,
              point: widget.origen,
              child: const NavigationMarker(
                size: 45,
                color: Colors.green,
                icon: Icons.play_arrow,
                isDestination: false,
              ),
            ),
          ],
        ),

        // Marcador animado de destino
        fm.MarkerLayer(
          markers: [
            fm.Marker(
              width: 50,
              height: 50,
              point: widget.destino,
              child: const NavigationMarker(
                size: 45,
                color: Colors.red,
                icon: Icons.flag,
                isDestination: true,
              ),
            ),
          ],
        ),

        // Marcador animado de posición actual
        if (_posicionActual != null)
          fm.MarkerLayer(
            markers: [
              fm.Marker(
                width: 60,
                height: 60,
                point: LatLng(
                    _posicionActual!.latitude, _posicionActual!.longitude),
                child: const PulsingLocationMarker(
                  size: 50,
                  color: Colors.blue,
                  pulseColor: Colors.blue,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      color: Colors.black.withValues(alpha: 0.3),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6A00)),
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      color: Colors.black.withValues(alpha: 0.3),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'Error al obtener la ruta',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _obtenerRuta,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6A00),
                ),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRutasAlternativas() {
    return Positioned(
      top: 20,
      left: 20,
      right: 20,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFFF6A00),
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Rutas alternativas',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _mostrarAlternativas = false;
                      });
                    },
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _rutasAlternativas!.length,
              itemBuilder: (context, index) {
                final ruta = _rutasAlternativas![index];
                final isSelected = index == _rutaSeleccionada;

                return Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFFF6A00).withValues(alpha: 0.1)
                        : null,
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFFF6A00)
                            : Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      'Ruta ${index + 1}',
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    subtitle: Row(
                      children: [
                        Icon(Icons.straighten,
                            size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(ruta.distanciaTotalFormateada),
                        const SizedBox(width: 16),
                        Icon(Icons.access_time,
                            size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(ruta.tiempoEstimadoFormateado),
                      ],
                    ),
                    onTap: () => _seleccionarRuta(index),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
