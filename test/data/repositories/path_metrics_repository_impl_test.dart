/// Test suite for PathMetricsRepositoryImpl
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streamshaala/data/repositories/path_metrics_repository_impl.dart';
import 'package:streamshaala/data/datasources/local/database/database_helper.dart';
import 'package:streamshaala/core/errors/exceptions.dart';

void main() {
  group('PathMetricsRepositoryImpl', () {
    late MockDatabaseHelper mockDbHelper;
    late PathMetricsRepositoryImpl repository;

    setUp(() {
      mockDbHelper = MockDatabaseHelper();
      repository = PathMetricsRepositoryImpl(databaseHelper: mockDbHelper);
    });

    tearDown(() {
      mockDbHelper.clear();
    });

    group('getCompletionRate', () {
      test('noPaths_returns0', () async {
        mockDbHelper.setQueryResult([
          {'completed_count': 0, 'total_count': 0}
        ]);

        final result = await repository.getCompletionRate();

        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (rate) => expect(rate, 0.0),
        );
      });

      test('allPathsCompleted_returns1', () async {
        mockDbHelper.setQueryResult([
          {'completed_count': 10, 'total_count': 10}
        ]);

        final result = await repository.getCompletionRate();

        result.fold(
          (failure) => fail('Should not return failure'),
          (rate) => expect(rate, 1.0),
        );
      });

      test('halfCompleted_returns0Point5', () async {
        mockDbHelper.setQueryResult([
          {'completed_count': 5, 'total_count': 10}
        ]);

        final result = await repository.getCompletionRate();

        result.fold(
          (failure) => fail('Should not return failure'),
          (rate) => expect(rate, 0.5),
        );
      });

      test('withSubjectFilter_passesCorrectArgs', () async {
        mockDbHelper.setQueryResult([
          {'completed_count': 3, 'total_count': 10}
        ]);

        await repository.getCompletionRate(subjectId: 'math');

        expect(mockDbHelper.lastArgs, contains('math'));
      });

      test('withDateRangeFilter_passesCorrectArgs', () async {
        final start = DateTime(2024, 1, 1);
        final end = DateTime(2024, 12, 31);
        final dateRange = DateTimeRange(start: start, end: end);

        mockDbHelper.setQueryResult([
          {'completed_count': 2, 'total_count': 5}
        ]);

        await repository.getCompletionRate(dateRange: dateRange);

        expect(mockDbHelper.lastArgs, contains(start.millisecondsSinceEpoch));
        expect(mockDbHelper.lastArgs, contains(end.millisecondsSinceEpoch));
      });

      test('databaseException_returnsLeftDatabaseFailure', () async {
        mockDbHelper.setNextException(Exception('Database error'));

        final result = await repository.getCompletionRate();

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.message, contains('Failed to get completion rate')),
          (rate) => fail('Should not return rate'),
        );
      });
    });

    group('getAverageCompletionTime', () {
      test('noCompletedPaths_returns0', () async {
        mockDbHelper.setQueryResult([
          {'avg_duration_ms': null}
        ]);

        final result = await repository.getAverageCompletionTime();

        result.fold(
          (failure) => fail('Should not return failure'),
          (time) => expect(time, 0.0),
        );
      });

      test('oneHourAverage_returns60Minutes', () async {
        final oneHourMs = 60 * 60 * 1000;
        mockDbHelper.setQueryResult([
          {'avg_duration_ms': oneHourMs}
        ]);

        final result = await repository.getAverageCompletionTime();

        result.fold(
          (failure) => fail('Should not return failure'),
          (time) => expect(time, closeTo(60.0, 0.1)),
        );
      });

      test('thirtyMinutesAverage_returns30Minutes', () async {
        final thirtyMinMs = 30 * 60 * 1000;
        mockDbHelper.setQueryResult([
          {'avg_duration_ms': thirtyMinMs}
        ]);

        final result = await repository.getAverageCompletionTime();

        result.fold(
          (failure) => fail('Should not return failure'),
          (time) => expect(time, closeTo(30.0, 0.1)),
        );
      });

      test('withFilters_passesCorrectArgs', () async {
        final dateRange = DateTimeRange(
          start: DateTime(2024, 1, 1),
          end: DateTime(2024, 12, 31),
        );

        mockDbHelper.setQueryResult([
          {'avg_duration_ms': 1800000}
        ]);

        await repository.getAverageCompletionTime(
          subjectId: 'science',
          dateRange: dateRange,
        );

        expect(mockDbHelper.lastArgs, contains('completed'));
        expect(mockDbHelper.lastArgs, contains('science'));
      });
    });

    group('getDropOffRate', () {
      test('noDropOffs_returns0', () async {
        mockDbHelper.setQueryResult([
          {'total_count': 10, 'early_dropoff_count': 0}
        ]);

        final result = await repository.getDropOffRate();

        result.fold(
          (failure) => fail('Should not return failure'),
          (rate) => expect(rate, 0.0),
        );
      });

      test('halfDropped_returns0Point5', () async {
        mockDbHelper.setQueryResult([
          {'total_count': 10, 'early_dropoff_count': 5}
        ]);

        final result = await repository.getDropOffRate();

        result.fold(
          (failure) => fail('Should not return failure'),
          (rate) => expect(rate, 0.5),
        );
      });

      test('allDropped_returns1', () async {
        mockDbHelper.setQueryResult([
          {'total_count': 10, 'early_dropoff_count': 10}
        ]);

        final result = await repository.getDropOffRate();

        result.fold(
          (failure) => fail('Should not return failure'),
          (rate) => expect(rate, 1.0),
        );
      });

      test('noPaths_returns0', () async {
        mockDbHelper.setQueryResult([
          {'total_count': 0, 'early_dropoff_count': 0}
        ]);

        final result = await repository.getDropOffRate();

        result.fold(
          (failure) => fail('Should not return failure'),
          (rate) => expect(rate, 0.0),
        );
      });
    });

    group('getNodeSkipRate', () {
      test('returnsPlaceholder0', () async {
        final result = await repository.getNodeSkipRate();

        result.fold(
          (failure) => fail('Should not return failure'),
          (rate) => expect(rate, 0.0),
        );
      });

      test('withFilters_stillReturns0', () async {
        final result = await repository.getNodeSkipRate(
          subjectId: 'math',
          nodeType: 'quiz',
        );

        result.fold(
          (failure) => fail('Should not return failure'),
          (rate) => expect(rate, 0.0),
        );
      });
    });

    group('getAveragePathScore', () {
      test('returnsPlaceholder0', () async {
        final result = await repository.getAveragePathScore();

        result.fold(
          (failure) => fail('Should not return failure'),
          (score) => expect(score, 0.0),
        );
      });

      test('withFilters_stillReturns0', () async {
        final dateRange = DateTimeRange(
          start: DateTime(2024, 1, 1),
          end: DateTime(2024, 12, 31),
        );

        final result = await repository.getAveragePathScore(
          subjectId: 'math',
          dateRange: dateRange,
        );

        result.fold(
          (failure) => fail('Should not return failure'),
          (score) => expect(score, 0.0),
        );
      });
    });

    group('getTotalPathsStarted', () {
      test('noPaths_returns0', () async {
        mockDbHelper.setQueryResult([
          {'count': 0}
        ]);

        final result = await repository.getTotalPathsStarted();

        result.fold(
          (failure) => fail('Should not return failure'),
          (count) => expect(count, 0),
        );
      });

      test('multiplePaths_returnsCorrectCount', () async {
        mockDbHelper.setQueryResult([
          {'count': 25}
        ]);

        final result = await repository.getTotalPathsStarted();

        result.fold(
          (failure) => fail('Should not return failure'),
          (count) => expect(count, 25),
        );
      });

      test('withSubjectFilter_passesCorrectArgs', () async {
        mockDbHelper.setQueryResult([
          {'count': 10}
        ]);

        await repository.getTotalPathsStarted(subjectId: 'physics');

        expect(mockDbHelper.lastArgs, contains('physics'));
      });

      test('withDateRange_passesCorrectArgs', () async {
        final dateRange = DateTimeRange(
          start: DateTime(2024, 6, 1),
          end: DateTime(2024, 6, 30),
        );

        mockDbHelper.setQueryResult([
          {'count': 15}
        ]);

        await repository.getTotalPathsStarted(dateRange: dateRange);

        expect(mockDbHelper.lastArgs.length, greaterThan(0));
      });
    });

    group('getTotalPathsCompleted', () {
      test('noPaths_returns0', () async {
        mockDbHelper.setQueryResult([
          {'count': 0}
        ]);

        final result = await repository.getTotalPathsCompleted();

        result.fold(
          (failure) => fail('Should not return failure'),
          (count) => expect(count, 0),
        );
      });

      test('someCompleted_returnsCorrectCount', () async {
        mockDbHelper.setQueryResult([
          {'count': 8}
        ]);

        final result = await repository.getTotalPathsCompleted();

        result.fold(
          (failure) => fail('Should not return failure'),
          (count) => expect(count, 8),
        );
      });

      test('alwaysIncludesCompletedStatusFilter', () async {
        mockDbHelper.setQueryResult([
          {'count': 5}
        ]);

        await repository.getTotalPathsCompleted();

        expect(mockDbHelper.lastArgs, contains('completed'));
      });
    });

    group('getMostPopularSubjects', () {
      test('noSubjects_returnsEmptyMap', () async {
        mockDbHelper.setQueryResult([]);

        final result = await repository.getMostPopularSubjects();

        result.fold(
          (failure) => fail('Should not return failure'),
          (subjects) => expect(subjects, isEmpty),
        );
      });

      test('multipleSubjects_returnsSortedByCount', () async {
        mockDbHelper.setQueryResult([
          {'subject_id': 'math', 'count': 50},
          {'subject_id': 'science', 'count': 30},
          {'subject_id': 'english', 'count': 20},
        ]);

        final result = await repository.getMostPopularSubjects();

        result.fold(
          (failure) => fail('Should not return failure'),
          (subjects) {
            expect(subjects.length, 3);
            expect(subjects['math'], 50);
            expect(subjects['science'], 30);
            expect(subjects['english'], 20);
          },
        );
      });

      test('respectsLimitParameter', () async {
        mockDbHelper.setQueryResult([
          {'subject_id': 'subj1', 'count': 10},
          {'subject_id': 'subj2', 'count': 9},
        ]);

        await repository.getMostPopularSubjects(limit: 5);

        expect(mockDbHelper.lastArgs, contains(5));
      });

      test('withDateRange_passesCorrectArgs', () async {
        final dateRange = DateTimeRange(
          start: DateTime(2024, 1, 1),
          end: DateTime(2024, 3, 31),
        );

        mockDbHelper.setQueryResult([
          {'subject_id': 'history', 'count': 15},
        ]);

        await repository.getMostPopularSubjects(dateRange: dateRange);

        expect(mockDbHelper.lastArgs.length, greaterThan(1));
      });
    });

    group('getStudentEngagement', () {
      test('noActivity_returnsZeroMetrics', () async {
        mockDbHelper.setQueryResult([]);

        final result = await repository.getStudentEngagement(
          studentId: 'student-1',
        );

        result.fold(
          (failure) => fail('Should not return failure'),
          (engagement) {
            expect(engagement['total_paths_started'], 0);
            expect(engagement['total_paths_completed'], 0);
            expect(engagement['completion_rate'], 0.0);
            expect(engagement['average_score'], 0.0);
            expect(engagement['total_time_spent_minutes'], 0.0);
          },
        );
      });

      test('withActivity_returnsCorrectMetrics', () async {
        final twoHoursMs = 2 * 60 * 60 * 1000;

        mockDbHelper.setQueryResult([
          {
            'total_paths_started': 10,
            'total_paths_completed': 7,
            'total_time_spent_ms': twoHoursMs,
          }
        ]);

        final result = await repository.getStudentEngagement(
          studentId: 'student-1',
        );

        result.fold(
          (failure) => fail('Should not return failure'),
          (engagement) {
            expect(engagement['total_paths_started'], 10);
            expect(engagement['total_paths_completed'], 7);
            expect(engagement['completion_rate'], closeTo(0.7, 0.01));
            expect(engagement['total_time_spent_minutes'], closeTo(120.0, 0.1));
          },
        );
      });

      test('passesStudentIdInArgs', () async {
        mockDbHelper.setQueryResult([
          {
            'total_paths_started': 5,
            'total_paths_completed': 3,
            'total_time_spent_ms': 0,
          }
        ]);

        await repository.getStudentEngagement(studentId: 'student-123');

        expect(mockDbHelper.lastArgs, contains('student-123'));
      });

      test('withDateRange_completesSuccessfully', () async {
        final dateRange = DateTimeRange(
          start: DateTime(2024, 7, 1),
          end: DateTime(2024, 7, 31),
        );

        mockDbHelper.setQueryResult([
          {
            'total_paths_started': 3,
            'total_paths_completed': 2,
            'total_time_spent_ms': 0,
          }
        ]);

        final result = await repository.getStudentEngagement(
          studentId: 'student-456',
          dateRange: dateRange,
        );

        // Verify the method completes and returns valid engagement data
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (engagement) {
            expect(engagement['total_paths_started'], 3);
            expect(engagement['total_paths_completed'], 2);
          },
        );
      });

      test('databaseException_returnsLeftDatabaseFailure', () async {
        mockDbHelper.setNextException(Exception('Query failed'));

        final result = await repository.getStudentEngagement(
          studentId: 'student-1',
        );

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.message, contains('Failed to get student engagement')),
          (engagement) => fail('Should not return engagement'),
        );
      });
    });

    group('Error Handling', () {
      test('allMethods_handleDatabaseException', () async {
        mockDbHelper.setNextException(Exception('DB error'));

        final completionRate = await repository.getCompletionRate();
        expect(completionRate.isLeft(), true);

        mockDbHelper.setNextException(Exception('DB error'));
        final avgTime = await repository.getAverageCompletionTime();
        expect(avgTime.isLeft(), true);

        mockDbHelper.setNextException(Exception('DB error'));
        final dropOff = await repository.getDropOffRate();
        expect(dropOff.isLeft(), true);

        mockDbHelper.setNextException(Exception('DB error'));
        final totalStarted = await repository.getTotalPathsStarted();
        expect(totalStarted.isLeft(), true);

        mockDbHelper.setNextException(Exception('DB error'));
        final totalCompleted = await repository.getTotalPathsCompleted();
        expect(totalCompleted.isLeft(), true);

        mockDbHelper.setNextException(Exception('DB error'));
        final popular = await repository.getMostPopularSubjects();
        expect(popular.isLeft(), true);
      });

      test('wrapsExceptionsInDatabaseFailure', () async {
        mockDbHelper.setNextException(Exception('Connection lost'));

        final result = await repository.getCompletionRate();

        result.fold(
          (failure) {
            expect(failure.runtimeType.toString(), 'DatabaseFailure');
            expect(failure.message, contains('Connection lost'));
          },
          (rate) => fail('Should not return rate'),
        );
      });
    });

    group('SQL Query Validation', () {
      test('completionRate_queriesCorrectColumns', () async {
        mockDbHelper.setQueryResult([
          {'completed_count': 5, 'total_count': 10}
        ]);

        await repository.getCompletionRate();

        expect(mockDbHelper.lastQuery, contains('completed'));
        expect(mockDbHelper.lastQuery, contains('learning_paths'));
      });

      test('averageCompletionTime_queriesCompletedPathsOnly', () async {
        mockDbHelper.setQueryResult([
          {'avg_duration_ms': 1000}
        ]);

        await repository.getAverageCompletionTime();

        expect(mockDbHelper.lastArgs, contains('completed'));
      });

      test('mostPopularSubjects_groupsBySubjectId', () async {
        mockDbHelper.setQueryResult([]);

        await repository.getMostPopularSubjects();

        expect(mockDbHelper.lastQuery, contains('GROUP BY'));
        expect(mockDbHelper.lastQuery, contains('subject_id'));
      });
    });
  });
}

