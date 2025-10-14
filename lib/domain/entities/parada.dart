import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';

/// Tipos de parada según su importancia
enum TipoParada {
  principal,
  secundaria,
  terminal,
  intercambio;

  /// Convierte un string a TipoParada
  static TipoParada fromString(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'principal':
        return TipoParada.principal;
      case 'secundaria':
        return TipoParada.secundaria;
      case 'terminal':
        return TipoParada.terminal;
      case 'intercambio':
        return TipoParada.intercambio;
      default:
        return TipoParada.secundaria;
    }
  }

  /// Convierte TipoParada a string para mostrar
  String get displayName {
    switch (this) {
      case TipoParada.principal:
        return 'Principal';
      case TipoParada.secundaria:
        return 'Secundaria';
      case TipoParada.terminal:
        return 'Terminal';
      case TipoParada.intercambio:
        return 'Intercambio';
    }
  }
}

/// Entidad que representa una parada de transporte público
class Parada extends Equatable {
  const Parada({
    required this.id,
    required this.nombre,
    required this.coordenadas,
    required this.tipo,
    this.direccion,
    this.barrio,
    this.comuna,
    this.descripcion,
    this.tieneCobertura = false,
    this.tieneBanco = false,
    this.tieneIluminacion = false,
    this.esAccesible = false,
    this.rutasQueParanAqui = const [],
  });

  /// Identificador único de la parada
  final String id;

  /// Nombre de la parada
  final String nombre;

  /// Coordenadas geográficas de la parada
  final LatLng coordenadas;

  /// Tipo de parada
  final TipoParada tipo;

  /// Dirección física de la parada
  final String? direccion;

  /// Barrio donde se encuentra la parada
  final String? barrio;

  /// Comuna donde se encuentra la parada
  final String? comuna;

  /// Descripción adicional de la parada
  final String? descripcion;

  /// Indica si la parada tiene cobertura/techo
  final bool tieneCobertura;

  /// Indica si la parada tiene banco para sentarse
  final bool tieneBanco;

  /// Indica si la parada tiene iluminación
  final bool tieneIluminacion;

  /// Indica si la parada es accesible para personas con discapacidad
  final bool esAccesible;

  /// Lista de IDs de rutas que paran en esta parada
  final List<String> rutasQueParanAqui;

  /// Obtiene la latitud de la parada
  double get latitud => coordenadas.latitude;

  /// Obtiene la longitud de la parada
  double get longitud => coordenadas.longitude;

  /// Obtiene el nombre completo de la parada incluyendo barrio si está disponible
  String get nombreCompleto {
    if (barrio != null && barrio!.isNotEmpty) {
      return '$nombre - $barrio';
    }
    return nombre;
  }

  /// Obtiene la ubicación completa como string
  String get ubicacionCompleta {
    final partes = <String>[];

    if (direccion != null && direccion!.isNotEmpty) {
      partes.add(direccion!);
    }

    if (barrio != null && barrio!.isNotEmpty) {
      partes.add(barrio!);
    }

    if (comuna != null && comuna!.isNotEmpty) {
      partes.add('Comuna $comuna');
    }

    return partes.join(', ');
  }

  /// Calcula la distancia a otra parada en metros
  double distanciaA(Parada otraParada) {
    const distance = Distance();
    return distance.as(LengthUnit.Meter, coordenadas, otraParada.coordenadas);
  }

  /// Calcula la distancia a unas coordenadas específicas en metros
  double distanciaACoordenadas(LatLng coordenadas) {
    const distance = Distance();
    return distance.as(LengthUnit.Meter, this.coordenadas, coordenadas);
  }

  /// Verifica si una ruta específica para en esta parada
  bool atiendeLaRuta(String rutaId) {
    return rutasQueParanAqui.contains(rutaId);
  }

  /// Obtiene el número de rutas que paran en esta parada
  int get numeroDeRutas => rutasQueParanAqui.length;

  /// Indica si es una parada importante (terminal o intercambio)
  bool get esImportante =>
      tipo == TipoParada.terminal || tipo == TipoParada.intercambio;

  /// Obtiene un puntaje de comodidad basado en las amenidades
  int get puntajeComodidad {
    int puntaje = 0;
    if (tieneCobertura) puntaje += 2;
    if (tieneBanco) puntaje += 2;
    if (tieneIluminacion) puntaje += 1;
    if (esAccesible) puntaje += 2;
    return puntaje;
  }

  /// Crea una copia de la parada con algunos campos modificados
  Parada copyWith({
    String? id,
    String? nombre,
    LatLng? coordenadas,
    TipoParada? tipo,
    String? direccion,
    String? barrio,
    String? comuna,
    String? descripcion,
    bool? tieneCobertura,
    bool? tieneBanco,
    bool? tieneIluminacion,
    bool? esAccesible,
    List<String>? rutasQueParanAqui,
  }) {
    return Parada(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      coordenadas: coordenadas ?? this.coordenadas,
      tipo: tipo ?? this.tipo,
      direccion: direccion ?? this.direccion,
      barrio: barrio ?? this.barrio,
      comuna: comuna ?? this.comuna,
      descripcion: descripcion ?? this.descripcion,
      tieneCobertura: tieneCobertura ?? this.tieneCobertura,
      tieneBanco: tieneBanco ?? this.tieneBanco,
      tieneIluminacion: tieneIluminacion ?? this.tieneIluminacion,
      esAccesible: esAccesible ?? this.esAccesible,
      rutasQueParanAqui: rutasQueParanAqui ?? this.rutasQueParanAqui,
    );
  }

  @override
  List<Object?> get props => [
        id,
        nombre,
        coordenadas,
        tipo,
        direccion,
        barrio,
        comuna,
        descripcion,
        tieneCobertura,
        tieneBanco,
        tieneIluminacion,
        esAccesible,
        rutasQueParanAqui,
      ];

  @override
  String toString() {
    return 'Parada(id: $id, nombre: $nombre, tipo: $tipo, coordenadas: $coordenadas)';
  }
}

