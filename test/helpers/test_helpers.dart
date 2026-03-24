/// Test helpers for StreamShaala tests
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Create a test app with provider overrides
Widget createTestApp({
  required Widget child,
  List<Override> overrides = const [],
}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      home: Scaffold(body: child),
    ),
  );
}

/// Create a test app with router config
Widget createTestAppWithRouter({
  required RouterConfig<Object> routerConfig,
  List<Override> overrides = const [],
}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp.router(
      routerConfig: routerConfig,
    ),
  );
}

/// Pump and settle with timeout
extension WidgetTesterExtensions on WidgetTester {
  /// Pump widget with common setup
  Future<void> pumpTestWidget(Widget widget) async {
    await pumpWidget(widget);
    await pumpAndSettle();
  }

  /// Pump with timeout to avoid infinite animations
  Future<void> pumpWithTimeout({
    Duration duration = const Duration(seconds: 5),
  }) async {
    await pumpAndSettle(duration);
  }
}

/// Test constants
class TestConstants {
  static const Duration defaultTimeout = Duration(seconds: 10);
  static const Duration animationDuration = Duration(milliseconds: 300);

  // Test profile IDs
  static const String profileA = 'test-profile-a-uuid';
  static const String profileB = 'test-profile-b-uuid';
  static const String defaultProfile = 'default-profile-uuid';

  // Test video IDs
  static const String videoId1 = 'test-video-1';
  static const String videoId2 = 'test-video-2';
  static const String videoId3 = 'test-video-3';

  // Test quiz IDs
  static const String quizId1 = 'test-quiz-1';
  static const String quizId2 = 'test-quiz-2';

  // Test student IDs
  static const String studentId1 = 'test-student-1';
  static const String studentId2 = 'test-student-2';
}

/// Screen sizes for responsive testing
class TestScreenSizes {
  static const Size iphoneSE = Size(320, 568);
  static const Size iphone8 = Size(375, 667);
  static const Size iphone14 = Size(393, 852);
  static const Size iphone14ProMax = Size(430, 932);
  static const Size ipadMini = Size(768, 1024);
  static const Size ipadPro = Size(1024, 1366);

  static const List<Size> mobileDevices = [iphoneSE, iphone8, iphone14];
  static const List<Size> allDevices = [iphoneSE, iphone8, iphone14, ipadMini];
}

/// Helper to set screen size in tests
extension ScreenSizeExtension on WidgetTester {
  void setScreenSize(Size size) {
    view.physicalSize = size;
    view.devicePixelRatio = 1.0;
  }

  void resetScreenSize() {
    view.resetPhysicalSize();
  }
}
