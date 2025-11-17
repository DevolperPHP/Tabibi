import 'package:flutter/material.dart';

class ModernTheme {
  // Modern color palette inspired by Apple's design system
  static const Color primaryColor = Color(0xFF007AFF); // iOS Blue
  static const Color primaryBlue = Color(0xFF007AFF); // iOS Blue (alias)
  static const Color primaryDarkColor = Color(0xFF0056CC); // Darker blue
  static const Color secondaryColor = Color(0xFF5856D6); // iOS Purple
  static const Color successColor = Color(0xFF34C759); // iOS Green
  static const Color success = Color(0xFF34C759); // iOS Green (alias)
  static const Color warningColor = Color(0xFFFF9500); // iOS Orange
  static const Color errorColor = Color(0xFFFF3B30); // iOS Red
  static const Color error = Color(0xFFFF3B30); // iOS Red (alias)
  static const Color backgroundColor = Color(0xFFF2F2F7); // iOS Light Gray
  static const Color background = Color(0xFFF2F2F7); // iOS Light Gray (alias)
  static const Color surfaceColor = Color(0xFFFFFFFF); // Pure White
  static const Color surface = Color(0xFFFFFFFF); // Pure White (alias)
  static const Color cardColor = Color(0xFFFFFFFF); // Card White
  static const Color dividerColor = Color(0xFFE5E5EA); // iOS Divider
  static const Color divider = Color(0xFFE5E5EA); // iOS Divider (alias)
  static const Color textPrimaryColor = Color(0xFF000000); // Pure Black
  static const Color textPrimary = Color(0xFF000000); // Pure Black (alias)
  static const Color textSecondaryColor = Color(0xFF8E8E93); // iOS Gray
  static const Color textSecondary = Color(0xFF8E8E93); // iOS Gray (alias)
  static const Color textTertiaryColor = Color(0xFFC7C7CC); // Light Gray
  static const Color textTertiary = Color(0xFFC7C7CC); // Light Gray (alias)
  
  // Gradient colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF007AFF), Color(0xFF5856D6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8F9FA)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  // Shadow styles
  static List<BoxShadow> get lightShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> get mediumShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 15,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.12),
      blurRadius: 30,
      offset: const Offset(0, 8),
    ),
  ];
  
  static List<BoxShadow> get heavyShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.12),
      blurRadius: 20,
      offset: const Offset(0, 6),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.16),
      blurRadius: 40,
      offset: const Offset(0, 12),
    ),
  ];
  
  // Small shadow for cards and buttons
  static List<BoxShadow> get shadowSM => [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
  
  // Border radius values
  static const double radiusSmall = 8.0;
  static const double radiusSM = 8.0; // Alias
  static const double radiusMedium = 12.0;
  static const double radiusMD = 12.0; // Alias
  static const double radiusLarge = 16.0;
  static const double radiusLG = 16.0; // Alias
  static const double radiusXLarge = 20.0;
  static const double radiusXL = 20.0; // Alias
  static const double radiusXXLarge = 24.0;
  static const double radiusFull = 100.0; // Full radius for circular shapes
  
  // Spacing values
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;
  
  // Aliases for spacing
  static const double spaceXS = 4.0;
  static const double spaceSM = 8.0;
  static const double spaceMD = 16.0;
  static const double spaceLG = 24.0;
  static const double spaceXL = 32.0;
  static const double spaceXXL = 48.0;
  
  // Text styles
  static TextStyle get headline1 => const TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: textPrimaryColor,
    letterSpacing: -0.5,
  );
  
  static TextStyle get headline2 => const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
    letterSpacing: -0.25,
  );
  
  static TextStyle get headline3 => const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
  );
  
  static TextStyle get headline4 => const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
  );
  
  static TextStyle get bodyLarge => const TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: textPrimaryColor,
  );
  
  static TextStyle get bodyMedium => const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: textPrimaryColor,
  );
  
  static TextStyle get bodySmall => const TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: textSecondaryColor,
  );
  
  static TextStyle get caption => const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textTertiaryColor,
  );
  
  static TextStyle get labelMedium => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: textPrimaryColor,
  );
  
  static TextStyle get buttonLarge => const TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: surfaceColor,
  );
  
  static TextStyle get buttonMedium => const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: surfaceColor,
  );
}