import 'package:flutter/material.dart';
import '../../core/utils/icon_helper.dart';

/// Widget de prueba para verificar que los iconos se muestren correctamente
class IconTestWidget extends StatelessWidget {
  const IconTestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prueba de Iconos'),
        backgroundColor: const Color(0xFFFF6A00),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Iconos de Navegación:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: const [
                Icon(IconHelper.home, size: 32, color: Color(0xFFFF6A00)),
                Icon(IconHelper.routes, size: 32, color: Color(0xFFFF6A00)),
                Icon(IconHelper.stops, size: 32, color: Color(0xFFFF6A00)),
                Icon(IconHelper.favorites, size: 32, color: Color(0xFFFF6A00)),
                Icon(IconHelper.search, size: 32, color: Color(0xFFFF6A00)),
                Icon(IconHelper.menu, size: 32, color: Color(0xFFFF6A00)),
                Icon(IconHelper.myLocation, size: 32, color: Color(0xFFFF6A00)),
                Icon(IconHelper.driver, size: 32, color: Color(0xFFFF6A00)),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Iconos de Puntos de Interés:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: const [
                Icon(IconHelper.poiHospital, size: 32, color: Colors.red),
                Icon(IconHelper.poiSchool, size: 32, color: Colors.orange),
                Icon(IconHelper.poiUniversity, size: 32, color: Colors.deepPurple),
                Icon(IconHelper.poiPark, size: 32, color: Colors.green),
                Icon(IconHelper.poiChurch, size: 32, color: Colors.indigo),
                Icon(IconHelper.poiMall, size: 32, color: Colors.pink),
                Icon(IconHelper.poiRestaurant, size: 32, color: Colors.amber),
                Icon(IconHelper.poiGasStation, size: 32, color: Colors.blue),
                Icon(IconHelper.poiPolice, size: 32, color: Colors.blue),
                Icon(IconHelper.poiHotel, size: 32, color: Colors.brown),
                Icon(IconHelper.poiMuseum, size: 32, color: Colors.purple),
                Icon(IconHelper.poiLibrary, size: 32, color: Colors.teal),
                Icon(IconHelper.poiPharmacy, size: 32, color: Colors.green),
                Icon(IconHelper.poiSupermarket, size: 32, color: Colors.orange),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Iconos con fondo circular:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildCircularIcon(IconHelper.home, Colors.blue),
                _buildCircularIcon(IconHelper.routes, Colors.green),
                _buildCircularIcon(IconHelper.stops, Colors.red),
                _buildCircularIcon(IconHelper.favorites, Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularIcon(IconData icon, Color color) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.9),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 30,
      ),
    );
  }
}

