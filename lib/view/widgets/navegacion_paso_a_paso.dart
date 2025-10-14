import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../domain/entities/ruta_detallada.dart';

/// Widget que muestra la navegación paso a paso
class NavegacionPasoAPaso extends StatefulWidget {
  final RutaDetallada ruta;
  final LatLng? posicionActual;
  final VoidCallback? onCerrar;
  final Function(InstruccionNavegacion)? onInstruccionSeleccionada;

  const NavegacionPasoAPaso({
    super.key,
    required this.ruta,
    this.posicionActual,
    this.onCerrar,
    this.onInstruccionSeleccionada,
  });

  @override
  State<NavegacionPasoAPaso> createState() => _NavegacionPasoAPasoState();
}

class _NavegacionPasoAPasoState extends State<NavegacionPasoAPaso> {
  int _instruccionActualIndex = 0;
  bool _mostrarTodasInstrucciones = false;

  @override
  void initState() {
    super.initState();
    _actualizarInstruccionActual();
  }

  @override
  void didUpdateWidget(NavegacionPasoAPaso oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.posicionActual != oldWidget.posicionActual) {
      _actualizarInstruccionActual();
    }
  }

  void _actualizarInstruccionActual() {
    if (widget.posicionActual == null || widget.ruta.instrucciones.isEmpty) {
      return;
    }

    final instruccionMasCercana = widget.ruta.instruccionMasCercana(
      widget.posicionActual!,
    );

    if (instruccionMasCercana != null) {
      final index = widget.ruta.instrucciones.indexOf(instruccionMasCercana);
      if (index != -1 && index != _instruccionActualIndex) {
        setState(() {
          _instruccionActualIndex = index;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.ruta.instrucciones.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header con información general
          _buildHeader(),

          // Instrucción actual o lista completa
          if (_mostrarTodasInstrucciones)
            _buildListaCompleta()
          else
            _buildInstruccionActual(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFF6A00),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Navegación',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.straighten,
                      color: Colors.white.withValues(alpha: 0.9),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.ruta.distanciaTotalFormateada,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.access_time,
                      color: Colors.white.withValues(alpha: 0.9),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.ruta.tiempoEstimadoFormateado,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _mostrarTodasInstrucciones = !_mostrarTodasInstrucciones;
              });
            },
            icon: Icon(
              _mostrarTodasInstrucciones
                  ? Icons.keyboard_arrow_down
                  : Icons.list,
              color: Colors.white,
            ),
          ),
          if (widget.onCerrar != null)
            IconButton(
              onPressed: widget.onCerrar,
              icon: const Icon(Icons.close, color: Colors.white),
            ),
        ],
      ),
    );
  }

  Widget _buildInstruccionActual() {
    final instruccion = widget.ruta.instrucciones[_instruccionActualIndex];

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Icono de la instrucción
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFFF6A00).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getIconoInstruccion(instruccion.tipo),
              color: const Color(0xFFFF6A00),
              size: 30,
            ),
          ),

          const SizedBox(height: 16),

          // Texto de la instrucción
          Text(
            instruccion.texto,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Nombre de la calle
          if (instruccion.calle.isNotEmpty)
            Text(
              instruccion.calle,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),

          const SizedBox(height: 16),

          // Distancia y tiempo
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoChip(
                Icons.straighten,
                instruccion.distanciaFormateada,
              ),
              _buildInfoChip(
                Icons.access_time,
                instruccion.duracionFormateada,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Navegación entre instrucciones
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _instruccionActualIndex > 0
                    ? () {
                        setState(() {
                          _instruccionActualIndex--;
                        });
                        _notificarInstruccionSeleccionada();
                      }
                    : null,
                icon: const Icon(Icons.arrow_back_ios),
              ),
              Text(
                '${_instruccionActualIndex + 1} de ${widget.ruta.instrucciones.length}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              IconButton(
                onPressed: _instruccionActualIndex <
                        widget.ruta.instrucciones.length - 1
                    ? () {
                        setState(() {
                          _instruccionActualIndex++;
                        });
                        _notificarInstruccionSeleccionada();
                      }
                    : null,
                icon: const Icon(Icons.arrow_forward_ios),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListaCompleta() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 400),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.ruta.instrucciones.length,
        itemBuilder: (context, index) {
          final instruccion = widget.ruta.instrucciones[index];
          final isActual = index == _instruccionActualIndex;

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: isActual
                  ? const Color(0xFFFF6A00).withValues(alpha: 0.1)
                  : null,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isActual ? const Color(0xFFFF6A00) : Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getIconoInstruccion(instruccion.tipo),
                  color: isActual ? Colors.white : Colors.grey[600],
                  size: 20,
                ),
              ),
              title: Text(
                instruccion.texto,
                style: TextStyle(
                  fontWeight: isActual ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (instruccion.calle.isNotEmpty) Text(instruccion.calle),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        instruccion.distanciaFormateada,
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        instruccion.duracionFormateada,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  _instruccionActualIndex = index;
                  _mostrarTodasInstrucciones = false;
                });
                _notificarInstruccionSeleccionada();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconoInstruccion(TipoInstruccion tipo) {
    switch (tipo) {
      case TipoInstruccion.continuar:
        return Icons.straight;
      case TipoInstruccion.girarDerecha:
        return Icons.turn_right;
      case TipoInstruccion.girarIzquierda:
        return Icons.turn_left;
      case TipoInstruccion.girarLigeroIzquierda:
        return Icons.turn_slight_left;
      case TipoInstruccion.girarLigeroDerecha:
        return Icons.turn_slight_right;
      case TipoInstruccion.uturn:
        return Icons.u_turn_left;
      case TipoInstruccion.rotonda:
        return Icons.roundabout_left;
      case TipoInstruccion.salirRotonda:
        return Icons.roundabout_right;
      case TipoInstruccion.mantenerDerecha:
        return Icons.arrow_forward;
      case TipoInstruccion.mantenerIzquierda:
        return Icons.arrow_back;
      case TipoInstruccion.llegada:
        return Icons.flag;
      case TipoInstruccion.salida:
        return Icons.location_on;
    }
  }

  void _notificarInstruccionSeleccionada() {
    if (widget.onInstruccionSeleccionada != null) {
      widget.onInstruccionSeleccionada!(
        widget.ruta.instrucciones[_instruccionActualIndex],
      );
    }
  }
}

