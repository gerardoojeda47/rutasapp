import 'package:flutter/material.dart';
import '../../core/services/voice_navigation_service.dart';

/// Widget para configurar las opciones de navegación por voz
class VoiceSettingsWidget extends StatefulWidget {
  final VoiceSettings initialSettings;
  final Function(VoiceSettings) onSettingsChanged;

  const VoiceSettingsWidget({
    super.key,
    required this.initialSettings,
    required this.onSettingsChanged,
  });

  @override
  State<VoiceSettingsWidget> createState() => _VoiceSettingsWidgetState();
}

class _VoiceSettingsWidgetState extends State<VoiceSettingsWidget> {
  late VoiceSettings _currentSettings;
  final VoiceNavigationService _voiceService = VoiceNavigationService();

  @override
  void initState() {
    super.initState();
    _currentSettings = widget.initialSettings;
  }

  void _updateSettings(VoiceSettings newSettings) {
    setState(() {
      _currentSettings = newSettings;
    });
    widget.onSettingsChanged(newSettings);
  }

  Future<void> _testVoice() async {
    await _voiceService.speakMessage(
        'Hola, esta es una prueba de la navegación por voz de RouWhite. '
        'En 200 metros, gire a la derecha hacia el centro de Popayán.');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Título
          Row(
            children: [
              const Icon(
                Icons.record_voice_over,
                color: Color(0xFFFF6A00),
                size: 28,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Configuración de Voz',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: _testVoice,
                icon: const Icon(Icons.play_circle_outline),
                tooltip: 'Probar voz',
              ),
            ],
          ),
          const SizedBox(height: 30),

          // Volumen
          _buildSliderSetting(
            'Volumen',
            Icons.volume_up,
            _currentSettings.baseVolume,
            0.0,
            1.0,
            (value) =>
                _updateSettings(_currentSettings.copyWith(baseVolume: value)),
            valueFormatter: (value) => '${(value * 100).round()}%',
          ),

          const SizedBox(height: 20),

          // Velocidad de habla
          _buildSliderSetting(
            'Velocidad de Habla',
            Icons.speed,
            _currentSettings.speechRate,
            0.1,
            1.0,
            (value) =>
                _updateSettings(_currentSettings.copyWith(speechRate: value)),
            valueFormatter: (value) => value < 0.3
                ? 'Lenta'
                : value < 0.7
                    ? 'Normal'
                    : 'Rápida',
          ),

          const SizedBox(height: 20),

          // Términos locales
          _buildSwitchSetting(
            'Usar Términos Locales',
            'Usar nombres conocidos de Popayán (ej: "la galería", "el centro")',
            Icons.location_city,
            _currentSettings.useLocalTerms,
            (value) => _updateSettings(
                _currentSettings.copyWith(useLocalTerms: value)),
          ),

          const SizedBox(height: 20),

          // Ajuste automático de volumen
          _buildSwitchSetting(
            'Ajuste Automático de Volumen',
            'Aumentar volumen automáticamente en ambientes ruidosos',
            Icons.auto_fix_high,
            _currentSettings.enableNoiseAdjustment,
            (value) => _updateSettings(
                _currentSettings.copyWith(enableNoiseAdjustment: value)),
          ),

          const SizedBox(height: 20),

          // Género de voz
          _buildGenderSetting(),

          const SizedBox(height: 30),

          // Botones de acción
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _voiceService.updateSettings(_currentSettings);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6A00),
                  ),
                  child: const Text(
                    'Guardar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSliderSetting(
    String title,
    IconData icon,
    double value,
    double min,
    double max,
    Function(double) onChanged, {
    String Function(double)? valueFormatter,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Text(
              valueFormatter?.call(value) ?? value.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: const Color(0xFFFF6A00),
            thumbColor: const Color(0xFFFF6A00),
            overlayColor: const Color(0xFFFF6A00).withValues(alpha: 0.2),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchSetting(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    Function(bool) onChanged,
  ) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFFF6A00).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFFF6A00),
            size: 20,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFFFF6A00),
        ),
      ],
    );
  }

  Widget _buildGenderSetting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.person, size: 20, color: Colors.grey[600]),
            const SizedBox(width: 8),
            const Text(
              'Género de Voz',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildGenderOption(
                'Femenina',
                Icons.woman,
                VoiceGender.female,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildGenderOption(
                'Masculina',
                Icons.man,
                VoiceGender.male,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderOption(String label, IconData icon, VoiceGender gender) {
    final isSelected = _currentSettings.preferredGender == gender;

    return GestureDetector(
      onTap: () =>
          _updateSettings(_currentSettings.copyWith(preferredGender: gender)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFFF6A00).withValues(alpha: 0.1)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF6A00) : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFFFF6A00) : Colors.grey[600],
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFFFF6A00) : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Extensión para crear copias de VoiceSettings con cambios
extension VoiceSettingsCopyWith on VoiceSettings {
  VoiceSettings copyWith({
    double? baseVolume,
    double? speechRate,
    bool? useLocalTerms,
    VoiceGender? preferredGender,
    bool? enableNoiseAdjustment,
    String? language,
  }) {
    return VoiceSettings(
      baseVolume: baseVolume ?? this.baseVolume,
      speechRate: speechRate ?? this.speechRate,
      useLocalTerms: useLocalTerms ?? this.useLocalTerms,
      preferredGender: preferredGender ?? this.preferredGender,
      enableNoiseAdjustment:
          enableNoiseAdjustment ?? this.enableNoiseAdjustment,
      language: language ?? this.language,
    );
  }
}

