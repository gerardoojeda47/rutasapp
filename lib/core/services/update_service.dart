import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class UpdateService {
  static const String _updateCheckUrl =
      'https://api.github.com/repos/YOUR_USERNAME/rouwhite/releases/latest';
  static const String _lastVersionKey = 'last_version_check';
  static const String _autoUpdateKey = 'auto_update_enabled';

  final Dio _dio = Dio();
  final Logger _logger = Logger();

  /// Verifica si hay una nueva versión disponible
  Future<UpdateInfo?> checkForUpdates() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      final response = await _dio.get(_updateCheckUrl);

      if (response.statusCode == 200) {
        final releaseData = response.data;
        final latestVersion =
            releaseData['tag_name']?.replaceAll('v', '') ?? '';

        if (_isNewerVersion(currentVersion, latestVersion)) {
          return UpdateInfo(
            currentVersion: currentVersion,
            latestVersion: latestVersion,
            downloadUrl: _getApkDownloadUrl(releaseData),
            releaseNotes: releaseData['body'] ?? '',
            publishedAt: DateTime.parse(releaseData['published_at']),
          );
        }
      }

      return null;
    } catch (e) {
      _logger.e('Error checking for updates: $e');
      return null;
    }
  }

  /// Obtiene la URL de descarga del APK desde los assets del release
  String _getApkDownloadUrl(Map<String, dynamic> releaseData) {
    final assets = releaseData['assets'] as List<dynamic>? ?? [];

    for (final asset in assets) {
      final name = asset['name'] as String? ?? '';
      if (name.endsWith('.apk')) {
        return asset['browser_download_url'] as String? ?? '';
      }
    }

    // Fallback: usar la URL de Firebase App Distribution si está configurada
    return 'https://appdistribution.firebase.dev/i/YOUR_APP_ID';
  }

  /// Compara versiones para determinar si hay una más nueva
  bool _isNewerVersion(String current, String latest) {
    final currentParts = current
        .split('.')
        .map(int.tryParse)
        .where((v) => v != null)
        .cast<int>()
        .toList();
    final latestParts = latest
        .split('.')
        .map(int.tryParse)
        .where((v) => v != null)
        .cast<int>()
        .toList();

    final maxLength = [currentParts.length, latestParts.length]
        .reduce((a, b) => a > b ? a : b);

    // Rellenar con ceros si es necesario
    while (currentParts.length < maxLength) currentParts.add(0);
    while (latestParts.length < maxLength) latestParts.add(0);

    for (int i = 0; i < maxLength; i++) {
      if (latestParts[i] > currentParts[i]) return true;
      if (latestParts[i] < currentParts[i]) return false;
    }

    return false;
  }

  /// Guarda la configuración de auto-actualización
  Future<void> setAutoUpdateEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_autoUpdateKey, enabled);
  }

  /// Obtiene la configuración de auto-actualización
  Future<bool> isAutoUpdateEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_autoUpdateKey) ?? true; // Por defecto habilitado
  }

  /// Guarda la última versión verificada
  Future<void> saveLastVersionCheck(String version) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastVersionKey, version);
  }

  /// Obtiene la última versión verificada
  Future<String?> getLastVersionCheck() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastVersionKey);
  }
}

class UpdateInfo {
  final String currentVersion;
  final String latestVersion;
  final String downloadUrl;
  final String releaseNotes;
  final DateTime publishedAt;

  UpdateInfo({
    required this.currentVersion,
    required this.latestVersion,
    required this.downloadUrl,
    required this.releaseNotes,
    required this.publishedAt,
  });

  @override
  String toString() {
    return 'UpdateInfo(current: $currentVersion, latest: $latestVersion, url: $downloadUrl)';
  }
}

