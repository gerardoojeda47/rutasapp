import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class UpdateService {
  static const String _lastVersionKey = 'last_version_check';
  static const String _autoUpdateKey = 'auto_update_enabled';
  static const String _distributionUrl =
      'https://YOUR_USERNAME.github.io/rouwhite/api/version.json';

  final Dio _dio = Dio();
  final Logger _logger = Logger();

  /// Verifica si hay una nueva versión disponible
  Future<UpdateCheckResponse?> checkForUpdates() async {
    try {
      final response = await _dio.get(_distributionUrl);
      final data = response.data;

      final latestVersion = data['version'] as String;
      final downloadUrl = data['downloadUrl'] as String;
      final releaseNotes = data['releaseNotes'] as String? ?? '';
      final forceUpdate = data['forceUpdate'] as bool? ?? false;

      // Obtener versión actual de la app
      const currentVersion = '1.0.0'; // TODO: Obtener de pubspec.yaml

      final hasUpdate = _isNewerVersion(currentVersion, latestVersion);

      return UpdateCheckResponse(
        hasUpdate: hasUpdate,
        latestVersion: latestVersion,
        downloadUrl: downloadUrl,
        releaseNotes: releaseNotes,
        forceUpdate: forceUpdate,
      );
    } catch (e) {
      _logger.e('Error checking for updates: $e');
      return null;
    }
  }

  /// Muestra dialog de actualización si hay una nueva versión
  Future<void> showUpdateDialogIfNeeded(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final autoUpdateEnabled = prefs.getBool(_autoUpdateKey) ?? true;

    if (!autoUpdateEnabled) return;

    final updateInfo = await checkForUpdates();
    if (updateInfo == null || !updateInfo.hasUpdate) return;

    if (context.mounted) {
      _showUpdateDialog(context, updateInfo);
    }
  }

  /// Muestra el dialog de actualización
  void _showUpdateDialog(BuildContext context, UpdateCheckResponse updateInfo) {
    showDialog(
      context: context,
      barrierDismissible: !updateInfo.forceUpdate,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nueva versión disponible'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Versión ${updateInfo.latestVersion} está disponible.'),
              if (updateInfo.releaseNotes.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text('Novedades:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(updateInfo.releaseNotes),
              ],
            ],
          ),
          actions: [
            if (!updateInfo.forceUpdate)
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Más tarde'),
              ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _openDownloadUrl(updateInfo.downloadUrl);
              },
              child: const Text('Actualizar'),
            ),
          ],
        );
      },
    );
  }

  /// Abre la URL de descarga
  void _openDownloadUrl(String url) {
    // TODO: Implementar apertura de URL
    // Usar url_launcher package
  }

  /// Compara versiones para determinar si hay una más nueva
  bool _isNewerVersion(String current, String latest) {
    final currentParts = current.split('.').map(int.parse).toList();
    final latestParts = latest.split('.').map(int.parse).toList();

    for (int i = 0; i < 3; i++) {
      final currentPart = i < currentParts.length ? currentParts[i] : 0;
      final latestPart = i < latestParts.length ? latestParts[i] : 0;

      if (latestPart > currentPart) return true;
      if (latestPart < currentPart) return false;
    }

    return false;
  }

  /// Habilita o deshabilita las actualizaciones automáticas
  Future<void> setAutoUpdateEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_autoUpdateKey, enabled);
  }

  /// Verifica si las actualizaciones automáticas están habilitadas
  Future<bool> isAutoUpdateEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_autoUpdateKey) ?? true;
  }
}

class UpdateCheckResponse {
  final bool hasUpdate;
  final String latestVersion;
  final String downloadUrl;
  final String releaseNotes;
  final bool forceUpdate;

  UpdateCheckResponse({
    required this.hasUpdate,
    required this.latestVersion,
    required this.downloadUrl,
    required this.releaseNotes,
    required this.forceUpdate,
  });
}
