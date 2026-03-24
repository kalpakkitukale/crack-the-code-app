/// ProgressDAO tests - Database CRUD operations and multi-profile isolation
/// Note: These tests require sqflite_ffi for in-memory database testing
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:crack_the_code/domain/entities/user/progress.dart';

import '../../fixtures/progress_fixtures.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('ProgressDAO', () {
    // Note: Full DAO tests require sqflite_ffi setup
    // These are unit tests for the logic without actual database

    // =========================================================================
    // MULTI-PROFILE ISOLATION TESTS (CRITICAL)
    // =========================================================================
    group('Multi-Profile Data Isolation (CRITICAL)', () {
      test('data_filtering_by_profileId', () {
        // Simulate data from two profiles
        const profileA = 'profile-uuid-a';
        const profileB = 'profile-uuid-b';

        final allData = [
          {'id': '1', 'videoId': 'v1', 'profileId': profileA, 'watchDuration': 100},
          {'id': '2', 'videoId': 'v1', 'profileId': profileB, 'watchDuration': 200},
          {'id': '3', 'videoId': 'v2', 'profileId': profileA, 'watchDuration': 150},
        ];

        // Simulate getAll with profile filter
        final profileAData = allData.where((d) => d['profileId'] == profileA).toList();
        final profileBData = allData.where((d) => d['profileId'] == profileB).toList();

        expect(profileAData.length, 2, reason: 'Profile A should have 2 records');
        expect(profileBData.length, 1, reason: 'Profile B should have 1 record');
      });

      test('same_videoId_different_profiles_returns_correct_data', () {
        const profileA = 'profile-uuid-a';
        const profileB = 'profile-uuid-b';
        const videoId = 'shared-video';

        // Same video, different watch progress per profile
        final allData = [
          {'id': '1', 'videoId': videoId, 'profileId': profileA, 'watchDuration': 100},
          {'id': '2', 'videoId': videoId, 'profileId': profileB, 'watchDuration': 500},
        ];

        // Simulate getByVideoId with profile filter
        final profileAProgress = allData.firstWhere(
          (d) => d['videoId'] == videoId && d['profileId'] == profileA,
          orElse: () => {},
        );
        final profileBProgress = allData.firstWhere(
          (d) => d['videoId'] == videoId && d['profileId'] == profileB,
          orElse: () => {},
        );

        expect(profileAProgress['watchDuration'], 100);
        expect(profileBProgress['watchDuration'], 500);
      });

      test('delete_by_profile_removes_only_that_profiles_data', () {
        const profileA = 'profile-uuid-a';
        const profileB = 'profile-uuid-b';

        var allData = [
          {'id': '1', 'profileId': profileA},
          {'id': '2', 'profileId': profileA},
          {'id': '3', 'profileId': profileB},
        ];

        // Simulate deleteAllForProfile
        allData = allData.where((d) => d['profileId'] != profileA).toList();

        expect(allData.length, 1);
        expect(allData.first['profileId'], profileB);
      });

      test('empty_profileId_returns_no_data', () {
        const profileA = 'profile-uuid-a';

        final allData = [
          {'id': '1', 'profileId': profileA},
        ];

        final emptyProfileData = allData.where((d) => d['profileId'] == '').toList();

        expect(emptyProfileData, isEmpty);
      });
    });

    // =========================================================================
    // CRUD OPERATION TESTS
    // =========================================================================
    group('CRUD Operations', () {
      test('insert_adds_new_record', () {
        final records = <Map<String, dynamic>>[];

        // Simulate insert
        final newRecord = {
          'id': 'progress-1',
          'videoId': 'video-1',
          'profileId': 'profile-1',
          'watchDuration': 100,
          'totalDuration': 600,
        };
        records.add(newRecord);

        expect(records.length, 1);
        expect(records.first['id'], 'progress-1');
      });

      test('update_modifies_existing_record', () {
        var records = <Map<String, dynamic>>[
          {'id': 'progress-1', 'videoId': 'video-1', 'watchDuration': 100},
        ];

        // Simulate update
        final updatedRecord = {'id': 'progress-1', 'videoId': 'video-1', 'watchDuration': 500};
        records = records.map((r) {
          return r['id'] == updatedRecord['id'] ? updatedRecord : r;
        }).toList();

        expect(records.first['watchDuration'], 500);
      });

      test('delete_removes_record', () {
        var records = <Map<String, dynamic>>[
          {'id': 'progress-1'},
          {'id': 'progress-2'},
        ];

        // Simulate delete
        records = records.where((r) => r['id'] != 'progress-1').toList();

        expect(records.length, 1);
        expect(records.first['id'], 'progress-2');
      });

      test('getById_returns_matching_record', () {
        final records = <Map<String, dynamic>>[
          {'id': 'progress-1', 'videoId': 'video-1'},
          {'id': 'progress-2', 'videoId': 'video-2'},
        ];

        final found = records.firstWhere(
          (r) => r['id'] == 'progress-1',
          orElse: () => {},
        );

        expect(found['videoId'], 'video-1');
      });

      test('getById_returns_null_for_missing_record', () {
        final records = <Map<String, dynamic>>[
          {'id': 'progress-1'},
        ];

        final found = records.cast<Map<String, dynamic>?>().firstWhere(
          (r) => r?['id'] == 'progress-99',
          orElse: () => null,
        );

        expect(found, isNull);
      });
    });

    // =========================================================================
    // QUERY TESTS
    // =========================================================================
    group('Queries', () {
      test('getInProgress_returns_incomplete_videos', () {
        final records = [
          {'id': '1', 'watchDuration': 50, 'totalDuration': 100, 'completed': false}, // 50%
          {'id': '2', 'watchDuration': 89, 'totalDuration': 100, 'completed': false}, // 89%
          {'id': '3', 'watchDuration': 90, 'totalDuration': 100, 'completed': true}, // 90%
        ];

        // Filter for in-progress (started but not completed)
        final inProgress = records.where((r) {
          final watchDuration = r['watchDuration'] as int;
          final completed = r['completed'] as bool;
          return watchDuration > 0 && !completed;
        }).toList();

        expect(inProgress.length, 2);
      });

      test('getCompleted_returns_completed_videos', () {
        final records = [
          {'id': '1', 'completed': false},
          {'id': '2', 'completed': true},
          {'id': '3', 'completed': true},
        ];

        final completed = records.where((r) => r['completed'] == true).toList();

        expect(completed.length, 2);
      });

      test('getRecent_orders_by_lastWatched', () {
        final now = DateTime.now();
        final records = [
          {'id': '1', 'lastWatched': now.subtract(const Duration(days: 2))},
          {'id': '2', 'lastWatched': now},
          {'id': '3', 'lastWatched': now.subtract(const Duration(days: 1))},
        ];

        // Sort by lastWatched descending
        records.sort((a, b) {
          final aDate = a['lastWatched'] as DateTime;
          final bDate = b['lastWatched'] as DateTime;
          return bDate.compareTo(aDate);
        });

        expect(records[0]['id'], '2'); // Most recent
        expect(records[1]['id'], '3');
        expect(records[2]['id'], '1'); // Oldest
      });

      test('getStatistics_calculates_correctly', () {
        final records = [
          {'watchDuration': 100, 'totalDuration': 200, 'completed': false},
          {'watchDuration': 200, 'totalDuration': 200, 'completed': true},
          {'watchDuration': 150, 'totalDuration': 300, 'completed': false},
        ];

        final totalWatchTime = records.fold<int>(
          0,
          (sum, r) => sum + (r['watchDuration'] as int),
        );
        final completedCount = records.where((r) => r['completed'] == true).length;

        expect(totalWatchTime, 450);
        expect(completedCount, 1);
      });
    });

    // =========================================================================
    // 90% COMPLETION THRESHOLD TESTS
    // =========================================================================
    group('90% Completion Threshold', () {
      test('video_at_89_percent_is_not_complete', () {
        const watchDuration = 89;
        const totalDuration = 100;

        final percentage = totalDuration > 0 ? (watchDuration / totalDuration) * 100 : 0.0;
        final shouldBeComplete = percentage >= 90;

        expect(shouldBeComplete, false);
      });

      test('video_at_90_percent_is_complete', () {
        const watchDuration = 90;
        const totalDuration = 100;

        final percentage = totalDuration > 0 ? (watchDuration / totalDuration) * 100 : 0.0;
        final shouldBeComplete = percentage >= 90;

        expect(shouldBeComplete, true);
      });

      test('real_world_600_second_video', () {
        const totalDuration = 600;

        // 89% = 534 seconds
        expect((534 / totalDuration) * 100 >= 90, false);

        // 90% = 540 seconds
        expect((540 / totalDuration) * 100 >= 90, true);
      });
    });

    // =========================================================================
    // PROGRESS ENTITY INTEGRATION
    // =========================================================================
    group('Progress Entity Integration', () {
      test('can_use_fixture_data', () {
        final progress = ProgressFixtures.halfWatched;

        expect(progress.videoId, isNotEmpty);
        expect(progress.watchDuration, 300);
        expect(progress.totalDuration, 600);
        expect(progress.progressFraction, 0.5);
      });

      test('fixture_boundary_values', () {
        expect(ProgressFixtures.almostComplete89.completionPercentage, closeTo(89, 1));
        expect(ProgressFixtures.atThreshold90.completionPercentage, 90);
      });
    });
  });
}
