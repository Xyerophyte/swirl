/// User Model
/// Represents a SWIRL user with anonymous tracking and preferences
/// Aligned with PRD v1.0 schema
class User {
  final String id;

  // Anonymous tracking
  final String? anonymousId;
  final bool isAnonymous;

  // Authentication (populated when user signs up)
  final String? email;
  final String? phone;
  final String? authProvider; // 'email', 'google', 'apple', 'phone'

  // Profile
  final String? displayName;
  final String? avatarUrl;

  // Onboarding data (from quiz)
  final String? genderPreference; // 'men', 'women', 'both'
  final List<String> stylePreferences; // ['minimalist', 'urban_vibe', 'streetwear_edge', 'avant_garde']
  final String? priceTier; // 'budget', 'mid_range', 'premium', 'luxury'

  // Computed preferences (ML-driven, updated periodically)
  final List<String> preferredCategories;
  final List<String> preferredBrands;
  final List<String> preferredColors;
  final double? avgLikedPrice;

  // Stats (denormalized for performance)
  final int totalSwirls;
  final int totalSwipes;
  final int daysActive;

  // Metadata
  final String deviceLocale;
  final String timezone;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime lastSeenAt;

  const User({
    required this.id,
    this.anonymousId,
    this.isAnonymous = true,
    this.email,
    this.phone,
    this.authProvider,
    this.displayName,
    this.avatarUrl,
    this.genderPreference,
    this.stylePreferences = const [],
    this.priceTier,
    this.preferredCategories = const [],
    this.preferredBrands = const [],
    this.preferredColors = const [],
    this.avgLikedPrice,
    this.totalSwirls = 0,
    this.totalSwipes = 0,
    this.daysActive = 0,
    this.deviceLocale = 'en-AE',
    this.timezone = 'Asia/Dubai',
    required this.createdAt,
    required this.updatedAt,
    required this.lastSeenAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      anonymousId: json['anonymous_id'] as String?,
      isAnonymous: json['is_anonymous'] as bool? ?? true,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      authProvider: json['auth_provider'] as String?,
      displayName: json['display_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      genderPreference: json['gender_preference'] as String?,
      stylePreferences: json['style_preferences'] != null
          ? List<String>.from(json['style_preferences'] as List)
          : const [],
      priceTier: json['price_tier'] as String?,
      preferredCategories: json['preferred_categories'] != null
          ? List<String>.from(json['preferred_categories'] as List)
          : const [],
      preferredBrands: json['preferred_brands'] != null
          ? List<String>.from(json['preferred_brands'] as List)
          : const [],
      preferredColors: json['preferred_colors'] != null
          ? List<String>.from(json['preferred_colors'] as List)
          : const [],
      avgLikedPrice: json['avg_liked_price'] != null
          ? (json['avg_liked_price'] as num).toDouble()
          : null,
      totalSwirls: json['total_swirls'] as int? ?? 0,
      totalSwipes: json['total_swipes'] as int? ?? 0,
      daysActive: json['days_active'] as int? ?? 0,
      deviceLocale: json['device_locale'] as String? ?? 'en-AE',
      timezone: json['timezone'] as String? ?? 'Asia/Dubai',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
      lastSeenAt: json['last_seen_at'] != null
          ? DateTime.parse(json['last_seen_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'anonymous_id': anonymousId,
      'is_anonymous': isAnonymous,
      'email': email,
      'phone': phone,
      'auth_provider': authProvider,
      'display_name': displayName,
      'avatar_url': avatarUrl,
      'gender_preference': genderPreference,
      'style_preferences': stylePreferences,
      'price_tier': priceTier,
      'preferred_categories': preferredCategories,
      'preferred_brands': preferredBrands,
      'preferred_colors': preferredColors,
      'avg_liked_price': avgLikedPrice,
      'total_swirls': totalSwirls,
      'total_swipes': totalSwipes,
      'days_active': daysActive,
      'device_locale': deviceLocale,
      'timezone': timezone,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'last_seen_at': lastSeenAt.toIso8601String(),
    };
  }

  /// Helper getters

  /// Check if user has completed onboarding
  bool get hasCompletedOnboarding =>
      genderPreference != null &&
      stylePreferences.isNotEmpty &&
      priceTier != null;

  /// Check if user is registered (not anonymous)
  bool get isRegistered => !isAnonymous && email != null;

  /// Get display name or fallback
  String get displayNameOrDefault => displayName ?? 'Anonymous User';

  /// Check if user has any preferences set
  bool get hasPreferences =>
      preferredCategories.isNotEmpty ||
      preferredBrands.isNotEmpty ||
      avgLikedPrice != null;

  /// Get engagement level based on stats
  String get engagementLevel {
    if (totalSwipes < 20) return 'New';
    if (totalSwipes < 100) return 'Active';
    if (totalSwipes < 500) return 'Engaged';
    return 'Power User';
  }

  /// Get like rate
  double get likeRate {
    if (totalSwipes == 0) return 0;
    return totalSwirls / totalSwipes;
  }

  /// Copy with method for immutability
  User copyWith({
    String? id,
    String? anonymousId,
    bool? isAnonymous,
    String? email,
    String? phone,
    String? authProvider,
    String? displayName,
    String? avatarUrl,
    String? genderPreference,
    List<String>? stylePreferences,
    String? priceTier,
    List<String>? preferredCategories,
    List<String>? preferredBrands,
    List<String>? preferredColors,
    double? avgLikedPrice,
    int? totalSwirls,
    int? totalSwipes,
    int? daysActive,
    String? deviceLocale,
    String? timezone,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastSeenAt,
  }) {
    return User(
      id: id ?? this.id,
      anonymousId: anonymousId ?? this.anonymousId,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      authProvider: authProvider ?? this.authProvider,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      genderPreference: genderPreference ?? this.genderPreference,
      stylePreferences: stylePreferences ?? this.stylePreferences,
      priceTier: priceTier ?? this.priceTier,
      preferredCategories: preferredCategories ?? this.preferredCategories,
      preferredBrands: preferredBrands ?? this.preferredBrands,
      preferredColors: preferredColors ?? this.preferredColors,
      avgLikedPrice: avgLikedPrice ?? this.avgLikedPrice,
      totalSwirls: totalSwirls ?? this.totalSwirls,
      totalSwipes: totalSwipes ?? this.totalSwipes,
      daysActive: daysActive ?? this.daysActive,
      deviceLocale: deviceLocale ?? this.deviceLocale,
      timezone: timezone ?? this.timezone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'User(id: $id, displayName: $displayName, isAnonymous: $isAnonymous, totalSwirls: $totalSwirls)';
}
