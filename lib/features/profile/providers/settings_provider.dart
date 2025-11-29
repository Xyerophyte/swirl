import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/models.dart';
import '../../../data/repositories/settings_repository.dart';
import '../../../data/services/supabase_service.dart';

/// Settings State
class SettingsState {
  final UserSettings? settings;
  final List<BlockedUser> blockedUsers;
  final bool isLoading;
  final String? error;

  const SettingsState({
    this.settings,
    this.blockedUsers = const [],
    this.isLoading = false,
    this.error,
  });

  SettingsState copyWith({
    UserSettings? settings,
    List<BlockedUser>? blockedUsers,
    bool? isLoading,
    String? error,
  }) {
    return SettingsState(
      settings: settings ?? this.settings,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Settings Notifier
class SettingsNotifier extends StateNotifier<SettingsState> {
  final SettingsRepository _settingsRepo;
  final String _userId;

  SettingsNotifier({
    required SettingsRepository settingsRepo,
    required String userId,
  })  : _settingsRepo = settingsRepo,
        _userId = userId,
        super(const SettingsState()) {
    loadSettings();
  }

  /// Load user settings and blocked users
  Future<void> loadSettings() async {
    if (!mounted) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      // Load settings
      var settings = await _settingsRepo.getSettings(_userId);

      // Create default settings if none exist
      if (settings == null) {
        settings = UserSettings.defaultSettings(_userId);
        await _settingsRepo.upsertSettings(settings);
      }

      // Load blocked users
      final blockedUsers = await _settingsRepo.getBlockedUsers(_userId);

      if (mounted) {
        state = state.copyWith(
          settings: settings,
          blockedUsers: blockedUsers,
          isLoading: false,
        );
      }
    } catch (e) {
      if (mounted) {
        state = state.copyWith(
          isLoading: false,
          error: e.toString(),
        );
      }
    }
  }

  /// Update theme
  Future<void> updateTheme(String theme) async {
    if (!mounted) return;

    try {
      final updated = await _settingsRepo.updateTheme(_userId, theme);
      if (mounted) {
        state = state.copyWith(settings: updated);
      }
    } catch (e) {
      if (mounted) {
        state = state.copyWith(error: e.toString());
      }
    }
  }

  /// Update profile visibility
  Future<void> updateProfileVisibility(String visibility) async {
    if (!mounted) return;

    try {
      final updated = await _settingsRepo.updateProfileVisibility(_userId, visibility);
      if (mounted) {
        state = state.copyWith(settings: updated);
      }
    } catch (e) {
      if (mounted) {
        state = state.copyWith(error: e.toString());
      }
    }
  }

  /// Update language
  Future<void> updateLanguage(String language) async {
    if (!mounted) return;

    try {
      final updated = await _settingsRepo.updateLanguage(_userId, language);
      if (mounted) {
        state = state.copyWith(settings: updated);
      }
    } catch (e) {
      if (mounted) {
        state = state.copyWith(error: e.toString());
      }
    }
  }

  /// Update currency
  Future<void> updateCurrency(String currency) async {
    if (!mounted) return;

    try {
      final updated = await _settingsRepo.updateCurrency(_userId, currency);
      if (mounted) {
        state = state.copyWith(settings: updated);
      }
    } catch (e) {
      if (mounted) {
        state = state.copyWith(error: e.toString());
      }
    }
  }

  /// Update temperature unit
  Future<void> updateTemperatureUnit(String unit) async {
    if (!mounted) return;

    try {
      final updated = await _settingsRepo.updateTemperatureUnit(_userId, unit);
      if (mounted) {
        state = state.copyWith(settings: updated);
      }
    } catch (e) {
      if (mounted) {
        state = state.copyWith(error: e.toString());
      }
    }
  }

  /// Toggle notification preference
  Future<void> toggleNotification(String key, bool value) async {
    if (!mounted) return;

    try {
      final updated = await _settingsRepo.updateNotificationPreference(_userId, key, value);
      if (mounted) {
        state = state.copyWith(settings: updated);
      }
    } catch (e) {
      if (mounted) {
        state = state.copyWith(error: e.toString());
      }
    }
  }

  /// Update multiple settings at once
  Future<void> updateSettings(UserSettings settings) async {
    if (!mounted) return;

    try {
      final updated = await _settingsRepo.upsertSettings(settings);
      if (mounted) {
        state = state.copyWith(settings: updated);
      }
    } catch (e) {
      if (mounted) {
        state = state.copyWith(error: e.toString());
      }
    }
  }

  /// Block a user
  Future<void> blockUser(String blockedUserId, {String? reason}) async {
    if (!mounted) return;

    try {
      await _settingsRepo.blockUser(
        userId: _userId,
        blockedUserId: blockedUserId,
        reason: reason,
      );

      // Reload blocked users list
      final blockedUsers = await _settingsRepo.getBlockedUsers(_userId);

      if (mounted) {
        state = state.copyWith(blockedUsers: blockedUsers);
      }
    } catch (e) {
      if (mounted) {
        state = state.copyWith(error: e.toString());
      }
    }
  }

  /// Unblock a user
  Future<void> unblockUser(String blockedUserId) async {
    if (!mounted) return;

    try {
      await _settingsRepo.unblockUser(_userId, blockedUserId);

      // Reload blocked users list
      final blockedUsers = await _settingsRepo.getBlockedUsers(_userId);

      if (mounted) {
        state = state.copyWith(blockedUsers: blockedUsers);
      }
    } catch (e) {
      if (mounted) {
        state = state.copyWith(error: e.toString());
      }
    }
  }
}

/// Providers

// Settings Repository Provider
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(SupabaseService.client);
});

// Settings Provider
final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  final settingsRepo = ref.watch(settingsRepositoryProvider);
  // TODO: Get user ID from persistent user provider
  final userId = '00000000-0000-0000-0000-000000000000'; // Placeholder

  return SettingsNotifier(
    settingsRepo: settingsRepo,
    userId: userId,
  );
});