import 'package:equatable/equatable.dart';

/// Tipos de usuario en el sistema
enum TipoUsuario {
  pasajero,
  conductor,
  administrador;

  /// Convierte un string a TipoUsuario
  static TipoUsuario fromString(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'pasajero':
        return TipoUsuario.pasajero;
      case 'conductor':
        return TipoUsuario.conductor;
      case 'administrador':
        return TipoUsuario.administrador;
      default:
        return TipoUsuario.pasajero;
    }
  }

  /// Convierte TipoUsuario a string para mostrar
  String get displayName {
    switch (this) {
      case TipoUsuario.pasajero:
        return 'Pasajero';
      case TipoUsuario.conductor:
        return 'Conductor';
      case TipoUsuario.administrador:
        return 'Administrador';
    }
  }
}

/// Entidad que representa un usuario del sistema
class Usuario extends Equatable {
  const Usuario({
    required this.id,
    required this.email,
    required this.nombre,
    required this.tipo,
    this.apellido,
    this.telefono,
    this.fechaNacimiento,
    this.fotoPerfil,
    this.fechaRegistro,
    this.ultimoAcceso,
    this.isActivo = true,
    this.preferencias = const {},
  });

  /// Identificador único del usuario
  final String id;

  /// Correo electrónico del usuario (único)
  final String email;

  /// Nombre del usuario
  final String nombre;

  /// Tipo de usuario
  final TipoUsuario tipo;

  /// Apellido del usuario
  final String? apellido;

  /// Número de teléfono del usuario
  final String? telefono;

  /// Fecha de nacimiento del usuario
  final DateTime? fechaNacimiento;

  /// URL de la foto de perfil del usuario
  final String? fotoPerfil;

  /// Fecha de registro en el sistema
  final DateTime? fechaRegistro;

  /// Fecha del último acceso al sistema
  final DateTime? ultimoAcceso;

  /// Indica si el usuario está activo
  final bool isActivo;

  /// Preferencias del usuario (notificaciones, tema, etc.)
  final Map<String, dynamic> preferencias;

  /// Obtiene el nombre completo del usuario
  String get nombreCompleto {
    if (apellido != null && apellido!.isNotEmpty) {
      return '$nombre $apellido';
    }
    return nombre;
  }

  /// Obtiene las iniciales del usuario para mostrar en avatar
  String get iniciales {
    final nombreParts = nombre.split(' ');
    final apellidoParts = apellido?.split(' ') ?? [];

    String iniciales = '';

    if (nombreParts.isNotEmpty) {
      iniciales += nombreParts.first.substring(0, 1).toUpperCase();
    }

    if (apellidoParts.isNotEmpty) {
      iniciales += apellidoParts.first.substring(0, 1).toUpperCase();
    } else if (nombreParts.length > 1) {
      iniciales += nombreParts[1].substring(0, 1).toUpperCase();
    }

    return iniciales;
  }

  /// Calcula la edad del usuario si tiene fecha de nacimiento
  int? get edad {
    if (fechaNacimiento == null) return null;

    final now = DateTime.now();
    int edad = now.year - fechaNacimiento!.year;

    if (now.month < fechaNacimiento!.month ||
        (now.month == fechaNacimiento!.month &&
            now.day < fechaNacimiento!.day)) {
      edad--;
    }

    return edad;
  }

  /// Indica si el usuario es mayor de edad
  bool get esMayorDeEdad {
    final edadUsuario = edad;
    return edadUsuario != null && edadUsuario >= 18;
  }

  /// Obtiene una preferencia específica
  T? getPreferencia<T>(String key) {
    return preferencias[key] as T?;
  }

  /// Verifica si tiene una preferencia específica habilitada
  bool tienePreferenciaHabilitada(String key) {
    return getPreferencia<bool>(key) ?? false;
  }

  /// Indica si el usuario tiene permisos de administrador
  bool get esAdministrador => tipo == TipoUsuario.administrador;

  /// Indica si el usuario es conductor
  bool get esConductor => tipo == TipoUsuario.conductor;

  /// Indica si el usuario es pasajero
  bool get esPasajero => tipo == TipoUsuario.pasajero;

  /// Indica si el perfil está completo
  bool get perfilCompleto {
    return nombre.isNotEmpty &&
        email.isNotEmpty &&
        apellido != null &&
        apellido!.isNotEmpty;
  }

  /// Calcula los días desde el registro
  int? get diasDesdeRegistro {
    if (fechaRegistro == null) return null;
    return DateTime.now().difference(fechaRegistro!).inDays;
  }

  /// Indica si es un usuario nuevo (menos de 7 días)
  bool get esUsuarioNuevo {
    final dias = diasDesdeRegistro;
    return dias != null && dias < 7;
  }

  /// Crea una copia del usuario con algunos campos modificados
  Usuario copyWith({
    String? id,
    String? email,
    String? nombre,
    TipoUsuario? tipo,
    String? apellido,
    String? telefono,
    DateTime? fechaNacimiento,
    String? fotoPerfil,
    DateTime? fechaRegistro,
    DateTime? ultimoAcceso,
    bool? isActivo,
    Map<String, dynamic>? preferencias,
  }) {
    return Usuario(
      id: id ?? this.id,
      email: email ?? this.email,
      nombre: nombre ?? this.nombre,
      tipo: tipo ?? this.tipo,
      apellido: apellido ?? this.apellido,
      telefono: telefono ?? this.telefono,
      fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
      fotoPerfil: fotoPerfil ?? this.fotoPerfil,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
      ultimoAcceso: ultimoAcceso ?? this.ultimoAcceso,
      isActivo: isActivo ?? this.isActivo,
      preferencias: preferencias ?? this.preferencias,
    );
  }

  /// Actualiza las preferencias del usuario
  Usuario actualizarPreferencias(Map<String, dynamic> nuevasPreferencias) {
    final preferenciasCombinadas = Map<String, dynamic>.from(preferencias);
    preferenciasCombinadas.addAll(nuevasPreferencias);

    return copyWith(preferencias: preferenciasCombinadas);
  }

  /// Actualiza una preferencia específica
  Usuario actualizarPreferencia(String key, dynamic value) {
    return actualizarPreferencias({key: value});
  }

  @override
  List<Object?> get props => [
        id,
        email,
        nombre,
        tipo,
        apellido,
        telefono,
        fechaNacimiento,
        fotoPerfil,
        fechaRegistro,
        ultimoAcceso,
        isActivo,
        preferencias,
      ];

  @override
  String toString() {
    return 'Usuario(id: $id, email: $email, nombre: $nombreCompleto, tipo: $tipo)';
  }
}

