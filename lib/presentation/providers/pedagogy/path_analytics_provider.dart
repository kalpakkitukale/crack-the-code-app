/// Path Analytics Provider
///
/// Provides access to path analytics service via Riverpod
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamshaala/domain/services/path_analytics_service.dart';
import 'package:streamshaala/infrastructure/di/injection_container.dart';

/// Provider for PathAnalyticsService
final pathAnalyticsServiceProvider = Provider<PathAnalyticsService>((ref) {
  return injectionContainer.pathAnalyticsService;
});