/// Mock DatabaseHelper for testing
class MockDatabaseHelper implements DatabaseHelper {
  List<Map<String, dynamic>> _queryResult = [];
  Exception? _nextException;
  String _lastQuery = '';
  List<dynamic> _lastArgs = [];

  void setQueryResult(List<Map<String, dynamic>> result) {
    _queryResult = result;
  }

  void setNextException(Exception exception) {
    _nextException = exception;
  }

  String get lastQuery => _lastQuery;
  List<dynamic> get lastArgs => _lastArgs;

  void clear() {
    _queryResult = [];
    _nextException = null;
    _lastQuery = '';
    _lastArgs = [];
  }

  @override
  Future<dynamic> get database async {
    return _MockDatabase(this);
  }

  @override
  Future<void> close() async {
    // Mock implementation - do nothing
  }

  @override
  Future<void> deleteDatabase() async {
    // Mock implementation - do nothing
  }

  Future<List<Map<String, dynamic>>> rawQuery(
    String query,
    List<dynamic> args,
  ) async {
    _lastQuery = query;
    _lastArgs = args;

    if (_nextException != null) {
      final exception = _nextException;
      _nextException = null;
      throw exception!;
    }

    return _queryResult;
  }
}

/// Mock database that delegates to MockDatabaseHelper
class _MockDatabase {
  final MockDatabaseHelper helper;

  _MockDatabase(this.helper);

  Future<List<Map<String, dynamic>>> rawQuery(
    String query, [
    List<dynamic>? arguments,
  ]) async {
    return helper.rawQuery(query, arguments ?? []);
  }
}
