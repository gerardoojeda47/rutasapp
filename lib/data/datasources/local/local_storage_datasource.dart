import 'package:rouwhite/core/constants/app_constants.dart';
import 'package:rouwhite/core/services/storage_service.dart';
import 'package:rouwhite/core/exceptions/app_exceptions.dart';
import '../../models/usuario_model.dart';
import '../../models/favorito_model.dart';
import '../../models/ruta_model.dart';

/// Fuente de datos local para operaciones de almacenamiento
class LocalStorageDataSource {
  const LocalStorageDataSource(this._storageService);

  final StorageService _storageService;

  // ========== USUARIOS ==========

  /// Guarda el usuario actual en almacenamiento local
  Future<void> guardarUsuarioActual(UsuarioModel usuario) async {
    try {
      await _storageService.saveObject(
        AppConstants.userDataKey,
        usuario.toJson(),
      );
    } catch (e) {
      throw StorageException(
        'Error al guardar usuario actual',
        originalError: e,
      );
    }
  }

  /// Obtiene el usuario actual del almacenamiento local
  Future<UsuarioModel?> obtenerUsuarioActual() async {
    try {
      final userData = await _storageService.getObject(
        AppConstants.userDataKey,
        (json) => json,
      );

      if (userData == null) return null;

      return UsuarioModel.fromJson(userData);
    } catch (e) {
      throw StorageException(
        'Error al obtener usuario actual',
        originalError: e,
      );
    }
  }

  /// Elimina el usuario actual del almacenamiento local
  Future<void> eliminarUsuarioActual() async {
    try {
      await _storageService.remove(AppConstants.userDataKey);
    } catch (e) {
      throw StorageException(
        'Error al eliminar usuario actual',
        originalError: e,
      );
    }
  }

  /// Guarda el token de autenticación
  Future<void> guardarToken(String token) async {
    try {
      await _storageService.saveString(AppConstants.authTokenKey, token);
    } catch (e) {
      throw StorageException(
        'Error al guardar token',
        originalError: e,
      );
    }
  }

  /// Obtiene el token de autenticación
  Future<String?> obtenerToken() async {
    try {
      return await _storageService.getString(AppConstants.authTokenKey);
    } catch (e) {
      throw StorageException(
        'Error al obtener token',
        originalError: e,
      );
    }
  }

  /// Elimina el token de autenticación
  Future<void> eliminarToken() async {
    try {
      await _storageService.remove(AppConstants.authTokenKey);
    } catch (e) {
      throw StorageException(
        'Error al eliminar token',
        originalError: e,
      );
    }
  }

  /// Guarda las preferencias del usuario
  Future<void> guardarPreferenciasUsuario(
      Map<String, dynamic> preferencias) async {
    try {
      await _storageService.saveObject(
        AppConstants.userPreferencesKey,
        preferencias,
      );
    } catch (e) {
      throw StorageException(
        'Error al guardar preferencias del usuario',
        originalError: e,
      );
    }
  }

  /// Obtiene las preferencias del usuario
  Future<Map<String, dynamic>> obtenerPreferenciasUsuario() async {
    try {
      final preferencias = await _storageService.getObject(
        AppConstants.userPreferencesKey,
        (json) => json,
      );

      return preferencias ?? {};
    } catch (e) {
      throw StorageException(
        'Error al obtener preferencias del usuario',
        originalError: e,
      );
    }
  }

  // ========== FAVORITOS ==========

  /// Guarda la lista de favoritos en almacenamiento local
  Future<void> guardarFavoritos(List<FavoritoModel> favoritos) async {
    try {
      await _storageService.saveList(
        AppConstants.favoritesKey,
        favoritos,
        (favorito) => favorito.toJson(),
      );
    } catch (e) {
      throw StorageException(
        'Error al guardar favoritos',
        originalError: e,
      );
    }
  }

  /// Obtiene la lista de favoritos del almacenamiento local
  Future<List<FavoritoModel>> obtenerFavoritos() async {
    try {
      return await _storageService.getList(
        AppConstants.favoritesKey,
        (json) => FavoritoModel.fromJson(json),
      );
    } catch (e) {
      throw StorageException(
        'Error al obtener favoritos',
        originalError: e,
      );
    }
  }

