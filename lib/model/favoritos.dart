import 'package:flutter/material.dart';

/// Singleton para manejar la lista de favoritos
class Favoritos {
  static final Favoritos _instancia = Favoritos._interno();
  factory Favoritos() => _instancia;
  Favoritos._interno();

  final List<Map<String, dynamic>> _favoritos = [];

  List<Map<String, dynamic>> get favoritos => _favoritos;

  void agregar(Map<String, dynamic> ruta) {
    if (!_favoritos.any((r) => r['nombre'] == ruta['nombre'])) {
      _favoritos.add(ruta);
    }
  }

  void quitar(Map<String, dynamic> ruta) {
    _favoritos.removeWhere((r) => r['nombre'] == ruta['nombre']);
  }

  bool esFavorito(String nombreRuta) {
    return _favoritos.any((r) => r['nombre'] == nombreRuta);
  }
}

/// Página para mostrar y quitar favoritos
class FavoritosPagina extends StatefulWidget {
  final void Function(String nombreRuta)? onRemoveFavorito;
  const FavoritosPagina({super.key, this.onRemoveFavorito});

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
                return ListTile(
                  leading: const Icon(Icons.star, color: Colors.amber),
                  title: Text(ruta['nombre']),
                  subtitle: Text(ruta['empresa']),
                  trailing: IconButton(
                    icon: const Icon(Icons.star_border, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        Favoritos().quitar(ruta);
                        widget.onRemoveFavorito?.call(ruta['nombre']);
                      });
                    },
                  ),
                );
              },
            ),
    );
  }
}
