import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'logging_service.dart';

/// Analytics Service
/// Centralizes all analytics tracking including error reporting
/// Provides type-safe event tracking with proper error handling
class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  FirebaseAnalytics? _analytics;
  FirebaseAnalyticsObserver? _observer;
  bool _isInitialized = false;

  /// Initialize analytics service
  Future<void> initialize() async {
    try {
      _analytics = FirebaseAnalytics.instance;
      _observer = FirebaseAnalyticsObserver(analytics: _analytics!);
      _isInitialized = true;
      logger.info('AnalyticsService initialized');
    } catch (e, stackTrace) {
      logger.error('Failed to initialize AnalyticsService', error: e, stackTrace: stackTrace);
      _isInitialized = false;
    }
  }

  /// Get analytics observer for navigation tracking
  FirebaseAnalyticsObserver? get observer => _observer;

  /// Track custom event
  Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    if (!_isInitialized || _analytics == null) return;

    try {
      await _analytics!.logEvent(
        name: name,
        parameters: parameters,
      );
      
      logger.userAction(name, metadata: parameters);
    } catch (e, stackTrace) {
      logger.error('Failed to log event: $name', error: e, stackTrace: stackTrace);
    }
  }

  /// Track error with context
  Future<void> logError({
    required String error,
    String? context,
    StackTrace? stackTrace,
    Map<String, dynamic>? additionalInfo,
  }) async {
    if (!_isInitialized || _analytics == null) return;

    try {
      final parameters = {
        'error_message': error,
        if (context != null) 'context': context,
        if (stackTrace != null) 'stack_trace': stackTrace.toString().substring(0, 500),
        ...?additionalInfo,
      };

      await _analytics!.logEvent(
        name: 'app_error',
        parameters: parameters,
      );

      logger.error('Analytics error logged: $error', context: context);
    } catch (e, stackTrace) {
      logger.error('Failed to log error to analytics', error: e, stackTrace: stackTrace);
    }
  }

  /// Track screen view
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    if (!_isInitialized || _analytics == null) return;

    try {
      await _analytics!.logScreenView(
        screenName: screenName,
        screenClass: screenClass,
      );

      logger.navigation(screenName);
    } catch (e, stackTrace) {
      logger.error('Failed to log screen view: $screenName', error: e, stackTrace: stackTrace);
    }
  }

  /// Track user property
  Future<void> setUserProperty({
    required String name,
    required String value,
  }) async {
    if (!_isInitialized || _analytics == null) return;

    try {
      await _analytics!.setUserProperty(
        name: name,
        value: value,
      );
    } catch (e, stackTrace) {
      logger.error('Failed to set user property: $name', error: e, stackTrace: stackTrace);
    }
  }

  /// Track user ID
  Future<void> setUserId(String? userId) async {
    if (!_isInitialized || _analytics == null) return;

    try {
      await _analytics!.setUserId(id: userId);
    } catch (e, stackTrace) {
      logger.error('Failed to set user ID', error: e, stackTrace: stackTrace);
    }
  }

  // Pre-defined event trackers

  /// Track product view
  Future<void> logProductView({
    required String productId,
    required String productName,
    required String brand,
    required double price,
  }) async {
    await logEvent(
      name: 'view_item',
      parameters: {
        'item_id': productId,
        'item_name': productName,
        'item_brand': brand,
        'price': price,
      },
    );
  }

  /// Track product like
  Future<void> logProductLike({
    required String productId,
    required String productName,
    int? dwellTimeMs,
  }) async {
    await logEvent(
      name: 'product_like',
      parameters: {
        'item_id': productId,
        'item_name': productName,
        if (dwellTimeMs != null) 'dwell_time_ms': dwellTimeMs,
      },
    );
  }

  /// Track product skip
  Future<void> logProductSkip({
    required String productId,
    required String productName,
    int? dwellTimeMs,
  }) async {
    await logEvent(
      name: 'product_skip',
      parameters: {
        'item_id': productId,
        'item_name': productName,
        if (dwellTimeMs != null) 'dwell_time_ms': dwellTimeMs,
      },
    );
  }

  /// Track wishlist add
  Future<void> logAddToWishlist({
    required String productId,
    required String productName,
    required double price,
  }) async {
    await logEvent(
      name: 'add_to_wishlist',
      parameters: {
        'item_id': productId,
        'item_name': productName,
        'price': price,
      },
    );
  }

  /// Track search
  Future<void> logSearch({
    required String searchTerm,
    int? resultCount,
  }) async {
    await logEvent(
      name: 'search',
      parameters: {
        'search_term': searchTerm,
        if (resultCount != null) 'result_count': resultCount,
      },
    );
  }

  /// Track filter usage
  Future<void> logFilterApplied({
    required String filterType,
    required String filterValue,
  }) async {
    await logEvent(
      name: 'filter_applied',
      parameters: {
        'filter_type': filterType,
        'filter_value': filterValue,
      },
    );
  }

  /// Track onboarding completion
  Future<void> logOnboardingComplete({
    required List<String> selectedStyles,
    required List<String> selectedBrands,
    required String priceRange,
  }) async {
    await logEvent(
      name: 'onboarding_complete',
      parameters: {
        'styles': selectedStyles.join(','),
        'brands': selectedBrands.join(','),
        'price_range': priceRange,
      },
    );
  }

  /// Track app crash
  Future<void> logAppCrash({
    required String error,
    required StackTrace stackTrace,
    String? context,
  }) async {
    await logError(
      error: 'App Crash: $error',
      context: context,
      stackTrace: stackTrace,
      additionalInfo: {'severity': 'critical'},
    );
  }

  /// Track performance issue
  Future<void> logPerformanceIssue({
    required String operation,
    required int durationMs,
    String? context,
  }) async {
    await logEvent(
      name: 'performance_issue',
      parameters: {
        'operation': operation,
        'duration_ms': durationMs,
        if (context != null) 'context': context,
      },
    );
  }
}

/// Global analytics instance
final analytics = AnalyticsService();