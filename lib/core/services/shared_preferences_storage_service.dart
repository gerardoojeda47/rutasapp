import 'package:shared_preferences/shared_preferences.dart';
import 'package:rouwhite/core/services/storage_service.dart';
import 'package:rouwhite/core/exceptions/app_exceptions.dart';

/// Implementation of StorageService using SharedPreferences
class SharedPreferencesStorageService extends BaseStorageService {
  SharedPreferences? _prefs;

  /// Initialize SharedPreferences
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Ensures SharedPreferences is initialized
  Future<SharedPreferences> get _preferences async {
    await init();
    return _prefs!;
  }

  @override
  Future<void> saveString(String key, String value) async {
    try {
      final prefs = await _preferences;
      await prefs.setString(key, value);
    } catch (e) {
      throw StorageException(
        'Error al guardar string para la clave "$key"',
        originalError: e,
      );
    }
  }

  @override
  Future<String?> getString(String key) async {
    try {
      final prefs = await _preferences;
      return prefs.getString(key);
    } catch (e) {
      throw StorageException(
        'Error al recuperar string para la clave "$key"',
        originalError: e,
      );
    }
  }

  @override
  Future<void> saveBool(String key, bool value) async {
    try {
      final prefs = await _preferences;
      await prefs.setBool(key, value);
    } catch (e) {
      throw StorageException(
        'Error al guardar bool para la clave "$key"',
        originalError: e,
      );
    }
  }

  @override
  Future<bool?> getBool(String key) async {
    try {
      final prefs = await _preferences;
      return prefs.getBool(key);
    } catch (e) {
      throw StorageException(
        'Error al recuperar bool para la clave "$key"',
        originalError: e,
      );
    }
  }

  @override
  Future<void> saveInt(String key, int value) async {
    try {
      final prefs = await _preferences;
      await prefs.setInt(key, value);
    } catch (e) {
      throw StorageException(
        'Error al guardar int para la clave "$key"',
        originalError: e,
      );
    }
  }

  @override
  Future<int?> getInt(String key) async {
    try {
      final prefs = await _preferences;
      return prefs.getInt(key);
    } catch (e) {
      throw StorageException(
        'Error al recuperar int para la clave "$key"',
        originalError: e,
      );
    }
  }

  @override
  Future<void> saveDouble(String key, double value) async {
    try {
      final prefs = await _preferences;
      await prefs.setDouble(key, value);
    } catch (e) {
      throw StorageException(
        'Error al guardar double para la clave "$key"',
        originalError: e,
      );
    }
  }

  @override
  Future<double?> getDouble(String key) async {
    try {
      final prefs = await _preferences;
      return prefs.getDouble(key);
    } catch (e) {
      throw StorageException(
        'Error al recuperar double para la clave "$key"',
        originalError: e,
      );
    }
  }

  @override
  Future<void> remove(String key) async {
    try {
      final prefs = await _preferences;
      await prefs.remove(key);
    } catch (e) {
      throw StorageException(
        'Error al eliminar clave "$key"',
        originalError: e,
      );
    }
  }

  @override
  Future<bool> containsKey(String key) async {
    try {
      final prefs = await _preferences;
      return prefs.containsKey(key);
    } catch (e) {
      throw StorageException(
        'Error al verificar clave "$key"',
        originalError: e,
      );
    }
  }

  @override
  Future<void> clear() async {
    try {
      final prefs = await _preferences;
      await prefs.clear();
    } catch (e) {
      throw StorageException(
        'Error al limpiar almacenamiento',
        originalError: e,
      );
    }
  }

  @override
  Future<Set<String>> getKeys() async {
    try {
      final prefs = await _preferences;
      return prefs.getKeys();
    } catch (e) {
      throw StorageException(
        'Error al obtener claves',
        originalError: e,
      );
    }
  }
}
