/// Keyboard Navigation Service
/// Provides keyboard shortcuts and navigation for web platform
/// Enhances accessibility and improves user experience on desktop
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Keyboard Navigation Service
/// 
/// Provides keyboard shortcuts for common actions:
/// - Arrow keys: Navigate cards (left/right)
/// - Enter/Space: Like current item
/// - Escape: Skip current item
/// - Tab: Navigate between UI elements
/// - Number keys (1-4): Navigate between tabs
/// 
/// Usage:
/// ```dart
/// KeyboardNavigationService.initialize(context);
/// KeyboardNavigationService.setCallbacks(
///   onLike: () => likeProduct(),
///   onSkip: () => skipProduct(),
///   onDetails: () => showDetails(),
/// );
/// ```
class KeyboardNavigationService {
  static KeyboardNavigationService? _instance;
  static KeyboardNavigationService get instance {
    _instance ??= KeyboardNavigationService._();
    return _instance!;
  }

  KeyboardNavigationService._();

  // Callbacks for keyboard actions
  VoidCallback? _onLike;
  VoidCallback? _onSkip;
  VoidCallback? _onDetails;
  VoidCallback? _onBack;
  Function(int)? _onNavigateTab;

  // State
  bool _isEnabled = kIsWeb; // Only enable on web by default
  FocusNode? _rootFocusNode;

  /// Initialize keyboard navigation
  /// Call this in your app's root widget
  static void initialize(BuildContext context, {bool? enableOnMobile}) {
    instance._isEnabled = enableOnMobile ?? kIsWeb;
    if (!instance._isEnabled) return;

    // Create root focus node if it doesn't exist
    instance._rootFocusNode ??= FocusNode();
  }

  /// Set action callbacks
  static void setCallbacks({
    VoidCallback? onLike,
    VoidCallback? onSkip,
    VoidCallback? onDetails,
    VoidCallback? onBack,
    Function(int)? onNavigateTab,
  }) {
    instance._onLike = onLike;
    instance._onSkip = onSkip;
    instance._onDetails = onDetails;
    instance._onBack = onBack;
    instance._onNavigateTab = onNavigateTab;
  }

  /// Clear callbacks (call when leaving a screen)
  static void clearCallbacks() {
    instance._onLike = null;
    instance._onSkip = null;
    instance._onDetails = null;
    instance._onBack = null;
    instance._onNavigateTab = null;
  }

  /// Enable/disable keyboard navigation
  static void setEnabled(bool enabled) {
    instance._isEnabled = enabled;
  }

  /// Check if keyboard navigation is enabled
  static bool get isEnabled => instance._isEnabled;

  /// Get keyboard shortcuts widget
  /// Wrap your main content with this widget
  static Widget wrap({
    required Widget child,
    VoidCallback? onLike,
    VoidCallback? onSkip,
    VoidCallback? onDetails,
    VoidCallback? onBack,
    Function(int)? onNavigateTab,
  }) {
    if (!instance._isEnabled) {
      return child;
    }

    // Set callbacks if provided
    if (onLike != null) instance._onLike = onLike;
    if (onSkip != null) instance._onSkip = onSkip;
    if (onDetails != null) instance._onDetails = onDetails;
    if (onBack != null) instance._onBack = onBack;
    if (onNavigateTab != null) instance._onNavigateTab = onNavigateTab;

    return KeyboardListener(
      focusNode: instance._rootFocusNode ?? FocusNode(),
      autofocus: true,
      onKeyEvent: (KeyEvent event) {
        if (event is! KeyDownEvent) return;

        _handleKeyPress(event.logicalKey);
      },
      child: child,
    );
  }

  /// Handle key press
  static void _handleKeyPress(LogicalKeyboardKey key) {
    // Arrow keys - Navigate cards
    if (key == LogicalKeyboardKey.arrowRight) {
      instance._onLike?.call();
    } else if (key == LogicalKeyboardKey.arrowLeft) {
      instance._onBack?.call();
    } else if (key == LogicalKeyboardKey.arrowUp) {
      instance._onSkip?.call();
    } else if (key == LogicalKeyboardKey.arrowDown) {
      instance._onDetails?.call();
    }
    // Enter/Space - Like
    else if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.space) {
      instance._onLike?.call();
    }
    // Escape - Skip
    else if (key == LogicalKeyboardKey.escape) {
      instance._onSkip?.call();
    }
    // Number keys - Navigate tabs
    else if (key == LogicalKeyboardKey.digit1) {
      instance._onNavigateTab?.call(0);
    } else if (key == LogicalKeyboardKey.digit2) {
      instance._onNavigateTab?.call(1);
    } else if (key == LogicalKeyboardKey.digit3) {
      instance._onNavigateTab?.call(2);
    } else if (key == LogicalKeyboardKey.digit4) {
      instance._onNavigateTab?.call(3);
    }
  }

  /// Get keyboard shortcuts help text
  static String getShortcutsHelp() {
    return '''
Keyboard Shortcuts:

Navigation:
  → (Right Arrow)    Like product
  ← (Left Arrow)     Go back
  ↑ (Up Arrow)       Skip product
  ↓ (Down Arrow)     View details

Actions:
  Enter / Space      Like current product
  Escape             Skip current product

Tabs:
  1                  Home
  2                  Search
  3                  Swirls
  4                  Profile
''';
  }

  /// Dispose resources
  static void dispose() {
    instance._rootFocusNode?.dispose();
    instance._rootFocusNode = null;
    clearCallbacks();
  }
}

/// Keyboard Shortcuts Help Widget
/// Displays available keyboard shortcuts
class KeyboardShortcutsHelp extends StatelessWidget {
  final bool compact;

  const KeyboardShortcutsHelp({
    super.key,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!KeyboardNavigationService.isEnabled) {
      return const SizedBox.shrink();
    }

    if (compact) {
      return Tooltip(
        message: KeyboardNavigationService.getShortcutsHelp(),
        child: const Icon(Icons.keyboard, size: 20),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.keyboard, size: 24),
              const SizedBox(width: 8),
              Text(
                'Keyboard Shortcuts',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            KeyboardNavigationService.getShortcutsHelp(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                ),
          ),
        ],
      ),
    );
  }
}

/// Keyboard Shortcut Indicator
/// Shows a visual indicator when keyboard shortcuts are available
class KeyboardShortcutIndicator extends StatelessWidget {
  const KeyboardShortcutIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    if (!KeyboardNavigationService.isEnabled) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 100,
      right: 16,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: const KeyboardShortcutsHelp(),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            );
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.keyboard, size: 16),
                const SizedBox(width: 4),
                Text(
                  'Shortcuts',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}