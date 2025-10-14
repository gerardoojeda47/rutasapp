import 'package:dartz/dartz.dart';
import 'package:latlong2/latlong.dart';
import 'package:rouwhite/domain/entities/ruta.dart';
import 'package:rouwhite/domain/entities/parada.dart';
import 'package:rouwhite/domain/repositories/ruta_repository.dart';

/// Parámetros para búsqueda avanzada de rutas
class BusquedaAvanzadaParams {
  const BusquedaAvanzadaParams({
    this.query,
    this.empresa,
    this.estado,
    this.costoMinimo,
    this.costoMaximo,
    this.ubicacionUsuario,
    this.radioMaximo,
    this.ordenarPor = RutaOrdenamiento.nombre,
    this.ordenAscendente = true,
    this.limite = 50,
  });

  final String? query;
  final String? empresa;
  final EstadoRuta? estado;
  final double? costoMinimo;
  final double? costoMaximo;
  final LatLng? ubicacionUsuario;
  final double? radioMaximo; // en metros
  final RutaOrdenamiento ordenarPor;
  final bool ordenAscendente;
  final int limite;

  bool get tieneUbicacion => ubicacionUsuario != null;
  bool get tieneFiltros =>
      empresa != null ||
      estado != null ||
      costoMinimo != null ||
      costoMaximo != null;
}

/// Resultado de búsqueda con información adicional
class ResultadoBusqueda {
  const ResultadoBusqueda({
    required this.rutas,
    required this.totalEncontradas,
    required this.tiempoBusqueda,
    this.sugerencias = const [],
  });

  final List<RutaConDistancia> rutas;
  final int totalEncontradas;
  final Duration tiempoBusqueda;
  final List<String> sugerencias;

  bool get tieneResultados => rutas.isNotEmpty;
  bool get tieneSugerencias => sugerencias.isNotEmpty;
}

/// Ruta con información de distancia al usuario
class RutaConDistancia {
  const RutaConDistancia({
    required this.ruta,
    this.distanciaAlUsuario,
    this.paradaMasCercana,
  });

  final Ruta ruta;
  final double? distanciaAlUsuario; // en metros
  final Parada? paradaMasCercana;

  bool get tieneDistancia => distanciaAlUsuario != null;

  String get distanciaFormateada {
    if (distanciaAlUsuario == null) return 'Distancia no disponible';

    if (distanciaAlUsuario! < 1000) {
      return '${distanciaAlUsuario!.round()} m';
    } else {
      final km = distanciaAlUsuario! / 1000;
      return '${km.toStringAsFixed(1)} km';
    }
  }
}

/// Caso de uso principal para búsqueda de rutas
class BuscarRutasUseCase {
  const BuscarRutasUseCase(this._repository);

  final RutaRepository _repository;

  /// Ejecuta búsqueda avanzada de rutas
  Future<Either<RutaFailure, ResultadoBusqueda>> call(
      BusquedaAvanzadaParams params) async {
    final stopwatch = Stopwatch()..start();

    try {
      // Construir filtro basado en parámetros
      final filtro = _construirFiltro(params);

      // Obtener rutas filtradas
      final rutasResult = await _repository.obtenerRutasFiltradas(filtro);

      return rutasResult.fold(
        (failure) => Left(failure),
        (rutas) async {
          // Aplicar búsqueda por texto si se especifica
          List<Ruta> rutasFiltradas = rutas;

          if (params.query != null && params.query!.trim().isNotEmpty) {
            final busquedaTextoResult =
                await _repository.buscarRutasPorTexto(params.query!);
            rutasFiltradas = busquedaTextoResult.fold(
              (failure) =>
                  rutas, // Si falla la búsqueda por texto, usar rutas filtradas
              (rutasBuscadas) => _combinarResultados(rutas, rutasBuscadas),
            );
          }

          // Calcular distancias si se proporciona ubicación
          final rutasConDistancia = await _calcularDistancias(
              rutasFiltradas, params.ubicacionUsuario);

          // Filtrar por radio si se especifica
          final rutasEnRadio =
              _filtrarPorRadio(rutasConDistancia, params.radioMaximo);

          // Ordenar resultados
          final rutasOrdenadas = _ordenarResultados(rutasEnRadio, params);

          // Aplicar límite
          final rutasLimitadas = rutasOrdenadas.take(params.limite).toList();

          // Generar sugerencias si hay pocos resultados
          final sugerencias = rutasLimitadas.length < 3
              ? await _generarSugerencias(params)
              : <String>[];

          stopwatch.stop();

          return Right(ResultadoBusqueda(
            rutas: rutasLimitadas,
            totalEncontradas: rutasOrdenadas.length,
            tiempoBusqueda: stopwatch.elapsed,
            sugerencias: sugerencias,
          ));
        },
      );
    } catch (e) {
      stopwatch.stop();
      return Left(
          RutaSearchFailure('Error durante la búsqueda: $e', originalError: e));
    }
  }

