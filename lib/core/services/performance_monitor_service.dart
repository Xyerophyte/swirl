import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

/// Comprehensive performance monitoring service for tracking app performance
/// metrics including FPS, frame build times, memory usage, and custom traces.
/// 
/// Expected Impact: Real-time performance insights, proactive issue detection
class PerformanceMonitorService {
  static final PerformanceMonitorService _instance = PerformanceMonitorService._internal();
  factory PerformanceMonitorService() => _instance;
  PerformanceMonitorService._internal();

  // Performance metrics storage
  final List<FrameMetric> _frameMetrics = [];
  final Map<String, TraceMetric> _customTraces = {};
  final List<PerformanceIssue> _detectedIssues = [];
  
  // Configuration
  static const int _maxStoredFrames = 300; // Store last 5 seconds at 60fps
  static const double _targetFrameTime = 16.67; // 60 FPS target (ms)
  static const double _slowFrameThreshold = 33.33; // 30 FPS threshold (ms)
  static const int _issueDetectionWindow = 30; // Check last 30 frames
  
  // State
  bool _isMonitoring = false;
  FrameCallback? _frameCallback;
  DateTime? _lastFrameTime;
  int _frameCount = 0;
  
  // Statistics
  final Map<String, dynamic> _statistics = {
    'totalFrames': 0,
    'droppedFrames': 0,
    'slowFrames': 0,
    'averageFPS': 60.0,
    'averageFrameTime': 16.67,
    'jankPercentage': 0.0,
  };

  /// Start monitoring frame performance
  void startMonitoring() {
    if (_isMonitoring) return;
    
    _isMonitoring = true;
    _lastFrameTime = DateTime.now();
    
    _frameCallback = (Duration timestamp) {
      if (!_isMonitoring) return;
      
      final now = DateTime.now();
      final frameTime = now.difference(_lastFrameTime!).inMilliseconds.toDouble();
      _lastFrameTime = now;
      _frameCount++;
      
      // Record frame metric
      final metric = FrameMetric(
        timestamp: now,
        buildTime: frameTime,
        isJanky: frameTime > _slowFrameThreshold,
      );
      
      _addFrameMetric(metric);
      _updateStatistics(metric);
      _detectIssues();
      
      // Schedule next frame
      SchedulerBinding.instance.scheduleFrameCallback(_frameCallback!);
    };
    
    SchedulerBinding.instance.scheduleFrameCallback(_frameCallback!);
    debugPrint('Performance monitoring started');
  }

  /// Stop monitoring frame performance
  void stopMonitoring() {
    _isMonitoring = false;
    debugPrint('Performance monitoring stopped');
  }

  /// Add frame metric with size limit
  void _addFrameMetric(FrameMetric metric) {
    _frameMetrics.add(metric);
    
    // Keep only recent frames
    if (_frameMetrics.length > _maxStoredFrames) {
      _frameMetrics.removeAt(0);
    }
  }

  /// Update performance statistics
  void _updateStatistics(FrameMetric metric) {
    _statistics['totalFrames'] = (_statistics['totalFrames'] as int) + 1;
    
    if (metric.isJanky) {
      _statistics['slowFrames'] = (_statistics['slowFrames'] as int) + 1;
    }
    
    // Calculate rolling averages
    if (_frameMetrics.length >= 60) {
      final recentFrames = _frameMetrics.sublist(_frameMetrics.length - 60);
      final totalTime = recentFrames.fold<double>(0, (sum, f) => sum + f.buildTime);
      final avgFrameTime = totalTime / recentFrames.length;
      
      _statistics['averageFrameTime'] = avgFrameTime;
      _statistics['averageFPS'] = 1000 / avgFrameTime;
      
      final jankyCount = recentFrames.where((f) => f.isJanky).length;
      _statistics['jankPercentage'] = (jankyCount / recentFrames.length) * 100;
    }
  }

