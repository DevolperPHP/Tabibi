import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/constants/modern_theme.dart';

class ModernButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final double? height;
  final double? width;
  final ButtonType buttonType;

  const ModernButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.height,
    this.width,
    this.buttonType = ButtonType.primary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = _getButtonColors();
    
    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: height ?? 50.h,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: buttonType == ButtonType.primary 
              ? ModernTheme.primaryGradient 
              : null,
          color: buttonType != ButtonType.primary 
              ? colors['background'] 
              : null,
          borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
          boxShadow: onPressed != null && !isLoading 
              ? [
                  BoxShadow(
                    color: colors['shadow']!.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: ModernTheme.spaceLG),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ModernTheme.radiusMD),
              ),
              child: Center(
                child: isLoading
                    ? _buildLoadingIndicator(colors['text']!)
                    : _buildButtonContent(colors['text']!),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(Color textColor) {
    return SizedBox(
      width: 20.h,
      height: 20.h,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(textColor),
      ),
    );
  }

  Widget _buildButtonContent(Color textColor) {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: ModernTheme.bodyLarge.copyWith(
              color: textColor,
            ),
          ),
          SizedBox(width: ModernTheme.spaceSM),
          Icon(
            icon,
            color: textColor,
            size: 20,
          ),
        ],
      );
    }
    
    return Text(
      text,
      style: ModernTheme.buttonLarge.copyWith(
        color: textColor,
      ),
    );
  }

  Map<String, Color> _getButtonColors() {
    switch (buttonType) {
      case ButtonType.primary:
        return {
          'background': backgroundColor ?? ModernTheme.primaryBlue,
          'text': textColor ?? ModernTheme.surface,
          'shadow': ModernTheme.primaryBlue,
        };
      case ButtonType.secondary:
        return {
          'background': backgroundColor ?? ModernTheme.surface,
          'text': textColor ?? ModernTheme.primaryBlue,
          'shadow': ModernTheme.primaryBlue,
        };
      case ButtonType.outline:
        return {
          'background': Colors.transparent,
          'text': textColor ?? ModernTheme.primaryBlue,
          'shadow': ModernTheme.primaryBlue,
        };
      case ButtonType.success:
        return {
          'background': backgroundColor ?? ModernTheme.success,
          'text': textColor ?? ModernTheme.surface,
          'shadow': ModernTheme.success,
        };
      case ButtonType.danger:
        return {
          'background': backgroundColor ?? ModernTheme.error,
          'text': textColor ?? ModernTheme.surface,
          'shadow': ModernTheme.error,
        };
    }
  }
}

enum ButtonType {
  primary,
  secondary,
  outline,
  success,
  danger,
}

class ModernIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? size;
  final bool isLoading;

  const ModernIconButton({
    Key? key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.backgroundColor,
    this.iconColor,
    this.size,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonSize = size ?? 40.h;
    final colors = _getButtonColors();
    
    return Tooltip(
      message: tooltip ?? '',
      child: SizedBox(
        width: buttonSize,
        height: buttonSize,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: colors['background'],
            borderRadius: BorderRadius.circular(buttonSize / 2),
            boxShadow: onPressed != null && !isLoading 
                ? [
                    BoxShadow(
                      color: colors['shadow']!.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isLoading ? null : onPressed,
              borderRadius: BorderRadius.circular(buttonSize / 2),
              child: Container(
                width: buttonSize,
                height: buttonSize,
                child: Center(
                  child: isLoading
                      ? SizedBox(
                          width: buttonSize * 0.4,
                          height: buttonSize * 0.4,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(colors['icon']!),
                          ),
                        )
                      : Icon(
                          icon,
                          color: colors['icon'],
                          size: buttonSize * 0.5,
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Map<String, Color> _getButtonColors() {
    return {
      'background': backgroundColor ?? ModernTheme.surface,
      'icon': iconColor ?? ModernTheme.primaryBlue,
      'shadow': iconColor ?? ModernTheme.primaryBlue,
    };
  }
}

class ModernTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? textColor;
  final IconData? icon;
  final bool isUnderlined;

  const ModernTextButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.textColor,
    this.icon,
    this.isUnderlined = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(ModernTheme.radiusSM),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ModernTheme.spaceSM,
            vertical: ModernTheme.spaceXS,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: ModernTheme.bodyMedium.copyWith(
                  color: textColor ?? ModernTheme.primaryBlue,
                  decoration: isUnderlined ? TextDecoration.underline : TextDecoration.none,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (icon != null) ...[
                SizedBox(width: ModernTheme.spaceXS),
                Icon(
                  icon,
                  color: textColor ?? ModernTheme.primaryBlue,
                  size: 16,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
