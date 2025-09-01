import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Configuración de voz para navegación
class VoiceSettings {
  final double baseVolume;
  final double speechRate;
  final bool useLocalTerms;
  final VoiceGender preferredGender;
  final bool enableNoiseAdjustment;
  final String language;

  const VoiceSettings({
    this.baseVolume = 0.8,
    this.speechRate = 0.5,
    this.useLocalTerms = true,
    this.preferredGender = VoiceGender.female,
    this.enableNoiseAdjustment = true,
    this.language = 'es-CO', // Español colombiano
  });
}

enum VoiceGender { male, female }

/// Localización específica para Popayán
class PopayanLocalization {
  static const Map<String, String> localTerms = {
    'centro_historico': 'el centro',
    'galeria_central': 'la galería',
    'terminal_transportes': 'el terminal',
    'universidad_cauca': 'la Unicauca',
    'hospital_san_jose': 'el San José',
    'plaza_caldas': 'la plaza de Caldas',
    'zona_rosa': 'la zona rosa',
    'barrio_norte': 'el barrio norte',
    'barrio_sur': 'el barrio sur',
    'aeropuerto': 'el aeropuerto Guillermo León Valencia',
    'panamericana': 'la vía Panamericana',
    'esmeralda': 'la Esmeralda',
  };

  static const Map<String, String> directions = {
    'turn_left': 'gire a la izquierda',
    'turn_right': 'gire a la derecha',
    'continue_straight': 'continúe derecho',
    'slight_left': 'tome ligeramente a la izquierda',
    'slight_right': 'tome ligeramente a la derecha',
    'sharp_left': 'gire completamente a la izquierda',
    'sharp_right': 'gire completamente a la derecha',
    'u_turn': 'dé la vuelta',
    'arrive': 'ha llegado a su destino',
  };

  static const Map<String, String> distances = {
    'in_meters': 'en {distance} metros',
    'in_kilometers': 'en {distance} kilómetros',
    'now': 'ahora',
    'soon': 'próximamente',
  };
}

/// Instrucción de navegación para voz
class NavigationInstruction {
  final String type;
  final String streetName;
  final double distanceInMeters;
  final String? landmark;
  final bool isUrgent;

  const NavigationInstruction({
    required this.type,
    required this.streetName,
    required this.distanceInMeters,
    this.landmark,
    this.isUrgent = false,
  });
}

/// Servicio de navegación por voz inteligente
class VoiceNavigationService {
  static final VoiceNavigationService _instance =
      VoiceNavigationService._internal();
  factory VoiceNavigationService() => _instance;
  VoiceNavigationService._internal();

  FlutterTts? _flutterTts;

  VoiceSettings _settings = const VoiceSettings();
  bool _isInitialized = false;
  bool _isSpeaking = false;
  Timer? _volumeAdjustmentTimer;

  /// Inicializa el servicio de voz
  Future<void> initializeVoice(VoiceSettings settings) async {
    _settings = settings;

    try {
      // Inicializar TTS
      _flutterTts = FlutterTts();

      // Configurar idioma
      await _flutterTts!.setLanguage(_settings.language);

      // Configurar velocidad de habla
      await _flutterTts!.setSpeechRate(_settings.speechRate);

      // Configurar volumen base
      await _flutterTts!.setVolume(_settings.baseVolume);

      // Configurar género de voz si está disponible
      await _configureVoiceGender();

      // Configurar callbacks
      _flutterTts!.setStartHandler(() {
        _isSpeaking = true;
      });

      _flutterTts!.setCompletionHandler(() {
        _isSpeaking = false;
      });

      _flutterTts!.setErrorHandler((msg) {
        debugPrint('Error TTS: $msg');
        _isSpeaking = false;
      });

      // Nota: Medidor de ruido deshabilitado temporalmente

      _isInitialized = true;
      debugPrint('VoiceNavigationService inicializado correctamente');
    } catch (e) {
      debugPrint('Error inicializando VoiceNavigationService: $e');
      _isInitialized = false;
    }
  }