  /// Detect performance issues
  void _detectIssues() {
    if (_frameMetrics.length < _issueDetectionWindow) return;
    
    final recentFrames = _frameMetrics.sublist(_frameMetrics.length - _issueDetectionWindow);
    final jankyCount = recentFrames.where((f) => f.isJanky).length;
    final jankPercentage = (jankyCount / _issueDetectionWindow) * 100;
    
    // Detect sustained jank (>20% janky frames in window)
    if (jankPercentage > 20) {
      _addIssue(PerformanceIssue(
        timestamp: DateTime.now(),
        type: PerformanceIssueType.sustainedJank,
        severity: jankPercentage > 50 ? IssueSeverity.critical : IssueSeverity.warning,
        description: 'Sustained jank detected: ${jankPercentage.toStringAsFixed(1)}% of frames are slow',
        metrics: {'jankPercentage': jankPercentage},
      ));
    }
    
    // Detect frame drops (consecutive slow frames)
    int consecutiveSlow = 0;
    for (final frame in recentFrames.reversed) {
      if (frame.isJanky) {
        consecutiveSlow++;
      } else {
        break;
      }
    }
    
    if (consecutiveSlow >= 5) {
      _addIssue(PerformanceIssue(
        timestamp: DateTime.now(),
        type: PerformanceIssueType.frameDrops,
        severity: consecutiveSlow >= 10 ? IssueSeverity.critical : IssueSeverity.warning,
        description: '$consecutiveSlow consecutive slow frames detected',
        metrics: {'consecutiveFrames': consecutiveSlow},
      ));
    }
  }

  /// Add performance issue (deduplicate)
  void _addIssue(PerformanceIssue issue) {
    // Avoid duplicate issues within 5 seconds
    final recentIssues = _detectedIssues.where((i) =>
      i.type == issue.type &&
      DateTime.now().difference(i.timestamp).inSeconds < 5
    );
    
    if (recentIssues.isEmpty) {
      _detectedIssues.add(issue);
      debugPrint('Performance issue detected: ${issue.description}');
      
      // Keep only recent issues (last 100)
      if (_detectedIssues.length > 100) {
        _detectedIssues.removeAt(0);
      }
    }
  }

  /// Start custom performance trace
  void startTrace(String name) {
    _customTraces[name] = TraceMetric(
      name: name,
      startTime: DateTime.now(),
    );
  }

  /// Stop custom performance trace
  void stopTrace(String name) {
    final trace = _customTraces[name];
    if (trace != null && trace.endTime == null) {
      trace.endTime = DateTime.now();
      trace.duration = trace.endTime!.difference(trace.startTime);
      
      debugPrint('Trace "$name" completed in ${trace.duration!.inMilliseconds}ms');
    }
  }

  /// Record custom metric
  void recordMetric(String name, double value, {String? unit}) {
    debugPrint('Metric "$name": $value${unit ?? ''}');
  }

  /// Get current FPS
  double getCurrentFPS() {
    return _statistics['averageFPS'] as double;
  }

  /// Get current frame time
  double getCurrentFrameTime() {
    return _statistics['averageFrameTime'] as double;
  }

  /// Get jank percentage
  double getJankPercentage() {
    return _statistics['jankPercentage'] as double;
  }

  /// Get all statistics
  Map<String, dynamic> getStatistics() {
    return Map.unmodifiable(_statistics);
  }

  /// Get recent performance issues
  List<PerformanceIssue> getRecentIssues({int limit = 10}) {
    return _detectedIssues.reversed.take(limit).toList();
  }

  /// Get custom traces
  List<TraceMetric> getTraces() {
    return _customTraces.values.where((t) => t.duration != null).toList()
      ..sort((a, b) => b.startTime.compareTo(a.startTime));
  }

