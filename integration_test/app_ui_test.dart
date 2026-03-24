import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:crack_the_code/main.dart' as app;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Crack the Code UI Tests', () {
    testWidgets('Navigate through app and capture screenshots', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Take screenshot of home screen
      await tester.pumpAndSettle();
      await binding.takeScreenshot('01_home_screen');

      // Navigate to Browse tab
      final browseFinder = find.text('Browse');
      await tester.tap(browseFinder);
      await tester.pumpAndSettle();
      await binding.takeScreenshot('02_browse_board_selection');

      // Tap on CBSE board
      final cbseFinder = find.text('CBSE');
      if (cbseFinder.evaluate().isNotEmpty) {
        await tester.tap(cbseFinder);
        await tester.pumpAndSettle();
        await binding.takeScreenshot('03_subject_selection');
      }

      // Tap on Physics subject
      final physicsFinder = find.text('Physics');
      if (physicsFinder.evaluate().isNotEmpty) {
        await tester.tap(physicsFinder);
        await tester.pumpAndSettle();
        await binding.takeScreenshot('04_chapter_selection');
      }

      // Scroll down to see bottom items
      await tester.drag(
        find.byType(ListView).first,
        const Offset(0, -500),
      );
      await tester.pumpAndSettle();
      await binding.takeScreenshot('05_scrolled_view');

      // Navigate to video player (if videos are visible)
      final videoFinder = find.byType(Card).first;
      if (videoFinder.evaluate().isNotEmpty) {
        await tester.tap(videoFinder);
        await tester.pumpAndSettle(const Duration(seconds: 2));
        await binding.takeScreenshot('06_video_player');
      }

      // Test related videos section
      await tester.drag(
        find.byType(ListView).last,
        const Offset(0, -200),
      );
      await tester.pumpAndSettle();
      await binding.takeScreenshot('07_related_videos');
    });

    testWidgets('Check bottom overflow issues', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Home screen - scroll to bottom
      await tester.dragUntilVisible(
        find.text('Recent Videos').first,
        find.byType(CustomScrollView),
        const Offset(0, -100),
      );
      await tester.pumpAndSettle();
      await binding.takeScreenshot('08_home_bottom');

      // Navigate to Browse and check bottom
      final browseFinder = find.text('Browse');
      await tester.tap(browseFinder);
      await tester.pumpAndSettle();

      await tester.dragUntilVisible(
        find.byType(Card).last,
        find.byType(CustomScrollView),
        const Offset(0, -100),
      );
      await tester.pumpAndSettle();
      await binding.takeScreenshot('09_browse_bottom');
    });
  });
}
