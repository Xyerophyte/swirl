/// Dark Theme Configuration
/// Defines dark mode color palette and theme data
library;

import 'package:flutter/material.dart';
import 'swirl_colors.dart';
import 'swirl_typography.dart';

/// Dark Mode Color Palette
class SwirlDarkColors {
  // Primary Colors
  static const Color primary = Color(0xFFE8B4F0); // Lighter purple for dark mode
  static const Color primaryDark = Color(0xFFD89FE3);
  static const Color primaryLight = Color(0xFFF0C9F7);
  
  // Background Colors
  static const Color background = Color(0xFF121212); // True dark
  static const Color surface = Color(0xFF1E1E1E); // Elevated surface
  static const Color surfaceVariant = Color(0xFF2C2C2C); // Cards
  
  // Text Colors
  static const Color textPrimary = Color(0xFFE0E0E0); // High emphasis
  static const Color textSecondary = Color(0xFFB0B0B0); // Medium emphasis
  static const Color textTertiary = Color(0xFF808080); // Low emphasis
  static const Color textDisabled = Color(0xFF606060);
  
  // Semantic Colors
  static const Color success = Color(0xFF66BB6A); // Softer green
  static const Color warning = Color(0xFFFFB74D); // Softer orange
  static const Color error = Color(0xFFEF5350); // Softer red
  static const Color info = Color(0xFF42A5F5); // Softer blue
  
  // Border & Divider
  static const Color border = Color(0xFF404040);
  static const Color divider = Color(0xFF303030);
  
  // Shadow (for elevated elements)
  static const Color shadow = Color(0x40000000); // Softer shadows
  
  // Overlay
  static const Color overlay = Color(0x20FFFFFF); // Light overlay on dark
  static const Color scrim = Color(0xCC000000);
}

/// Dark Theme Data
class SwirlDarkTheme {
  static ThemeData get theme {
    return ThemeData(
      // Brightness
      brightness: Brightness.dark,
      
      // Color Scheme
      colorScheme: ColorScheme.dark(
        primary: SwirlDarkColors.primary,
        secondary: SwirlDarkColors.primaryDark,
        surface: SwirlDarkColors.surface,
        error: SwirlDarkColors.error,
        onPrimary: SwirlDarkColors.background,
        onSecondary: SwirlDarkColors.background,
        onSurface: SwirlDarkColors.textPrimary,
        onError: Colors.white,
      ),
      
      // Scaffold
      scaffoldBackgroundColor: SwirlDarkColors.background,
      
      // App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: SwirlDarkColors.surface,
        foregroundColor: SwirlDarkColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: SwirlTypography.headingLg.copyWith(
          color: SwirlDarkColors.textPrimary,
        ),
      ),
      
      // Card
      cardTheme: const CardThemeData(
        color: SwirlDarkColors.surfaceVariant,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      
      // Text Theme
      textTheme: TextTheme(
        displayLarge: SwirlTypography.headingXl.copyWith(color: SwirlDarkColors.textPrimary),
        displayMedium: SwirlTypography.headingLg.copyWith(color: SwirlDarkColors.textPrimary),
        displaySmall: SwirlTypography.headingMedium.copyWith(color: SwirlDarkColors.textPrimary),
        headlineMedium: SwirlTypography.headingSmall.copyWith(color: SwirlDarkColors.textPrimary),
        titleLarge: SwirlTypography.cardTitle.copyWith(color: SwirlDarkColors.textPrimary),
        titleMedium: SwirlTypography.cardSubtitle.copyWith(color: SwirlDarkColors.textSecondary),
        bodyLarge: SwirlTypography.bodyLarge.copyWith(color: SwirlDarkColors.textPrimary),
        bodyMedium: SwirlTypography.bodyMedium.copyWith(color: SwirlDarkColors.textSecondary),
        bodySmall: SwirlTypography.caption.copyWith(color: SwirlDarkColors.textTertiary),
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: SwirlDarkColors.textSecondary,
        size: 24,
      ),
      
      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: SwirlDarkColors.primary,
          foregroundColor: SwirlDarkColors.background,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: SwirlDarkColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: SwirlDarkColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: SwirlDarkColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: SwirlDarkColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: SwirlDarkColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: SwirlDarkColors.error),
        ),
        labelStyle: TextStyle(color: SwirlDarkColors.textSecondary),
        hintStyle: TextStyle(color: SwirlDarkColors.textTertiary),
      ),
      
      // Divider
      dividerTheme: const DividerThemeData(
        color: SwirlDarkColors.divider,
        thickness: 1,
      ),
      
      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: SwirlDarkColors.surface,
        selectedItemColor: SwirlDarkColors.primary,
        unselectedItemColor: SwirlDarkColors.textTertiary,
        elevation: 8,
      ),
      
      // Dialog
      dialogTheme: const DialogThemeData(
        backgroundColor: SwirlDarkColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
      
      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: SwirlDarkColors.surfaceVariant,
        contentTextStyle: TextStyle(color: SwirlDarkColors.textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      
      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: SwirlDarkColors.surfaceVariant,
        disabledColor: SwirlDarkColors.surfaceVariant.withOpacity(0.5),
        selectedColor: SwirlDarkColors.primary.withOpacity(0.3),
        labelStyle: TextStyle(color: SwirlDarkColors.textPrimary),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      
      // Progress Indicator
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: SwirlDarkColors.primary,
      ),
      
      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return SwirlDarkColors.primary;
          }
          return SwirlDarkColors.textTertiary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return SwirlDarkColors.primary.withOpacity(0.5);
          }
          return SwirlDarkColors.border;
        }),
      ),
    );
  }
}