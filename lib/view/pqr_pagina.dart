import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class PqrPagina extends StatefulWidget {
  const PqrPagina({super.key});

  @override
  State<PqrPagina> createState() => _PqrPaginaState();
}

class _PqrPaginaState extends State<PqrPagina> {
  final TextEditingController _mensajeCtrl = TextEditingController();
  final List<PlatformFile> _adjuntos = [];
  bool _enviando = false;

  Future<void> _seleccionarArchivos() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        withReadStream: false,
      );
      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _adjuntos.addAll(result.files);
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error seleccionando archivos: $e')),
      );
    }
  }

  void _removerAdjunto(int index) {
    setState(() {
      _adjuntos.removeAt(index);
    });
  }

  Future<void> _enviar() async {
    FocusScope.of(context).unfocus();
    final texto = _mensajeCtrl.text.trim();
    if (texto.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escribe tu mensaje antes de enviar.')),
      );
      return;
    }

    setState(() => _enviando = true);

    // Aquí iría tu integración real (API, correo, etc.).
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() => _enviando = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('PQR enviada. ¡Gracias por tu mensaje!')),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _mensajeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peticiones, Quejas y Reclamos'),
        backgroundColor: const Color(0xFFFF6A00),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cuéntanos tu solicitud o comentario',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: _mensajeCtrl,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  hintText: 'Escribe aquí tu PQR... (sin encuesta, solo texto)',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFFF6A00), width: 2),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
                textInputAction: TextInputAction.newline,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _seleccionarArchivos,
                  icon: const Icon(Icons.attach_file, color: Colors.white),
                  label: const Text('Adjuntar archivos', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6A00),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(width: 12),
                if (_adjuntos.isNotEmpty) Text('${_adjuntos.length} adjunto(s)')
              ],
            ),
            const SizedBox(height: 8),
            if (_adjuntos.isNotEmpty)
              SizedBox(
                height: 90,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _adjuntos.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final f = _adjuntos[index];
                    return Container(
                      width: 220,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[300]!),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.insert_drive_file, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  f.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  f.size != null ? '${(f.size! / 1024).toStringAsFixed(1)} KB' : '',
                                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            tooltip: 'Quitar',
                            onPressed: () => _removerAdjunto(index),
                            icon: const Icon(Icons.close, size: 18),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _enviando ? null : () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _enviando ? null : _enviar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6A00),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: _enviando
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)),
                          )
                        : const Text('Enviar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
