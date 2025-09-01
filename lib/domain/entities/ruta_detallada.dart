import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

/// Tipos de instrucciones de navegación
enum TipoInstruccion {
  continuar,
  girarDerecha,
  girarIzquierda,
  girarLigeroIzquierda,
  girarLigeroDerecha,
  uturn,
  rotonda,
  salirRotonda,
  mantenerDerecha,
  mantenerIzquierda,
  llegada,
  salida,
}

/// Instrucción de navegación detallada
class InstruccionNavegacion extends Equatable {
  const InstruccionNavegacion({
    required this.texto,
    required this.calle,
    required this.tipo,
    required this.posicion,
    required this.distancia,
    required this.duracion,
    this.icono,
  });

  final String texto; // "Gira a la derecha en Carrera 12"
  final String calle; // "Carrera 12"
  final TipoInstruccion tipo;
  final LatLng posicion;
  final double distancia; // metros
  final Duration duracion;
  final String? icono; // Icono específico para la instrucción

  /// Obtiene el icono basado en el tipo de instrucción
  String get iconoPorDefecto {
    switch (tipo) {
      case TipoInstruccion.continuar:
        return 'straight';
      case TipoInstruccion.girarDerecha:
        return 'turn-right';
      case TipoInstruccion.girarIzquierda:
        return 'turn-left';
      case TipoInstruccion.girarLigeroIzquierda:
        return 'turn-slight-left';
      case TipoInstruccion.girarLigeroDerecha:
        return 'turn-slight-right';
      case TipoInstruccion.uturn:
        return 'u-turn';
      case TipoInstruccion.rotonda:
        return 'roundabout';
      case TipoInstruccion.salirRotonda:
        return 'roundabout-exit';
      case TipoInstruccion.mantenerDerecha:
        return 'keep-right';
      case TipoInstruccion.mantenerIzquierda:
        return 'keep-left';
      case TipoInstruccion.llegada:
        return 'flag';
      case TipoInstruccion.salida:
        return 'location-dot';
    }
  }

  /// Formatea la distancia para mostrar
  String get distanciaFormateada {
    if (distancia < 1000) {
      return '${distancia.round()} m';
    } else {
      return '${(distancia / 1000).toStringAsFixed(1)} km';
    }
  }

  /// Formatea la duración para mostrar
  String get duracionFormateada {
    final minutos = duracion.inMinutes;
    if (minutos < 60) {
      return '$minutos min';
    } else {
      final horas = minutos ~/ 60;
      final minutosRestantes = minutos % 60;
      return '${horas}h ${minutosRestantes}min';
    }
  }

  @override
  List<Object?> get props => [
        texto,
        calle,
        tipo,
        posicion,
        distancia,
        duracion,
        icono,
      ];

  @override
  String toString() {
    return 'InstruccionNavegacion(texto: $texto, calle: $calle, distancia: ${distanciaFormateada})';
  }
}

/// Segmento de ruta con información detallada
class SegmentoRuta extends Equatable {
  const SegmentoRuta({
    required this.puntos,
    required this.calle,
    required this.distancia,
    required this.duracion,
    this.velocidadPromedio,
    this.tipoVia,
  });

  final List<LatLng> puntos;
  final String calle;
  final double distancia; // metros
  final Duration duracion;
  final double? velocidadPromedio; // km/h
  final String? tipoVia; // 'primary', 'secondary', 'residential', etc.

  @override
  List<Object?> get props => [
        puntos,
        calle,
        distancia,
        duracion,
        velocidadPromedio,
        tipoVia,
      ];
}

/// Ruta detallada con instrucciones paso a paso
class RutaDetallada extends Equatable {
  const RutaDetallada({
    required this.puntos,
    required this.instrucciones,
    required this.segmentos,
    required this.distanciaTotal,
    required this.tiempoEstimado,
    required this.origen,
    required this.destino,
    this.descripcion,
    this.advertencias = const [],
  });

  final List<LatLng> puntos; // Todos los puntos de la ruta
  final List<InstruccionNavegacion> instrucciones;
  final List<SegmentoRuta> segmentos;
  final double distanciaTotal; // metros
  final Duration tiempoEstimado;
  final LatLng origen;
  final LatLng destino;
  final String? descripcion;
  final List<String> advertencias; // Alertas de tráfico, obras, etc.

  /// Obtiene la distancia total formateada
  String get distanciaTotalFormateada {
    if (distanciaTotal < 1000) {
      return '${distanciaTotal.round()} m';
    } else {
      return '${(distanciaTotal / 1000).toStringAsFixed(1)} km';
    }
  }

  /// Obtiene el tiempo estimado formateado
  String get tiempoEstimadoFormateado {
    final minutos = tiempoEstimado.inMinutes;
    if (minutos < 60) {
      return '$minutos min';
    } else {
      final horas = minutos ~/ 60;
      final minutosRestantes = minutos % 60;
      return '${horas}h ${minutosRestantes}min';
    }
  }

  /// Obtiene la velocidad promedio
  double get velocidadPromedio {
    if (tiempoEstimado.inSeconds == 0) return 0;
    return (distanciaTotal / 1000) / (tiempoEstimado.inHours);
  }

  /// Obtiene los bounds de la ruta para centrar el mapa
  LatLngBounds get bounds {
    if (puntos.isEmpty) {
      return LatLngBounds(origen, destino);
    }

    double minLat = puntos.first.latitude;
    double maxLat = puntos.first.latitude;
    double minLng = puntos.first.longitude;
    double maxLng = puntos.first.longitude;

    for (final punto in puntos) {
      minLat = minLat < punto.latitude ? minLat : punto.latitude;
      maxLat = maxLat > punto.latitude ? maxLat : punto.latitude;
      minLng = minLng < punto.longitude ? minLng : punto.longitude;
      maxLng = maxLng > punto.longitude ? maxLng : punto.longitude;
    }

    return LatLngBounds(
      LatLng(minLat, minLng),
      LatLng(maxLat, maxLng),
    );
  }

  /// Encuentra la instrucción más cercana a una posición
  InstruccionNavegacion? instruccionMasCercana(LatLng posicionActual) {
    if (instrucciones.isEmpty) return null;

    final distance = Distance();
    InstruccionNavegacion? masCercana;
    double menorDistancia = double.infinity;

    for (final instruccion in instrucciones) {
      final distancia = distance.as(
        LengthUnit.Meter,
        posicionActual,
        instruccion.posicion,
      );

      if (distancia < menorDistancia) {
        menorDistancia = distancia;
        masCercana = instruccion;
      }
    }

    return masCercana;
  }

  @override
  List<Object?> get props => [
        puntos,
        instrucciones,
        segmentos,
        distanciaTotal,
        tiempoEstimado,
        origen,
        destino,
        descripcion,
        advertencias,
      ];

  @override
  String toString() {
    return 'RutaDetallada(distancia: $distanciaTotalFormateada, tiempo: $tiempoEstimadoFormateado, instrucciones: ${instrucciones.length})';
  }
}
