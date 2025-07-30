import 'package:flutter/material.dart';
import 'ver_buses_pagina.dart';
import 'mapa_ruta_pagina.dart';

class RutasPagina extends StatefulWidget {
  const RutasPagina({super.key});

  @override
  State<RutasPagina> createState() => _RutasPaginaState();
}

class _RutasPaginaState extends State<RutasPagina> {
  final List<Map<String, dynamic>> _rutas = [
    {
      'nombre': 'Ruta 1',
      'empresa': 'Transpubenza',
      'trayecto': 'Centro - La Paz',
      'paradas': ['Centro', 'La Paz', 'Jose María Obando', 'San Camilo'],
      'horario': '6:00 AM - 8:00 PM',
      'costo': '2.500',
      'trafico': 'Fluido',
      'proxBus': '5 min',
      'favorito': false,
      'busId': 'TP001',
    },
    {
      'nombre': 'Ruta 2',
      'empresa': 'Coopetrans',
      'trayecto': 'Centro - La Esmeralda',
      'paradas': ['Centro', 'Campan', 'La Esmeralda', 'El Recuerdo'],
      'horario': '5:30 AM - 9:00 PM',
      'costo': '2.500',
      'trafico': 'Moderado',
      'proxBus': '8 min',
      'favorito': false,
      'busId': 'CT002',
    },
    {
      'nombre': 'Ruta 3',
      'empresa': 'Transpubenza',
      'trayecto': 'Terminal - El Uvo',
      'paradas': ['Terminal', 'El Uvo', 'San Eduardo', 'La Paz'],
      'horario': '6:00 AM - 8:30 PM',
      'costo': '2.500',
      'trafico': 'Congestionado',
      'proxBus': '12 min',
      'favorito': false,
      'busId': 'TP003',
    },
    {
      'nombre': 'Ruta 4',
      'empresa': 'Coopetrans',
      'trayecto': 'Centro - Bello Horizonte',
      'paradas': ['Centro', 'Bello Horizonte', 'El Placer', 'La Arboleda'],
      'horario': '5:45 AM - 8:00 PM',
      'costo': '2.500',
      'trafico': 'Fluido',
      'proxBus': '7 min',
      'favorito': false,
      'busId': 'CT004',
    },
    {
      'nombre': 'Ruta 5',
      'empresa': 'Transpubenza',
      'trayecto': 'Centro - Alfonso López',
      'paradas': ['Centro', 'Alfonso López', 'El Limonar', 'El Boquerón'],
      'horario': '6:00 AM - 8:00 PM',
      'costo': '2.500',
      'trafico': 'Moderado',
      'proxBus': '10 min',
      'favorito': false,
      'busId': 'TP005',
    },
    {
      'nombre': 'Ruta 6',
      'empresa': 'Coopetrans',
      'trayecto': 'Centro - La Floresta',
      'paradas': ['Centro', 'La Floresta', 'El Lago', 'Gabriel G. Marqués'],
      'horario': '5:30 AM - 9:00 PM',
      'costo': '2.500',
      'trafico': 'Fluido',
      'proxBus': '6 min',
      'favorito': false,
      'busId': 'CT006',
    },
    {
      'nombre': 'Ruta 7',
      'empresa': 'Transpubenza',
      'trayecto': 'Centro - Los Sauces',
      'paradas': ['Centro', 'Los Sauces', 'La Campiña', 'María Oriente'],
      'horario': '6:00 AM - 8:00 PM',
      'costo': '2.500',
      'trafico': 'Fluido',
      'proxBus': '9 min',
      'favorito': false,
      'busId': 'TP007',
    },
    {
      'nombre': 'Ruta 8',
      'empresa': 'Coopetrans',
      'trayecto': 'Centro - Bello Horizonte',
      'paradas': ['Centro', 'Bello Horizonte', 'El Placer', 'La Primavera'],
      'horario': '5:45 AM - 8:00 PM',
      'costo': '2.500',
      'trafico': 'Moderado',
      'proxBus': '11 min',
      'favorito': false,
      'busId': 'CT008',
    },
  ];

  int? _rutaSeleccionada;

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
      _rutas[index]['favorito'] = !_rutas[index]['favorito'];
    });
  }

  void _rastrearBus(int index) {
    final ruta = _rutas[index];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerBusesPagina(
          routeName: ruta['nombre'],
          busId: ruta['busId'],
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
          image: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/7/7e/Popayan_Panoramica.jpg/640px-Popayan_Panoramica.jpg'),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Mapa de referencia',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
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
        title: const Text('Rutas de Popayán', style: TextStyle(fontWeight: FontWeight.bold)),
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
                          color: const Color(0xFFFF6A00).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: const Icon(Icons.directions_bus, color: Color(0xFFFF6A00), size: 28),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ruta['nombre'],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF6A00),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              ruta['empresa'],
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
                          ruta['favorito'] ? Icons.star : Icons.star_border,
                          color: ruta['favorito'] ? Colors.amber : Colors.grey,
                        ),
                        onPressed: () => _toggleFavorito(index),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    ruta['trayecto'],
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
                      children: ruta['paradas'].map<Widget>((p) => Row(
                        children: [
                          const Icon(Icons.location_on, color: Color(0xFFFF6A00), size: 18),
                          const SizedBox(width: 4),
                          Text(p, style: const TextStyle(fontSize: 15)),
                        ],
                      )).toList(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 18, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('Horario: ${ruta['horario']}'),
                      const SizedBox(width: 16),
                      const Icon(Icons.attach_money, size: 18, color: Colors.green),
                      Text(ruta['costo']),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(_traficoIcon(ruta['trafico']), color: _traficoColor(ruta['trafico']), size: 18),
                      const SizedBox(width: 4),
                      Text('Tráfico: ${ruta['trafico']}'),
                      const SizedBox(width: 16),
                      const Icon(Icons.directions_bus_filled, size: 18, color: Colors.blue),
                      Text('Próximo bus: ${ruta['proxBus']}'),
                    ],
                  ),
                  const SizedBox(height: 14),
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 300),
                    crossFadeState: seleccionada ? CrossFadeState.showFirst : CrossFadeState.showSecond,
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
                                  routeName: ruta['nombre'],
                                  stops: List<String>.from(ruta['paradas']),
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.map, color: Colors.white),
                          label: const Text('Ver mapa', style: TextStyle(color: Colors.white)),
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
                          icon: const Icon(Icons.location_searching, color: Colors.white),
                          label: const Text('Rastrear', style: TextStyle(color: Colors.white)),
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