import 'package:flutter/material.dart';

class RouteSearchPage extends StatefulWidget {
  const RouteSearchPage({super.key});

  @override
  State<RouteSearchPage> createState() => _RouteSearchPageState();
}

class _RouteSearchPageState extends State<RouteSearchPage> {
  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  String _selectedTime = 'Ahora';
  String _selectedPreference = 'Más rápido';

  final List<Map<String, dynamic>> _suggestedRoutes = [
    {
      'route': 'La Paz',
      'duration': '35 min',
      'transfers': 0,
      'walking': '5 min',
      'stops': 18,
      'price': '\$2.000',
      'nextBus': '5 min',
      'busyLevel': 'Medio',
    },
    {
      'route': 'La Esmeralda + La Paz',
      'duration': '45 min',
      'transfers': 1,
      'walking': '8 min',
      'stops': 25,
      'price': '\$4.000',
      'nextBus': '8 min',
      'busyLevel': 'Bajo',
    },
    {
      'route': 'Campanario + La Estación',
      'duration': '40 min',
      'transfers': 1,
      'walking': '3 min',
      'stops': 22,
      'price': '\$4.000',
      'nextBus': '12 min',
      'busyLevel': 'Alto',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '¿Cómo llegar?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFF6A00),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6A00),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                // Origin field
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: _originController,
                    decoration: InputDecoration(
                      hintText: '¿Desde dónde?',
                      border: InputBorder.none,
                      icon: Icon(Icons.location_on, color: Colors.grey[600]),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Destination field
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: _destinationController,
                    decoration: InputDecoration(
                      hintText: '¿A dónde quieres ir?',
                      border: InputBorder.none,
                      icon: Icon(Icons.location_on, color: Colors.grey[600]),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Options row
                Row(
                  children: [
                    Expanded(
                      child: _buildOptionDropdown(
                        value: _selectedTime,
                        items: ['Ahora', 'Salir a las...', 'Llegar a las...'],
                        onChanged: (value) {
                          setState(() => _selectedTime = value!);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildOptionDropdown(
                        value: _selectedPreference,
                        items: ['Más rápido', 'Menos transbordos', 'Menos caminar'],
                        onChanged: (value) {
                          setState(() => _selectedPreference = value!);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Suggested routes
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _suggestedRoutes.length,
              itemBuilder: (context, index) {
                final route = _suggestedRoutes[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 15),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF6A00).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.directions_bus,
                                color: Color(0xFFFF6A00),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    route['route'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${route['duration']} • ${route['transfers']} transbordo',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _buildBusyLevelIndicator(route['busyLevel']),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildRouteInfo(
                              Icons.directions_walk,
                              'Caminar: ${route['walking']}',
                            ),
                            _buildRouteInfo(
                              Icons.timer,
                              'Próximo bus: ${route['nextBus']}',
                            ),
                            _buildRouteInfo(
                              Icons.attach_money,
                              route['price'],
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6A00),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            'Ver detalles de la ruta',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionDropdown({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildBusyLevelIndicator(String level) {
    Color color;
    switch (level.toLowerCase()) {
      case 'alto':
        color = Colors.red;
        break;
      case 'medio':
        color = Colors.orange;
        break;
      case 'bajo':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        'Ocupación: $level',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRouteInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }
} 