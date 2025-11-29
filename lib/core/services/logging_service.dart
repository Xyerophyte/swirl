import 'package:flutter/foundation.dart';

/// Comprehensive Logging Service
/// Provides structured logging with severity levels for debugging and monitoring
/// Only logs in debug mode to avoid performance impact in production
class LoggingService {
  static LoggingService? _instance;
  LoggingService._();

  static LoggingService get instance {
    _instance ??= LoggingService._();
    return _instance!;
  }

  // Log severity levels
  static const String _debug = '🐛 DEBUG';
  static const String _info = 'ℹ️ INFO';
  static const String _warning = '⚠️ WARNING';
  static const String _error = '❌ ERROR';
  static const String _critical = '🚨 CRITICAL';

  /// Log debug message (detailed technical information)
  void debug(String message, {String? context, Object? data}) {
    _log(_debug, message, context: context, data: data);
  }

  /// Log info message (general informational messages)
  void info(String message, {String? context, Object? data}) {
    _log(_info, message, context: context, data: data);
  }

  /// Log warning message (potentially harmful situations)
  void warning(String message, {String? context, Object? data}) {
    _log(_warning, message, context: context, data: data);
  }

  /// Log error message (error events that might still allow app to continue)
  void error(
    String message, {
    String? context,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      _error,
      message,
      context: context,
      data: error,
      stackTrace: stackTrace,
    );
  }

  /// Log critical message (severe errors causing app failure)
  void critical(
    String message, {
    String? context,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      _critical,
      message,
      context: context,
      data: error,
      stackTrace: stackTrace,
    );
  }

  /// Internal logging method
  void _log(
    String level,
    String message, {
    String? context,
    Object? data,
    StackTrace? stackTrace,
  }) {
    // Only log in debug mode
    if (!kDebugMode) return;

    final timestamp = DateTime.now().toIso8601String();
    final contextStr = context != null ? ' [$context]' : '';
    
    debugPrint('$timestamp | $level$contextStr: $message');
    
    if (data != null) {
      debugPrint('  ↳ Data: $data');
    }
    
    if (stackTrace != null) {
      debugPrint('  ↳ Stack trace:\n$stackTrace');
    }
  }

  /// Log performance metric
  void performance(
    String operation,
    Duration duration, {
    String? context,
    Map<String, dynamic>? metadata,
  }) {
    if (!kDebugMode) return;

    final ms = duration.inMilliseconds;
    final contextStr = context != null ? ' [$context]' : '';
    
    debugPrint('⏱️ PERFORMANCE$contextStr: $operation took ${ms}ms');
    
    if (metadata != null) {
      debugPrint('  ↳ Metadata: $metadata');
    }
  }

  /// Log API request
  void apiRequest(
    String method,
    String endpoint, {
    Map<String, dynamic>? params,
    Map<String, dynamic>? headers,
  }) {
    if (!kDebugMode) return;

    debugPrint('🌐 API REQUEST: $method $endpoint');
    
    if (params != null && params.isNotEmpty) {
      debugPrint('  ↳ Params: $params');
    }
    
    if (headers != null && headers.isNotEmpty) {
      debugPrint('  ↳ Headers: $headers');
    }
  }

  /// Log API response
  void apiResponse(
    String method,
    String endpoint,
    int statusCode,
    Duration duration, {
    Object? data,
    String? error,
  }) {
    if (!kDebugMode) return;

    final ms = duration.inMilliseconds;
    final status = statusCode >= 200 && statusCode < 300 ? '✅' : '❌';
    
    debugPrint('$status API RESPONSE: $method $endpoint ($statusCode) - ${ms}ms');
    
    if (error != null) {
      debugPrint('  ↳ Error: $error');
    } else if (data != null) {
      debugPrint('  ↳ Data: $data');
    }
  }

  /// Log cache operation
  void cache(
    String operation,
    String key, {
    bool hit = false,
    int? itemCount,
  }) {
    if (!kDebugMode) return;

    final hitStr = hit ? '✅ HIT' : '❌ MISS';
    final countStr = itemCount != null ? ' ($itemCount items)' : '';
    
    debugPrint('💾 CACHE $hitStr: $operation [$key]$countStr');
  }

  /// Log user action
  void userAction(
    String action, {
    String? userId,
    Map<String, dynamic>? metadata,
  }) {
    if (!kDebugMode) return;

    final userStr = userId != null ? ' [User: $userId]' : '';
    
    debugPrint('👤 USER ACTION$userStr: $action');
    
    if (metadata != null) {
      debugPrint('  ↳ Metadata: $metadata');
    }
  }

  /// Log navigation
  void navigation(
    String route, {
    String? from,
    Map<String, dynamic>? arguments,
  }) {
    if (!kDebugMode) return;

    final fromStr = from != null ? ' from $from' : '';
    
    debugPrint('🧭 NAVIGATION$fromStr: → $route');
    
    if (arguments != null && arguments.isNotEmpty) {
      debugPrint('  ↳ Arguments: $arguments');
    }
  }

  /// Log state change
  void stateChange(
    String provider,
    String change, {
    Object? oldValue,
    Object? newValue,
  }) {
    if (!kDebugMode) return;

    debugPrint('🔄 STATE CHANGE [$provider]: $change');
    
    if (oldValue != null) {
      debugPrint('  ↳ Old: $oldValue');
    }
    
    if (newValue != null) {
      debugPrint('  ↳ New: $newValue');
    }
  }

  /// Create a performance timer
  PerformanceTimer startTimer(String operation, {String? context}) {
    return PerformanceTimer(operation, context: context, logger: this);
  }
}

/// Performance timer utility
class PerformanceTimer {
  final String operation;
  final String? context;
  final LoggingService logger;
  final Stopwatch _stopwatch;
  Map<String, dynamic>? metadata;

  PerformanceTimer(
    this.operation, {
    this.context,
    required this.logger,
  }) : _stopwatch = Stopwatch()..start();

  /// Add metadata to the timer
  void addMetadata(String key, dynamic value) {
    metadata ??= {};
    metadata![key] = value;
  }

  /// Stop the timer and log the result
  void stop() {
    _stopwatch.stop();
    logger.performance(
      operation,
      _stopwatch.elapsed,
      context: context,
      metadata: metadata,
    );
  }
}

/// Global logger instance
final logger = LoggingService.instance;