  /// Construye el filtro basado en los parámetros
  RutaFilter _construirFiltro(BusquedaAvanzadaParams params) {
    return RutaFilter(
      empresa: params.empresa,
      estado: params.estado,
      costoMinimo: params.costoMinimo,
      costoMaximo: params.costoMaximo,
      ordenarPor: params.ordenarPor,
      ordenAscendente: params.ordenAscendente,
    );
  }

  /// Combina resultados de filtros y búsqueda por texto
  List<Ruta> _combinarResultados(
      List<Ruta> rutasFiltradas, List<Ruta> rutasBuscadas) {
    final idsRutasFiltradas = rutasFiltradas.map((r) => r.id).toSet();
    return rutasBuscadas
        .where((ruta) => idsRutasFiltradas.contains(ruta.id))
        .toList();
  }

  /// Calcula distancias desde la ubicación del usuario
  Future<List<RutaConDistancia>> _calcularDistancias(
    List<Ruta> rutas,
    LatLng? ubicacionUsuario,
  ) async {
    if (ubicacionUsuario == null) {
      return rutas.map((ruta) => RutaConDistancia(ruta: ruta)).toList();
    }

    const distance = Distance();

    return rutas.map((ruta) {
      // Encontrar la parada más cercana al usuario
      Parada? paradaMasCercana;
      double? distanciaMinima;

      for (final parada in ruta.paradas) {
        final distancia = distance.as(
          LengthUnit.Meter,
          ubicacionUsuario,
          parada.coordenadas,
        );

        if (distanciaMinima == null || distancia < distanciaMinima) {
          distanciaMinima = distancia;
          paradaMasCercana = parada;
        }
      }

      return RutaConDistancia(
        ruta: ruta,
        distanciaAlUsuario: distanciaMinima,
        paradaMasCercana: paradaMasCercana,
      );
    }).toList();
  }

  /// Filtra rutas por radio máximo
  List<RutaConDistancia> _filtrarPorRadio(
    List<RutaConDistancia> rutas,
    double? radioMaximo,
  ) {
    if (radioMaximo == null) return rutas;

    return rutas.where((rutaConDistancia) {
      final distancia = rutaConDistancia.distanciaAlUsuario;
      return distancia == null || distancia <= radioMaximo;
    }).toList();
  }

  /// Ordena los resultados según los parámetros
  List<RutaConDistancia> _ordenarResultados(
    List<RutaConDistancia> rutas,
    BusquedaAvanzadaParams params,
  ) {
    rutas.sort((a, b) {
      int comparison = 0;

      switch (params.ordenarPor) {
        case RutaOrdenamiento.nombre:
          comparison = a.ruta.nombre.compareTo(b.ruta.nombre);
          break;
        case RutaOrdenamiento.empresa:
          comparison = a.ruta.empresa.compareTo(b.ruta.empresa);
          break;
        case RutaOrdenamiento.costo:
          comparison = a.ruta.costo.compareTo(b.ruta.costo);
          break;
        case RutaOrdenamiento.estado:
          comparison = a.ruta.estado.index.compareTo(b.ruta.estado.index);
          break;
        case RutaOrdenamiento.numeroParadas:
          comparison = a.ruta.numeroParadas.compareTo(b.ruta.numeroParadas);
          break;
      }

      // Si hay ubicación del usuario, ordenar por distancia como criterio secundario
      if (comparison == 0 && params.tieneUbicacion) {
        final distanciaA = a.distanciaAlUsuario ?? double.infinity;
        final distanciaB = b.distanciaAlUsuario ?? double.infinity;
        comparison = distanciaA.compareTo(distanciaB);
      }

      return params.ordenAscendente ? comparison : -comparison;
    });

    return rutas;
  }

