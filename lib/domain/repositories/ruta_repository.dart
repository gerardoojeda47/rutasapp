import 'package:dartz/dartz.dart';
import '../entities/ruta.dart';
import '../../core/exceptions/app_exceptions.dart';

/// Tipos de falla que pueden ocurrir en operaciones de rutas
abstract class RutaFailure extends AppException {
  const RutaFailure(String message, {String? code, dynamic originalError})
      : super(message, code: code, originalError: originalError);
}

class RutaNotFoundFailure extends RutaFailure {
  const RutaNotFoundFailure(String rutaId)
      : super('Ruta con ID $rutaId no encontrada', code: 'RUTA_NOT_FOUND');
}

class RutasLoadFailure extends RutaFailure {
  const RutasLoadFailure(String message, {dynamic originalError})
      : super(message, code: 'RUTAS_LOAD_ERROR', originalError: originalError);
}

class RutaSearchFailure extends RutaFailure {
  const RutaSearchFailure(String message, {dynamic originalError})
      : super(message, code: 'RUTA_SEARCH_ERROR', originalError: originalError);
}

/// Parámetros para filtrar rutas
class RutaFilter {
  const RutaFilter({
    this.empresa,
    this.estado,
    this.costoMinimo,
    this.costoMaximo,
    this.tieneParadaEn,
    this.ordenarPor = RutaOrdenamiento.nombre,
    this.ordenAscendente = true,
  });

  final String? empresa;
  final EstadoRuta? estado;
  final double? costoMinimo;
  final double? costoMaximo;
  final String? tieneParadaEn;
  final RutaOrdenamiento ordenarPor;
  final bool ordenAscendente;

  RutaFilter copyWith({
    String? empresa,
    EstadoRuta? estado,
    double? costoMinimo,
    double? costoMaximo,
    String? tieneParadaEn,
    RutaOrdenamiento? ordenarPor,
    bool? ordenAscendente,
  }) {
    return RutaFilter(
      empresa: empresa ?? this.empresa,
      estado: estado ?? this.estado,
      costoMinimo: costoMinimo ?? this.costoMinimo,
      costoMaximo: costoMaximo ?? this.costoMaximo,
      tieneParadaEn: tieneParadaEn ?? this.tieneParadaEn,
      ordenarPor: ordenarPor ?? this.ordenarPor,
      ordenAscendente: ordenAscendente ?? this.ordenAscendente,
    );
  }
}

/// Opciones de ordenamiento para rutas
enum RutaOrdenamiento {
  nombre,
  empresa,
  costo,
  estado,
  numeroParadas,
}

/// Parámetros para búsqueda de rutas entre dos puntos
class BusquedaRutaParams {
  const BusquedaRutaParams({
    required this.origenId,
    required this.destinoId,
    this.horaDeseada,
    this.soloRutasActivas = true,
    this.incluirTransbordos = true,
    this.maxTransbordos = 2,
  });

  final String origenId;
  final String destinoId;
  final DateTime? horaDeseada;
  final bool soloRutasActivas;
  final bool incluirTransbordos;
  final int maxTransbordos;
}

/// Resultado de búsqueda de ruta con información adicional
class RutaConInfo {
  const RutaConInfo({
    required this.ruta,
    this.tiempoEstimado,
    this.distanciaTotal,
    this.numeroTransbordos = 0,
    this.rutasConexion = const [],
  });

  final Ruta ruta;
  final Duration? tiempoEstimado;
  final double? distanciaTotal;
  final int numeroTransbordos;
  final List<Ruta> rutasConexion;
}

/// Repositorio para operaciones relacionadas con rutas
abstract class RutaRepository {
  /// Obtiene todas las rutas disponibles
  Future<Either<RutaFailure, List<Ruta>>> obtenerRutas();

  /// Obtiene una ruta específica por su ID
  Future<Either<RutaFailure, Ruta>> obtenerRutaPorId(String id);

