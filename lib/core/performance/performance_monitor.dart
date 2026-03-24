// Performance Monitoring
// Tracks app performance metrics including startup time, frame rates, and memory usage
// Essential for ensuring smooth experience on Junior segment devices

import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// Performance metric types
enum PerformanceMetric {
  appStartup,
  screenLoad,
  contentLoad,
  videoLoad,
  quizLoad,
  databaseQuery,
  networkRequest,
  imageLoad,
  animationFrame,
}

/// Performance thresholds (in milliseconds)
class PerformanceThresholds {
  static const int appStartupGood = 2000;
  static const int appStartupAcceptable = 3000;

  static const int screenLoadGood = 300;
  static const int screenLoadAcceptable = 500;

  static const int contentLoadGood = 500;
  static const int contentLoadAcceptable = 1000;

  static const int networkRequestGood = 1000;
  static const int networkRequestAcceptable = 3000;

  static const int databaseQueryGood = 50;
  static const int databaseQueryAcceptable = 200;

  static const double frameRateGood = 55.0;
  static const double frameRateAcceptable = 30.0;
}

/// Performance result classification
enum PerformanceResult {
  good,
  acceptable,
  poor,
}

/// Performance measurement record
class PerformanceMeasurement {
  final PerformanceMetric metric;
  final String name;
  final int durationMs;
  final DateTime timestamp;
  final Map<String, dynamic>? extras;

  PerformanceMeasurement({
    required this.metric,
    required this.name,
    required this.durationMs,
    DateTime? timestamp,
    this.extras,
  }) : timestamp = timestamp ?? DateTime.now();

  PerformanceResult get result {
    switch (metric) {
      case PerformanceMetric.appStartup:
        if (durationMs < PerformanceThresholds.appStartupGood) {
          return PerformanceResult.good;
        }
        if (durationMs < PerformanceThresholds.appStartupAcceptable) {
          return PerformanceResult.acceptable;
        }
        return PerformanceResult.poor;

      case PerformanceMetric.screenLoad:
        if (durationMs < PerformanceThresholds.screenLoadGood) {
          return PerformanceResult.good;
        }
        if (durationMs < PerformanceThresholds.screenLoadAcceptable) {
          return PerformanceResult.acceptable;
        }
        return PerformanceResult.poor;

      case PerformanceMetric.contentLoad:
      case PerformanceMetric.videoLoad:
      case PerformanceMetric.quizLoad:
        if (durationMs < PerformanceThresholds.contentLoadGood) {
          return PerformanceResult.good;
        }
        if (durationMs < PerformanceThresholds.contentLoadAcceptable) {
          return PerformanceResult.acceptable;
        }
        return PerformanceResult.poor;

      case PerformanceMetric.networkRequest:
        if (durationMs < PerformanceThresholds.networkRequestGood) {
          return PerformanceResult.good;
        }
        if (durationMs < PerformanceThresholds.networkRequestAcceptable) {
          return PerformanceResult.acceptable;
        }
        return PerformanceResult.poor;

      case PerformanceMetric.databaseQuery:
        if (durationMs < PerformanceThresholds.databaseQueryGood) {
          return PerformanceResult.good;
        }
        if (durationMs < PerformanceThresholds.databaseQueryAcceptable) {
          return PerformanceResult.acceptable;
        }
        return PerformanceResult.poor;

      case PerformanceMetric.imageLoad:
      case PerformanceMetric.animationFrame:
        // Use content thresholds as default
        if (durationMs < PerformanceThresholds.contentLoadGood) {
          return PerformanceResult.good;
        }
        if (durationMs < PerformanceThresholds.contentLoadAcceptable) {
          return PerformanceResult.acceptable;
        }
        return PerformanceResult.poor;
    }
  }

  Map<String, dynamic> toJson() => {
        'metric': metric.name,
        'name': name,
        'duration_ms': durationMs,
        'result': result.name,
        'timestamp': timestamp.toIso8601String(),
        if (extras != null) ...extras!,
      };
}

/// Performance Monitor singleton
class PerformanceMonitor {
  static final PerformanceMonitor _instance = PerformanceMonitor._internal();
  factory PerformanceMonitor() => _instance;
  PerformanceMonitor._internal();

  /// Whether monitoring is enabled
  bool _isEnabled = kDebugMode;

  /// Active measurements (trace name -> start time)
  final Map<String, _ActiveTrace> _activeTraces = {};

  /// Completed measurements
  final List<PerformanceMeasurement> _measurements = [];
  static const int _maxMeasurements = 100;

  /// Frame rate tracking
  int _frameCount = 0;
  DateTime? _frameRateStart;
  double _currentFrameRate = 60.0;

  /// App startup time
  DateTime? _appStartTime;
  int? _appStartupDuration;

  /// Initialize performance monitoring
  void initialize() {
    _appStartTime = DateTime.now();

    if (_isEnabled) {
      // Start frame rate monitoring
      _startFrameRateMonitoring();

      debugPrint('[Performance] Monitoring initialized');
    }
  }

  /// Set monitoring enabled state
  void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  /// Record app startup complete
  void recordAppStartupComplete() {
    if (_appStartTime != null) {
      _appStartupDuration = DateTime.now().difference(_appStartTime!).inMilliseconds;

      _recordMeasurement(PerformanceMeasurement(
        metric: PerformanceMetric.appStartup,
        name: 'App Startup',
        durationMs: _appStartupDuration!,
      ));

      if (_isEnabled) {
        debugPrint('[Performance] App startup: ${_appStartupDuration}ms');
      }
    }
  }

