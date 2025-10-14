import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/services/update_service.dart';
import '../../core/constants/app_colors.dart';

class UpdateDialog extends StatelessWidget {
  final UpdateInfo updateInfo;
  final VoidCallback? onDismiss;

  const UpdateDialog({
    super.key,
    required this.updateInfo,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Icon(
            Icons.system_update,
            color: AppColors.primary,
            size: 28,
          ),
          const SizedBox(width: 12),
          const Text(
            'Actualización Disponible',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nueva versión ${updateInfo.latestVersion} disponible',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Versión actual: ${updateInfo.currentVersion}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          if (updateInfo.releaseNotes.isNotEmpty) ...[
            const Text(
              'Novedades:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                updateInfo.releaseNotes,
                style: const TextStyle(fontSize: 13),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            'Publicado: ${_formatDate(updateInfo.publishedAt)}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onDismiss?.call();
          },
          child: const Text('Más tarde'),
        ),
        ElevatedButton(
          onPressed: () => _downloadUpdate(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          child: const Text('Descargar'),
        ),
      ],
    );
  }

  Future<void> _downloadUpdate(BuildContext context) async {
    try {
      final uri = Uri.parse(updateInfo.downloadUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (context.mounted) {
          Navigator.of(context).pop();
          onDismiss?.call();
        }
      } else {
        if (context.mounted) {
          _showErrorDialog(context, 'No se pudo abrir el enlace de descarga');
        }
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorDialog(context, 'Error al abrir la descarga: $e');
      }
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

/// Función helper para mostrar el diálogo de actualización
Future<void> showUpdateDialog(BuildContext context, UpdateInfo updateInfo) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => UpdateDialog(updateInfo: updateInfo),
  );
}