  /// Obtiene rutas filtradas según los criterios especificados
  Future<Either<RutaFailure, List<Ruta>>> obtenerRutasFiltradas(
      RutaFilter filtro);

  /// Busca rutas por nombre o descripción
  Future<Either<RutaFailure, List<Ruta>>> buscarRutasPorTexto(String query);

  /// Busca rutas que conecten dos paradas específicas
  Future<Either<RutaFailure, List<RutaConInfo>>> buscarRutasEntre(
      BusquedaRutaParams params);

  /// Obtiene rutas que pasan por una parada específica
  Future<Either<RutaFailure, List<Ruta>>> obtenerRutasPorParada(
      String paradaId);

  /// Obtiene rutas de una empresa específica
  Future<Either<RutaFailure, List<Ruta>>> obtenerRutasPorEmpresa(
      String empresa);

  /// Obtiene las empresas disponibles
  Future<Either<RutaFailure, List<String>>> obtenerEmpresas();

  /// Obtiene rutas cercanas a una ubicación específica
  Future<Either<RutaFailure, List<Ruta>>> obtenerRutasCercanas(
    double latitud,
    double longitud,
    double radioEnMetros,
  );

  /// Obtiene estadísticas de rutas
  Future<Either<RutaFailure, RutaEstadisticas>> obtenerEstadisticas();

  /// Stream de rutas para actualizaciones en tiempo real
  Stream<Either<RutaFailure, List<Ruta>>> watchRutas();

  /// Stream de una ruta específica para actualizaciones en tiempo real
  Stream<Either<RutaFailure, Ruta>> watchRuta(String id);

  /// Refresca los datos de rutas desde el servidor
  Future<Either<RutaFailure, void>> refrescarRutas();

  /// Obtiene la información de tráfico actual para las rutas
  Future<Either<RutaFailure, Map<String, TraficoInfo>>> obtenerInfoTrafico();
}

/// Estadísticas generales de rutas
class RutaEstadisticas {
  const RutaEstadisticas({
    required this.totalRutas,
    required this.rutasActivas,
    required this.rutasInactivas,
    required this.totalEmpresas,
    required this.costoPromedio,
    required this.rutaMasLarga,
    required this.rutaMasCorta,
  });

  final int totalRutas;
  final int rutasActivas;
  final int rutasInactivas;
  final int totalEmpresas;
  final double costoPromedio;
  final Ruta? rutaMasLarga;
  final Ruta? rutaMasCorta;

  double get porcentajeActivas =>
      totalRutas > 0 ? (rutasActivas / totalRutas) * 100 : 0;
}

/// Información de tráfico para una ruta
class TraficoInfo {
  const TraficoInfo({
    required this.rutaId,
    required this.nivel,
    required this.tiempoAdicional,
    this.descripcion,
    this.ultimaActualizacion,
  });

  final String rutaId;
  final NivelTrafico nivel;
  final Duration tiempoAdicional;
  final String? descripcion;
  final DateTime? ultimaActualizacion;
}

/// Niveles de tráfico
enum NivelTrafico {
  fluido,
  moderado,
  congestionado,
  bloqueado;

  String get displayName {
    switch (this) {
      case NivelTrafico.fluido:
        return 'Fluido';
      case NivelTrafico.moderado:
        return 'Moderado';
      case NivelTrafico.congestionado:
        return 'Congestionado';
      case NivelTrafico.bloqueado:
        return 'Bloqueado';
    }
  }

  /// Obtiene el color asociado al nivel de tráfico
  String get colorHex {
    switch (this) {
      case NivelTrafico.fluido:
        return '#4CAF50'; // Verde
      case NivelTrafico.moderado:
        return '#FF9800'; // Naranja
      case NivelTrafico.congestionado:
        return '#F44336'; // Rojo
      case NivelTrafico.bloqueado:
        return '#9C27B0'; // Morado
    }
  }
}
