import 'dart:convert';
import '../exceptions/app_exceptions.dart';

/// Abstract interface for storage operations
abstract class StorageService {
  /// Saves a string value with the given key
  Future<void> saveString(String key, String value);

  /// Retrieves a string value for the given key
  Future<String?> getString(String key);

  /// Saves an object as JSON with the given key
  Future<void> saveObject<T>(String key, T object);

  /// Retrieves an object from JSON for the given key
  Future<T?> getObject<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  );

  /// Saves a list of objects as JSON with the given key
  Future<void> saveList<T>(
    String key,
    List<T> list,
    Map<String, dynamic> Function(T) toJson,
  );

  /// Retrieves a list of objects from JSON for the given key
  Future<List<T>> getList<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  );

  /// Saves a boolean value with the given key
  Future<void> saveBool(String key, bool value);

  /// Retrieves a boolean value for the given key
  Future<bool?> getBool(String key);

  /// Saves an integer value with the given key
  Future<void> saveInt(String key, int value);

  /// Retrieves an integer value for the given key
  Future<int?> getInt(String key);

  /// Saves a double value with the given key
  Future<void> saveDouble(String key, double value);

  /// Retrieves a double value for the given key
  Future<double?> getDouble(String key);

  /// Removes the value for the given key
  Future<void> remove(String key);

  /// Checks if a key exists in storage
  Future<bool> containsKey(String key);

  /// Clears all stored data
  Future<void> clear();

  /// Gets all keys in storage
  Future<Set<String>> getKeys();
}

/// Mixin to provide JSON serialization helpers
mixin JsonStorageMixin on StorageService {
  /// Safely encodes object to JSON string
  String encodeJson(dynamic object) {
    try {
      return json.encode(object);
    } catch (e) {
      throw StorageException(
        'Error al codificar JSON',
        originalError: e,
      );
    }
  }

  /// Safely decodes JSON string to object
  dynamic decodeJson(String jsonString) {
    try {
      return json.decode(jsonString);
    } catch (e) {
      throw StorageException(
        'Error al decodificar JSON',
        originalError: e,
      );
    }
  }

  /// Validates that decoded JSON is a Map
  Map<String, dynamic> validateJsonMap(dynamic decoded, String key) {
    if (decoded is! Map<String, dynamic>) {
      throw StorageException(
        'Los datos almacenados para la clave "$key" no son un objeto JSON válido',
      );
    }
    return decoded;
  }

  /// Validates that decoded JSON is a List
  List<dynamic> validateJsonList(dynamic decoded, String key) {
    if (decoded is! List) {
      throw StorageException(
        'Los datos almacenados para la clave "$key" no son una lista JSON válida',
      );
    }
    return decoded;
  }
}

/// Base implementation with common functionality
abstract class BaseStorageService extends StorageService with JsonStorageMixin {
  @override
  Future<void> saveObject<T>(String key, T object) async {
    try {
      final jsonString = encodeJson(object);
      await saveString(key, jsonString);
    } catch (e) {
      if (e is StorageException) rethrow;
      throw StorageException(
        'Error al guardar objeto para la clave "$key"',
        originalError: e,
      );
    }
  }

  @override
  Future<T?> getObject<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final jsonString = await getString(key);
      if (jsonString == null) return null;

      final decoded = decodeJson(jsonString);
      final jsonMap = validateJsonMap(decoded, key);

      return fromJson(jsonMap);
    } catch (e) {
      if (e is StorageException) rethrow;
      throw StorageException(
        'Error al recuperar objeto para la clave "$key"',
        originalError: e,
      );
    }
  }

  @override
  Future<void> saveList<T>(
    String key,
    List<T> list,
    Map<String, dynamic> Function(T) toJson,
  ) async {
    try {
      final jsonList = list.map(toJson).toList();
      final jsonString = encodeJson(jsonList);
      await saveString(key, jsonString);
    } catch (e) {
      if (e is StorageException) rethrow;
      throw StorageException(
        'Error al guardar lista para la clave "$key"',
        originalError: e,
      );
    }
  }

  @override
  Future<List<T>> getList<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final jsonString = await getString(key);
      if (jsonString == null) return [];

      final decoded = decodeJson(jsonString);
      final jsonList = validateJsonList(decoded, key);

      return jsonList.cast<Map<String, dynamic>>().map(fromJson).toList();
    } catch (e) {
      if (e is StorageException) rethrow;
      throw StorageException(
        'Error al recuperar lista para la clave "$key"',
        originalError: e,
      );
    }
  }
}
