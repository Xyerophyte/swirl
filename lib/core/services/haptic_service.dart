import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'logging_service.dart';

/// Haptic Feedback Service
/// Provides different types of haptic feedback for various user interactions
/// Includes comprehensive error handling and platform checking
class HapticService {
  static bool _isEnabled = true;
  static bool _hasShownError = false;

  /// Enable or disable haptic feedback globally
  static void setEnabled(bool enabled) {
    _isEnabled = enabled;
    logger.info('Haptic feedback ${enabled ? 'enabled' : 'disabled'}');
  }

  /// Check if haptic feedback is enabled
  static bool get isEnabled => _isEnabled;

  /// Safe haptic feedback wrapper with error handling
  static Future<void> _performHaptic(
    Future<void> Function() hapticFunction,
    String hapticType,
  ) async {
    if (!_isEnabled) return;

    try {
      await hapticFunction();
    } catch (e, stackTrace) {
      // Only log error once to avoid spam
      if (!_hasShownError) {
        logger.warning(
          'Haptic feedback not available on this device: $hapticType',
          context: 'HapticService',
        );
        _hasShownError = true;
      }
      
      // In debug mode, show more details
      if (kDebugMode) {
        logger.debug(
          'Haptic error details',
          context: 'HapticService',
          data: {'type': hapticType, 'error': e.toString()},
        );
      }
    }
  }

  /// Light impact - Used for swipes and minor interactions
  /// Provides subtle feedback that doesn't interrupt the user
  static Future<void> lightImpact() async {
    await _performHaptic(
      () => HapticFeedback.lightImpact(),
      'lightImpact',
    );
  }

  /// Medium impact - Used for likes/saves and important actions
  /// Provides noticeable feedback for user actions
  static Future<void> mediumImpact() async {
    await _performHaptic(
      () => HapticFeedback.mediumImpact(),
      'mediumImpact',
    );
  }

  /// Heavy impact - Used for critical actions and errors
  /// Provides strong feedback that demands attention
  static Future<void> heavyImpact() async {
    await _performHaptic(
      () => HapticFeedback.heavyImpact(),
      'heavyImpact',
    );
  }

  /// Selection click - Used for UI interactions and toggles
  /// Provides crisp, precise feedback for selections
  static Future<void> selectionClick() async {
    await _performHaptic(
      () => HapticFeedback.selectionClick(),
      'selectionClick',
    );
  }

  /// Vibrate - Generic vibration for general notifications
  /// Falls back to basic vibration on older devices
  static Future<void> vibrate() async {
    await _performHaptic(
      () => HapticFeedback.vibrate(),
      'vibrate',
    );
  }

  /// Success haptic - For successful actions
  /// Uses medium impact to convey positive feedback
  static Future<void> success() async {
    await mediumImpact();
  }

  /// Error haptic - For failed actions or validation errors
  /// Uses heavy impact to convey importance
  static Future<void> error() async {
    await heavyImpact();
  }

  /// Warning haptic - For warnings or caution states
  /// Uses light impact for subtle notification
  static Future<void> warning() async {
    await lightImpact();
  }

  /// Reset error flag (useful for testing)
  static void resetErrorFlag() {
    _hasShownError = false;
  }
}