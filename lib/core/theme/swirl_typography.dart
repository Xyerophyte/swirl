import 'package:flutter/material.dart';

/// SWIRL Typography System
/// Using Inter font family for clean, modern aesthetics
class SwirlTypography {
  static const String fontFamily = 'Inter';
  
  // Product Card Text Styles
  static const TextStyle cardTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600, // SemiBold
    height: 1.3,
    letterSpacing: -0.2,
  );
  
  static const TextStyle cardSubtitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400, // Regular
    height: 1.4,
  );
  
  // Price Text Styles
  static const TextStyle priceLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700, // Bold
    height: 1.2,
    letterSpacing: -0.3,
  );

  static const TextStyle price = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700, // Bold
    height: 1.2,
  );

  static const TextStyle priceOriginal = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400, // Regular
    decoration: TextDecoration.lineThrough,
    height: 1.2,
  );
  
  // Heading Text Styles
  static const TextStyle headingXl = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700, // Bold
    height: 1.2,
    letterSpacing: -0.5,
  );

  static const TextStyle headingLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700, // Bold
    height: 1.3,
    letterSpacing: -0.4,
  );

  static const TextStyle headingMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600, // SemiBold
    height: 1.3,
    letterSpacing: -0.3,
  );

  static const TextStyle headingSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600, // SemiBold
    height: 1.3,
    letterSpacing: -0.2,
  );

  static const TextStyle headingXs = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600, // SemiBold
    height: 1.3,
    letterSpacing: -0.2,
  );

  // Detail View Text Styles (Aliases for backwards compatibility)
  static const TextStyle detailTitle = headingMedium; // 24px

  static const TextStyle detailSubtitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400, // Regular
    height: 1.5,
  );

  static const TextStyle detailDescription = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400, // Regular
    height: 1.6,
  );
  
  // Button Text Styles
  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600, // SemiBold
    height: 1.2,
    letterSpacing: -0.1,
  );
  
  static const TextStyle buttonSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600, // SemiBold
    height: 1.2,
  );
  
  // Navigation Text Styles
  static const TextStyle navLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500, // Medium
    height: 1.2,
  );
  
  // Badge/Chip Text Styles
  static const TextStyle badge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600, // SemiBold
    height: 1.2,
  );
  
  // Body Text Styles
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400, // Regular
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400, // Regular
    height: 1.5,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400, // Regular
    height: 1.4,
  );
  
  // Caption & Label Text Styles
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w400, // Regular
    height: 1.3,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w500, // Medium
    height: 1.2,
    letterSpacing: 0.2,
  );

  static const TextStyle labelTiny = TextStyle(
    fontFamily: fontFamily,
    fontSize: 9,
    fontWeight: FontWeight.w500, // Medium
    height: 1.2,
    letterSpacing: 0.3,
  );
}