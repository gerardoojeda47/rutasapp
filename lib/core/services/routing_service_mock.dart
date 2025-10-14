import 'package:latlong2/latlong.dart';
import 'package:rouwhite/domain/entities/ruta_detallada.dart';

/// Servicio mock para probar la navegación sin API key
class RoutingServiceMock {
  /// Obtiene una ruta detallada simulada
  Future<RutaDetallada> obtenerRutaDetallada({
    required LatLng origen,
    required LatLng destino,
    String perfil = 'driving-car',
    bool incluirInstrucciones = true,
    bool incluirGeometria = true,
  }) async {
    // Simular delay de red
    await Future.delayed(const Duration(seconds: 2));

    // Crear puntos simulados entre origen y destino
    final puntos = _generarPuntosRuta(origen, destino);

    // Crear instrucciones simuladas
    final instrucciones = _generarInstruccionesSimuladas(puntos);

    // Crear segmentos simulados
    final segmentos = _generarSegmentosSimulados(puntos);

    return RutaDetallada(
      puntos: puntos,
      instrucciones: instrucciones,
      segmentos: segmentos,
      distanciaTotal: 2500, // 2.5 km
      tiempoEstimado: const Duration(minutes: 8),
      origen: origen,
      destino: destino,
      descripcion: 'Ruta simulada para demo',
    );
  }

  /// Obtiene múltiples rutas alternativas simuladas
  Future<List<RutaDetallada>> obtenerRutasAlternativas({
    required LatLng origen,
    required LatLng destino,
    String perfil = 'driving-car',
    int numeroAlternativas = 3,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    final rutas = <RutaDetallada>[];

    for (int i = 0; i < numeroAlternativas; i++) {
      final puntos = _generarPuntosRuta(origen, destino, variacion: i);
      final instrucciones = _generarInstruccionesSimuladas(puntos);
      final segmentos = _generarSegmentosSimulados(puntos);

      rutas.add(RutaDetallada(
        puntos: puntos,
        instrucciones: instrucciones,
        segmentos: segmentos,
        distanciaTotal: 2500 + (i * 300), // Variar distancia
        tiempoEstimado: Duration(minutes: 8 + i),
        origen: origen,
        destino: destino,
        descripcion: 'Ruta alternativa ${i + 1}',
      ));
    }

    return rutas;
  }

  /// Busca direcciones simuladas
  Future<List<LatLng>> buscarDireccion(String direccion) async {
    await Future.delayed(const Duration(seconds: 1));

    // Direcciones simuladas en Popayán
    final direccionesSimuladas = {
      'centro': LatLng(2.444814, -76.614739),
      'terminal': LatLng(2.445000, -76.617000),
      'universidad': LatLng(2.453000, -76.599000),
      'hospital': LatLng(2.447500, -76.610000),
      'plaza': LatLng(2.444814, -76.614739),
    };

    final query = direccion.toLowerCase();
    final resultados = <LatLng>[];

    for (final entry in direccionesSimuladas.entries) {
      if (entry.key.contains(query)) {
        resultados.add(entry.value);
      }
    }

    return resultados.isNotEmpty
        ? resultados
        : [direccionesSimuladas['centro']!];
  }

  /// Genera puntos de ruta simulados
  List<LatLng> _generarPuntosRuta(LatLng origen, LatLng destino,
      {int variacion = 0}) {
    final puntos = <LatLng>[origen];

    // Calcular puntos intermedios
    final latDiff = destino.latitude - origen.latitude;
    final lngDiff = destino.longitude - origen.longitude;

    const numPuntos = 10;
    for (int i = 1; i < numPuntos; i++) {
      final factor = i / numPuntos;

      // Agregar variación para rutas alternativas
      final variacionLat = variacion * 0.001 * (i % 2 == 0 ? 1 : -1);
      final variacionLng = variacion * 0.001 * (i % 2 == 0 ? -1 : 1);

      final lat = origen.latitude + (latDiff * factor) + variacionLat;
      final lng = origen.longitude + (lngDiff * factor) + variacionLng;

      puntos.add(LatLng(lat, lng));
    }

    puntos.add(destino);
    return puntos;
  }

  /// Genera instrucciones simuladas
  List<InstruccionNavegacion> _generarInstruccionesSimuladas(
      List<LatLng> puntos) {
    final instrucciones = <InstruccionNavegacion>[];

    final callesSimuladas = [
      'Carrera 5',
      'Calle 4',
      'Carrera 6',
      'Calle 3',
      'Carrera 7',
      'Calle 2',
      'Carrera 8',
    ];

    final tiposInstruccion = [
      TipoInstruccion.salida,
      TipoInstruccion.continuar,
      TipoInstruccion.girarDerecha,
      TipoInstruccion.continuar,
      TipoInstruccion.girarIzquierda,
      TipoInstruccion.continuar,
      TipoInstruccion.llegada,
    ];

    final textosInstruccion = [
      'Dirígete hacia el sur por Carrera 5',
      'Continúa por Carrera 5',
      'Gira a la derecha en Calle 4',
      'Continúa por Calle 4',
      'Gira a la izquierda en Carrera 6',
      'Continúa por Carrera 6',
      'Has llegado a tu destino',
    ];

    for (int i = 0; i < puntos.length && i < callesSimuladas.length; i++) {
      instrucciones.add(InstruccionNavegacion(
        texto: textosInstruccion[i],
        calle: callesSimuladas[i],
        tipo: tiposInstruccion[i],
        posicion: puntos[i],
        distancia: i == puntos.length - 1 ? 0 : 300 + (i * 50),
        duracion: Duration(minutes: 1 + i),
      ));
    }

    return instrucciones;
  }

  /// Genera segmentos simulados
  List<SegmentoRuta> _generarSegmentosSimulados(List<LatLng> puntos) {
    final segmentos = <SegmentoRuta>[];

    final calles = ['Carrera 5', 'Calle 4', 'Carrera 6', 'Calle 3'];

    for (int i = 0; i < calles.length && i < puntos.length - 1; i++) {
      final inicio = i * (puntos.length ~/ calles.length);
      final fin = (i + 1) * (puntos.length ~/ calles.length);

      segmentos.add(SegmentoRuta(
        puntos: puntos.sublist(inicio, fin.clamp(0, puntos.length)),
        calle: calles[i],
        distancia: 400 + (i * 100),
        duracion: Duration(minutes: 2 + i),
        velocidadPromedio: 25.0,
        tipoVia: i == 0 ? 'primary' : 'secondary',
      ));
    }

    return segmentos;
  }
}

