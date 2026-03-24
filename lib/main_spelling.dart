// Entry point for SpellShaala (English Spelling Learning)
//
// This file initializes the app with Spelling segment configuration.
// Build with: flutter run --flavor spelling -t lib/main_spelling.dart

import 'package:streamshaala/core/config/segment_config.dart';
import 'package:streamshaala/main_common.dart';

void main() {
  // Initialize Spelling segment configuration FIRST
  SegmentConfig.initialize(AppSegment.spelling);

  // Run common initialization and app
  runStreamShaalaApp();
}
