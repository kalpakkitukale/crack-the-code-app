// Entry point for StreamShaala Board Prep (Grade 10)
//
// This file initializes the app with Preboard segment configuration.
// Build with: flutter run --flavor preboard -t lib/main_preboard.dart

import 'package:streamshaala/core/config/segment_config.dart';
import 'package:streamshaala/main_common.dart';

void main() {
  // Initialize Preboard segment configuration FIRST
  SegmentConfig.initialize(AppSegment.preboard);

  // Run common initialization and app
  runStreamShaalaApp();
}
