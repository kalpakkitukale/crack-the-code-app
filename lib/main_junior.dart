// Entry point for StreamShaala Junior (Grades 1-7)
//
// This file initializes the app with Junior segment configuration.
// Build with: flutter run --flavor junior -t lib/main_junior.dart

import 'package:streamshaala/core/config/segment_config.dart';
import 'package:streamshaala/main_common.dart';

void main() {
  // Initialize Junior segment configuration FIRST
  SegmentConfig.initialize(AppSegment.junior);

  // Run common initialization and app
  runStreamShaalaApp();
}