  /// Start a performance trace
  void startTrace(String name, PerformanceMetric metric) {
    if (!_isEnabled) return;

    _activeTraces[name] = _ActiveTrace(
      name: name,
      metric: metric,
      startTime: DateTime.now(),
    );

    // Use dart:developer Timeline for profiling tools
    developer.Timeline.startSync(name);
  }

  /// Stop a performance trace
  PerformanceMeasurement? stopTrace(String name, {Map<String, dynamic>? extras}) {
    developer.Timeline.finishSync();

    final trace = _activeTraces.remove(name);
    if (trace == null) return null;

    final duration = DateTime.now().difference(trace.startTime).inMilliseconds;

    final measurement = PerformanceMeasurement(
      metric: trace.metric,
      name: name,
      durationMs: duration,
      extras: extras,
    );

    _recordMeasurement(measurement);

    if (_isEnabled) {
      final resultIcon = switch (measurement.result) {
        PerformanceResult.good => '✓',
        PerformanceResult.acceptable => '⚠',
        PerformanceResult.poor => '✗',
      };
      debugPrint('[Performance] $resultIcon $name: ${duration}ms');
    }

    return measurement;
  }

  /// Measure async operation
  Future<T> measureAsync<T>(
    String name,
    PerformanceMetric metric,
    Future<T> Function() operation, {
    Map<String, dynamic>? extras,
  }) async {
    startTrace(name, metric);
    try {
      return await operation();
    } finally {
      stopTrace(name, extras: extras);
    }
  }

  /// Measure sync operation
  T measureSync<T>(
    String name,
    PerformanceMetric metric,
    T Function() operation, {
    Map<String, dynamic>? extras,
  }) {
    startTrace(name, metric);
    try {
      return operation();
    } finally {
      stopTrace(name, extras: extras);
    }
  }

  /// Record a measurement
  void _recordMeasurement(PerformanceMeasurement measurement) {
    _measurements.add(measurement);

    // Keep only recent measurements
    if (_measurements.length > _maxMeasurements) {
      _measurements.removeAt(0);
    }
  }

  /// Start frame rate monitoring
  void _startFrameRateMonitoring() {
    _frameRateStart = DateTime.now();
    _frameCount = 0;

    SchedulerBinding.instance.addPersistentFrameCallback((timeStamp) {
      _frameCount++;

      final elapsed = DateTime.now().difference(_frameRateStart!);
      if (elapsed.inSeconds >= 1) {
        _currentFrameRate = _frameCount / elapsed.inSeconds;
        _frameCount = 0;
        _frameRateStart = DateTime.now();
      }
    });
  }

  /// Get current frame rate
  double get currentFrameRate => _currentFrameRate;

  /// Get frame rate performance result
  PerformanceResult get frameRateResult {
    if (_currentFrameRate >= PerformanceThresholds.frameRateGood) {
      return PerformanceResult.good;
    }
    if (_currentFrameRate >= PerformanceThresholds.frameRateAcceptable) {
      return PerformanceResult.acceptable;
    }
    return PerformanceResult.poor;
  }

  /// Get app startup duration
  int? get appStartupDuration => _appStartupDuration;

  /// Get recent measurements
  List<PerformanceMeasurement> get recentMeasurements =>
      List.unmodifiable(_measurements);

  /// Get measurements by metric type
  List<PerformanceMeasurement> getMeasurementsByType(PerformanceMetric metric) {
    return _measurements.where((m) => m.metric == metric).toList();
  }

  /// Get average duration for a metric type
  double? getAverageDuration(PerformanceMetric metric) {
    final measurements = getMeasurementsByType(metric);
    if (measurements.isEmpty) return null;

    final total = measurements.fold<int>(0, (sum, m) => sum + m.durationMs);
    return total / measurements.length;
  }

  /// Get performance summary
  Map<String, dynamic> getSummary() {
    return {
      'app_startup_ms': _appStartupDuration,
      'current_frame_rate': _currentFrameRate,
      'frame_rate_result': frameRateResult.name,
      'total_measurements': _measurements.length,
      'poor_measurements': _measurements.where((m) => m.result == PerformanceResult.poor).length,
      'averages': {
        for (final metric in PerformanceMetric.values)
          if (getAverageDuration(metric) != null)
            metric.name: getAverageDuration(metric),
      },
    };
  }

  /// Clear measurements
  void clearMeasurements() {
    _measurements.clear();
  }
}

/// Internal active trace record
class _ActiveTrace {
  final String name;
  final PerformanceMetric metric;
  final DateTime startTime;

  _ActiveTrace({
    required this.name,
    required this.metric,
    required this.startTime,
  });
}

/// Global performance monitor instance
final performanceMonitor = PerformanceMonitor();

/// Widget that measures build time
class PerformanceTracker extends StatefulWidget {
  final String name;
  final PerformanceMetric metric;
  final Widget child;

  const PerformanceTracker({
    super.key,
    required this.name,
    this.metric = PerformanceMetric.screenLoad,
    required this.child,
  });

  @override
  State<PerformanceTracker> createState() => _PerformanceTrackerState();
}

class _PerformanceTrackerState extends State<PerformanceTracker> {
  @override
  void initState() {
    super.initState();
    performanceMonitor.startTrace(widget.name, widget.metric);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Stop trace after first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      performanceMonitor.stopTrace(widget.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Extension for measuring operations
extension PerformanceMeasureExtension<T> on Future<T> {
  /// Measure async operation performance
  Future<T> withPerformanceTracking(
    String name,
    PerformanceMetric metric, {
    Map<String, dynamic>? extras,
  }) {
    return performanceMonitor.measureAsync(name, metric, () => this, extras: extras);
  }
}
