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
  bool _showOriginSuggestions = false;
  bool _showDestinationSuggestions = false;
  String _selectedOrigin = '';
  String _selectedDestination = '';

  // Lista completa de barrios y puntos de interés de Popayán
  final List<Map<String, dynamic>> _locations = [
    // Comuna 1 - Centro Histórico
    {'name': 'Centro Histórico', 'type': 'Zona', 'comuna': 'Comuna 1'},
    {'name': 'Avelino Ull', 'type': 'Barrio', 'comuna': 'Comuna 1'},
    {'name': 'Braceros', 'type': 'Barrio', 'comuna': 'Comuna 1'},
    {'name': 'El Lago', 'type': 'Barrio', 'comuna': 'Comuna 1'},
    {'name': 'Berlín', 'type': 'Barrio', 'comuna': 'Comuna 1'},
    {'name': 'Suizo', 'type': 'Barrio', 'comuna': 'Comuna 1'},
    {'name': 'Las Ferias', 'type': 'Barrio', 'comuna': 'Comuna 1'},
    {'name': 'La Campiña', 'type': 'Barrio', 'comuna': 'Comuna 1'},
    {'name': 'María Oriente', 'type': 'Barrio', 'comuna': 'Comuna 1'},
    {'name': 'Los Sauces', 'type': 'Barrio', 'comuna': 'Comuna 1'},
    {'name': 'Santa Mónica', 'type': 'Barrio', 'comuna': 'Comuna 1'},
    {'name': 'La Floresta', 'type': 'Barrio', 'comuna': 'Comuna 1'},
    {'name': 'Los Andes', 'type': 'Barrio', 'comuna': 'Comuna 1'},
    {'name': 'Colgate Palmolive', 'type': 'Barrio', 'comuna': 'Comuna 1'},
    {'name': 'Alameda', 'type': 'Barrio', 'comuna': 'Comuna 1'},
    {'name': 'Plateado', 'type': 'Barrio', 'comuna': 'Comuna 1'},
    {'name': 'Poblado Altos Sauces', 'type': 'Barrio', 'comuna': 'Comuna 1'},
    
    // Comuna 2
    {'name': 'González', 'type': 'Barrio', 'comuna': 'Comuna 2'},
    {'name': 'El Tablazo', 'type': 'Barrio', 'comuna': 'Comuna 2'},
    {'name': 'Morinda', 'type': 'Barrio', 'comuna': 'Comuna 2'},
    {'name': 'Destechados', 'type': 'Barrio', 'comuna': 'Comuna 2'},
    {'name': 'Santiago de Cali', 'type': 'Barrio', 'comuna': 'Comuna 2'},
    {'name': 'Zuldemaida', 'type': 'Barrio', 'comuna': 'Comuna 2'},
    {'name': 'María Paz', 'type': 'Barrio', 'comuna': 'Comuna 2'},
    {'name': 'Balcón Norte', 'type': 'Barrio', 'comuna': 'Comuna 2'},
    {'name': 'Pino Pardo', 'type': 'Barrio', 'comuna': 'Comuna 2'},
    {'name': 'Matamoros', 'type': 'Barrio', 'comuna': 'Comuna 2'},
    {'name': 'Chamizal', 'type': 'Barrio', 'comuna': 'Comuna 2'},
    {'name': 'Tóez', 'type': 'Barrio', 'comuna': 'Comuna 2'},
    {'name': 'Villa Claudia', 'type': 'Barrio', 'comuna': 'Comuna 2'},
    {'name': 'Guayacanes del Río', 'type': 'Barrio', 'comuna': 'Comuna 2'},
    {'name': 'Pinar', 'type': 'Barrio', 'comuna': 'Comuna 2'},
    {'name': 'Villa Melisa', 'type': 'Barrio', 'comuna': 'Comuna 2'},
    {'name': 'Esperanza', 'type': 'Barrio', 'comuna': 'Comuna 2'},
    {'name': 'Canterbury', 'type': 'Barrio', 'comuna': 'Comuna 2'},
    {'name': 'La Arboleda', 'type': 'Barrio', 'comuna': 'Comuna 2'},
    {'name': 'El Uvo', 'type': 'Barrio', 'comuna': 'Comuna 2'},
    {'name': 'San Ignacio', 'type': 'Barrio', 'comuna': 'Comuna 2'},
    {'name': 'Bella Vista', 'type': 'Barrio', 'comuna': 'Comuna 2'},
    {'name': 'El Bambú Cruz Roja', 'type': 'Barrio', 'comuna': 'Comuna 2'},
    {'name': 'Río Vista', 'type': 'Barrio', 'comuna': 'Comuna 2'},
    {'name': 'Bello Horizonte', 'type': 'Barrio', 'comuna': 'Comuna 2'},
    {'name': 'El Placer', 'type': 'Barrio', 'comuna': 'Comuna 2'},
    {'name': 'Villa del Norte', 'type': 'Barrio', 'comuna': 'Comuna 2'},
    {'name': 'La Primavera', 'type': 'Barrio', 'comuna': 'Comuna 2'},
    {'name': 'Rinconcito Primaveral', 'type': 'Barrio', 'comuna': 'Comuna 2'},
    
    // Comunas 3, 4, 5, 6 y 8
    {'name': 'Alfonso López', 'type': 'Barrio', 'comuna': 'Comuna 3'},
    {'name': 'Calicanto', 'type': 'Barrio', 'comuna': 'Comuna 3'},
    {'name': 'Comuneros', 'type': 'Barrio', 'comuna': 'Comuna 3'},
    {'name': 'El Boquerón', 'type': 'Barrio', 'comuna': 'Comuna 3'},
    {'name': 'El Deán', 'type': 'Barrio', 'comuna': 'Comuna 3'},
    {'name': 'El Limonar', 'type': 'Barrio', 'comuna': 'Comuna 3'},
    {'name': 'El Pajonal', 'type': 'Barrio', 'comuna': 'Comuna 3'},
    {'name': 'Gabriel G. Marqués', 'type': 'Barrio', 'comuna': 'Comuna 3'},
    {'name': 'Jorge E.', 'type': 'Barrio', 'comuna': 'Comuna 3'},
    
    // Zona Rural
    {'name': 'Los Cerillos', 'type': 'Vereda', 'comuna': 'Rural'},
    {'name': 'La Yunga', 'type': 'Vereda', 'comuna': 'Rural'},
    {'name': 'Julumito', 'type': 'Vereda', 'comuna': 'Rural'},
    {'name': 'San Bernardino', 'type': 'Vereda', 'comuna': 'Rural'},
    
    // Otros Barrios
    {'name': 'Deportistas', 'type': 'Barrio', 'comuna': 'Otros'},
    {'name': 'Los Hoyos', 'type': 'Barrio', 'comuna': 'Otros'},
    {'name': 'Samuel Silverio', 'type': 'Barrio', 'comuna': 'Otros'},
    {'name': 'Camino Real', 'type': 'Barrio', 'comuna': 'Otros'},
    {'name': 'Junín', 'type': 'Barrio', 'comuna': 'Otros'},
    {'name': 'Santa Elena', 'type': 'Barrio', 'comuna': 'Otros'},
    {'name': 'Popular', 'type': 'Barrio', 'comuna': 'Otros'},
    
    // Puntos de Interés
    {'name': 'Terminal de Transportes', 'type': 'Terminal', 'comuna': 'Centro'},
    {'name': 'Universidad del Cauca', 'type': 'Universidad', 'comuna': 'Centro'},
    {'name': 'Hospital San José', 'type': 'Hospital', 'comuna': 'Centro'},
    {'name': 'Centro Comercial Campanario', 'type': 'Centro Comercial', 'comuna': 'Centro'},
    {'name': 'Plaza de Mercado', 'type': 'Mercado', 'comuna': 'Centro'},
    {'name': 'Parque Caldas', 'type': 'Parque', 'comuna': 'Centro'},
    {'name': 'Museo de Arte Religioso', 'type': 'Museo', 'comuna': 'Centro'},
    {'name': 'Iglesia de San Francisco', 'type': 'Iglesia', 'comuna': 'Centro'},
    {'name': 'Puente del Humilladero', 'type': 'Monumento', 'comuna': 'Centro'},
    {'name': 'Morro de Tulcán', 'type': 'Monumento', 'comuna': 'Centro'},
    {'name': 'Cerro de las Tres Cruces', 'type': 'Monumento', 'comuna': 'Centro'},
    {'name': 'Aeropuerto Guillermo León Valencia', 'type': 'Aeropuerto', 'comuna': 'Rural'},
  ];

  // Historial de búsquedas
  final List<String> _searchHistory = [
    'Centro Histórico',
    'Universidad del Cauca',
    'Terminal de Transportes',
    'Centro Comercial Campanario',
  ];

  // Favoritos
  final List<String> _favorites = [
    'Casa',
    'Trabajo',
    'Universidad',
  ];

  final List<Map<String, dynamic>> _suggestedRoutes = [
    {
      'route': 'La Paz',
      'duration': '35 min',
      'transfers': 0,
      'walking': '5 min',
      'stops': 18,
      'price': '2.000',
      'nextBus': '5 min',
      'busyLevel': 'Medio',
      'routeDetails': ['Ruta 1', 'Transpubenza'],
    },
    {
      'route': 'La Esmeralda + La Paz',
      'duration': '45 min',
      'transfers': 1,
      'walking': '8 min',
      'stops': 25,
      'price': '4.000',
      'nextBus': '8 min',
      'busyLevel': 'Bajo',
      'routeDetails': ['Ruta 2', 'Coopetrans'],
    },
    {
      'route': 'Campanario + La Estación',
      'duration': '40 min',
      'transfers': 1,
      'walking': '3 min',
      'stops': 22,
      'price': '4.000',
      'nextBus': '12 min',
      'busyLevel': 'Alto',
      'routeDetails': ['Ruta 3', 'Transpubenza'],
    },
  ];

  List<Map<String, dynamic>> _getFilteredLocations(String query) {
    if (query.isEmpty) return [];
    return _locations.where((location) =>
        location['name'].toLowerCase().contains(query.toLowerCase())).toList();
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
        borderRadius: BorderRadius.circular(25),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildBusyLevelIndicator(String level) {
    Color color;
    IconData icon;
    
    switch (level.toLowerCase()) {
      case 'bajo':
        color = Colors.green;
        icon = Icons.sentiment_satisfied;
        break;
      case 'medio':
        color = Colors.orange;
        icon = Icons.sentiment_neutral;
        break;
      case 'alto':
        color = Colors.red;
        icon = Icons.sentiment_dissatisfied;
        break;
      default:
        color = Colors.grey;
        icon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Text(
            level,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteInfo(IconData icon, String text) {
    return Row(
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
    );
  }

  Widget _buildLocationSuggestion(Map<String, dynamic> location, bool isOrigin) {
    return ListTile(
      leading: Icon(
        _getLocationIcon(location['type']),
        color: const Color(0xFFFF6A00),
      ),
      title: Text(
        location['name'],
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text('${location['type']} • ${location['comuna']}'),
      onTap: () {
        if (isOrigin) {
          _originController.text = location['name'];
          _selectedOrigin = location['name'];
          setState(() {
            _showOriginSuggestions = false;
          });
        } else {
          _destinationController.text = location['name'];
          _selectedDestination = location['name'];
          setState(() {
            _showDestinationSuggestions = false;
          });
        }
      },
    );
  }

  IconData _getLocationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'barrio':
        return Icons.location_city;
      case 'zona':
        return Icons.map;
      case 'terminal':
        return Icons.directions_bus;
      case 'universidad':
        return Icons.school;
      case 'hospital':
        return Icons.local_hospital;
      case 'centro comercial':
        return Icons.shopping_cart;
      case 'mercado':
        return Icons.store;
      case 'parque':
        return Icons.park;
      case 'museo':
        return Icons.museum;
      case 'iglesia':
        return Icons.church;
      case 'monumento':
        return Icons.location_on;
      case 'aeropuerto':
        return Icons.flight;
      case 'vereda':
        return Icons.landscape;
      default:
        return Icons.location_on;
    }
  }

  void _searchRoutes() {
    if (_selectedOrigin.isEmpty || _selectedDestination.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona origen y destino'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Simular búsqueda
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Buscando rutas...'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Calculando la mejor ruta para ti'),
            ],
          ),
        );
      },
    );

    // Simular delay y cerrar diálogo
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Rutas encontradas!'),
          backgroundColor: Color(0xFFFF6A00),
        ),
      );
    });
  }

  void _showRouteDetails(Map<String, dynamic> route) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detalles de ${route['route']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Empresa: ${route['routeDetails'][1]}'),
              Text('Ruta: ${route['routeDetails'][0]}'),
              Text('Duración: ${route['duration']}'),
              Text('Precio: \$${route['price']}'),
              Text('Transbordos: ${route['transfers']}'),
              Text('Caminar: ${route['walking']}'),
              Text('Paradas: ${route['stops']}'),
              Text('Próximo bus: ${route['nextBus']}'),
              const SizedBox(height: 10),
              _buildBusyLevelIndicator(route['busyLevel']),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Ruta seleccionada: ${route['route']}'),
                    backgroundColor: const Color(0xFFFF6A00),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6A00),
                foregroundColor: Colors.white,
              ),
              child: const Text('Seleccionar'),
            ),
          ],
        );
      },
    );
  }

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
                      suffixIcon: _originController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _originController.clear();
                                _selectedOrigin = '';
                                setState(() {
                                  _showOriginSuggestions = false;
                                });
                              },
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _showOriginSuggestions = value.isNotEmpty;
                        _selectedOrigin = value;
                      });
                    },
                    onTap: () {
                      setState(() {
                        _showOriginSuggestions = true;
                        _showDestinationSuggestions = false;
                      });
                    },
                  ),
                ),
                
                // Origin suggestions
                if (_showOriginSuggestions)
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_favorites.isNotEmpty) ...[
                          const Padding(
                            padding: EdgeInsets.all(15),
                            child: Text(
                              'Favoritos',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF6A00),
                              ),
                            ),
                          ),
                          ..._favorites.map((favorite) => ListTile(
                            leading: const Icon(Icons.favorite, color: Colors.red),
                            title: Text(favorite),
                            onTap: () {
                              _originController.text = favorite;
                              _selectedOrigin = favorite;
                              setState(() {
                                _showOriginSuggestions = false;
                              });
                            },
                          )),
                          const Divider(),
                        ],
                        if (_searchHistory.isNotEmpty) ...[
                          const Padding(
                            padding: EdgeInsets.all(15),
                            child: Text(
                              'Búsquedas recientes',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF6A00),
                              ),
                            ),
                          ),
                          ..._searchHistory.map((history) => ListTile(
                            leading: const Icon(Icons.history, color: Colors.grey),
                            title: Text(history),
                            onTap: () {
                              _originController.text = history;
                              _selectedOrigin = history;
                              setState(() {
                                _showOriginSuggestions = false;
                              });
                            },
                          )),
                          const Divider(),
                        ],
                        const Padding(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            'Lugares',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF6A00),
                            ),
                          ),
                        ),
                        ..._getFilteredLocations(_originController.text)
                            .take(5)
                            .map((location) => _buildLocationSuggestion(location, true)),
                      ],
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
                      suffixIcon: _destinationController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _destinationController.clear();
                                _selectedDestination = '';
                                setState(() {
                                  _showDestinationSuggestions = false;
                                });
                              },
                            )
                          : null,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _showDestinationSuggestions = value.isNotEmpty;
                        _selectedDestination = value;
                      });
                    },
                    onTap: () {
                      setState(() {
                        _showDestinationSuggestions = true;
                        _showOriginSuggestions = false;
                      });
                    },
                  ),
                ),

                // Destination suggestions
                if (_showDestinationSuggestions)
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_favorites.isNotEmpty) ...[
                          const Padding(
                            padding: EdgeInsets.all(15),
                            child: Text(
                              'Favoritos',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF6A00),
                              ),
                            ),
                          ),
                          ..._favorites.map((favorite) => ListTile(
                            leading: const Icon(Icons.favorite, color: Colors.red),
                            title: Text(favorite),
                            onTap: () {
                              _destinationController.text = favorite;
                              _selectedDestination = favorite;
                              setState(() {
                                _showDestinationSuggestions = false;
                              });
                            },
                          )),
                          const Divider(),
                        ],
                        if (_searchHistory.isNotEmpty) ...[
                          const Padding(
                            padding: EdgeInsets.all(15),
                            child: Text(
                              'Búsquedas recientes',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF6A00),
                              ),
                            ),
                          ),
                          ..._searchHistory.map((history) => ListTile(
                            leading: const Icon(Icons.history, color: Colors.grey),
                            title: Text(history),
                            onTap: () {
                              _destinationController.text = history;
                              _selectedDestination = history;
                              setState(() {
                                _showDestinationSuggestions = false;
                              });
                            },
                          )),
                          const Divider(),
                        ],
                        const Padding(
                          padding: EdgeInsets.all(15),
                          child: Text(
                            'Lugares',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF6A00),
                            ),
                          ),
                        ),
                        ..._getFilteredLocations(_destinationController.text)
                            .take(5)
                            .map((location) => _buildLocationSuggestion(location, false)),
                      ],
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
                const SizedBox(height: 15),
                
                // Search button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _searchRoutes,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFFFF6A00),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: const Text(
                      'Buscar Rutas',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
                                color: const Color(0xFFFF6A00).withValues(alpha: 0.1),
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
                              Icons.stop_circle,
                              '${route['stops']} paradas',
                            ),
                            _buildRouteInfo(
                              Icons.attach_money,
                              '\$${route['price']}',
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'Próximo bus: ${route['nextBus']}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Flexible(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                    onPressed: () => _showRouteDetails(route),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[200],
                                      foregroundColor: Colors.black87,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: const Text('Detalles'),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Ruta seleccionada: ${route['route']}'),
                                          backgroundColor: const Color(0xFFFF6A00),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFFF6A00),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: const Text('Seleccionar'),
                                  ),
                                ],
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
          ),
        ],
      ),
    );
  }
} 