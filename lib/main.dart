// Default entry point for StreamShaala
//
// This file defaults to Senior segment for backward compatibility.
// For specific variants, use:
//   - main_junior.dart (Grades 1-7)
//   - main_senior.dart (Grades 11-12)
//
// Build variants:
//   flutter run --flavor junior -t lib/main_junior.dart
//   flutter run --flavor senior -t lib/main_senior.dart

import 'package:streamshaala/core/config/segment_config.dart';
import 'package:streamshaala/main_common.dart';

void main() {
  // Default to Senior segment for backward compatibility
  // This ensures existing builds continue to work unchanged
  SegmentConfig.initialize(AppSegment.senior);

  // Run common initialization and app
  runStreamShaalaApp();
}
