import 'package:flutter/material.dart';
import 'mapa_ruta_pagina.dart';
import '../model/favoritos.dart';
import '../data/popayan_bus_routes.dart';

class RutasPagina extends StatefulWidget {
  const RutasPagina({super.key});

  @override
  State<RutasPagina> createState() => _RutasPaginaState();
}

class _RutasPaginaState extends State<RutasPagina> {
  late List<BusRoute> _rutas;
  List<bool> _favoritos = [];
  int? _rutaSeleccionada;

  @override
  void initState() {
    super.initState();
    _rutas = PopayanBusRoutes.getAllRoutes();
    _favoritos = List.filled(_rutas.length, false);
  }

  Color _traficoColor(String trafico) {
    switch (trafico.toLowerCase()) {
      case 'fluido':
        return Colors.green;
      case 'moderado':
        return Colors.orange;
      case 'congestionado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _traficoIcon(String trafico) {
    switch (trafico.toLowerCase()) {
      case 'fluido':
        return Icons.check_circle;
      case 'moderado':
        return Icons.error;
      case 'congestionado':
        return Icons.warning;
      default:
        return Icons.help;
    }
  }

  void _toggleFavorito(int index) {
    setState(() {
      _favoritos[index] = !_favoritos[index];
      if (_favoritos[index]) {
        // Convertir BusRoute a Map para compatibilidad con Favoritos
        final rutaMap = {
          'nombre': _rutas[index].name,
          'empresa': _rutas[index].company,
          'trayecto': _rutas[index].neighborhoods.join(' - '),
          'paradas': _rutas[index].neighborhoods,
          'horario': _rutas[index].schedule,
          'costo': _rutas[index].fare,
          'busId': _rutas[index].id,
        };
        Favoritos().agregar(rutaMap);
      } else {
        final rutaMap = {
          'nombre': _rutas[index].name,
          'empresa': _rutas[index].company,
          'busId': _rutas[index].id,
        };
        Favoritos().quitar(rutaMap);
      }
    });
  }

  void _rastrearBus(int index) {
    final ruta = _rutas[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapaRutaPagina(
          route: ruta,
        ),
      ),
    );
  }

  Widget _buildImagenMapa() {
    return Container(
      height: 200,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: NetworkImage(
              'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7e/Popayan_Panoramica.jpg/640px-Popayan_Panoramica.jpg'),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Mapa de referencia',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: const Text('Rutas de Popayán',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFFF6A00),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _rutas.length,
        itemBuilder: (context, index) {
          final ruta = _rutas[index];
          final seleccionada = _rutaSeleccionada == index;
          return Card(
            margin: const EdgeInsets.only(bottom: 24),
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF6A00).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(Icons.directions_bus,
                            color: Color(0xFFFF6A00), size: 28),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ruta.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF6A00),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              ruta.company,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _favoritos[index] ? Icons.star : Icons.star_border,
                          color: _favoritos[index] ? Colors.amber : Colors.grey,
                        ),
                        onPressed: () {
                          _toggleFavorito(index);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    ruta.neighborhoods.join(' - '),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Paradas:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 2),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ruta.neighborhoods
                          .map<Widget>((p) => Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      color: Color(0xFFFF6A00), size: 18),
                                  const SizedBox(width: 4),
                                  Text(p, style: const TextStyle(fontSize: 15)),
                                  const SizedBox(width: 8),
                                ],
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 18, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('Horario: ${ruta.schedule}'),
                      const SizedBox(width: 16),
                      const Icon(Icons.attach_money,
                          size: 18, color: Colors.green),
                      Text(ruta.fare),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(_traficoIcon('moderado'),
                          color: _traficoColor('moderado'), size: 18),
                      const SizedBox(width: 4),
                      const Text('Tráfico: moderado'),
                      const SizedBox(width: 16),
                      const Icon(Icons.directions_bus_filled,
                          size: 18, color: Colors.blue),
                      const Text('Próximo bus: 5 min'),
                    ],
                  ),
                  const SizedBox(height: 14),
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 300),
                    crossFadeState: seleccionada
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    firstChild: _buildImagenMapa(),
                    secondChild: const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6A00),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MapaRutaPagina(
                                  route: ruta,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.map, color: Colors.white),
                          label: const Text('Ver mapa',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => _rastrearBus(index),
                          icon: const Icon(Icons.location_searching,
                              color: Colors.white),
                          label: const Text('Rastrear',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
