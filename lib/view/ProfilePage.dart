import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Map<String, dynamic> userProfile = {
    'name': 'Juan Pérez',
    'email': 'juan.perez@email.com',
    'phone': '+57 300 123 4567',
    'membershipDate': '15/03/2023',
    'tripsCount': 45,
    'favoriteRoutes': [
      {
        'name': 'Avelino Ull',
        'frequency': 'Diaria',
        'lastUsed': 'Hace 2 días',
      },
      {
        'name': 'Las Ferias',
        'frequency': 'Semanal',
        'lastUsed': 'Hace 5 días',
      },
      {
        'name': 'Alameda',
        'frequency': 'Ocasional',
        'lastUsed': 'Hace 1 semana',
      },
    ],
    'recentTrips': [
      {
        'route': 'Avelino Ull',
        'date': '15/03/2024',
        'time': '08:30 AM',
        'duration': '25 min',
        'price': '\$2.000',
      },
      {
        'route': 'Las Ferias',
        'date': '14/03/2024',
        'time': '05:15 PM',
        'duration': '35 min',
        'price': '\$2.000',
      },
    ],
    'transportCard': {
      'number': '1234 5678 9012 3456',
      'balance': '\$25.000',
      'expiryDate': '12/25',
    },
    'notifications': {
      'routeAlerts': true,
      'priceUpdates': true,
      'serviceAlerts': true,
      'promotions': false,
    },
    'preferences': {
      'language': 'Español',
      'theme': 'Claro',
      'distanceUnit': 'Kilómetros',
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mi Perfil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFF6A00),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFFF6A00),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Color(0xFFFF6A00),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    userProfile['name'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    userProfile['email'],
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            // Transport Card
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6A00), Color(0xFFFF8C00)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tarjeta de Transporte',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        Icons.credit_card,
                        color: Colors.white,
                        size: 30,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    userProfile['transportCard']['number'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Saldo',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            userProfile['transportCard']['balance'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'Vence',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            userProfile['transportCard']['expiryDate'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Personal Information
            _buildSection(
              'Información Personal',
              [
                _buildInfoTile(
                  Icons.phone,
                  'Teléfono',
                  userProfile['phone'],
                ),
                _buildInfoTile(
                  Icons.calendar_today,
                  'Miembro desde',
                  userProfile['membershipDate'],
                ),
                _buildInfoTile(
                  Icons.directions_bus,
                  'Viajes realizados',
                  '${userProfile['tripsCount']} viajes',
                ),
              ],
            ),

            // Favorite Routes
            _buildSection(
              'Rutas Favoritas',
              userProfile['favoriteRoutes'].map<Widget>((route) {
                return _buildRouteTile(route);
              }).toList(),
            ),

            // Recent Trips
            _buildSection(
              'Viajes Recientes',
              userProfile['recentTrips'].map<Widget>((trip) {
                return _buildTripTile(trip);
              }).toList(),
            ),

            // Settings
            _buildSection(
              'Configuración',
              [
                _buildSettingTile(
                  Icons.notifications,
                  'Notificaciones',
                  'Configurar alertas y notificaciones',
                  onTap: () {
                    // Mostrar diálogo de configuración de notificaciones
                    _showNotificationSettings();
                  },
                ),
                _buildSettingTile(
                  Icons.language,
                  'Idioma',
                  userProfile['preferences']['language'],
                  onTap: () {
                    // Mostrar selector de idioma
                  },
                ),
                _buildSettingTile(
                  Icons.palette,
                  'Tema',
                  userProfile['preferences']['theme'],
                  onTap: () {
                    // Mostrar selector de tema
                  },
                ),
              ],
            ),

            // Logout Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Implementar cierre de sesión
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                icon: const Icon(Icons.logout),
                label: const Text(
                  'Cerrar Sesión',
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
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFFF6A00)),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        value,
        style: TextStyle(
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildRouteTile(Map<String, dynamic> route) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFFF6A00).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.directions_bus,
          color: Color(0xFFFF6A00),
        ),
      ),
      title: Text(
        route['name'],
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        'Frecuencia: ${route['frequency']} • Último uso: ${route['lastUsed']}',
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // Navegar a detalles de la ruta
      },
    );
  }

  Widget _buildTripTile(Map<String, dynamic> trip) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.history,
          color: Colors.green,
        ),
      ),
      title: Text(
        trip['route'],
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        '${trip['date']} • ${trip['time']}',
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            trip['duration'],
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            trip['price'],
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(
    IconData icon,
    String title,
    String subtitle, {
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFFF6A00)),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey[600],
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showNotificationSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Configuración de Notificaciones'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Alertas de Rutas'),
              value: userProfile['notifications']['routeAlerts'],
              onChanged: (value) {
                setState(() {
                  userProfile['notifications']['routeAlerts'] = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Actualizaciones de Precios'),
              value: userProfile['notifications']['priceUpdates'],
              onChanged: (value) {
                setState(() {
                  userProfile['notifications']['priceUpdates'] = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Alertas de Servicio'),
              value: userProfile['notifications']['serviceAlerts'],
              onChanged: (value) {
                setState(() {
                  userProfile['notifications']['serviceAlerts'] = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Promociones'),
              value: userProfile['notifications']['promotions'],
              onChanged: (value) {
                setState(() {
                  userProfile['notifications']['promotions'] = value;
                });
              },
            ),
          ],
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
} 