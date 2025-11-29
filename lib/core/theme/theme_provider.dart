/// Theme Provider
/// Manages application theme mode (light/dark)
/// Persists user preference across app sessions
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Theme mode notifier
/// Manages theme state and persistence
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  static const String _themeKey = 'theme_mode';
  
  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadTheme();
  }

  /// Load saved theme from storage
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themeKey);
      
      if (savedTheme != null) {
        state = ThemeMode.values.firstWhere(
          (mode) => mode.toString() == savedTheme,
          orElse: () => ThemeMode.system,
        );
      }
    } catch (e) {
      // Silently fail - use system theme
      state = ThemeMode.system;
    }
  }

  /// Set theme mode and persist
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, mode.toString());
    } catch (e) {
      // Log error but don't crash
      debugPrint('Failed to save theme preference: $e');
    }
  }

  /// Toggle between light and dark
  Future<void> toggleTheme() async {
    final newMode = state == ThemeMode.light 
        ? ThemeMode.dark 
        : ThemeMode.light;
    await setThemeMode(newMode);
  }

  /// Reset to system theme
  Future<void> resetToSystem() async {
    await setThemeMode(ThemeMode.system);
  }
}

/// Theme mode provider
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

/// Current theme brightness (computed)
final currentBrightnessProvider = Provider<Brightness>((ref) {
  final themeMode = ref.watch(themeModeProvider);
  final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
  
  switch (themeMode) {
    case ThemeMode.light:
      return Brightness.light;
    case ThemeMode.dark:
      return Brightness.dark;
    case ThemeMode.system:
      return brightness;
  }
});

/// Is dark mode active
final isDarkModeProvider = Provider<bool>((ref) {
  return ref.watch(currentBrightnessProvider) == Brightness.dark;
});