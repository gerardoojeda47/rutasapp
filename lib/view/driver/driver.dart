import 'package:flutter/material.dart';

class Driver extends StatefulWidget {
  const Driver({super.key});

  @override
  State<Driver> createState() => _DriverState();
}

class _DriverState extends State<Driver> {
  // Controladores para los campos del formulario
  final TextEditingController _busNumberController = TextEditingController();
  final TextEditingController _indicatorController = TextEditingController();
  String? _selectedShift;

  final List<String> _shifts = [
    'Turno Mañana',
    'Turno Tarde',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: const Text(
          'Registro de Conductor',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFFFF6A00),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con icono
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6A00).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.person_pin_circle,
                  size: 60,
                  color: Color(0xFFFF6A00),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Título de la sección
            const Text(
              'Información del Bus',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF6A00),
              ),
            ),
            const SizedBox(height: 20),

            // Campo Número de Bus
            _buildTextField(
              controller: _busNumberController,
              label: 'Número de Bus',
              icon: Icons.directions_bus,
              keyboardType: TextInputType.number,
              hint: 'Ej: TP001',
            ),
            const SizedBox(height: 20),

            // Campo Indicador
            _buildTextField(
              controller: _indicatorController,
              label: 'Indicador',
              icon: Icons.badge,
              hint: 'Ej: Conductor Principal',
            ),
            const SizedBox(height: 30),

            // Título de la sección de turno
            const Text(
              'Turno de Servicio',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF6A00),
              ),
            ),
            const SizedBox(height: 20),

            // Campo de turno (Dropdown)
            _buildShiftDropdown(),
            const SizedBox(height: 40),

            // Botón de registro
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _validateAndSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6A00),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  shadowColor: const Color(0xFFFF6A00).withOpacity(0.3),
                ),
                child: const Text(
                  'Registrar Conductor',
                  style: TextStyle(
                    fontSize: 18,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? hint,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: const Color(0xFFFF6A00)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          labelStyle: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
          floatingLabelStyle: const TextStyle(
            color: Color(0xFFFF6A00),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildShiftDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedShift,
        decoration: InputDecoration(
          labelText: 'Turno',
          prefixIcon: const Icon(Icons.schedule, color: Color(0xFFFF6A00)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          labelStyle: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
          floatingLabelStyle: const TextStyle(
            color: Color(0xFFFF6A00),
            fontWeight: FontWeight.bold,
          ),
        ),
        items: _shifts
            .map((shift) => DropdownMenuItem(
                  value: shift,
                  child: Text(shift),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedShift = value;
          });
        },
      ),
    );
  }

  void _validateAndSubmit() {
    if (_busNumberController.text.isEmpty ||
        _indicatorController.text.isEmpty ||
        _selectedShift == null) {
      _showErrorDialog('Por favor, complete todos los campos');
      return;
    }

    _showSuccessDialog();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red[400],
              size: 28,
            ),
            const SizedBox(width: 8),
            const Text(
              'Error',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Entendido',
              style: TextStyle(
                color: Color(0xFFFF6A00),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    final busNumber = _busNumberController.text;
    final indicator = _indicatorController.text;
    final shift = _selectedShift ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green[400],
              size: 28,
            ),
            const SizedBox(width: 8),
            const Text(
              'Registro Exitoso',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Bus:', busNumber),
            const SizedBox(height: 8),
            _buildInfoRow('Indicador:', indicator),
            const SizedBox(height: 8),
            _buildInfoRow('Turno:', shift),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _clearForm();
            },
            child: const Text(
              'Nuevo Registro',
              style: TextStyle(
                color: Color(0xFFFF6A00),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  void _clearForm() {
    setState(() {
      _busNumberController.clear();
      _indicatorController.clear();
      _selectedShift = null;
    });
  }
}
