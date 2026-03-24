// Entry point for Crack the Code
//
// Single app with adaptive experience for all ages.
// Build with: flutter run

import 'package:crack_the_code/core/config/segment_config.dart';
import 'package:crack_the_code/main_common.dart';

void main() {
  SegmentConfig.initialize(AppSegment.crackTheCode);
  runCrackTheCodeApp();
}
