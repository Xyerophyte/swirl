import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart';

/// Settings Repository
/// Handles user settings and blocked users operations
class SettingsRepository {
  final SupabaseClient _client;

  SettingsRepository(this._client);

  // ============================================================================
  // USER SETTINGS OPERATIONS
  // ============================================================================

  /// Get user settings by user ID
  Future<UserSettings?> getSettings(String userId) async {
    try {
      final response = await _client
          .from('user_settings')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) {
        return null;
      }

      return UserSettings.fromJson(response as Map<String, dynamic>);
    } on PostgrestException catch (e) {
      throw Exception('Failed to get settings: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get settings: $e');
    }
  }

  /// Create or update user settings
  Future<UserSettings> upsertSettings(UserSettings settings) async {
    try {
      final response = await _client
          .from('user_settings')
          .upsert(settings.toJson())
          .select()
          .single();

      return UserSettings.fromJson(response as Map<String, dynamic>);
    } on PostgrestException catch (e) {
      throw Exception('Failed to upsert settings: ${e.message}');
    } catch (e) {
      throw Exception('Failed to upsert settings: $e');
    }
  }

  /// Update theme preference
  Future<UserSettings> updateTheme(String userId, String theme) async {
    try {
      final response = await _client
          .from('user_settings')
          .update({
            'theme': theme,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', userId)
          .select()
          .single();

      return UserSettings.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update theme: $e');
    }
  }

  /// Update profile visibility
  Future<UserSettings> updateProfileVisibility(
    String userId,
    String visibility,
  ) async {
    try {
      final response = await _client
          .from('user_settings')
          .update({
            'profile_visibility': visibility,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', userId)
          .select()
          .single();

      return UserSettings.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update visibility: $e');
    }
  }

  /// Update notification preference
  Future<UserSettings> updateNotificationPreference(
    String userId,
    String key,
    bool value,
  ) async {
    try {
      final response = await _client
          .from('user_settings')
          .update({
            key: value,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', userId)
          .select()
          .single();

      return UserSettings.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update notification: $e');
    }
  }

  /// Update language preference
  Future<UserSettings> updateLanguage(String userId, String language) async {
    try {
      final response = await _client
          .from('user_settings')
          .update({
            'language': language,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', userId)
          .select()
          .single();

      return UserSettings.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update language: $e');
    }
  }

  /// Update currency preference
  Future<UserSettings> updateCurrency(String userId, String currency) async {
    try {
      final response = await _client
          .from('user_settings')
          .update({
            'currency': currency,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', userId)
          .select()
          .single();

      return UserSettings.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update currency: $e');
    }
  }

  /// Update temperature unit preference
  Future<UserSettings> updateTemperatureUnit(
    String userId,
    String unit,
  ) async {
    try {
      final response = await _client
          .from('user_settings')
          .update({
            'temperature_unit': unit,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('user_id', userId)
          .select()
          .single();

      return UserSettings.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update temperature unit: $e');
    }
  }

  // ============================================================================
  // BLOCKED USERS OPERATIONS
  // ============================================================================

  /// Get all blocked users for a user
  Future<List<BlockedUser>> getBlockedUsers(String userId) async {
    try {
      final response = await _client
          .from('blocked_users')
          .select('*, blocked_user_profile:users!blocked_user_id(*)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((item) => BlockedUser.fromJson(item as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw Exception('Failed to get blocked users: ${e.message}');
    } catch (e) {
      throw Exception('Failed to get blocked users: $e');
    }
  }

  /// Block a user
  Future<BlockedUser> blockUser({
    required String userId,
    required String blockedUserId,
    String? reason,
  }) async {
    try {
      final response = await _client
          .from('blocked_users')
          .insert({
            'user_id': userId,
            'blocked_user_id': blockedUserId,
            'reason': reason,
            'created_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      return BlockedUser.fromJson(response as Map<String, dynamic>);
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        // Unique constraint violation - user already blocked
        throw Exception('User is already blocked');
      }
      throw Exception('Failed to block user: ${e.message}');
    } catch (e) {
      throw Exception('Failed to block user: $e');
    }
  }

  /// Unblock a user
  Future<void> unblockUser(String userId, String blockedUserId) async {
    try {
      await _client
          .from('blocked_users')
          .delete()
          .eq('user_id', userId)
          .eq('blocked_user_id', blockedUserId);
    } on PostgrestException catch (e) {
      throw Exception('Failed to unblock user: ${e.message}');
    } catch (e) {
      throw Exception('Failed to unblock user: $e');
    }
  }

  /// Check if a user is blocked
  Future<bool> isUserBlocked(String userId, String checkUserId) async {
    try {
      final response = await _client
          .from('blocked_users')
          .select('id')
          .eq('user_id', userId)
          .eq('blocked_user_id', checkUserId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      // If there's an error checking, assume not blocked
      return false;
    }
  }

  /// Get count of blocked users
  Future<int> getBlockedUsersCount(String userId) async {
    try {
      final response = await _client
          .from('blocked_users')
          .select('id')
          .eq('user_id', userId);

      return (response as List).length;
    } catch (e) {
      return 0;
    }
  }
}