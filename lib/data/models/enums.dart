/// Enums and Constants for SWIRL App
/// Aligned with PRD v1.0

/// Style Tags - The 4 primary style categories
enum StyleTag {
  minimalist('minimalist', 'Minimalist', 'Clean, neutral, simple'),
  urbanVibe('urban_vibe', 'Urban Vibe', 'Contemporary, streetwear'),
  streetwearEdge('streetwear_edge', 'Streetwear Edge', 'Athletic, oversized, brand-heavy'),
  avantGarde('avant_garde', 'Avant-Garde', 'Experimental, high-fashion, unique');

  const StyleTag(this.value, this.displayName, this.description);

  final String value;
  final String displayName;
  final String description;

  static StyleTag fromString(String value) {
    return StyleTag.values.firstWhere(
      (e) => e.value == value,
      orElse: () => StyleTag.minimalist,
    );
  }
}

/// Product Categories
enum ProductCategory {
  men('men', 'Men'),
  women('women', 'Women'),
  unisex('unisex', 'Unisex'),
  accessories('accessories', 'Accessories'),
  shoes('shoes', 'Shoes');

  const ProductCategory(this.value, this.displayName);

  final String value;
  final String displayName;

  static ProductCategory fromString(String value) {
    return ProductCategory.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ProductCategory.men,
    );
  }
}

/// Swipe Directions
enum SwipeDirection {
  right('right', 'Like / Save'),
  left('left', 'View Details'),
  up('up', 'Skip / Next'),
  down('down', 'Quick Wishlist'),
  none('none', 'No Swipe');

  const SwipeDirection(this.value, this.description);

  final String value;
  final String description;

  static SwipeDirection fromString(String value) {
    return SwipeDirection.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SwipeDirection.none,
    );
  }
}

/// Swipe Actions (what the swipe resulted in)
enum SwipeAction {
  like('like', 'Liked Item'),
  detailsView('details_view', 'Viewed Details'),
  skip('skip', 'Skipped'),
  wishlist('wishlist', 'Added to Wishlist');

  const SwipeAction(this.value, this.displayName);

  final String value;
  final String displayName;

  static SwipeAction fromString(String value) {
    return SwipeAction.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SwipeAction.skip,
    );
  }

  /// Get corresponding swipe direction for action
  SwipeDirection get defaultDirection {
    switch (this) {
      case SwipeAction.like:
        return SwipeDirection.right;
      case SwipeAction.detailsView:
        return SwipeDirection.left;
      case SwipeAction.skip:
        return SwipeDirection.up;
      case SwipeAction.wishlist:
        return SwipeDirection.down;
    }
  }
}

/// Gender Preferences (for onboarding)
enum GenderPreference {
  men('men', 'Men\'s Fashion'),
  women('women', 'Women\'s Fashion'),
  both('both', 'Both');

  const GenderPreference(this.value, this.displayName);

  final String value;
  final String displayName;

  static GenderPreference fromString(String value) {
    return GenderPreference.values.firstWhere(
      (e) => e.value == value,
      orElse: () => GenderPreference.men,
    );
  }
}

/// Price Tiers (for onboarding and preferences)
enum PriceTier {
  budget('budget', 'Budget-Friendly', 'Under 200 AED'),
  midRange('mid_range', 'Mid-Range', '200-500 AED'),
  premium('premium', 'Premium', '500-1000 AED'),
  luxury('luxury', 'Luxury', '1000+ AED');

  const PriceTier(this.value, this.displayName, this.description);

  final String value;
  final String displayName;
  final String description;

  static PriceTier fromString(String value) {
    return PriceTier.values.firstWhere(
      (e) => e.value == value,
      orElse: () => PriceTier.midRange,
    );
  }

  /// Get price range for tier
  (double min, double? max) get priceRange {
    switch (this) {
      case PriceTier.budget:
        return (0, 200);
      case PriceTier.midRange:
        return (200, 500);
      case PriceTier.premium:
        return (500, 1000);
      case PriceTier.luxury:
        return (1000, null);
    }
  }
}

/// Source Stores (where products come from)
enum SourceStore {
  amazon('amazon', 'Amazon.ae', 'https://amazon.ae'),
  noon('noon', 'Noon', 'https://noon.com'),
  namshi('namshi', 'Namshi', 'https://namshi.com'),
  other('other', 'Other', '');

  const SourceStore(this.value, this.displayName, this.websiteUrl);

  final String value;
  final String displayName;
  final String websiteUrl;

  static SourceStore fromString(String value) {
    return SourceStore.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SourceStore.other,
    );
  }
}

/// Auth Providers
enum AuthProvider {
  email('email', 'Email'),
  google('google', 'Google'),
  apple('apple', 'Apple'),
  phone('phone', 'Phone');

