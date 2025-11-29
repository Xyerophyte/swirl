import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'swirl_colors.dart';
import 'swirl_typography.dart';
import '../constants/app_constants.dart';

/// SWIRL Theme Configuration
/// Comfortable, soothing design system
class SwirlTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: SwirlTypography.fontFamily,
      scaffoldBackgroundColor: SwirlColors.background,
      
      // Color Scheme
      colorScheme: ColorScheme.light(
        primary: SwirlColors.primary,
        secondary: SwirlColors.accent,
        surface: SwirlColors.surface,
        error: SwirlColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: SwirlColors.textPrimary,
        onError: Colors.white,
      ),
      
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: SwirlColors.surface,
        foregroundColor: SwirlColors.textPrimary,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        titleTextStyle: SwirlTypography.detailTitle,
        iconTheme: IconThemeData(
          color: SwirlColors.textPrimary,
          size: 24,
        ),
      ),
      
      // Text Theme
      textTheme: const TextTheme(
        displayLarge: SwirlTypography.detailTitle,
        displayMedium: SwirlTypography.cardTitle,
        bodyLarge: SwirlTypography.bodyLarge,
        bodyMedium: SwirlTypography.bodyMedium,
        bodySmall: SwirlTypography.bodySmall,
        labelLarge: SwirlTypography.button,
        labelMedium: SwirlTypography.buttonSmall,
        labelSmall: SwirlTypography.caption,
      ),
      
      // Card Theme
      cardTheme: CardThemeData(
        elevation: 8,
        shadowColor: Colors.black.withOpacity(AppConstants.shadowOpacity),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusCard),
        ),
        color: SwirlColors.surface,
        margin: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMd,
          vertical: AppConstants.spacingXl,
        ),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: SwirlColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusButtonLarge),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingLg,
            vertical: AppConstants.spacingMd,
          ),
          textStyle: SwirlTypography.button,
        ),
      ),
      
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: SwirlColors.primary,
          side: const BorderSide(
            color: SwirlColors.border,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusButtonLarge),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingLg,
            vertical: AppConstants.spacingMd,
          ),
          textStyle: SwirlTypography.button,
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: SwirlColors.primary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingMd,
            vertical: AppConstants.spacingSm,
          ),
          textStyle: SwirlTypography.buttonSmall,
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: SwirlColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusInput),
          borderSide: const BorderSide(
            color: SwirlColors.border,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusInput),
          borderSide: const BorderSide(
            color: SwirlColors.border,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusInput),
          borderSide: const BorderSide(
            color: SwirlColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusInput),
          borderSide: const BorderSide(
            color: SwirlColors.error,
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMd,
          vertical: AppConstants.spacingMd,
        ),
        hintStyle: SwirlTypography.bodyMedium.copyWith(
          color: SwirlColors.textTertiary,
        ),
      ),
      
      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: SwirlColors.surface,
        selectedColor: SwirlColors.primary,
        disabledColor: SwirlColors.borderLight,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingMd,
          vertical: AppConstants.spacingSm,
        ),
        labelStyle: SwirlTypography.badge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusChip),
          side: const BorderSide(
            color: SwirlColors.border,
            width: 1,
          ),
        ),
      ),
      
      // Bottom Sheet Theme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: SwirlColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppConstants.radiusModal),
          ),
        ),
        elevation: 16,
      ),
      
      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: SwirlColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusModal),
        ),
        elevation: 24,
      ),
      
      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: SwirlColors.borderLight,
        thickness: 1,
        space: 1,
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: SwirlColors.textPrimary,
        size: 24,
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: SwirlColors.surfaceElevated,
        selectedItemColor: SwirlColors.primary,
        unselectedItemColor: SwirlColors.textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: SwirlTypography.navLabel,
        unselectedLabelStyle: SwirlTypography.navLabel,
      ),
      
      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: SwirlColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusButtonLarge),
        ),
      ),
      
      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: SwirlColors.primary,
      ),
      
      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: SwirlColors.primary,
        contentTextStyle: SwirlTypography.bodyMedium.copyWith(
          color: Colors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusButtonSmall),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  /// System UI Overlay Style for light theme
  static const SystemUiOverlayStyle lightSystemUI = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarColor: SwirlColors.surface,
    systemNavigationBarIconBrightness: Brightness.dark,
  );
}