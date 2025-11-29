import 'package:flutter/material.dart';

/// SWIRL Color Palette
/// Designed for comfort and minimal visual stress
class SwirlColors {
  // Primary colors (soft, not aggressive)
  static const Color primary = Color(0xFF2C2C2C); // Soft black
  static const Color accent = Color(0xFFFF6B6B); // Coral (for likes)
  static const Color secondary = Color(0xFF4A5568); // Muted blue-gray
  
  // Backgrounds (warm, comfortable)
  static const Color background = Color(0xFFFAFAFA); // Warm off-white
  static const Color surface = Color(0xFFFFFFFF); // Pure white
  static const Color surfaceElevated = Color(0xFFFEFEFE); // Cream
  
  // Text (high contrast but soft)
  static const Color textPrimary = Color(0xFF2C2C2C);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  
  // Borders & dividers (subtle)
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFF3F4F6);
  
  // Success & error (muted)
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  
  // Overlays
  static const Color overlay = Color(0x99000000); // 60% black
  static const Color overlayLight = Color(0x66000000); // 40% black
  
  // Gradients
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.center,
    colors: [
      Color(0xB3000000), // 70% black
      Color(0x66000000), // 40% black
      Color(0x00000000), // Transparent
    ],
    stops: [0.0, 0.3, 1.0],
  );
  
  static const LinearGradient shimmerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFE0E0E0),
      Color(0xFFF5F5F5),
      Color(0xFFE0E0E0),
    ],
  );
}