  /// Genera sugerencias cuando hay pocos resultados
  Future<List<String>> _generarSugerencias(
      BusquedaAvanzadaParams params) async {
    final sugerencias = <String>[];

    // Sugerir relajar filtros de costo
    if (params.costoMinimo != null || params.costoMaximo != null) {
      sugerencias.add('Intenta ampliar el rango de precios');
    }

    // Sugerir cambiar empresa
    if (params.empresa != null) {
      sugerencias.add('Prueba con otras empresas de transporte');
    }

    // Sugerir ampliar radio de búsqueda
    if (params.radioMaximo != null && params.radioMaximo! < 5000) {
      sugerencias.add('Amplía el radio de búsqueda');
    }

    // Sugerir búsqueda más general
    if (params.query != null && params.query!.length > 5) {
      sugerencias.add('Intenta con términos de búsqueda más cortos');
    }

    return sugerencias;
  }
}

/// Caso de uso para búsqueda rápida por texto
class BusquedaRapidaUseCase {
  const BusquedaRapidaUseCase(this._buscarRutasUseCase);

  final BuscarRutasUseCase _buscarRutasUseCase;

  /// Ejecuta búsqueda rápida por texto
  Future<Either<RutaFailure, List<RutaConDistancia>>> call(
    String query, {
    LatLng? ubicacionUsuario,
    int limite = 10,
  }) async {
    if (query.trim().isEmpty) {
      return const Right([]);
    }

    final params = BusquedaAvanzadaParams(
      query: query,
      ubicacionUsuario: ubicacionUsuario,
      limite: limite,
      ordenarPor: RutaOrdenamiento.nombre,
    );

    final result = await _buscarRutasUseCase(params);

    return result.fold(
      (failure) => Left(failure),
      (resultado) => Right(resultado.rutas),
    );
  }
}

/// Caso de uso para obtener rutas cercanas
class ObtenerRutasCercanasUseCase {
  const ObtenerRutasCercanasUseCase(this._buscarRutasUseCase);

  final BuscarRutasUseCase _buscarRutasUseCase;

  /// Ejecuta búsqueda de rutas cercanas
  Future<Either<RutaFailure, List<RutaConDistancia>>> call(
    LatLng ubicacion, {
    double radioEnMetros = 1000.0,
    int limite = 20,
  }) async {
    final params = BusquedaAvanzadaParams(
      ubicacionUsuario: ubicacion,
      radioMaximo: radioEnMetros,
      limite: limite,
      ordenarPor:
          RutaOrdenamiento.nombre, // Se ordenará por distancia automáticamente
    );

    final result = await _buscarRutasUseCase(params);

    return result.fold(
      (failure) => Left(failure),
      (resultado) => Right(resultado.rutas),
    );
  }
}

/// Caso de uso para búsqueda con filtros específicos
class BuscarRutasConFiltrosUseCase {
  const BuscarRutasConFiltrosUseCase(this._buscarRutasUseCase);

  final BuscarRutasUseCase _buscarRutasUseCase;

  /// Ejecuta búsqueda con filtros específicos
  Future<Either<RutaFailure, ResultadoBusqueda>> call({
    String? empresa,
    EstadoRuta? estado,
    double? costoMinimo,
    double? costoMaximo,
    RutaOrdenamiento ordenarPor = RutaOrdenamiento.nombre,
    bool ordenAscendente = true,
    int limite = 50,
  }) async {
    final params = BusquedaAvanzadaParams(
      empresa: empresa,
      estado: estado,
      costoMinimo: costoMinimo,
      costoMaximo: costoMaximo,
      ordenarPor: ordenarPor,
      ordenAscendente: ordenAscendente,
      limite: limite,
    );

    return await _buscarRutasUseCase(params);
  }
}

