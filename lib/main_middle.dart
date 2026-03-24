// Entry point for StreamShaala Middle (Grades 7-9)
//
// This file initializes the app with Middle segment configuration.
// Build with: flutter run --flavor middle -t lib/main_middle.dart

import 'package:streamshaala/core/config/segment_config.dart';
import 'package:streamshaala/main_common.dart';

void main() {
  // Initialize Middle segment configuration FIRST
  SegmentConfig.initialize(AppSegment.middle);

  // Run common initialization and app
  runStreamShaalaApp();
}
