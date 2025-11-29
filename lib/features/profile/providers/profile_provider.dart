import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/app_providers.dart';
import '../../../data/models/models.dart' as models;
import '../../../data/repositories/user_repository.dart';

/// Profile State
class ProfileState {
  final models.User? user;
  final bool isLoading;
  final String? error;

  const ProfileState({
    this.user,
    this.isLoading = false,
    this.error,
  });

  ProfileState copyWith({
    models.User? user,
    bool? isLoading,
    String? error,
  }) {
    return ProfileState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Profile Notifier
class ProfileNotifier extends StateNotifier<ProfileState> {
  final UserRepository _userRepo;
  final String _userId;

  ProfileNotifier({
    required UserRepository userRepo,
    required String userId,
  })  : _userRepo = userRepo,
        _userId = userId,
        super(const ProfileState()) {
    loadProfile();
  }

  /// Load user profile
  /// If user doesn't exist in Supabase, create them with default values
  Future<void> loadProfile() async {
    if (!mounted) return;
    
    state = state.copyWith(isLoading: true, error: null);

    try {
      // Try to get existing user
      var user = await _userRepo.getUser(_userId);
      
      if (!mounted) return;
      
      // If user doesn't exist, create them
      if (user == null) {
        print('User not found in Supabase, creating default profile...');
        user = await _createDefaultUser();
      }
      
      if (user != null) {
        state = state.copyWith(
          user: user,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to create user profile',
        );
      }
    } catch (e) {
      if (!mounted) return;
      
      print('Error loading profile: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Create a default user profile when it doesn't exist
  Future<models.User?> _createDefaultUser() async {
    try {
      final now = DateTime.now();
      final newUser = models.User(
        id: _userId,
        anonymousId: _userId,
        isAnonymous: true,
        displayName: 'Guest User',
        stylePreferences: const [],
        preferredCategories: const [],
        preferredBrands: const [],
        preferredColors: const [],
        totalSwirls: 0,
        totalSwipes: 0,
        daysActive: 0,
        deviceLocale: 'en-AE',
        timezone: 'Asia/Dubai',
        createdAt: now,
        updatedAt: now,
        lastSeenAt: now,
      );
      
      return await _userRepo.upsertUser(newUser);
    } catch (e) {
      print('Failed to create default user: $e');
      return null;
    }
  }

  /// Update user profile
  Future<void> updateProfile({
    String? displayName,
    String? avatarUrl,
  }) async {
    if (!mounted) return;
    
    try {
      final updatedUser = await _userRepo.updateUser(
        userId: _userId,
        displayName: displayName,
        avatarUrl: avatarUrl,
      );

      if (mounted) {
        state = state.copyWith(user: updatedUser);
      }
    } catch (e) {
      if (mounted) {
        state = state.copyWith(error: e.toString());
      }
    }
  }

  /// Update style preferences
  Future<void> updateStylePreferences(List<String> stylePreferences) async {
    if (!mounted) return;
    
    try {
      final updatedUser = await _userRepo.updateStylePreferences(
        userId: _userId,
        stylePreferences: stylePreferences,
      );

      if (mounted) {
        state = state.copyWith(user: updatedUser);
      }
    } catch (e) {
      if (mounted) {
        state = state.copyWith(error: e.toString());
      }
    }
  }
}

/// Providers
// Using centralized providers from core/providers/app_providers.dart

// Profile provider
final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  final userRepo = ref.watch(userRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);

  return ProfileNotifier(
    userRepo: userRepo,
    userId: userId,
  );
});

// Brands Followed Count Provider
// Fetches real-time count of brands the user follows
final brandsFollowedCountProvider = FutureProvider<int>((ref) async {
  final userRepo = ref.watch(userRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);
  
  try {
    return await userRepo.getBrandsFollowedCount(userId);
  } catch (e) {
    print('Error fetching brands followed count: $e');
    return 0;
  }
});