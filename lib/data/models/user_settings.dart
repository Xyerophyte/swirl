/// User Settings Model
/// Represents user preferences and app settings stored in Supabase
class UserSettings {
  final String userId;

  // Privacy Settings
  final String profileVisibility; // 'public', 'private', 'friends_only'
  final bool dataSharingEnabled;
  final bool analyticsEnabled;

  // App Preferences
  final String theme; // 'light', 'dark', 'auto'
  final String language;
  final String currency;
  final String temperatureUnit; // 'celsius', 'fahrenheit'

  // Notification Settings
  final bool pushNotificationsEnabled;
  final bool emailNotificationsEnabled;
  final bool swirlAlerts;
  final bool priceDropAlerts;
  final bool newArrivalsAlerts;

  // Metadata
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserSettings({
    required this.userId,
    this.profileVisibility = 'public',
    this.dataSharingEnabled = true,
    this.analyticsEnabled = true,
    this.theme = 'light',
    this.language = 'en',
    this.currency = 'AED',
    this.temperatureUnit = 'celsius',
    this.pushNotificationsEnabled = true,
    this.emailNotificationsEnabled = true,
    this.swirlAlerts = true,
    this.priceDropAlerts = true,
    this.newArrivalsAlerts = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      userId: json['user_id'] as String,
      profileVisibility: json['profile_visibility'] as String? ?? 'public',
      dataSharingEnabled: json['data_sharing_enabled'] as bool? ?? true,
      analyticsEnabled: json['analytics_enabled'] as bool? ?? true,
      theme: json['theme'] as String? ?? 'light',
      language: json['language'] as String? ?? 'en',
      currency: json['currency'] as String? ?? 'AED',
      temperatureUnit: json['temperature_unit'] as String? ?? 'celsius',
      pushNotificationsEnabled: json['push_notifications_enabled'] as bool? ?? true,
      emailNotificationsEnabled: json['email_notifications_enabled'] as bool? ?? true,
      swirlAlerts: json['swirl_alerts'] as bool? ?? true,
      priceDropAlerts: json['price_drop_alerts'] as bool? ?? true,
      newArrivalsAlerts: json['new_arrivals_alerts'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'profile_visibility': profileVisibility,
      'data_sharing_enabled': dataSharingEnabled,
      'analytics_enabled': analyticsEnabled,
      'theme': theme,
      'language': language,
      'currency': currency,
      'temperature_unit': temperatureUnit,
      'push_notifications_enabled': pushNotificationsEnabled,
      'email_notifications_enabled': emailNotificationsEnabled,
      'swirl_alerts': swirlAlerts,
      'price_drop_alerts': priceDropAlerts,
      'new_arrivals_alerts': newArrivalsAlerts,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Create default settings for a user
  factory UserSettings.defaultSettings(String userId) {
    final now = DateTime.now();
    return UserSettings(
      userId: userId,
      createdAt: now,
      updatedAt: now,
    );
  }

  /// Copy with method for immutability
  UserSettings copyWith({
    String? userId,
    String? profileVisibility,
    bool? dataSharingEnabled,
    bool? analyticsEnabled,
    String? theme,
    String? language,
    String? currency,
    String? temperatureUnit,
    bool? pushNotificationsEnabled,
    bool? emailNotificationsEnabled,
    bool? swirlAlerts,
    bool? priceDropAlerts,
    bool? newArrivalsAlerts,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserSettings(
      userId: userId ?? this.userId,
      profileVisibility: profileVisibility ?? this.profileVisibility,
      dataSharingEnabled: dataSharingEnabled ?? this.dataSharingEnabled,
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
      theme: theme ?? this.theme,
      language: language ?? this.language,
      currency: currency ?? this.currency,
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
      pushNotificationsEnabled: pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      emailNotificationsEnabled: emailNotificationsEnabled ?? this.emailNotificationsEnabled,
      swirlAlerts: swirlAlerts ?? this.swirlAlerts,
      priceDropAlerts: priceDropAlerts ?? this.priceDropAlerts,
      newArrivalsAlerts: newArrivalsAlerts ?? this.newArrivalsAlerts,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserSettings && other.userId == userId;
  }

  @override
  int get hashCode => userId.hashCode;

  @override
  String toString() => 'UserSettings(userId: $userId, theme: $theme, language: $language)';
}