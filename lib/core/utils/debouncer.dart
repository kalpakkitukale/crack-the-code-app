import 'dart:async';
import 'package:flutter/foundation.dart';

/// Debouncer utility to delay execution of a function
/// Useful for search inputs and other scenarios where you want to wait
/// for the user to stop typing before executing a function
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({required this.delay});

  /// Run the action after the delay
  /// If called again before delay expires, the previous call is cancelled
  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  /// Cancel any pending actions
  void cancel() {
    _timer?.cancel();
  }

  /// Dispose the debouncer
  void dispose() {
    _timer?.cancel();
  }
}

/// Throttler utility to limit execution frequency
/// Executes immediately and then ignores calls for the duration
class Throttler {
  final Duration duration;
  Timer? _timer;
  bool _canExecute = true;

  Throttler({required this.duration});

  /// Run the action if not throttled
  void run(VoidCallback action) {
    if (_canExecute) {
      action();
      _canExecute = false;
      _timer = Timer(duration, () {
        _canExecute = true;
      });
    }
  }

  /// Dispose the throttler
  void dispose() {
    _timer?.cancel();
  }
}