  /// Agrega un favorito al almacenamiento local
  Future<void> agregarFavorito(FavoritoModel favorito) async {
    try {
      final favoritos = await obtenerFavoritos();

      // Verificar si ya existe
      final existe = favoritos.any((f) =>
          f.rutaId == favorito.rutaId && f.usuarioId == favorito.usuarioId);
      if (existe) {
        throw StorageException('El favorito ya existe');
      }

      favoritos.add(favorito);
      await guardarFavoritos(favoritos);
    } catch (e) {
      if (e is StorageException) rethrow;
      throw StorageException(
        'Error al agregar favorito',
        originalError: e,
      );
    }
  }

  /// Remueve un favorito del almacenamiento local
  Future<void> removerFavorito(String favoritoId) async {
    try {
      final favoritos = await obtenerFavoritos();
      final favoritosFiltrados =
          favoritos.where((f) => f.id != favoritoId).toList();
      await guardarFavoritos(favoritosFiltrados);
    } catch (e) {
      throw StorageException(
        'Error al remover favorito',
        originalError: e,
      );
    }
  }

  /// Remueve un favorito por usuario y ruta
  Future<void> removerFavoritoPorRuta(String usuarioId, String rutaId) async {
    try {
      final favoritos = await obtenerFavoritos();
      final favoritosFiltrados = favoritos
          .where((f) => !(f.usuarioId == usuarioId && f.rutaId == rutaId))
          .toList();
      await guardarFavoritos(favoritosFiltrados);
    } catch (e) {
      throw StorageException(
        'Error al remover favorito por ruta',
        originalError: e,
      );
    }
  }

  /// Actualiza un favorito en el almacenamiento local
  Future<void> actualizarFavorito(FavoritoModel favoritoActualizado) async {
    try {
      final favoritos = await obtenerFavoritos();
      final index = favoritos.indexWhere((f) => f.id == favoritoActualizado.id);

      if (index == -1) {
        throw StorageException('Favorito no encontrado');
      }

      favoritos[index] = favoritoActualizado;
      await guardarFavoritos(favoritos);
    } catch (e) {
      if (e is StorageException) rethrow;
      throw StorageException(
        'Error al actualizar favorito',
        originalError: e,
      );
    }
  }

  /// Obtiene favoritos de un usuario específico
  Future<List<FavoritoModel>> obtenerFavoritosPorUsuario(
      String usuarioId) async {
    try {
      final favoritos = await obtenerFavoritos();
      return favoritos.where((f) => f.usuarioId == usuarioId).toList();
    } catch (e) {
      throw StorageException(
        'Error al obtener favoritos por usuario',
        originalError: e,
      );
    }
  }

  /// Verifica si una ruta es favorita para un usuario
  Future<bool> esRutaFavorita(String usuarioId, String rutaId) async {
    try {
      final favoritos = await obtenerFavoritosPorUsuario(usuarioId);
      return favoritos.any((f) => f.rutaId == rutaId);
    } catch (e) {
      throw StorageException(
        'Error al verificar si ruta es favorita',
        originalError: e,
      );
    }
  }

  /// Limpia todos los favoritos
  Future<void> limpiarFavoritos() async {
    try {
      await _storageService.remove(AppConstants.favoritesKey);
    } catch (e) {
      throw StorageException(
        'Error al limpiar favoritos',
        originalError: e,
      );
    }
  }

  // ========== RUTAS (CACHE) ==========

  /// Guarda rutas en caché local
  Future<void> guardarRutasCache(List<RutaModel> rutas) async {
    try {
      await _storageService.saveList(
        'rutas_cache',
        rutas,
        (ruta) => ruta.toJson(),
      );

      // Guardar timestamp del caché
      await _storageService.saveString(
        'rutas_cache_timestamp',
        DateTime.now().toIso8601String(),
      );
    } catch (e) {
      throw StorageException(
        'Error al guardar rutas en caché',
        originalError: e,
      );
    }
  }

  /// Obtiene rutas del caché local
  Future<List<RutaModel>> obtenerRutasCache() async {
    try {
      return await _storageService.getList(
        'rutas_cache',
        (json) => RutaModel.fromJson(json),
      );
    } catch (e) {
      throw StorageException(
        'Error al obtener rutas del caché',
        originalError: e,
      );
    }
  }

