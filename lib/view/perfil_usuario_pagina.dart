import 'package:flutter/material.dart';

class PerfilUsuarioPagina extends StatefulWidget {
  final String username;
  final VoidCallback onLogout;
  const PerfilUsuarioPagina(
      {super.key, required this.username, required this.onLogout});

  @override
  State<PerfilUsuarioPagina> createState() => _PerfilUsuarioPaginaState();
}

class _PerfilUsuarioPaginaState extends State<PerfilUsuarioPagina> {
  final Map<String, dynamic> userProfile = {
    'name': '',
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
  void initState() {
    super.initState();
    userProfile['name'] = widget.username;
  }

  void _editProfile() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final nameController = TextEditingController(text: userProfile['name']);
        final emailController =
            TextEditingController(text: userProfile['email']);
        final phoneController =
            TextEditingController(text: userProfile['phone']);

        return AlertDialog(
          title: const Text('Editar Perfil'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre completo',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Correo electrónico',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Teléfono',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  userProfile['name'] = nameController.text;
                  userProfile['email'] = emailController.text;
                  userProfile['phone'] = phoneController.text;
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Perfil actualizado correctamente'),
                    backgroundColor: Color(0xFFFF6A00),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6A00),
                foregroundColor: Colors.white,
              ),
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _addBalance() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final amountController = TextEditingController();

        return AlertDialog(
          title: const Text('Recargar Tarjeta'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Monto a recargar',
                  prefixText: '\$',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Saldo actual: \$${userProfile['transportCard']['balance']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = int.tryParse(amountController.text);
                if (amount != null && amount > 0) {
                  setState(() {
                    final currentBalance = int.parse(
                        userProfile['transportCard']['balance']
                            .replaceAll('.', ''));
                    userProfile['transportCard']['balance'] =
                        (currentBalance + amount).toString();
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Recarga exitosa: \$${amount.toString()}'),
                      backgroundColor: const Color(0xFFFF6A00),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6A00),
                foregroundColor: Colors.white,
              ),
              child: const Text('Recargar'),
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
          'Mi Perfil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFF6A00),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editProfile,
          ),
        ],
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
                      color: Colors.white.withValues(alpha: 0.9),
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
                    color: Colors.grey.withValues(alpha: 0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tarjeta de Transporte',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: _addBalance,
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
                            '\$${userProfile['transportCard']['balance']}',
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
                    _showNotificationSettings();
                  },
                ),
                _buildSettingTile(
                  Icons.language,
                  'Idioma',
                  userProfile['preferences']['language'],
                  onTap: () {
                    _showLanguageSelector();
                  },
                ),
                _buildSettingTile(
                  Icons.palette,
                  'Tema',
                  userProfile['preferences']['theme'],
                  onTap: () {
                    _showThemeSelector();
                  },
                ),
              ],
            ),

            // Logout Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton.icon(
                onPressed: () {
                  _showLogoutDialog();
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
          color: const Color(0xFFFF6A00).withValues(alpha: 0.1),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ver detalles de ruta: ${route['name']}'),
            backgroundColor: const Color(0xFFFF6A00),
          ),
        );
      },
    );
  }

  Widget _buildTripTile(Map<String, dynamic> trip) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.1),
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
            '\$${trip['price']}',
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

  void _showLanguageSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar Idioma'),
        content: StatefulBuilder(
          builder: (context, setDialogState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('Español'),
                  leading: Icon(
                    userProfile['preferences']['language'] == 'Español'
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: const Color(0xFFFF6A00),
                  ),
                  onTap: () {
                    setState(() {
                      userProfile['preferences']['language'] = 'Español';
                    });
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text('English'),
                  leading: Icon(
                    userProfile['preferences']['language'] == 'English'
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: const Color(0xFFFF6A00),
                  ),
                  onTap: () {
                    setState(() {
                      userProfile['preferences']['language'] = 'English';
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showThemeSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar Tema'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Claro'),
              leading: Icon(
                userProfile['preferences']['theme'] == 'Claro'
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: const Color(0xFFFF6A00),
              ),
              onTap: () {
                setState(() {
                  userProfile['preferences']['theme'] = 'Claro';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Oscuro'),
              leading: Icon(
                userProfile['preferences']['theme'] == 'Oscuro'
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: const Color(0xFFFF6A00),
              ),
              onTap: () {
                setState(() {
                  userProfile['preferences']['theme'] = 'Oscuro';
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onLogout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }
}
