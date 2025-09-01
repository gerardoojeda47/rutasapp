# Design Document

## Overview

This design document outlines the architectural refactoring of the RouWhite Flutter application. The refactoring will transform the current monolithic structure into a clean, maintainable architecture following Clean Architecture principles, implementing proper state management, data persistence, and performance optimizations.

## Architecture

### Clean Architecture Layers

The application will be restructured into three main layers:

```
lib/
├── core/                     # Shared utilities and constants
│   ├── constants/
│   │   ├── app_constants.dart
│   │   ├── colors.dart
│   │   └── strings.dart
│   ├── utils/
│   │   ├── validators.dart
│   │   ├── formatters.dart
│   │   └── extensions.dart
│   ├── services/
│   │   ├── storage_service.dart
│   │   ├── location_service.dart
│   │   └── error_handler.dart
│   └── exceptions/
│       ├── app_exceptions.dart
│       └── network_exceptions.dart
├── data/                     # Data layer
│   ├── models/
│   │   ├── ruta_model.dart
│   │   ├── parada_model.dart
│   │   ├── usuario_model.dart
│   │   └── favorito_model.dart
│   ├── repositories/
│   │   ├── ruta_repository_impl.dart
│   │   ├── usuario_repository_impl.dart
│   │   └── favoritos_repository_impl.dart
│   └── datasources/
│       ├── local/
│       │   ├── local_storage_datasource.dart
│       │   └── database_helper.dart
│       └── remote/
│           ├── api_service.dart
│           └── network_client.dart
├── domain/                   # Business logic layer
│   ├── entities/
│   │   ├── ruta.dart
│   │   ├── parada.dart
│   │   ├── usuario.dart
│   │   └── favorito.dart
│   ├── repositories/
│   │   ├── ruta_repository.dart
│   │   ├── usuario_repository.dart
│   │   └── favoritos_repository.dart
│   └── usecases/
│       ├── obtener_rutas_usecase.dart
│       ├── gestionar_favoritos_usecase.dart
│       ├── autenticar_usuario_usecase.dart
│       └── buscar_rutas_usecase.dart
└── presentation/             # UI layer
    ├── pages/
    │   ├── auth/
    │   │   ├── login_page.dart
    │   │   └── registro_page.dart
    │   ├── home/
    │   │   ├── home_page.dart
    │   │   └── widgets/
    │   ├── rutas/
    │   │   ├── rutas_page.dart
    │   │   ├── buscar_ruta_page.dart
    │   │   └── widgets/
    │   ├── favoritos/
    │   │   ├── favoritos_page.dart
    │   │   └── widgets/
    │   └── perfil/
    │       ├── perfil_page.dart
    │       └── widgets/
    ├── providers/
    │   ├── auth_provider.dart
    │   ├── rutas_provider.dart
    │   ├── favoritos_provider.dart
    │   └── location_provider.dart
    └── widgets/
        ├── common/
        │   ├── custom_app_bar.dart
        │   ├── loading_widget.dart
        │   └── error_widget.dart
        └── map/
            ├── interactive_map.dart
            └── route_marker.dart
```

### State Management Architecture

The application will use Provider pattern with the following structure:

```dart
// Provider hierarchy
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => LocationProvider()),
    ChangeNotifierProxyProvider<AuthProvider, RutasProvider>(
      create: (_) => RutasProvider(),
      update: (_, auth, previous) => previous?..updateAuth(auth),
    ),
    ChangeNotifierProxyProvider<AuthProvider, FavoritosProvider>(
      create: (_) => FavoritosProvider(),
      update: (_, auth, previous) => previous?..updateAuth(auth),
    ),
  ],
  child: MyApp(),
)
```

## Components and Interfaces

### Core Services

#### StorageService

```dart
abstract class StorageService {
  Future<void> saveString(String key, String value);
  Future<String?> getString(String key);
  Future<void> saveObject<T>(String key, T object);
  Future<T?> getObject<T>(String key, T Function(Map<String, dynamic>) fromJson);
  Future<void> remove(String key);
  Future<void> clear();
}
```

#### LocationService

