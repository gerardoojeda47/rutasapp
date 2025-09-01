import 'package:flutter/material.dart';

class ParadasPagina extends StatefulWidget {
  const ParadasPagina({super.key});

  @override
  State<ParadasPagina> createState() => _ParadasPaginaState();
}

class _ParadasPaginaState extends State<ParadasPagina> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final Map<String, List<String>> _comunas = {
    'Comuna 1 - Centro Histórico': [
      'Avelino Ull',
      'Braceros',
      'El Lago',
      'Berlín',
      'Suizo',
      'Las Ferias',
      'La Campiña',
      'María Oriente',
      'Los Sauces',
      'Santa Mónica',
      'La Floresta',
      'Los Andes',
      'Colgate Palmolive',
      'Alameda',
      'Plateado',
      'Poblado Altos Sauces'
    ],
    'Comuna 2 - Norte': [
      'González',
      'El Tablazo',
      'Morinda',
      'Destechados',
      'Santiago de Cali',
      'Zuldemaida',
      'María Paz',
      'Balcón Norte',
      'Pino Pardo',
      'Matamoros',
      'Chamizal',
      'Tóez',
      'Villa Claudia',
      'Guayacanes del Río',
      'Pinar',
      'Villa Melisa',
      'Esperanza',
      'Canterbury',
      'La Arboleda',
      'El Uvo',
      'San Ignacio',
      'Bella Vista',
      'El Bambú Cruz Roja',
      'Río Vista',
      'Bello Horizonte',
      'El Placer',
      'Villa del Norte',
      'La Primavera',
      'Rinconcito Primaveral'
    ],
    'Comunas 3, 4, 5, 6 y 8 - Sur y Este': [
      'Alfonso López',
      'Calicanto',
      'Comuneros',
      'El Boquerón',
      'El Deán',
      'El Limonar',
      'El Pajonal',
      'Gabriel G. Marqués',
      'Jorge E. Gaitán',
      'La Paz',
      'Jose María Obando',
      'San Camilo',
      'La Esmeralda',
      'Campan',
      'El Recuerdo',
      'Terminal',
      'San Eduardo',
      'El Uvo',
      'San Eduardo',
      'La Paz'
    ],
    'Zona Rural - Veredas': [
      'Los Cerillos',
      'La Yunga',
      'Julumito',
      'San Bernardino',
      'La Estrella',
      'El Tablón',
      'La Laguna',
      'El Cofre',
      'La Bolsa',
      'El Diviso',
      'La Vega',
      'El Palmar',
      'La Sierpe',
      'El Rosal',
      'La María',
      'El Vergel',
      'La Esperanza',
      'El Progreso',
      'La Libertad',
      'El Paraíso'
    ],
    'Otros Barrios y Zonas': [
      'Deportistas',
      'Los Hoyos',
      'Samuel Silverio',
      'Camino Real',
      'Junín',
      'Santa Elena',
      'Popular',
      'La Estación',
      'El Bosque',
      'La Soledad',
      'El Mirador',
      'La Victoria',
      'El Triunfo',
      'La Gloria',
      'El Edén',
      'La Unión',
      'El Porvenir',
      'La Aurora',
      'El Amparo',
      'La Providencia'
    ]
  };

  // Información de rutas por barrio mejorada
  final Map<String, List<Map<String, dynamic>>> _rutasPorBarrio = {
    'Los Sauces': [
      {
        'nombre': 'Ruta 1 - Los Sauces',
        'horario': '5:30 AM - 9:00 PM',
        'frecuencia': 'Cada 10 minutos',
        'destino': 'Centro - Los Sauces',
        'costo': '2.500',
        'tiempoEstimado': '15 minutos',
        'estadoTrafico': 'Fluido',
        'paradas': ['Centro', 'La Campiña', 'Los Sauces'],
        'empresa': 'Transportes Popayán',
        'tipoBus': 'Buseta',
        'capacidad': '25 pasajeros',
        'servicios': ['Aire acondicionado', 'WiFi'],
      },
    ],
    'Santa Mónica': [
      {
        'nombre': 'Ruta 2 - Santa Mónica',
        'horario': '5:30 AM - 9:00 PM',
        'frecuencia': 'Cada 12 minutos',
        'destino': 'Centro - Santa Mónica',
        'costo': '2.500',
        'tiempoEstimado': '12 minutos',
        'estadoTrafico': 'Fluido',
        'paradas': ['Centro', 'Santa Mónica'],
        'empresa': 'Coopetrans',
        'tipoBus': 'Buseta',
        'capacidad': '25 pasajeros',
        'servicios': ['Aire acondicionado'],
      },
    ],
    'La Floresta': [
      {
        'nombre': 'Ruta 3 - La Floresta',
        'horario': '5:30 AM - 9:00 PM',
        'frecuencia': 'Cada 15 minutos',
        'destino': 'Centro - La Floresta',
        'costo': '2.500',
        'tiempoEstimado': '10 minutos',
        'estadoTrafico': 'Fluido',
        'paradas': ['Centro', 'La Floresta'],
        'empresa': 'Transportes Popayán',
        'tipoBus': 'Buseta',
        'capacidad': '25 pasajeros',
        'servicios': ['Aire acondicionado'],
      },
    ],
    'Los Andes': [
      {
        'nombre': 'Ruta 4 - Los Andes',
        'horario': '5:30 AM - 9:00 PM',
        'frecuencia': 'Cada 15 minutos',
        'destino': 'Centro - Los Andes',
        'costo': '2.500',
        'tiempoEstimado': '8 minutos',
        'estadoTrafico': 'Fluido',
        'paradas': ['Centro', 'Los Andes'],
        'empresa': 'Coopetrans',
        'tipoBus': 'Buseta',
        'capacidad': '25 pasajeros',
        'servicios': ['Aire acondicionado'],
      },
    ],
    'La Campiña': [
      {
        'nombre': 'Ruta 5 - La Campiña',
        'horario': '5:30 AM - 9:00 PM',
        'frecuencia': 'Cada 10 minutos',
        'destino': 'Centro - La Campiña',
        'costo': '2.500',
        'tiempoEstimado': '10 minutos',
        'estadoTrafico': 'Fluido',
        'paradas': ['Centro', 'La Campiña'],
        'empresa': 'Transportes Popayán',
        'tipoBus': 'Buseta',
        'capacidad': '25 pasajeros',
        'servicios': ['Aire acondicionado'],
      },
    ],
    'María Oriente': [
      {
        'nombre': 'Ruta 6 - María Oriente',
        'horario': '5:30 AM - 9:00 PM',
        'frecuencia': 'Cada 15 minutos',
        'destino': 'Centro - María Oriente',
        'costo': '2.500',
        'tiempoEstimado': '15 minutos',
        'estadoTrafico': 'Fluido',
        'paradas': ['Centro', 'María Oriente'],
        'empresa': 'Coopetrans',
        'tipoBus': 'Buseta',
        'capacidad': '25 pasajeros',
        'servicios': ['Aire acondicionado'],
      },
    ],
    'El Lago': [
      {
        'nombre': 'Ruta 7 - El Lago',
        'horario': '5:30 AM - 9:00 PM',
        'frecuencia': 'Cada 12 minutos',
        'destino': 'Centro - El Lago',
        'costo': '2.500',
        'tiempoEstimado': '12 minutos',
        'estadoTrafico': 'Fluido',
        'paradas': ['Centro', 'El Lago'],
        'empresa': 'Transportes Popayán',
        'tipoBus': 'Buseta',
        'capacidad': '25 pasajeros',
        'servicios': ['Aire acondicionado'],
      },
    ],
    'Berlín': [
      {
        'nombre': 'Ruta 8 - Berlín',
        'horario': '5:30 AM - 9:00 PM',
        'frecuencia': 'Cada 15 minutos',
        'destino': 'Centro - Berlín',
        'costo': '2.500',
        'tiempoEstimado': '15 minutos',
        'estadoTrafico': 'Fluido',
        'paradas': ['Centro', 'Berlín'],
        'empresa': 'Coopetrans',
        'tipoBus': 'Buseta',
        'capacidad': '25 pasajeros',
        'servicios': ['Aire acondicionado'],
      },
    ],
    'Suizo': [
      {
        'nombre': 'Ruta 9 - Suizo',
        'horario': '5:30 AM - 9:00 PM',
        'frecuencia': 'Cada 12 minutos',
        'destino': 'Centro - Suizo',
        'costo': '2.500',
        'tiempoEstimado': '10 minutos',
        'estadoTrafico': 'Fluido',
        'paradas': ['Centro', 'Suizo'],
        'empresa': 'Transportes Popayán',
        'tipoBus': 'Buseta',
        'capacidad': '25 pasajeros',
        'servicios': ['Aire acondicionado'],
      },
    ],
    'Las Ferias': [
      {
        'nombre': 'Ruta 10 - Las Ferias',
        'horario': '5:30 AM - 9:00 PM',
        'frecuencia': 'Cada 15 minutos',
        'destino': 'Centro - Las Ferias',
        'costo': '2.500',
        'tiempoEstimado': '12 minutos',
        'estadoTrafico': 'Fluido',
        'paradas': ['Centro', 'Las Ferias'],
        'empresa': 'Coopetrans',
        'tipoBus': 'Buseta',
        'capacidad': '25 pasajeros',
        'servicios': ['Aire acondicionado'],
      },
    ],
    'Bello Horizonte': [
      {
        'nombre': 'Ruta 11 - Bello Horizonte',
        'horario': '5:30 AM - 9:00 PM',
        'frecuencia': 'Cada 10 minutos',
        'destino': 'Centro - Bello Horizonte',
        'costo': '2.500',
        'tiempoEstimado': '18 minutos',
        'estadoTrafico': 'Moderado',
        'paradas': ['Centro', 'Bello Horizonte', 'El Placer'],
        'empresa': 'Transportes Popayán',
        'tipoBus': 'Buseta',
        'capacidad': '25 pasajeros',
        'servicios': ['Aire acondicionado'],
      },
    ],
    'Alfonso López': [
      {
        'nombre': 'Ruta 12 - Alfonso López',
        'horario': '5:30 AM - 9:00 PM',
        'frecuencia': 'Cada 12 minutos',
        'destino': 'Centro - Alfonso López',
        'costo': '2.500',
        'tiempoEstimado': '20 minutos',
        'estadoTrafico': 'Moderado',
        'paradas': ['Centro', 'Alfonso López', 'El Limonar'],
        'empresa': 'Coopetrans',
        'tipoBus': 'Buseta',
        'capacidad': '25 pasajeros',
        'servicios': ['Aire acondicionado'],
      },
    ],
    'La Paz': [
      {
        'nombre': 'Ruta 13 - La Paz',
        'horario': '5:30 AM - 9:00 PM',
        'frecuencia': 'Cada 8 minutos',
        'destino': 'Centro - La Paz',
        'costo': '2.500',
        'tiempoEstimado': '25 minutos',
        'estadoTrafico': 'Congestionado',
        'paradas': ['Centro', 'La Paz', 'Jose María Obando'],
        'empresa': 'Transportes Popayán',
        'tipoBus': 'Buseta',
        'capacidad': '25 pasajeros',
        'servicios': ['Aire acondicionado', 'WiFi'],
      },
    ],
    'La Esmeralda': [
      {
        'nombre': 'Ruta 14 - La Esmeralda',
        'horario': '5:30 AM - 9:00 PM',
        'frecuencia': 'Cada 10 minutos',
        'destino': 'Centro - La Esmeralda',
        'costo': '2.500',
        'tiempoEstimado': '22 minutos',
        'estadoTrafico': 'Moderado',
        'paradas': ['Centro', 'Campan', 'La Esmeralda'],
        'empresa': 'Coopetrans',
        'tipoBus': 'Buseta',
        'capacidad': '25 pasajeros',
        'servicios': ['Aire acondicionado'],
      },
    ],
  };

  List<String> _getFilteredBarrios() {
    if (_searchQuery.isEmpty) return [];

    List<String> filteredBarrios = [];
    _comunas.forEach((comuna, barrios) {
      filteredBarrios.addAll(barrios.where((barrio) =>
          barrio.toLowerCase().contains(_searchQuery.toLowerCase())));
    });
    return filteredBarrios;
  }

  Color _getTrafficColor(String estado) {
    switch (estado.toLowerCase()) {
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

  void _showRutasDialog(String barrio) {
    final rutas = _rutasPorBarrio[barrio] ?? [];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Rutas en $barrio'),
        content: SizedBox(
          width: double.maxFinite,
          child: rutas.isEmpty
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.bus_alert,
                      size: 50,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No hay rutas registradas para este barrio',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Las rutas se actualizarán próximamente',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: rutas.length,
                  itemBuilder: (context, index) {
                    final ruta = rutas[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    ruta['nombre'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Color(0xFFFF6A00),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        _getTrafficColor(ruta['estadoTrafico'])
                                            .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    ruta['estadoTrafico'],
                                    style: TextStyle(
                                      color: _getTrafficColor(
                                          ruta['estadoTrafico']),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('Destino: ${ruta['destino']}'),
                            Text('Horario: ${ruta['horario']}'),
                            Text('Frecuencia: ${ruta['frecuencia']}'),
                            Text('Costo: \$${ruta['costo']}'),
                            Text('Tiempo estimado: ${ruta['tiempoEstimado']}'),
                            const SizedBox(height: 8),
                            const Text(
                              'Paradas:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            ...ruta['paradas']
                                .map((parada) => Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16, top: 4),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.location_on,
                                              size: 16,
                                              color: Color(0xFFFF6A00)),
                                          const SizedBox(width: 8),
                                          Text(parada),
                                        ],
                                      ),
                                    ))
                                .toList(),
                            const SizedBox(height: 8),
                            const Text(
                              'Información del bus:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('Empresa: ${ruta['empresa']}'),
                            Text('Tipo: ${ruta['tipoBus']}'),
                            Text('Capacidad: ${ruta['capacidad']}'),
                            const SizedBox(height: 8),
                            const Text(
                              'Servicios:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Wrap(
                              spacing: 8,
                              children: (ruta['servicios'] as List<String>)
                                  .map((servicio) => Chip(
                                        label: Text(servicio),
                                        backgroundColor: const Color(0xFFFF6A00)
                                            .withValues(alpha: 0.1),
                                        labelStyle: const TextStyle(
                                            color: Color(0xFFFF6A00)),
                                      ))
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredBarrios = _getFilteredBarrios();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Paradas de Popayán',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFF6A00),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar barrio o comuna...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Lista de resultados de búsqueda o comunas
          Expanded(
            child: _searchQuery.isNotEmpty
                ? ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredBarrios.length,
                    itemBuilder: (context, index) {
                      final barrio = filteredBarrios[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6A00)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.location_on,
                              color: Color(0xFFFF6A00),
                            ),
                          ),
                          title: Text(
                            barrio,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            _getComunaForBarrio(barrio),
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () => _showRutasDialog(barrio),
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _comunas.length,
                    itemBuilder: (context, index) {
                      String comuna = _comunas.keys.elementAt(index);
                      List<String> barrios = _comunas[comuna]!;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ExpansionTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6A00)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.location_city,
                              color: Color(0xFFFF6A00),
                            ),
                          ),
                          title: Text(
                            comuna,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF6A00),
                            ),
                          ),
                          subtitle: Text(
                            '${barrios.length} barrios',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          children: barrios
                              .map((barrio) => ListTile(
                                    leading: const Icon(Icons.location_on,
                                        color: Color(0xFFFF6A00)),
                                    title: Text(barrio),
                                    subtitle: Text(
                                      _rutasPorBarrio.containsKey(barrio)
                                          ? '${_rutasPorBarrio[barrio]!.length} rutas disponibles'
                                          : 'Sin rutas registradas',
                                      style: TextStyle(
                                        color:
                                            _rutasPorBarrio.containsKey(barrio)
                                                ? Colors.green
                                                : Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                    trailing:
                                        _rutasPorBarrio.containsKey(barrio)
                                            ? const Icon(Icons.check_circle,
                                                color: Colors.green, size: 16)
                                            : const Icon(Icons.info_outline,
                                                color: Colors.grey, size: 16),
                                    onTap: () => _showRutasDialog(barrio),
                                  ))
                              .toList(),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _getComunaForBarrio(String barrio) {
    for (var entry in _comunas.entries) {
      if (entry.value.contains(barrio)) {
        return entry.key;
      }
    }
    return 'Comuna no especificada';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
