/// Swipe Model
/// Represents a comprehensive swipe interaction for ML training
/// Tracks every swipe with context, engagement metrics, and product snapshot
/// Aligned with PRD v1.0 schema
class Swipe {
  final String id;

  // Identifiers
  final String userId;
  final String productId;
  final String? sessionId;

  // Swipe data
  final String direction; // 'right', 'left', 'up', 'down'
  final String swipeAction; // 'like', 'details_view', 'skip', 'wishlist'

  // Engagement metrics (ML features)
  final int? dwellMs; // Time spent viewing card before swipe (milliseconds)
  final int? cardPosition; // Position in feed (0-indexed)
  final bool isRepeatView; // User saw this item before?

  // Product snapshot (denormalized for ML training)
  final double? price;
  final String currency;
  final String? brand;
  final String? category;
  final String? subcategory;
  final List<String> styleTags;

  // Context at time of swipe
  final String? deviceLocale;
  final String? devicePlatform; // 'ios', 'android', 'web'
  final List<String> activeStyleFilters; // Active filters when swiped
  final int? timeOfDay; // Hour (0-23)
  final int? dayOfWeek; // 0=Sunday, 6=Saturday

  // Timestamp
  final DateTime createdAt;

  const Swipe({
    required this.id,
    required this.userId,
    required this.productId,
    this.sessionId,
    required this.direction,
    required this.swipeAction,
    this.dwellMs,
    this.cardPosition,
    this.isRepeatView = false,
    this.price,
    this.currency = 'AED',
    this.brand,
    this.category,
    this.subcategory,
    this.styleTags = const [],
    this.deviceLocale,
    this.devicePlatform,
    this.activeStyleFilters = const [],
    this.timeOfDay,
    this.dayOfWeek,
    required this.createdAt,
  });

  factory Swipe.fromJson(Map<String, dynamic> json) {
    return Swipe(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      productId: json['product_id'] as String,
      sessionId: json['session_id'] as String?,
      direction: json['direction'] as String,
      swipeAction: json['swipe_action'] as String,
      dwellMs: json['dwell_ms'] as int?,
      cardPosition: json['card_position'] as int?,
      isRepeatView: json['is_repeat_view'] as bool? ?? false,
      price: json['price'] != null ? (json['price'] as num).toDouble() : null,
      currency: json['currency'] as String? ?? 'AED',
      brand: json['brand'] as String?,
      category: json['category'] as String?,
      subcategory: json['subcategory'] as String?,
      styleTags: json['style_tags'] != null
          ? List<String>.from(json['style_tags'] as List)
          : const [],
      deviceLocale: json['device_locale'] as String?,
      devicePlatform: json['device_platform'] as String?,
      activeStyleFilters: json['active_style_filters'] != null
          ? List<String>.from(json['active_style_filters'] as List)
          : const [],
      timeOfDay: json['time_of_day'] as int?,
      dayOfWeek: json['day_of_week'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'product_id': productId,
      'session_id': sessionId,
      'direction': direction,
      'swipe_action': swipeAction,
      'dwell_ms': dwellMs,
      'card_position': cardPosition,
      'is_repeat_view': isRepeatView,
      'price': price,
      'currency': currency,
      'brand': brand,
      'category': category,
      'subcategory': subcategory,
      'style_tags': styleTags,
      'device_locale': deviceLocale,
      'device_platform': devicePlatform,
      'active_style_filters': activeStyleFilters,
      'time_of_day': timeOfDay,
      'day_of_week': dayOfWeek,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Helper getters

  /// Check if this was a positive interaction (like or wishlist)
  bool get isPositive =>
      swipeAction == 'like' || swipeAction == 'wishlist';

  /// Check if this was a negative interaction (skip)
  bool get isNegative => swipeAction == 'skip';

  /// Check if user showed interest (details view)
  bool get showedInterest => swipeAction == 'details_view';

  /// Get engagement score (for ML)
  /// High dwell time + positive action = high score
  double get engagementScore {
    double score = 0;

    // Base score from action
    switch (swipeAction) {
      case 'like':
        score += 10;
        break;
      case 'wishlist':
        score += 10;
        break;
      case 'details_view':
        score += 5;
        break;
      case 'skip':
        score -= 5;
        break;
    }

    // Dwell time bonus (>3s = interest)
    if (dwellMs != null) {
      if (dwellMs! > 3000) score += 2;
      if (dwellMs! < 1000) score -= 1;
    }

    // Repeat view bonus (consistent interest)
    if (isRepeatView) score += 3;

    return score;
  }

  /// Get time of day category
  String? get timeOfDayCategory {
    if (timeOfDay == null) return null;
    if (timeOfDay! >= 6 && timeOfDay! < 12) return 'morning';
    if (timeOfDay! >= 12 && timeOfDay! < 17) return 'afternoon';
    if (timeOfDay! >= 17 && timeOfDay! < 21) return 'evening';
    return 'night';
  }

  /// Get day name
  String? get dayName {
    if (dayOfWeek == null) return null;
    const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    return days[dayOfWeek!];
  }

  /// Copy with method for immutability
  Swipe copyWith({
    String? id,
    String? userId,
    String? productId,
    String? sessionId,
    String? direction,
    String? swipeAction,
    int? dwellMs,
    int? cardPosition,
    bool? isRepeatView,
    double? price,
    String? currency,
    String? brand,
    String? category,
    String? subcategory,
    List<String>? styleTags,
    String? deviceLocale,
    String? devicePlatform,
    List<String>? activeStyleFilters,
    int? timeOfDay,
    int? dayOfWeek,
    DateTime? createdAt,
  }) {
    return Swipe(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      productId: productId ?? this.productId,
      sessionId: sessionId ?? this.sessionId,
      direction: direction ?? this.direction,
      swipeAction: swipeAction ?? this.swipeAction,
      dwellMs: dwellMs ?? this.dwellMs,
      cardPosition: cardPosition ?? this.cardPosition,
      isRepeatView: isRepeatView ?? this.isRepeatView,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      styleTags: styleTags ?? this.styleTags,
      deviceLocale: deviceLocale ?? this.deviceLocale,
      devicePlatform: devicePlatform ?? this.devicePlatform,
      activeStyleFilters: activeStyleFilters ?? this.activeStyleFilters,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Swipe && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Swipe(id: $id, action: $swipeAction, direction: $direction, dwell: ${dwellMs}ms)';
}