```dart
abstract class LocationService {
  Future<Position?> getCurrentLocation();
  Stream<Position> getLocationStream();
  Future<bool> requestPermission();
  Future<bool> isLocationServiceEnabled();
}
```

#### ErrorHandler

```dart
class ErrorHandler {
  static void handleError(BuildContext context, dynamic error);
  static String getErrorMessage(dynamic error);
  static void logError(dynamic error, StackTrace stackTrace);
}
```

### Data Layer

#### Repository Pattern Implementation

```dart
abstract class RutaRepository {
  Future<List<Ruta>> obtenerRutas();
  Future<List<Ruta>> buscarRutas(String query);
  Future<Ruta?> obtenerRutaPorId(String id);
  Stream<List<Ruta>> obtenerRutasStream();
}

class RutaRepositoryImpl implements RutaRepository {
  final ApiService _apiService;
  final LocalStorageDataSource _localDataSource;

  RutaRepositoryImpl(this._apiService, this._localDataSource);

  @override
  Future<List<Ruta>> obtenerRutas() async {
    try {
      final rutas = await _apiService.obtenerRutas();
      await _localDataSource.guardarRutas(rutas);
      return rutas.map((model) => model.toEntity()).toList();
    } catch (e) {
      // Fallback to local data
      final localRutas = await _localDataSource.obtenerRutas();
      return localRutas.map((model) => model.toEntity()).toList();
    }
  }
}
```

### Domain Layer

#### Use Cases

```dart
class ObtenerRutasUseCase {
  final RutaRepository _repository;

  ObtenerRutasUseCase(this._repository);

  Future<Either<Failure, List<Ruta>>> call() async {
    try {
      final rutas = await _repository.obtenerRutas();
      return Right(rutas);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
```

#### Entities

```dart
class Ruta extends Equatable {
  final String id;
  final String nombre;
  final String empresa;
  final List<Parada> paradas;
  final LatLng origen;
  final LatLng destino;
  final double costo;
  final EstadoRuta estado;

  const Ruta({
    required this.id,
    required this.nombre,
    required this.empresa,
    required this.paradas,
    required this.origen,
    required this.destino,
    required this.costo,
    required this.estado,
  });

  @override
  List<Object?> get props => [id, nombre, empresa, paradas, origen, destino, costo, estado];
}
```

### Presentation Layer

#### Provider Implementation

```dart
class RutasProvider extends ChangeNotifier {
  final ObtenerRutasUseCase _obtenerRutasUseCase;
  final BuscarRutasUseCase _buscarRutasUseCase;

  List<Ruta> _rutas = [];
  List<Ruta> _rutasFiltradas = [];
  bool _isLoading = false;
  String? _error;

  List<Ruta> get rutas => _rutas;
  List<Ruta> get rutasFiltradas => _rutasFiltradas;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> cargarRutas() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _obtenerRutasUseCase();
    result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (rutas) {
        _rutas = rutas;
        _rutasFiltradas = rutas;
        _isLoading = false;
        notifyListeners();
      },
    );
  }
}
```

## Data Models

### Ruta Model

```dart
class RutaModel extends Equatable {
  final String id;
  final String nombre;
  final String empresa;
  final List<ParadaModel> paradas;
  final double origenLat;
  final double origenLng;
  final double destinoLat;
  final double destinoLng;
  final double costo;
  final String estado;

  const RutaModel({
    required this.id,
    required this.nombre,
    required this.empresa,
    required this.paradas,
    required this.origenLat,
    required this.origenLng,
    required this.destinoLat,
    required this.destinoLng,
    required this.costo,
    required this.estado,
  });

  factory RutaModel.fromJson(Map<String, dynamic> json) {
    return RutaModel(
      id: json['id'] as String,
      nombre: json['nombre'] as String,
      empresa: json['empresa'] as String,
      paradas: (json['paradas'] as List)
          .map((p) => ParadaModel.fromJson(p))
          .toList(),
      origenLat: (json['origen']['lat'] as num).toDouble(),
      origenLng: (json['origen']['lng'] as num).toDouble(),
      destinoLat: (json['destino']['lat'] as num).toDouble(),
      destinoLng: (json['destino']['lng'] as num).toDouble(),
      costo: (json['costo'] as num).toDouble(),
      estado: json['estado'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'empresa': empresa,
      'paradas': paradas.map((p) => p.toJson()).toList(),
      'origen': {'lat': origenLat, 'lng': origenLng},
      'destino': {'lat': destinoLat, 'lng': destinoLng},
      'costo': costo,
      'estado': estado,
    };
  }

  Ruta toEntity() {
    return Ruta(
      id: id,
      nombre: nombre,
      empresa: empresa,
      paradas: paradas.map((p) => p.toEntity()).toList(),
      origen: LatLng(origenLat, origenLng),
      destino: LatLng(destinoLat, destinoLng),
      costo: costo,
      estado: EstadoRuta.fromString(estado),
    );
  }

  @override
  List<Object?> get props => [id, nombre, empresa, paradas, origenLat, origenLng, destinoLat, destinoLng, costo, estado];
}
```

