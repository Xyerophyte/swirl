import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// User Session State
/// Manages user session data including persistent user ID
class UserSession {
  final String userId;
  final bool isAnonymous;
  final bool isInitialized;

  const UserSession({
    required this.userId,
    this.isAnonymous = true,
    this.isInitialized = false,
  });

  const UserSession.initial()
      : userId = '',
        isAnonymous = true,
        isInitialized = false;

  UserSession copyWith({
    String? userId,
    bool? isAnonymous,
    bool? isInitialized,
  }) {
    return UserSession(
      userId: userId ?? this.userId,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      isInitialized: isInitialized ?? this.isInitialized,
    );
  }
}

/// User Session Notifier
/// Handles user session lifecycle and persistence
class UserSessionNotifier extends StateNotifier<UserSession> {
  static const String _userIdKey = 'user_id';
  static const String _isAnonymousKey = 'is_anonymous';

  UserSessionNotifier() : super(const UserSession.initial()) {
    _initializeSession();
  }

  /// Initialize session by loading existing user ID or creating new one
  Future<void> _initializeSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Try to load existing user ID
      final existingUserId = prefs.getString(_userIdKey);
      final isAnonymous = prefs.getBool(_isAnonymousKey) ?? true;

      if (existingUserId != null && existingUserId.isNotEmpty) {
        // Use existing user ID
        state = UserSession(
          userId: existingUserId,
          isAnonymous: isAnonymous,
          isInitialized: true,
        );
      } else {
        // Create new anonymous user
        await _createAnonymousUser();
      }
    } catch (e) {
      // If SharedPreferences fails, create temporary session
      state = UserSession(
        userId: const Uuid().v4(),
        isAnonymous: true,
        isInitialized: true,
      );
    }
  }

  /// Create new anonymous user and persist ID
  Future<void> _createAnonymousUser() async {
    try {
      final newUserId = const Uuid().v4();
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setString(_userIdKey, newUserId);
      await prefs.setBool(_isAnonymousKey, true);

      state = UserSession(
        userId: newUserId,
        isAnonymous: true,
        isInitialized: true,
      );
    } catch (e) {
      // Fallback to non-persisted session
      state = UserSession(
        userId: const Uuid().v4(),
        isAnonymous: true,
        isInitialized: true,
      );
    }
  }

  /// Convert anonymous user to authenticated user
  Future<void> upgradeToAuthenticatedUser(String authenticatedUserId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setString(_userIdKey, authenticatedUserId);
      await prefs.setBool(_isAnonymousKey, false);

      state = UserSession(
        userId: authenticatedUserId,
        isAnonymous: false,
        isInitialized: true,
      );
    } catch (e) {
      // Log error but keep current state
      print('Failed to upgrade user session: $e');
    }
  }

  /// Clear session (logout)
  Future<void> clearSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userIdKey);
      await prefs.remove(_isAnonymousKey);
      
      // Create new anonymous session
      await _createAnonymousUser();
    } catch (e) {
      print('Failed to clear session: $e');
    }
  }

  /// Refresh session (useful after app restart)
  Future<void> refresh() async {
    await _initializeSession();
  }
}

/// User Session Provider
/// Provides access to persistent user session
final userSessionProvider = StateNotifierProvider<UserSessionNotifier, UserSession>((ref) {
  return UserSessionNotifier();
});

/// Current User ID Provider (convenience provider)
/// Returns the user ID from the session
final persistentUserIdProvider = Provider<String>((ref) {
  final session = ref.watch(userSessionProvider);
  
  // Return user ID if initialized, otherwise return empty string
  // The app should wait for initialization before making API calls
  return session.isInitialized ? session.userId : '';
});

/// Is Session Initialized Provider
/// Use this to show loading screen while session initializes
final isSessionInitializedProvider = Provider<bool>((ref) {
  final session = ref.watch(userSessionProvider);
  return session.isInitialized;
});