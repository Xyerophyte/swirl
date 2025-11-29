import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart' as models;

/// User Repository
/// Handles user-related operations
class UserRepository {
  final SupabaseClient _client;

  UserRepository(this._client);

  /// Get user by ID
  Future<models.User?> getUser(String userId) async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return models.User.fromJson(response as Map<String, dynamic>);
    } on PostgrestException catch (e) {
      throw Exception('Failed to get user: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  /// Create or update user
  Future<models.User> upsertUser(models.User user) async {
    try {
      final response = await _client
          .from('users')
          .upsert({
            'id': user.id,
            'anonymous_id': user.anonymousId,
            'is_anonymous': user.isAnonymous,
            'email': user.email,
            'phone': user.phone,
            'auth_provider': user.authProvider,
            'display_name': user.displayName,
            'avatar_url': user.avatarUrl,
            'gender_preference': user.genderPreference,
            'style_preferences': user.stylePreferences,
            'price_tier': user.priceTier,
            'preferred_categories': user.preferredCategories,
            'preferred_brands': user.preferredBrands,
            'preferred_colors': user.preferredColors,
            'avg_liked_price': user.avgLikedPrice,
            'total_swirls': user.totalSwirls,
            'total_swipes': user.totalSwipes,
            'days_active': user.daysActive,
            'device_locale': user.deviceLocale,
            'timezone': user.timezone,
          })
          .select()
          .maybeSingle();

      if (response == null) {
        throw Exception('Failed to upsert user - no response');
      }

      return models.User.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to upsert user: $e');
    }
  }

 /// Update user profile
  Future<models.User> updateUser({
    required String userId,
    String? displayName,
    String? avatarUrl,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      if (displayName != null) updateData['display_name'] = displayName;
      if (avatarUrl != null) updateData['avatar_url'] = avatarUrl;
      updateData['updated_at'] = DateTime.now().toIso8601String();

      final response = await _client
          .from('users')
          .update(updateData)
          .eq('id', userId)
          .select()
          .maybeSingle();

      if (response == null) {
        throw Exception('Failed to update user - user not found');
      }

      return models.User.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  /// Update user style preferences
 Future<models.User> updateStylePreferences({
    required String userId,
    required List<String> stylePreferences,
  }) async {
    try {
      final response = await _client
          .from('users')
          .update({
            'style_preferences': stylePreferences,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', userId)
          .select()
          .maybeSingle();

      if (response == null) {
        throw Exception('Failed to update style preferences - user not found');
      }

      return models.User.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update style preferences: $e');
    }
  }

 /// Update user onboarding data
  Future<models.User> updateOnboardingData({
    required String userId,
    String? genderPreference,
    List<String>? stylePreferences,
    String? priceTier,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      if (genderPreference != null) updateData['gender_preference'] = genderPreference;
      if (stylePreferences != null) updateData['style_preferences'] = stylePreferences;
      if (priceTier != null) updateData['price_tier'] = priceTier;
      updateData['updated_at'] = DateTime.now().toIso8601String();

      final response = await _client
          .from('users')
          .update(updateData)
          .eq('id', userId)
          .select()
          .maybeSingle();

      if (response == null) {
        throw Exception('Failed to update onboarding data - user not found');
      }

      return models.User.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update onboarding data: $e');
    }
  }

  /// Increment user swipes
  /// Uses SQL function for atomic increment without race conditions
  Future<void> incrementSwipes(String userId) async {
    try {
      // Use Supabase RPC or direct SQL to increment atomically
      await _client.rpc('increment_user_swipes', params: {'user_id_param': userId});
    } catch (e) {
      // Fallback to manual increment if RPC doesn't exist
      try {
        final current = await _getCurrentValue(userId, 'total_swipes');
        await _client
            .from('users')
            .update({
              'total_swipes': (current ?? 0) + 1,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', userId);
      } catch (fallbackError) {
        // Silent fail - don't break the app for analytics
        print('Failed to increment swipes: $fallbackError');
      }
    }
  }

 /// Increment user swirls
  /// Uses SQL function for atomic increment without race conditions
  Future<void> incrementSwirls(String userId) async {
    try {
      // Use Supabase RPC or direct SQL to increment atomically
      await _client.rpc('increment_user_swirls', params: {'user_id_param': userId});
    } catch (e) {
      // Fallback to manual increment if RPC doesn't exist
      try {
        final current = await _getCurrentValue(userId, 'total_swirls');
        await _client
            .from('users')
            .update({
              'total_swirls': (current ?? 0) + 1,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', userId);
      } catch (fallbackError) {
        // Silent fail - don't break the app for analytics
        print('Failed to increment swirls: $fallbackError');
      }
    }
  }

  /// Increment user days active
 Future<void> incrementDaysActive(String userId) async {
    try {
      final today = DateTime.now().toIso8601String().split('T')[0];
      final lastSeen = await _getCurrentValue(userId, 'last_seen_at');
      final lastSeenDate = DateTime.parse(lastSeen.toString()).toIso8601String().split('T')[0];
      
      // Only increment if it's a new day
      if (lastSeenDate != today) {
        await _client
            .from('users')
            .update({
              'days_active': await _getCurrentValue(userId, 'days_active') + 1,
              'last_seen_at': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', userId);
      }
    } catch (e) {
      throw Exception('Failed to increment days active: $e');
    }
 }

  /// Update user preferences based on interactions
  Future<models.User> updateUserPreferences({
    required String userId,
    List<String>? preferredCategories,
    List<String>? preferredBrands,
    List<String>? preferredColors,
    double? avgLikedPrice,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      if (preferredCategories != null) updateData['preferred_categories'] = preferredCategories;
      if (preferredBrands != null) updateData['preferred_brands'] = preferredBrands;
      if (preferredColors != null) updateData['preferred_colors'] = preferredColors;
      if (avgLikedPrice != null) updateData['avg_liked_price'] = avgLikedPrice;
      updateData['updated_at'] = DateTime.now().toIso8601String();

      final response = await _client
          .from('users')
          .update(updateData)
          .eq('id', userId)
          .select()
          .maybeSingle();

      if (response == null) {
        throw Exception('Failed to update user preferences - user not found');
      }

      return models.User.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update user preferences: $e');
    }
  }

  /// Get count of brands followed by user
  Future<int> getBrandsFollowedCount(String userId) async {
    try {
      final response = await _client
          .from('brand_follows')
          .select('id')
          .eq('user_id', userId);

      return (response as List).length;
    } catch (e) {
      return 0;
    }
  }

  /// Get current value for a field
  /// Returns null if user doesn't exist or field is null
  Future<dynamic> _getCurrentValue(String userId, String field) async {
    try {
      final response = await _client
          .from('users')
          .select(field)
          .eq('id', userId)
          .maybeSingle();

      return response?[field] ?? 0;
    } catch (e) {
      // Return default value instead of throwing
      return 0;
    }
  }
}