  const AuthProvider(this.value, this.displayName);

  final String value;
  final String displayName;

  static AuthProvider fromString(String value) {
    return AuthProvider.values.firstWhere(
      (e) => e.value == value,
      orElse: () => AuthProvider.email,
    );
  }
}

/// Brand Follow Sources
enum BrandFollowSource {
  manual('manual', 'Manual'),
  auto5Likes('auto_5_likes', 'Auto (5 Likes)'),
  onboarding('onboarding', 'Onboarding');

  const BrandFollowSource(this.value, this.displayName);

  final String value;
  final String displayName;

  static BrandFollowSource fromString(String value) {
    return BrandFollowSource.values.firstWhere(
      (e) => e.value == value,
      orElse: () => BrandFollowSource.manual,
    );
  }
}

/// Swirl/Wishlist Sources
enum ItemSource {
  swipeRight('swipe_right', 'Right Swipe'),
  swipeDown('swipe_down', 'Down Swipe'),
  doubleTap('double_tap', 'Double Tap'),
  detailView('detail_view', 'Detail View'),
  detailViewButton('detail_view_button', 'Detail View Button'),
  searchResult('search_result', 'Search Result');

  const ItemSource(this.value, this.displayName);

  final String value;
  final String displayName;

  static ItemSource fromString(String value) {
    return ItemSource.values.firstWhere(
      (e) => e.value == value,
      orElse: () => ItemSource.swipeRight,
    );
  }
}

/// Device Platforms
enum DevicePlatform {
  ios('ios', 'iOS'),
  android('android', 'Android'),
  web('web', 'Web');

  const DevicePlatform(this.value, this.displayName);

  final String value;
  final String displayName;

  static DevicePlatform fromString(String value) {
    return DevicePlatform.values.firstWhere(
      (e) => e.value == value,
      orElse: () => DevicePlatform.android,
    );
  }
}

/// Time of Day Categories
enum TimeOfDayCategory {
  morning(6, 12, 'Morning', '🌅'),
  afternoon(12, 17, 'Afternoon', '☀️'),
  evening(17, 21, 'Evening', '🌆'),
  night(21, 6, 'Night', '🌙');

  const TimeOfDayCategory(this.startHour, this.endHour, this.displayName, this.emoji);

  final int startHour;
  final int endHour;
  final String displayName;
  final String emoji;

  static TimeOfDayCategory fromHour(int hour) {
    if (hour >= 6 && hour < 12) return TimeOfDayCategory.morning;
    if (hour >= 12 && hour < 17) return TimeOfDayCategory.afternoon;
    if (hour >= 17 && hour < 21) return TimeOfDayCategory.evening;
    return TimeOfDayCategory.night;
  }
}

/// Constants
class SwirlConstants {
  SwirlConstants._(); // Private constructor to prevent instantiation

  // Swipe thresholds
  static const double swipeThreshold = 0.3; // 30% of screen
  static const double velocityThreshold = 300.0; // pixels/second

  // Animation durations
  static const int cardAnimationDurationMs = 300;
  static const int detailViewAnimationDurationMs = 400;

  // Feed preloading
  static const int fullyLoadedDistance = 5; // Next 5 cards fully loaded
  static const int queueDistance = 10; // Next 5 in queue
  static const int fetchTrigger = 5; // Fetch when 5 remaining

  // ML tracking
  static const int highDwellTimeMs = 3000; // 3s = high interest
  static const int lowDwellTimeMs = 1000; // <1s = low interest

  // Brand following
  static const int autoFollowThreshold = 5; // Auto-follow after 5 likes

  // Engagement scores (for ML)
  static const double likeScore = 10.0;
  static const double wishlistScore = 10.0;
  static const double detailsViewScore = 5.0;
  static const double skipScore = -5.0;
  static const double highDwellBonus = 2.0;
  static const double lowDwellPenalty = -1.0;
  static const double repeatViewBonus = 3.0;

  // Brand priority boost
  static const double followedBrandBoost = 15.0; // 1.5x effective

  // Currency
  static const String defaultCurrency = 'AED';
  static const String currencySymbol = 'AED';

  // Locale
  static const String defaultLocale = 'en-AE';
  static const String defaultTimezone = 'Asia/Dubai';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Image sizes
  static const int thumbnailSize = 150;
  static const int mediumImageSize = 400;

  // Success metrics targets (Phase 1 MVP)
  static const int targetDailyActiveUsers = 1000;
  static const int targetSessionDurationMinutes = 10;
  static const double targetLikeRate = 0.20; // 20%
  static const double targetDay7Retention = 0.40; // 40%
  static const int targetSwipesPerSession = 50;
}
