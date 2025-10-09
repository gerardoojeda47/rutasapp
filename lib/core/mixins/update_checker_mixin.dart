import 'package:flutter/material.dart';
import '../services/update_service.dart';
import '../../view/widgets/update_dialog.dart';

mixin UpdateCheckerMixin<T extends StatefulWidget> on State<T> {
  final UpdateService _updateService = UpdateService();
  bool _isCheckingUpdates = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForUpdatesIfEnabled();
    });
  }

  /// Verifica actualizaciones si está habilitado
  Future<void> _checkForUpdatesIfEnabled() async {
    if (_isCheckingUpdates) return;

    final isAutoUpdateEnabled = await _updateService.isAutoUpdateEnabled();
    if (isAutoUpdateEnabled && mounted) {
      await checkForUpdates();
    }
  }

  /// Verifica actualizaciones manualmente
  Future<void> checkForUpdates({bool showNoUpdateMessage = false}) async {
    if (_isCheckingUpdates) return;

    _isCheckingUpdates = true;

    try {
      final updateInfo = await _updateService.checkForUpdates();

      if (mounted) {
        if (updateInfo != null) {
          await showUpdateDialog(context, updateInfo);
          await _updateService.saveLastVersionCheck(updateInfo.latestVersion);
        } else if (showNoUpdateMessage) {
          _showNoUpdateMessage();
        }
      }
    } catch (e) {
      if (mounted && showNoUpdateMessage) {
        _showErrorMessage('Error al verificar actualizaciones: $e');
      }
    } finally {
      _isCheckingUpdates = false;
    }
  }

  /// Muestra mensaje cuando no hay actualizaciones
  void _showNoUpdateMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ya tienes la versión más reciente'),
        backgroundColor: Colors.green,
      ),
    );
  }

  /// Muestra mensaje de error
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  /// Abre configuración de actualizaciones
  Future<void> openUpdateSettings() async {
    final currentSetting = await _updateService.isAutoUpdateEnabled();

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Configuración de Actualizaciones'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  title: const Text('Verificar automáticamente'),
                  subtitle:
                      const Text('Buscar actualizaciones al abrir la app'),
                  value: currentSetting,
                  onChanged: (value) async {
                    await _updateService.setAutoUpdateEnabled(value);
                    setState(() {});
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      checkForUpdates(showNoUpdateMessage: true);
                    },
                    child: const Text('Verificar ahora'),
                  ),
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
