/// Test suite for ContentSyncNotifier and ContentSyncState
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:crack_the_code/core/config/remote_content_config.dart';
import 'package:crack_the_code/presentation/providers/sync/content_sync_provider.dart';

void main() {
  group('ContentSyncState', () {
    test('default_hasInitialValues', () {
      const state = ContentSyncState();

      expect(state.isInitialized, false);
      expect(state.isSyncing, false);
      expect(state.hasUpdates, false);
      expect(state.error, isNull);
      expect(state.manifest, isNull);
      expect(state.lastSyncTime, isNull);
      expect(state.syncProgress, isEmpty);
    });

    group('copyWith', () {
      test('updatesSpecifiedFields', () {
        const initial = ContentSyncState();

        final updated = initial.copyWith(
          isInitialized: true,
          isSyncing: true,
          hasUpdates: true,
        );

        expect(updated.isInitialized, true);
        expect(updated.isSyncing, true);
        expect(updated.hasUpdates, true);
        expect(updated.error, isNull);
      });

      test('preservesUnspecifiedFields', () {
        final initial = ContentSyncState(
          isInitialized: true,
          lastSyncTime: DateTime(2024, 1, 1),
        );

        final updated = initial.copyWith(isSyncing: true);

        expect(updated.isInitialized, true);
        expect(updated.isSyncing, true);
        expect(updated.lastSyncTime, DateTime(2024, 1, 1));
      });

      test('updatesSyncProgress', () {
        const initial = ContentSyncState();

        final updated = initial.copyWith(
          syncProgress: {'junior': 0.5, 'senior': 0.75},
        );

        expect(updated.syncProgress['junior'], 0.5);
        expect(updated.syncProgress['senior'], 0.75);
      });

      test('allowsClearingError', () {
        final initial = ContentSyncState(error: 'Some error');

        final updated = initial.copyWith(error: null);

        expect(updated.error, isNull);
      });

      test('updatesManifest', () {
        const initial = ContentSyncState();
        final manifest = _createTestManifest();

        final updated = initial.copyWith(manifest: manifest);

        expect(updated.manifest, manifest);
        expect(updated.manifest?.version, '1.0.0');
      });

      test('updatesLastSyncTime', () {
        const initial = ContentSyncState();
        final syncTime = DateTime(2024, 6, 15, 10, 30);

        final updated = initial.copyWith(lastSyncTime: syncTime);

        expect(updated.lastSyncTime, syncTime);
      });
    });

    group('syncProgress operations', () {
      test('canTrackMultipleSegments', () {
        final state = ContentSyncState(
          syncProgress: {
            'junior': 1.0,
            'middle': 0.5,
            'preboard': 0.25,
            'senior': 0.0,
          },
        );

        expect(state.syncProgress.length, 4);
        expect(state.syncProgress['junior'], 1.0);
        expect(state.syncProgress['middle'], 0.5);
        expect(state.syncProgress['preboard'], 0.25);
        expect(state.syncProgress['senior'], 0.0);
      });

      test('canUpdateSingleSegmentProgress', () {
        const initial = ContentSyncState();

        // Simulate updating progress for one segment
        final updated = initial.copyWith(
          syncProgress: {...initial.syncProgress, 'junior': 0.5},
        );

        expect(updated.syncProgress['junior'], 0.5);

        // Update again
        final updated2 = updated.copyWith(
          syncProgress: {...updated.syncProgress, 'junior': 1.0},
        );

        expect(updated2.syncProgress['junior'], 1.0);
      });
    });

    group('state transitions', () {
      test('initializationFlow', () {
        // Start
        const state1 = ContentSyncState();
        expect(state1.isInitialized, false);

        // After initialization
        final state2 = state1.copyWith(isInitialized: true);
        expect(state2.isInitialized, true);
      });

      test('syncingFlow', () {
        // Start sync
        const state1 = ContentSyncState(isInitialized: true);
        final state2 = state1.copyWith(
          isSyncing: true,
          syncProgress: {'junior': 0.0},
        );
        expect(state2.isSyncing, true);

        // Progress update
        final state3 = state2.copyWith(
          syncProgress: {...state2.syncProgress, 'junior': 0.5},
        );
        expect(state3.syncProgress['junior'], 0.5);

        // Complete
        final state4 = state3.copyWith(
          isSyncing: false,
          lastSyncTime: DateTime.now(),
          syncProgress: {...state3.syncProgress, 'junior': 1.0},
        );
        expect(state4.isSyncing, false);
        expect(state4.syncProgress['junior'], 1.0);
        expect(state4.lastSyncTime, isNotNull);
      });

      test('errorFlow', () {
        const state1 = ContentSyncState(isSyncing: true);

        // Error occurs
        final state2 = state1.copyWith(
          isSyncing: false,
          error: 'Network error',
        );
        expect(state2.isSyncing, false);
        expect(state2.error, 'Network error');

        // Clear error
        final state3 = state2.copyWith(error: null);
        expect(state3.error, isNull);
      });

      test('checkForUpdatesFlow', () {
        const state1 = ContentSyncState(isInitialized: true);

        // No updates
        final state2 = state1.copyWith(hasUpdates: false);
        expect(state2.hasUpdates, false);

        // Updates available
        final state3 = state1.copyWith(hasUpdates: true);
        expect(state3.hasUpdates, true);
      });
    });
  });

  group('ContentManifest', () {
    test('fromJson_parsesCorrectly', () {
      final json = {
        'version': '1.0.0',
        'updatedAt': '2024-06-15T10:30:00.000Z',
        'segments': {
          'junior': {
            'checksum': 'abc123',
            'updatedAt': '2024-06-15T10:30:00.000Z',
            'subjects': ['physics', 'chemistry'],
          },
        },
      };

      final manifest = ContentManifest.fromJson(json);

      expect(manifest.version, '1.0.0');
      expect(manifest.updatedAt, isNotNull);
      expect(manifest.segments.containsKey('junior'), true);
    });

    test('toJson_serializesCorrectly', () {
      final manifest = ContentManifest(
        version: '2.0.0',
        updatedAt: DateTime(2024, 6, 15),
        segments: {
          'junior': SegmentManifest(
            checksum: 'def456',
            updatedAt: DateTime(2024, 6, 15),
            subjects: const ['physics'],
          ),
        },
      );

      final json = manifest.toJson();

      expect(json['version'], '2.0.0');
      expect(json['segments'], isNotNull);
    });
  });

  group('SegmentManifest', () {
    test('fromJson_parsesCorrectly', () {
      final json = {
        'checksum': 'abc123',
        'updatedAt': '2024-06-15T10:30:00.000Z',
        'subjects': ['physics', 'chemistry'],
      };

      final segment = SegmentManifest.fromJson(json);

      expect(segment.checksum, 'abc123');
      expect(segment.subjects.length, 2);
    });

    test('toJson_serializesCorrectly', () {
      final segment = SegmentManifest(
        checksum: 'xyz789',
        updatedAt: DateTime(2024, 6, 15),
        subjects: const ['physics'],
      );

      final json = segment.toJson();

      expect(json['checksum'], 'xyz789');
      expect(json['subjects'], ['physics']);
    });
  });
}

/// Create a test manifest
ContentManifest _createTestManifest() {
  return ContentManifest(
    version: '1.0.0',
    updatedAt: DateTime(2024, 6, 15),
    segments: {
      'junior': SegmentManifest(
        checksum: 'abc123',
        updatedAt: DateTime(2024, 6, 15),
        subjects: const [],
      ),
    },
  );
}