  /// Generate performance report
  String generateReport() {
    final buffer = StringBuffer()
      ..writeln('=== Performance Report ===')
      ..writeln('Monitoring: ${_isMonitoring ? 'Active' : 'Inactive'}')
      ..writeln('\nFrame Statistics:')
      ..writeln('  Total Frames: ${_statistics['totalFrames']}')
      ..writeln('  Slow Frames: ${_statistics['slowFrames']}')
      ..writeln('  Average FPS: ${(_statistics['averageFPS'] as double).toStringAsFixed(1)}')
      ..writeln('  Average Frame Time: ${(_statistics['averageFrameTime'] as double).toStringAsFixed(2)}ms')
      ..writeln('  Jank Percentage: ${(_statistics['jankPercentage'] as double).toStringAsFixed(1)}%')
      ..writeln('\nRecent Issues: ${_detectedIssues.length}');
    
    final recentIssues = getRecentIssues(limit: 5);
    if (recentIssues.isNotEmpty) {
      buffer.writeln('\nLast 5 Issues:');
      for (final issue in recentIssues) {
        buffer.writeln('  [${issue.severity.name.toUpperCase()}] ${issue.description}');
      }
    }
    
    final traces = getTraces();
    if (traces.isNotEmpty) {
      buffer.writeln('\nRecent Traces:');
      for (final trace in traces.take(5)) {
        buffer.writeln('  ${trace.name}: ${trace.duration!.inMilliseconds}ms');
      }
    }
    
    return buffer.toString();
  }

  /// Check if performance is healthy
  bool isPerformanceHealthy() {
    final fps = getCurrentFPS();
    final jank = getJankPercentage();
    return fps >= 55 && jank < 10; // 55+ FPS and <10% jank
  }

  /// Get performance health status
  PerformanceHealth getHealthStatus() {
    final fps = getCurrentFPS();
    final jank = getJankPercentage();
    
    if (fps >= 58 && jank < 5) {
      return PerformanceHealth.excellent;
    } else if (fps >= 55 && jank < 10) {
      return PerformanceHealth.good;
    } else if (fps >= 45 && jank < 20) {
      return PerformanceHealth.fair;
    } else {
      return PerformanceHealth.poor;
    }
  }

  /// Reset all metrics
  void reset() {
    _frameMetrics.clear();
    _customTraces.clear();
    _detectedIssues.clear();
    _frameCount = 0;
    _statistics['totalFrames'] = 0;
    _statistics['droppedFrames'] = 0;
    _statistics['slowFrames'] = 0;
    _statistics['averageFPS'] = 60.0;
    _statistics['averageFrameTime'] = 16.67;
    _statistics['jankPercentage'] = 0.0;
    debugPrint('Performance metrics reset');
  }
}

/// Frame performance metric
class FrameMetric {
  final DateTime timestamp;
  final double buildTime;
  final bool isJanky;

  FrameMetric({
    required this.timestamp,
    required this.buildTime,
    required this.isJanky,
  });
}

/// Custom trace metric
class TraceMetric {
  final String name;
  final DateTime startTime;
  DateTime? endTime;
  Duration? duration;

  TraceMetric({
    required this.name,
    required this.startTime,
    this.endTime,
    this.duration,
  });
}

/// Performance issue detected
class PerformanceIssue {
  final DateTime timestamp;
  final PerformanceIssueType type;
  final IssueSeverity severity;
  final String description;
  final Map<String, dynamic> metrics;

  PerformanceIssue({
    required this.timestamp,
    required this.type,
    required this.severity,
    required this.description,
    required this.metrics,
  });
}

/// Types of performance issues
enum PerformanceIssueType {
  sustainedJank,
  frameDrops,
  memoryPressure,
  slowTrace,
}

/// Issue severity levels
enum IssueSeverity {
  info,
  warning,
  critical,
}

/// Performance health status
enum PerformanceHealth {
  excellent, // 58+ FPS, <5% jank
  good,      // 55+ FPS, <10% jank
  fair,      // 45+ FPS, <20% jank
  poor,      // Below 45 FPS or >20% jank
}