  /// Verifica si el caché de rutas es válido (menos de 1 hora)
  Future<bool> esCacheRutasValido() async {
    try {
      final timestampString =
          await _storageService.getString('rutas_cache_timestamp');
      if (timestampString == null) return false;

      final timestamp = DateTime.parse(timestampString);
      final ahora = DateTime.now();
      final diferencia = ahora.difference(timestamp);

      return diferencia.inHours < 1; // Caché válido por 1 hora
    } catch (e) {
      return false; // Si hay error, considerar caché inválido
    }
  }

  /// Limpia el caché de rutas
  Future<void> limpiarCacheRutas() async {
    try {
      await _storageService.remove('rutas_cache');
      await _storageService.remove('rutas_cache_timestamp');
    } catch (e) {
      throw StorageException(
        'Error al limpiar caché de rutas',
        originalError: e,
      );
    }
  }

  // ========== CONFIGURACIÓN GENERAL ==========

  /// Guarda configuración de la aplicación
  Future<void> guardarConfiguracion(String key, dynamic value) async {
    try {
      if (value is String) {
        await _storageService.saveString(key, value);
      } else if (value is bool) {
        await _storageService.saveBool(key, value);
      } else if (value is int) {
        await _storageService.saveInt(key, value);
      } else if (value is double) {
        await _storageService.saveDouble(key, value);
      } else {
        await _storageService.saveObject(key, value);
      }
    } catch (e) {
      throw StorageException(
        'Error al guardar configuración',
        originalError: e,
      );
    }
  }

  /// Obtiene configuración de la aplicación
  Future<T?> obtenerConfiguracion<T>(String key) async {
    try {
      if (T == String) {
        return await _storageService.getString(key) as T?;
      } else if (T == bool) {
        return await _storageService.getBool(key) as T?;
      } else if (T == int) {
        return await _storageService.getInt(key) as T?;
      } else if (T == double) {
        return await _storageService.getDouble(key) as T?;
      } else {
        return await _storageService.getObject(key, (json) => json as T);
      }
    } catch (e) {
      throw StorageException(
        'Error al obtener configuración',
        originalError: e,
      );
    }
  }

  /// Verifica si existe una clave en el almacenamiento
  Future<bool> existeClave(String key) async {
    try {
      return await _storageService.containsKey(key);
    } catch (e) {
      throw StorageException(
        'Error al verificar existencia de clave',
        originalError: e,
      );
    }
  }

  /// Limpia todo el almacenamiento local
  Future<void> limpiarTodo() async {
    try {
      await _storageService.clear();
    } catch (e) {
      throw StorageException(
        'Error al limpiar almacenamiento',
        originalError: e,
      );
    }
  }

  /// Obtiene el tamaño aproximado del almacenamiento
  Future<int> obtenerTamanoAlmacenamiento() async {
    try {
      final keys = await _storageService.getKeys();
      return keys.length;
    } catch (e) {
      throw StorageException(
        'Error al obtener tamaño del almacenamiento',
        originalError: e,
      );
    }
  }

  /// Exporta todos los datos del usuario
  Future<Map<String, dynamic>> exportarDatosUsuario(String usuarioId) async {
    try {
      final usuario = await obtenerUsuarioActual();
      final favoritos = await obtenerFavoritosPorUsuario(usuarioId);
      final preferencias = await obtenerPreferenciasUsuario();

      return {
        'usuario': usuario?.toJson(),
        'favoritos': favoritos.map((f) => f.toJson()).toList(),
        'preferencias': preferencias,
        'fecha_exportacion': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      throw StorageException(
        'Error al exportar datos del usuario',
        originalError: e,
      );
    }
  }

  /// Importa datos del usuario
  Future<void> importarDatosUsuario(Map<String, dynamic> datos) async {
    try {
      // Importar usuario
      if (datos['usuario'] != null) {
        final usuario =
            UsuarioModel.fromJson(datos['usuario'] as Map<String, dynamic>);
        await guardarUsuarioActual(usuario);
      }

      // Importar favoritos
      if (datos['favoritos'] != null) {
        final favoritosJson = datos['favoritos'] as List<dynamic>;
        final favoritos = favoritosJson
            .map((f) => FavoritoModel.fromJson(f as Map<String, dynamic>))
            .toList();
        await guardarFavoritos(favoritos);
      }

      // Importar preferencias
      if (datos['preferencias'] != null) {
        await guardarPreferenciasUsuario(
            datos['preferencias'] as Map<String, dynamic>);
      }
    } catch (e) {
      throw StorageException(
        'Error al importar datos del usuario',
        originalError: e,
      );
    }
  }
}

