/// Performance utility functions and helpers
library;

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// Debouncer for search and filter operations
/// Delays the execution of a function until after a specified duration
class Debouncer {
  final Duration duration;
  Timer? _timer;

  Debouncer({this.duration = const Duration(milliseconds: 500)});

  /// Run the callback after the debounce duration
  void run(VoidCallback callback) {
    _timer?.cancel();
    _timer = Timer(duration, callback);
  }

  /// Cancel any pending callbacks
  void cancel() {
    _timer?.cancel();
  }

  /// Dispose the debouncer
  void dispose() {
    _timer?.cancel();
  }
}

/// Throttler for limiting function execution frequency
/// Ensures a function is called at most once per specified duration
class Throttler {
  final Duration duration;
  DateTime? _lastExecutionTime;

  Throttler({this.duration = const Duration(milliseconds: 300)});

  /// Run the callback if throttle duration has passed
  void run(VoidCallback callback) {
    final now = DateTime.now();

    if (_lastExecutionTime == null ||
        now.difference(_lastExecutionTime!) >= duration) {
      _lastExecutionTime = now;
      callback();
    }
  }

  /// Reset the throttler
  void reset() {
    _lastExecutionTime = null;
  }
}

/// Cache manager for expensive computations
class ComputationCache<K, V> {
  final Map<K, V> _cache = {};
  final int maxSize;

  ComputationCache({this.maxSize = 100});

  /// Get a cached value or compute it
  V getOrCompute(K key, V Function() compute) {
    if (_cache.containsKey(key)) {
      return _cache[key]!;
    }

    final value = compute();

    // Implement simple LRU by clearing oldest entries if cache is full
    if (_cache.length >= maxSize) {
      final firstKey = _cache.keys.first;
      _cache.remove(firstKey);
    }

    _cache[key] = value;
    return value;
  }

  /// Clear the cache
  void clear() {
    _cache.clear();
  }

  /// Remove a specific key from cache
  void remove(K key) {
    _cache.remove(key);
  }

  /// Check if cache contains a key
  bool containsKey(K key) {
    return _cache.containsKey(key);
  }

  /// Get cache size
  int get size => _cache.length;
}

/// Pagination helper for list rendering
class PaginationHelper<T> {
  final List<T> items;
  final int pageSize;
  int _currentPage = 0;

  PaginationHelper({
    required this.items,
    this.pageSize = 20,
  });

  /// Get items for current page
  List<T> get currentPageItems {
    final start = _currentPage * pageSize;
    final end = (start + pageSize).clamp(0, items.length);

    if (start >= items.length) return [];
    return items.sublist(start, end);
  }

  /// Get items up to current page (for infinite scroll)
  List<T> get itemsUpToCurrentPage {
    final end = ((_currentPage + 1) * pageSize).clamp(0, items.length);
    return items.sublist(0, end);
  }

  /// Load next page
  bool loadNextPage() {
    if (hasNextPage) {
      _currentPage++;
      return true;
    }
    return false;
  }

  /// Load previous page
  bool loadPreviousPage() {
    if (hasPreviousPage) {
      _currentPage--;
      return true;
    }
    return false;
  }

  /// Check if there's a next page
  bool get hasNextPage {
    return (_currentPage + 1) * pageSize < items.length;
  }

  /// Check if there's a previous page
  bool get hasPreviousPage {
    return _currentPage > 0;
  }

  /// Reset to first page
  void reset() {
    _currentPage = 0;
  }

  /// Get current page number (0-indexed)
  int get currentPage => _currentPage;

  /// Get total number of pages
  int get totalPages => (items.length / pageSize).ceil();

  /// Jump to specific page
  void goToPage(int page) {
    if (page >= 0 && page < totalPages) {
      _currentPage = page;
    }
  }
}

/// Image cache helper for network images
class ImageCacheHelper {
  static const int maxCacheSize = 100; // Number of images
  static const int maxMemoryCacheSize = 50 * 1024 * 1024; // 50 MB

  /// Configure image cache
  static void configure() {
    if (kIsWeb) return; // Skip on web
    // Configure image cache through PaintingBinding
    final imageCache = PaintingBinding.instance.imageCache;
    imageCache.maximumSize = maxCacheSize;
    imageCache.maximumSizeBytes = maxMemoryCacheSize;
  }

  /// Clear image cache
  static void clearCache() {
    if (kIsWeb) return; // Skip on web
    final imageCache = PaintingBinding.instance.imageCache;
    imageCache.clear();
    imageCache.clearLiveImages();
  }

  /// Get cache statistics
  static Map<String, dynamic> getCacheStats() {
    if (kIsWeb) {
      return {
        'currentSize': 0,
        'currentSizeBytes': 0,
        'maximumSize': maxCacheSize,
        'maximumSizeBytes': maxMemoryCacheSize,
        'liveImageCount': 0,
        'pendingImageCount': 0,
      };
    }
    final imageCache = PaintingBinding.instance.imageCache;
    return {
      'currentSize': imageCache.currentSize,
      'currentSizeBytes': imageCache.currentSizeBytes,
      'maximumSize': imageCache.maximumSize,
      'maximumSizeBytes': imageCache.maximumSizeBytes,
      'liveImageCount': imageCache.liveImageCount,
      'pendingImageCount': imageCache.pendingImageCount,
    };
  }
}

/// Memory usage monitoring (debug only)
class MemoryMonitor {
  /// Log current memory usage
  static void logMemoryUsage(String tag) {
    if (kDebugMode) {
      // Memory monitoring is limited in Flutter
      // This is a placeholder for potential future memory tracking
      debugPrint('[$tag] Memory monitoring point');
    }
  }
}

/// Format duration helper (extracted for reuse)
class DurationFormatter {
  /// Format seconds to HH:MM:SS or MM:SS
  static String format(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;

    if (minutes > 60) {
      final hours = minutes ~/ 60;
      final mins = minutes % 60;
      return '${hours}:${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }

    return '${minutes}:${secs.toString().padLeft(2, '0')}';
  }

  /// Format duration with labels
  static String formatWithLabels(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  /// Format to compact form (e.g., "2h 15m")
  static String formatCompact(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m';
    } else {
      return '${duration.inSeconds}s';
    }
  }
}

/// Build performance helper
class BuildOptimizer {
  /// Checks if a rebuild is necessary based on value equality
  static bool shouldRebuild<T>(T oldValue, T newValue) {
    return oldValue != newValue;
  }

  /// Creates a unique key for list items to optimize rebuilds
  static String createListItemKey(String prefix, int index, String id) {
    return '$prefix-$index-$id';
  }
}
