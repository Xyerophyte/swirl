import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// App Lifecycle Service
/// Manages app lifecycle events for background refresh and cache updates
class AppLifecycleService {
  static AppLifecycleService? _instance;
  AppLifecycleService._();

  static AppLifecycleService get instance {
    _instance ??= AppLifecycleService._();
    return _instance!;
  }

  DateTime? _lastResumeTime;
  DateTime? _lastPauseTime;
  final List<VoidCallback> _onResumeCallbacks = [];
  final List<VoidCallback> _onPauseCallbacks = [];

  /// Register callback for app resume
  void onResume(VoidCallback callback) {
    _onResumeCallbacks.add(callback);
  }

  /// Register callback for app pause
  void onPause(VoidCallback callback) {
    _onPauseCallbacks.add(callback);
  }

  /// Remove resume callback
  void removeOnResume(VoidCallback callback) {
    _onResumeCallbacks.remove(callback);
  }

  /// Remove pause callback
  void removeOnPause(VoidCallback callback) {
    _onPauseCallbacks.remove(callback);
  }

  /// Handle app lifecycle state change
  void handleLifecycleChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _handleResume();
        break;
      case AppLifecycleState.paused:
        _handlePause();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        // No action needed
        break;
    }
  }

  void _handleResume() {
    final now = DateTime.now();
    _lastResumeTime = now;

    // Check if app was paused for more than 5 minutes
    final shouldRefresh = _lastPauseTime != null &&
        now.difference(_lastPauseTime!).inMinutes >= 5;

    print('📱 App resumed${shouldRefresh ? " (triggering refresh)" : ""}');

    // Trigger all resume callbacks
    for (final callback in _onResumeCallbacks) {
      try {
        callback();
      } catch (e) {
        print('❌ Error in resume callback: $e');
      }
    }
  }

  void _handlePause() {
    _lastPauseTime = DateTime.now();
    print('📱 App paused');

    // Trigger all pause callbacks
    for (final callback in _onPauseCallbacks) {
      try {
        callback();
      } catch (e) {
        print('❌ Error in pause callback: $e');
      }
    }
  }

  /// Check if should refresh based on last resume time
  bool shouldRefreshDiscovery() {
    if (_lastResumeTime == null) return true;

    final minutesSinceResume =
        DateTime.now().difference(_lastResumeTime!).inMinutes;

    // Refresh if more than 30 minutes since last resume
    return minutesSinceResume >= 30;
  }

  /// Check if app was in background for extended period
  bool wasInBackgroundLongTime() {
    if (_lastPauseTime == null || _lastResumeTime == null) return false;

    return _lastResumeTime!.difference(_lastPauseTime!).inMinutes >= 5;
  }

  /// Get time in background (in minutes)
  int? getTimeInBackground() {
    if (_lastPauseTime == null || _lastResumeTime == null) return null;

    return _lastResumeTime!.difference(_lastPauseTime!).inMinutes;
  }

  /// Clear all callbacks (for cleanup)
  void clearCallbacks() {
    _onResumeCallbacks.clear();
    _onPauseCallbacks.clear();
  }
}

/// App Lifecycle Observer Widget
/// Wraps the app to observe lifecycle changes
class AppLifecycleObserver extends StatefulWidget {
  final Widget child;
  final VoidCallback? onResume;
  final VoidCallback? onPause;

  const AppLifecycleObserver({
    super.key,
    required this.child,
    this.onResume,
    this.onPause,
  });

  @override
  State<AppLifecycleObserver> createState() => _AppLifecycleObserverState();
}

class _AppLifecycleObserverState extends State<AppLifecycleObserver>
    with WidgetsBindingObserver {
  final AppLifecycleService _lifecycleService = AppLifecycleService.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Register callbacks if provided
    if (widget.onResume != null) {
      _lifecycleService.onResume(widget.onResume!);
    }
    if (widget.onPause != null) {
      _lifecycleService.onPause(widget.onPause!);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    // Remove callbacks
    if (widget.onResume != null) {
      _lifecycleService.removeOnResume(widget.onResume!);
    }
    if (widget.onPause != null) {
      _lifecycleService.removeOnPause(widget.onPause!);
    }

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _lifecycleService.handleLifecycleChange(state);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Riverpod Provider for AppLifecycleService
final appLifecycleServiceProvider = Provider<AppLifecycleService>((ref) {
  return AppLifecycleService.instance;
});