## Error Handling

### Exception Hierarchy

```dart
abstract class AppException implements Exception {
  final String message;
  final String? code;

  const AppException(this.message, [this.code]);
}

class NetworkException extends AppException {
  const NetworkException(String message, [String? code]) : super(message, code);
}

class ValidationException extends AppException {
  const ValidationException(String message, [String? code]) : super(message, code);
}

class StorageException extends AppException {
  const StorageException(String message, [String? code]) : super(message, code);
}
```

### Error Handler Implementation

```dart
class ErrorHandler {
  static void handleError(BuildContext context, dynamic error) {
    String message = _getErrorMessage(error);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _getErrorColor(error),
        action: _getErrorAction(context, error),
      ),
    );

    // Log error for debugging
    _logError(error);
  }

  static String _getErrorMessage(dynamic error) {
    if (error is NetworkException) {
      return 'Error de conexión. Verifica tu internet.';
    } else if (error is ValidationException) {
      return error.message;
    } else if (error is StorageException) {
      return 'Error al guardar datos. Intenta nuevamente.';
    }
    return 'Ha ocurrido un error inesperado.';
  }
}
```

## Testing Strategy

### Unit Tests

- Test all use cases with mock repositories
- Test providers with mock use cases
- Test utility functions and validators
- Test data model serialization/deserialization

### Widget Tests

- Test individual widgets in isolation
- Test widget interactions and state changes
- Test error states and loading states
- Test accessibility features

### Integration Tests

- Test complete user flows (login, search routes, add favorites)
- Test offline/online scenarios
- Test location permission flows
- Test data persistence across app restarts

### Test Structure

```dart
// test/domain/usecases/obtener_rutas_usecase_test.dart
void main() {
  group('ObtenerRutasUseCase', () {
    late ObtenerRutasUseCase usecase;
    late MockRutaRepository mockRepository;

    setUp(() {
      mockRepository = MockRutaRepository();
      usecase = ObtenerRutasUseCase(mockRepository);
    });

    test('should return list of rutas when repository call is successful', () async {
      // arrange
      final tRutas = [
        Ruta(id: '1', nombre: 'Ruta 1', /* ... */),
      ];
      when(mockRepository.obtenerRutas()).thenAnswer((_) async => tRutas);

      // act
      final result = await usecase();

      // assert
      expect(result, Right(tRutas));
      verify(mockRepository.obtenerRutas());
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
```

## Performance Optimizations

### Widget Optimization

- Use `const` constructors wherever possible
- Implement `RepaintBoundary` for expensive widgets
- Use `ListView.builder` for large lists
- Implement proper `keys` for list items

### State Management Optimization

- Use `Selector` widgets to listen to specific parts of state
- Implement proper `shouldRebuild` logic in providers
- Cache expensive computations
- Use `ValueNotifier` for simple state changes

### Map Optimization

- Implement marker clustering for dense areas
- Use appropriate zoom levels for different contexts
- Cache map tiles when possible
- Optimize polyline rendering

### Memory Management

- Dispose controllers and streams properly
- Use weak references where appropriate
- Implement proper image caching
- Monitor memory usage in development

This design provides a solid foundation for the RouWhite refactoring, ensuring maintainability, testability, and scalability while preserving all existing functionality.
