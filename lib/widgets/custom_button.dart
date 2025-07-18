import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

enum ButtonType {
  primary,
  secondary,
  outlined,
  text,
  danger
}

enum ButtonSize {
  small,
  medium,
  large
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final ButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.width,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SizedBox(
      width: width,
      height: height ?? _getHeight(),
      child: _buildButton(theme),
    );
  }

  Widget _buildButton(ThemeData theme) {
    final content = _buildContent();
    
    switch (type) {
      case ButtonType.primary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: _getPrimaryStyle(),
          child: content,
        );
      case ButtonType.secondary:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: _getSecondaryStyle(),
          child: content,
        );
      case ButtonType.outlined:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: _getOutlinedStyle(),
          child: content,
        );
      case ButtonType.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: _getTextStyle(),
          child: content,
        );
      case ButtonType.danger:
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: _getDangerStyle(),
          child: content,
        );
    }
  }

  Widget _buildContent() {
    if (isLoading) {
      return SizedBox(
        height: _getIconSize(),
        width: _getIconSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(_getLoadingColor()),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: _getIconSize()),
          SizedBox(width: AppConstants.espaciadoPequeno),
          Text(text, style: TextStyle(fontSize: _getFontSize())),
        ],
      );
    }

    return Text(text, style: TextStyle(fontSize: _getFontSize()));
  }

  ButtonStyle _getPrimaryStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: AppConstants.colorPrimario,
      foregroundColor: Colors.white,
      padding: padding ?? _getPadding(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_getBorderRadius()),
      ),
      elevation: 2,
    );
  }

  ButtonStyle _getSecondaryStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.grey[200],
      foregroundColor: AppConstants.colorTexto,
      padding: padding ?? _getPadding(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_getBorderRadius()),
      ),
      elevation: 1,
    );
  }

  ButtonStyle _getOutlinedStyle() {
    return OutlinedButton.styleFrom(
      foregroundColor: AppConstants.colorPrimario,
      padding: padding ?? _getPadding(),
      side: const BorderSide(color: AppConstants.colorPrimario),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_getBorderRadius()),
      ),
    );
  }

  ButtonStyle _getTextStyle() {
    return TextButton.styleFrom(
      foregroundColor: AppConstants.colorPrimario,
      padding: padding ?? _getPadding(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_getBorderRadius()),
      ),
    );
  }

  ButtonStyle _getDangerStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: AppConstants.colorError,
      foregroundColor: Colors.white,
      padding: padding ?? _getPadding(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_getBorderRadius()),
      ),
      elevation: 2,
    );
  }

  double _getHeight() {
    switch (size) {
      case ButtonSize.small:
        return 36;
      case ButtonSize.medium:
        return 44;
      case ButtonSize.large:
        return 52;
    }
  }

  double _getFontSize() {
    switch (size) {
      case ButtonSize.small:
        return AppConstants.tamanotPequeno;
      case ButtonSize.medium:
        return AppConstants.tamanotCuerpo;
      case ButtonSize.large:
        return AppConstants.tamanotSubtitulo;
    }
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return 16;
      case ButtonSize.medium:
        return 20;
      case ButtonSize.large:
        return 24;
    }
  }

  double _getBorderRadius() {
    switch (size) {
      case ButtonSize.small:
        return AppConstants.radioBotonPequeno;
      case ButtonSize.medium:
        return AppConstants.radioBotonMedio;
      case ButtonSize.large:
        return AppConstants.radioBotonGrande;
    }
  }

  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 12);
    }
  }

  Color _getLoadingColor() {
    switch (type) {
      case ButtonType.primary:
      case ButtonType.danger:
        return Colors.white;
      case ButtonType.secondary:
      case ButtonType.outlined:
      case ButtonType.text:
        return AppConstants.colorPrimario;
    }
  }
}