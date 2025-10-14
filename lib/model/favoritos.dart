import 'package:flutter/material.dart';

/// Singleton para manejar la lista de favoritos
class Favoritos {
  Favoritos._interno();

  static final Favoritos _instancia = Favoritos._interno();
  factory Favoritos() => _instancia;

  final List<Map<String, dynamic>> _favoritos = [];

  List<Map<String, dynamic>> get favoritos => _favoritos;

  void agregar(Map<String, dynamic> ruta) {
    final nombre = ruta['nombre'] as String?;
    if (nombre != null &&
        !_favoritos.any((r) => (r['nombre'] as String?) == nombre)) {
      _favoritos.add(ruta);
    }
  }

  void quitar(Map<String, dynamic> ruta) {
    final nombre = ruta['nombre'] as String?;
    if (nombre != null) {
      _favoritos.removeWhere((r) => (r['nombre'] as String?) == nombre);
    }
  }

  bool esFavorito(String nombreRuta) {
    return _favoritos.any((r) => (r['nombre'] as String?) == nombreRuta);
  }
}

/// Página para mostrar y quitar favoritos
class FavoritosPagina extends StatefulWidget {
  const FavoritosPagina({super.key, this.onRemoveFavorito});

  final void Function(String nombreRuta)? onRemoveFavorito;

  @override
  State<FavoritosPagina> createState() => _FavoritosPaginaState();
}

class _FavoritosPaginaState extends State<FavoritosPagina> {
  @override
  Widget build(BuildContext context) {
    final favoritos = Favoritos().favoritos;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos'),
        backgroundColor: const Color(0xFFFF6A00),
      ),
      body: favoritos.isEmpty
          ? const Center(child: Text('No hay rutas favoritas.'))
          : ListView.builder(
              itemCount: favoritos.length,
              itemBuilder: (context, index) {
                final ruta = favoritos[index];
                final nombre = ruta['nombre'] as String? ?? 'Sin nombre';
                final empresa = ruta['empresa'] as String? ?? 'Sin empresa';

                return ListTile(
                  leading: const Icon(Icons.star, color: Colors.amber),
                  title: Text(nombre),
                  subtitle: Text(empresa),
                  trailing: IconButton(
                    icon: const Icon(Icons.star_border, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        Favoritos().quitar(ruta);
                        widget.onRemoveFavorito?.call(nombre);
                      });
                    },
                  ),
                );
              },
            ),
    );
  }
}

