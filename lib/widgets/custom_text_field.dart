import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final void Function(String)? onFieldSubmitted;
  final bool enabled;
  final bool readOnly;
  final int maxLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;
  final bool autofocus;

  const CustomTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.onTap,
    this.onFieldSubmitted,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.textInputAction,
    this.focusNode,
    this.contentPadding,
    this.autofocus = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onTap: widget.onTap,
      onFieldSubmitted: widget.onFieldSubmitted,
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      textInputAction: widget.textInputAction,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      style: TextStyle(
        fontSize: AppConstants.tamanotCuerpo,
        color: widget.enabled ? AppConstants.colorTexto : Colors.grey[600],
      ),
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        helperText: widget.helperText,
        errorText: widget.errorText,
        prefixIcon: widget.prefixIcon != null 
            ? Icon(widget.prefixIcon, color: AppConstants.colorPrimario)
            : null,
        suffixIcon: _buildSuffixIcon(),
        contentPadding: widget.contentPadding ?? const EdgeInsets.symmetric(
          horizontal: AppConstants.espaciadoMedio,
          vertical: AppConstants.espaciadoPequeno,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radioBotonMedio),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radioBotonMedio),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radioBotonMedio),
          borderSide: const BorderSide(color: AppConstants.colorPrimario, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radioBotonMedio),
          borderSide: const BorderSide(color: AppConstants.colorError),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radioBotonMedio),
          borderSide: const BorderSide(color: AppConstants.colorError, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radioBotonMedio),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        filled: true,
        fillColor: widget.enabled ? Colors.white : Colors.grey[50],
        labelStyle: TextStyle(
          color: Colors.grey[600],
          fontSize: AppConstants.tamanotCuerpo,
        ),
        hintStyle: TextStyle(
          color: Colors.grey[400],
          fontSize: AppConstants.tamanotCuerpo,
        ),
        helperStyle: TextStyle(
          color: Colors.grey[600],
          fontSize: AppConstants.tamanotPequeno,
        ),
        errorStyle: const TextStyle(
          color: AppConstants.colorError,
          fontSize: AppConstants.tamanotPequeno,
        ),
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    // Si es un campo de contraseña, mostrar icono de visibilidad
    if (widget.obscureText) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey[600],
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }

    // Si hay un icono personalizado, mostrarlo
    if (widget.suffixIcon != null) {
      return IconButton(
        icon: Icon(widget.suffixIcon, color: AppConstants.colorPrimario),
        onPressed: widget.onSuffixIconPressed,
      );
    }

    return null;
  }
}

// Widget especializado para campos de búsqueda
class SearchTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final void Function(String)? onChanged;
  final VoidCallback? onClear;
  final bool showClearButton;

  const SearchTextField({
    super.key,
    this.controller,
    this.hintText = 'Buscar...',
    this.onChanged,
    this.onClear,
    this.showClearButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      hintText: hintText,
      prefixIcon: Icons.search,
      suffixIcon: showClearButton && 
                  controller != null && 
                  controller!.text.isNotEmpty 
          ? Icons.clear 
          : null,
      onSuffixIconPressed: onClear ?? () => controller?.clear(),
      onChanged: onChanged,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
    );
  }
}