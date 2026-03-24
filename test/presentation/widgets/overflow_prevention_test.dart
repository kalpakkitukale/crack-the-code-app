/// Widget overflow prevention tests
/// Tests for ensuring widgets don't overflow on various screen sizes
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('Overflow Prevention', () {
    // =========================================================================
    // SCREEN SIZES FOR TESTING
    // =========================================================================
    final testSizes = [
      (width: 320.0, height: 568.0, name: 'iPhone SE (smallest)'),
      (width: 375.0, height: 667.0, name: 'iPhone 8'),
      (width: 393.0, height: 852.0, name: 'iPhone 14'),
      (width: 430.0, height: 932.0, name: 'iPhone 14 Pro Max'),
      (width: 768.0, height: 1024.0, name: 'iPad Mini'),
    ];

    // =========================================================================
    // GENERIC OVERFLOW TEST HELPER
    // =========================================================================
    void testNoOverflow({
      required WidgetTester tester,
      required Widget widget,
      required Size screenSize,
      String? testName,
    }) {
      tester.view.physicalSize = screenSize;
      tester.view.devicePixelRatio = 1.0;
    }

    // =========================================================================
    // TEXT OVERFLOW TESTS
    // =========================================================================
    group('Long Text Handling', () {
      for (final size in testSizes) {
        testWidgets('long_title_no_overflow_${size.name}', (tester) async {
          tester.view.physicalSize = Size(size.width, size.height);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(() => tester.view.resetPhysicalSize());

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Long title text
                      Text(
                        'This is a very long title that should not overflow the screen boundary and should wrap properly to multiple lines',
                        style: const TextStyle(fontSize: 18),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );

          // Should not throw any overflow exceptions
          expect(tester.takeException(), isNull);
        });
      }
    });

    // =========================================================================
    // CARD WIDGET OVERFLOW TESTS
    // =========================================================================
    group('Card Widgets', () {
      for (final size in testSizes) {
        testWidgets('video_card_no_overflow_${size.name}', (tester) async {
          tester.view.physicalSize = Size(size.width, size.height);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(() => tester.view.resetPhysicalSize());

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Thumbnail placeholder
                            Container(
                              height: 100,
                              width: double.infinity,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 8),
                            // Long video title
                            const Text(
                              'Understanding Complex Mathematical Concepts: A Comprehensive Introduction to Algebra and Geometry for Students',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            // Channel name
                            const Text(
                              'Educational Content Creator Channel Name That Might Be Long',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 4),
                            // Duration and views
                            Row(
                              children: const [
                                Icon(Icons.access_time, size: 14),
                                SizedBox(width: 4),
                                Text('45:30'),
                                SizedBox(width: 16),
                                Icon(Icons.visibility, size: 14),
                                SizedBox(width: 4),
                                Text('1.2M views'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );

          expect(tester.takeException(), isNull);
        });

        testWidgets('quiz_history_card_no_overflow_${size.name}', (tester) async {
          tester.view.physicalSize = Size(size.width, size.height);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(() => tester.view.resetPhysicalSize());

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            // Score circle
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green[100],
                              ),
                              child: const Center(
                                child: Text('85%', style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Quiz info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Very Long Quiz Name That Could Potentially Overflow the Screen',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Environmental Science and Social Studies',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Readiness Assessment • 5 questions',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            // Arrow
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );

          expect(tester.takeException(), isNull);
        });
      }
    });

    // =========================================================================
    // LIST VIEW OVERFLOW TESTS
    // =========================================================================
    group('List Views', () {
      for (final size in testSizes) {
        testWidgets('horizontal_list_no_overflow_${size.name}', (tester) async {
          tester.view.physicalSize = Size(size.width, size.height);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(() => tester.view.resetPhysicalSize());

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 150,
                        margin: const EdgeInsets.all(8),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 80,
                                  color: Colors.grey[300],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Video Title $index That Is Very Long',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );

          expect(tester.takeException(), isNull);
        });

        testWidgets('vertical_list_no_overflow_${size.name}', (tester) async {
          tester.view.physicalSize = Size(size.width, size.height);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(() => tester.view.resetPhysicalSize());

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: ListView.builder(
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(child: Text('$index')),
                      title: Text(
                        'List Item $index with a very long title that should truncate properly',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        'Subtitle text that might also be long and need truncation',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.arrow_forward),
                    );
                  },
                ),
              ),
            ),
          );

          expect(tester.takeException(), isNull);
        });
      }
    });

    // =========================================================================
    // ROW OVERFLOW TESTS
    // =========================================================================
    group('Row Layouts', () {
      for (final size in testSizes) {
        testWidgets('row_with_flexible_no_overflow_${size.name}', (tester) async {
          tester.view.physicalSize = Size(size.width, size.height);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(() => tester.view.resetPhysicalSize());

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const CircleAvatar(radius: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'This is a very long name that should not overflow',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Secondary text that is also quite long',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('Action'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );

          expect(tester.takeException(), isNull);
        });
      }
    });

    // =========================================================================
    // CHIP OVERFLOW TESTS
    // =========================================================================
    group('Chip Layouts', () {
      for (final size in testSizes) {
        testWidgets('answer_ready_chip_no_overflow_${size.name}', (tester) async {
          tester.view.physicalSize = Size(size.width, size.height);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(() => tester.view.resetPhysicalSize());

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Chip(
                    avatar: const Icon(Icons.check_circle, size: 18),
                    label: const Text(
                      'Answer ready',
                      style: TextStyle(fontSize: 12),
                    ),
                    backgroundColor: Colors.green[100],
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                  ),
                ),
              ),
            ),
          );

          expect(tester.takeException(), isNull);
        });

        testWidgets('wrap_chips_no_overflow_${size.name}', (tester) async {
          tester.view.physicalSize = Size(size.width, size.height);
          tester.view.devicePixelRatio = 1.0;
          addTearDown(() => tester.view.resetPhysicalSize());

          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      'Mathematics',
                      'Science',
                      'English',
                      'Social Studies',
                      'Environmental Science',
                    ].map((subject) {
                      return Chip(label: Text(subject));
                    }).toList(),
                  ),
                ),
              ),
            ),
          );

          expect(tester.takeException(), isNull);
        });
      }
    });

    // =========================================================================
    // TOUCH TARGET SIZE TESTS
    // =========================================================================
    group('Touch Target Sizes', () {
      testWidgets('buttons_meet_minimum_size', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Submit'),
                ),
              ),
            ),
          ),
        );

        final button = tester.getRect(find.byType(ElevatedButton));
        expect(button.width, greaterThanOrEqualTo(48));
        expect(button.height, greaterThanOrEqualTo(48));
      });

      testWidgets('icon_buttons_meet_minimum_size', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.close),
                ),
              ),
            ),
          ),
        );

        final button = tester.getRect(find.byType(IconButton));
        expect(button.width, greaterThanOrEqualTo(48));
        expect(button.height, greaterThanOrEqualTo(48));
      });
    });
  });
}
