// Entry point for StreamShaala Senior (Grades 11-12)
//
// This file initializes the app with Senior segment configuration.
// Build with: flutter run --flavor senior -t lib/main_senior.dart

import 'package:streamshaala/core/config/segment_config.dart';
import 'package:streamshaala/main_common.dart';

void main() {
  // Initialize Senior segment configuration FIRST
  SegmentConfig.initialize(AppSegment.senior);

  // Run common initialization and app
  runStreamShaalaApp();
}
