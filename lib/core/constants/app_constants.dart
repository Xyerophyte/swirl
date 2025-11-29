/// SWIRL Application Constants
/// Contains all app-wide configuration values

import 'package:flutter/material.dart';

class AppConstants {
  // App Info
  static const String appName = 'SWIRL';
  static const String appVersion = '1.0.0';
  
  // Border Radius (Comfortable, Rounded)
  static const double radiusTiny = 2.0;         // For dividers, indicators
  static const double radiusSmall = 4.0;        // For small elements
  static const double radiusMedium = 8.0;       // For medium elements
  static const double radiusLarge = 10.0;       // For standard elements
  static const double radiusButtonSmall = 12.0; // For small buttons
  static const double radiusImage = 12.0;       // For images
  static const double radiusInput = 14.0;       // For input fields
  static const double radiusButtonLarge = 16.0; // For large buttons
  static const double radiusChip = 20.0;        // For chips/tags
  static const double radiusCard = 24.0;        // For cards
  static const double radiusBottomNav = 28.0;   // For bottom nav
  static const double radiusXLarge = 30.0;      // For large modals
  static const double radiusModal = 32.0;       // For modals/drawers

  // Spacing
  static const double spacingXxs = 6.0;   // Extra extra small (rare)
  static const double spacingXs = 4.0;    // Extra small
  static const double spacingSm = 8.0;    // Small (common)
  static const double spacingMd = 16.0;   // Medium (most common)
  static const double spacingLg = 24.0;   // Large (common)
  static const double spacingXl = 32.0;   // Extra large
  static const double spacingXxl = 40.0;  // Extra extra large
  static const double spacingXxxl = 120.0; // Huge spacing (rare)

  // Icon Sizes
  static const double iconSizeXxs = 10.0; // Extra tiny icons
  static const double iconSizeXs = 14.0;  // Tiny icons
  static const double iconSizeSm = 16.0;  // Small icons
  static const double iconSizeMd = 20.0;  // Medium icons (less common)
  static const double iconSizeLg = 24.0;  // Large icons (standard)
  static const double iconSizeXl = 28.0;  // Extra large icons
  static const double iconSizeXxl = 40.0; // Huge action icons
  static const double iconSizeXxxl = 64.0; // Illustration icons

  // Button Sizes
  static const double buttonHeightSmall = 40.0;   // Small button height
  static const double buttonHeightMedium = 48.0;  // Medium button height
  static const double buttonHeightLarge = 56.0;   // Large button height
  static const double buttonSquareSize = 48.0;    // Square action button (48x48)

  // Profile & Avatar Sizes
  static const double avatarSizeSmall = 40.0;     // Small avatar
  static const double avatarSizeMedium = 80.0;    // Medium avatar
  static const double avatarSizeLarge = 120.0;    // Large avatar/profile picture
  static const double emptyStateIconSize = 120.0; // Empty state illustrations
  
  // Animation Durations
  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  static const Duration animationLike = Duration(milliseconds: 400);
  
  // Swipe Configuration
  static const double swipeThreshold = 0.3; // 30% of screen width
  static const double swipeVelocityThreshold = 300.0; // pixels per second
  
  // Preloading Configuration
  static const int fullyLoadedDistance = 5; // Next 5 cards fully loaded
  static const int queueDistance = 10; // Next 5 cards queued
  static const int fetchTrigger = 5; // Fetch more when at position +5
  static const int backgroundFetchCount = 10; // Fetch 10 more in background
  
  // Surprise Injection
  static const int surpriseMinSwipes = 15; // Minimum swipes before surprise
  static const int surpriseMaxSwipes = 20; // Maximum swipes before surprise
  
  // Feed Configuration
  static const int initialFeedSize = 20; // Initial products to load
  static const int feedBatchSize = 20; // Products to load per batch
  
  // Card Configuration
  static const double cardHeightRatio = 0.92; // 92% of screen height
  static const double cardStackScale1 = 0.96; // Scale for card behind
  static const double cardStackScale2 = 0.92; // Scale for card 2 behind
  static const double cardStackOpacity1 = 0.6; // Opacity for card behind
  static const double cardStackOpacity2 = 0.3; // Opacity for card 2 behind
  
  // Image Configuration
  static const double imageQuality = 0.8; // 80% quality
  static const int imageCacheSize = 100; // Cache up to 100 images
  
  // Analytics Configuration (Hidden from users)
  static const String analyticsSessionEvent = 'session_start';
  static const String analyticsSwipeEvent = 'swipe';
  static const String analyticsLikeEvent = 'swipe_right';
  static const String analyticsSkipEvent = 'swipe_up';
  static const String analyticsDetailEvent = 'swipe_left';
  static const String analyticsWishlistEvent = 'double_tap';
  
  // Network Configuration
  static const Duration requestTimeout = Duration(seconds: 30);
  static const int maxRetries = 3;
  
  // UI Configuration
  static const double bottomNavHeight = 60.0;
  static const double appBarHeight = 56.0;
  static const double floatingNavMargin = 20.0;
  static const double floatingNavBottom = 24.0;
  
  // Shadow Configuration
  static const double shadowBlurRadius = 24.0;
  static const double shadowOffset = 8.0;
  static const double shadowOpacity = 0.12;
  
  // Haptic Feedback
  static const bool enableHaptics = true;
  
  // Debug Mode (Set to false for production)
  static const bool debugMode = true;
  static const bool showPerformanceOverlay = false;
}

/// Surprise Types for Injection
enum SurpriseType {
  flashSale,
  trending,
  exclusive,
  newArrival,
  celebrityPick,
}

/// Interaction Types for Analytics
enum InteractionType {
  like,
  skip,
  view,
  cart,
  purchase,
  wishlist,
}

/// Swipe Direction (defined here for backwards compatibility)
/// The primary definition is in data/models/enums.dart
enum SwipeDirection {
  right,  // Like
  left,   // Detail
  up,     // Skip
  down,   // Quick Wishlist/Details Drawer
  none,
}

/// Spacing Helper Classes
/// Provides pre-configured SizedBox widgets for consistent spacing
/// Use these instead of hardcoded SizedBox(height/width: X) values

/// Vertical Spacing
class VSpace {
  static const xxs = SizedBox(height: AppConstants.spacingXxs);  // 6px
  static const xs = SizedBox(height: AppConstants.spacingXs);    // 4px
  static const sm = SizedBox(height: AppConstants.spacingSm);    // 8px
  static const md = SizedBox(height: AppConstants.spacingMd);    // 16px
  static const lg = SizedBox(height: AppConstants.spacingLg);    // 24px
  static const xl = SizedBox(height: AppConstants.spacingXl);    // 32px
  static const xxl = SizedBox(height: AppConstants.spacingXxl);  // 40px
  static const xxxl = SizedBox(height: AppConstants.spacingXxxl); // 120px
}

/// Horizontal Spacing
class HSpace {
  static const xxs = SizedBox(width: AppConstants.spacingXxs);   // 6px
  static const xs = SizedBox(width: AppConstants.spacingXs);     // 4px
  static const sm = SizedBox(width: AppConstants.spacingSm);     // 8px
  static const md = SizedBox(width: AppConstants.spacingMd);     // 16px
  static const lg = SizedBox(width: AppConstants.spacingLg);     // 24px
  static const xl = SizedBox(width: AppConstants.spacingXl);     // 32px
  static const xxl = SizedBox(width: AppConstants.spacingXxl);   // 40px
  static const xxxl = SizedBox(width: AppConstants.spacingXxxl); // 120px
}