  /// Configura el género de voz preferido
  Future<void> _configureVoiceGender() async {
    try {
      if (Platform.isAndroid) {
        // En Android, intentar configurar voz específica
        final voices = await _flutterTts!.getVoices;
        if (voices != null) {
          // Buscar voz en español colombiano
          final spanishVoices = voices
              .where((voice) => voice['locale'].toString().startsWith('es'))
              .toList();

          if (spanishVoices.isNotEmpty) {
            // Preferir voz femenina si está disponible
            final preferredVoice = spanishVoices.firstWhere(
              (voice) =>
                  voice['name'].toString().toLowerCase().contains('female') ||
                  voice['name'].toString().toLowerCase().contains('mujer'),
              orElse: () => spanishVoices.first,
            );

            await _flutterTts!.setVoice({
              'name': preferredVoice['name'],
              'locale': preferredVoice['locale']
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Error configurando género de voz: $e');
    }
  }

  /// Reproduce una instrucción de navegación
  Future<void> speakInstruction(NavigationInstruction instruction) async {
    if (!_isInitialized || _flutterTts == null) {
      debugPrint('VoiceNavigationService no está inicializado');
      return;
    }

    try {
      // Detener cualquier reproducción anterior
      await _flutterTts!.stop();

      // Generar texto localizado
      final localizedText = _localizeInstruction(instruction);

      // Reproducir instrucción
      await _flutterTts!.speak(localizedText);

      debugPrint('Reproduciendo: $localizedText');
    } catch (e) {
      debugPrint('Error reproduciendo instrucción: $e');
    }
  }

  /// Localiza una instrucción usando términos de Popayán
  String _localizeInstruction(NavigationInstruction instruction) {
    String text = '';

    // Agregar distancia si es relevante
    if (instruction.distanceInMeters > 0) {
      if (instruction.distanceInMeters < 50) {
        text += 'Ahora, ';
      } else if (instruction.distanceInMeters < 200) {
        text += 'En ${instruction.distanceInMeters.round()} metros, ';
      } else if (instruction.distanceInMeters < 1000) {
        text += 'En ${instruction.distanceInMeters.round()} metros, ';
      } else {
        final km = (instruction.distanceInMeters / 1000).toStringAsFixed(1);
        text += 'En $km kilómetros, ';
      }
    }

    // Agregar instrucción de dirección
    final direction =
        PopayanLocalization.directions[instruction.type] ?? instruction.type;
    text += direction;

    // Agregar nombre de calle localizado
    if (instruction.streetName.isNotEmpty) {
      final localizedStreet = _localizeStreetName(instruction.streetName);
      text += ' hacia $localizedStreet';
    }

    // Agregar punto de referencia si existe
    if (instruction.landmark != null && instruction.landmark!.isNotEmpty) {
      final localizedLandmark = _localizeLandmark(instruction.landmark!);
      text += ', cerca de $localizedLandmark';
    }

    return text;
  }

  /// Localiza nombres de calles usando términos conocidos de Popayán
  String _localizeStreetName(String streetName) {
    if (!_settings.useLocalTerms) return streetName;

    String localizedName = streetName.toLowerCase();

    // Reemplazar términos conocidos
    PopayanLocalization.localTerms.forEach((key, value) {
      localizedName = localizedName.replaceAll(key, value);
    });

    return localizedName;
  }

  /// Localiza puntos de referencia
  String _localizeLandmark(String landmark) {
    if (!_settings.useLocalTerms) return landmark;

    String localizedLandmark = landmark.toLowerCase();

    // Reemplazar términos conocidos
    PopayanLocalization.localTerms.forEach((key, value) {
      localizedLandmark = localizedLandmark.replaceAll(key, value);
    });

    return localizedLandmark;
  }

  /// Reproduce un mensaje personalizado
  Future<void> speakMessage(String message) async {
    if (!_isInitialized || _flutterTts == null) return;

    try {
      await _flutterTts!.stop();
      await _flutterTts!.speak(message);
    } catch (e) {
      debugPrint('Error reproduciendo mensaje: $e');
    }
  }

  /// Detiene la reproducción actual
  Future<void> stop() async {
    if (_flutterTts != null) {
      await _flutterTts!.stop();
    }
    _isSpeaking = false;
  }

  /// Pausa la reproducción
  Future<void> pause() async {
    if (_flutterTts != null) {
      await _flutterTts!.pause();
    }
  }

  /// Obtiene el nivel de ruido ambiente actual (deshabilitado temporalmente)
  Stream<double> getAmbientNoiseLevel() {
    return Stream.empty();
  }

  /// Actualiza la configuración de voz
  Future<void> updateSettings(VoiceSettings newSettings) async {
    _settings = newSettings;

    if (_flutterTts != null) {
      await _flutterTts!.setLanguage(_settings.language);
      await _flutterTts!.setSpeechRate(_settings.speechRate);
      await _flutterTts!.setVolume(_settings.baseVolume);
      await _configureVoiceGender();
    }
  }

  /// Verifica si el servicio está hablando actualmente
  bool get isSpeaking => _isSpeaking;

  /// Verifica si el servicio está inicializado
  bool get isInitialized => _isInitialized;

  /// Obtiene la configuración actual
  VoiceSettings get currentSettings => _settings;

  /// Libera recursos
  void dispose() {
    _volumeAdjustmentTimer?.cancel();
    _flutterTts?.stop();
  }
}
