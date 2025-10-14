import 'package:flutter/material.dart';

class Driver extends StatefulWidget {
  const Driver({super.key});

  @override
  State<Driver> createState() => _DriverState();
}

class _DriverState extends State<Driver> {
  bool _enRuta = true;
  double _progresoRuta = 0.45; // 45%

  @override
  Widget build(BuildContext context) {
    const brand = Color(0xFFFF6A00);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        titleSpacing: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Panel Conductor',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFF6A00), Color(0xFFFF8C3A)],
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12, top: 12, bottom: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _enRuta ? Colors.green : Colors.grey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _enRuta ? 'EN RUTA' : 'PAUSADO',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          _DriverCard(brand: brand),
          const SizedBox(height: 16),
          _SectionTitle(icon: Icons.bolt, title: 'Acciones Rápidas'),
          const SizedBox(height: 10),
          _QuickActions(
            onIniciar: () => setState(() => _enRuta = true),
            onPausar: () => setState(() => _enRuta = false),
            onReportar: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Reporte enviado (demo).')),
              );
            },
            onDespacho: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Llamando a despacho (demo).')),
              );
            },
          ),
          const SizedBox(height: 22),
          _SectionTitle(icon: Icons.directions_bus, title: 'Ruta Actual'),
          const SizedBox(height: 10),
          _RutaActualCard(
            brand: brand,
            progreso: _progresoRuta,
            paradasRestantes: 12,
            minutosEstimados: 45,
            kmRestantes: 3.2,
            titulo: 'La Paz ↔ Campanario ↔ Pomona ↔ Chirimía',
            proximaParada: 'La Esmeralda (2 min)'
          ),
          const SizedBox(height: 22),
          _SectionTitle(icon: Icons.group, title: 'Pasajeros'),
          const SizedBox(height: 10),
          const _PasajerosCard(
            ocupados: 18,
            capacidad: 40,
            abordo: 18,
            disponibles: 22,
            ocupacion: 45,
          ),
        ],
      ),
    );
  }
}

class _DriverCard extends StatelessWidget {
  const _DriverCard({required this.brand});
  final Color brand;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: brand.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'JM',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFFFF6A00)),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Juan Manuel Rodríguez',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 4),
                Text(
                  'Conductor Ruta 1 • Licencia: A-12345',
                  style: TextStyle(color: Colors.black54),
                ),
                SizedBox(height: 8),
                _RatingRow(rating: 4.8, viajes: 2450),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingRow extends StatelessWidget {
  const _RatingRow({required this.rating, required this.viajes});
  final double rating;
  final int viajes;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: List.generate(
            5,
            (i) => Icon(
              i < rating.floor()
                  ? Icons.star
                  : (i == rating.floor() && rating - rating.floor() >= 0.5)
                      ? Icons.star_half
                      : Icons.star_border,
              color: const Color(0xFFFFB300),
              size: 18,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$rating • ${_formatNum(viajes)} viajes',
          style: TextStyle(color: Colors.grey[700], fontSize: 12),
        ),
      ],
    );
  }

  static String _formatNum(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return '$n';
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 2),
        Icon(icon, color: const Color(0xFFFF6A00)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({
    required this.onIniciar,
    required this.onPausar,
    required this.onReportar,
    required this.onDespacho,
  });
  final VoidCallback onIniciar;
  final VoidCallback onPausar;
  final VoidCallback onReportar;
  final VoidCallback onDespacho;

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.7,
      ),
      children: [
        _ActionCard(
          color: const Color(0xFF32C671),
          icon: Icons.play_circle_fill,
          label: 'Iniciar Ruta',
          onTap: onIniciar,
        ),
        _ActionCard(
          color: const Color(0xFFFFB300),
          icon: Icons.pause_circle_filled,
          label: 'Pausar',
          onTap: onPausar,
        ),
        _ActionCard(
          color: const Color(0xFF2962FF),
          icon: Icons.report,
          label: 'Reportar',
          onTap: onReportar,
        ),
        _ActionCard(
          color: const Color(0xFFE53935),
          icon: Icons.phone_in_talk,
          label: 'Despacho',
          onTap: onDespacho,
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.color,
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final Color color;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RutaActualCard extends StatelessWidget {
  const _RutaActualCard({
    required this.brand,
    required this.progreso,
    required this.paradasRestantes,
    required this.minutosEstimados,
    required this.kmRestantes,
    required this.titulo,
    required this.proximaParada,
  });

  final Color brand;
  final double progreso;
  final int paradasRestantes;
  final int minutosEstimados;
  final double kmRestantes;
  final String titulo;
  final String proximaParada;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: brand,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    '1',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Próxima parada: $proximaParada',
                      style: TextStyle(color: Colors.grey[700], fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progreso,
              minHeight: 8,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation(Color(0xFF35C56C)),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _StatItem(label: 'Paradas restantes', value: '$paradasRestantes')),
              Container(width: 1, height: 28, color: Colors.grey[200]),
              Expanded(child: _StatItem(label: 'Min estimados', value: '$minutosEstimados')),
              Container(width: 1, height: 28, color: Colors.grey[200]),
              Expanded(child: _StatItem(label: 'Km restantes', value: '$kmRestantes')),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }
}

class _PasajerosCard extends StatelessWidget {
  const _PasajerosCard({
    required this.ocupados,
    required this.capacidad,
    required this.abordo,
    required this.disponibles,
    required this.ocupacion,
  });

  final int ocupados;
  final int capacidad;
  final int abordo;
  final int disponibles;
  final int ocupacion; // porcentaje

  @override
  Widget build(BuildContext context) {
    final chipColor = Colors.blue.shade700;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Estado del Bus',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: chipColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$ocupados/$capacidad ocupado',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Ilustración simple del bus
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFFF6A00).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFF6A00).withValues(alpha: 0.25)),
            ),
            child: Center(
              child: Icon(Icons.directions_bus, color: const Color(0xFFFF6A00).withValues(alpha: 0.9), size: 40),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _StatItem(label: 'A bordo', value: '$abordo')),
              Container(width: 1, height: 28, color: Colors.grey[200]),
              Expanded(child: _StatItem(label: 'Disponibles', value: '$disponibles')),
              Container(width: 1, height: 28, color: Colors.grey[200]),
              Expanded(child: _StatItem(label: 'Ocupación', value: '$ocupacion%')),
            ],
          ),
        ],
      ),
    );
  }
}

