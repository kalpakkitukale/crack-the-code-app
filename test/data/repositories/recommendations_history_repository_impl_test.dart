/// Comprehensive tests for RecommendationsHistoryRepositoryImpl
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:crack_the_code/core/errors/exceptions.dart';
import 'package:crack_the_code/core/models/assessment_type.dart';
import 'package:crack_the_code/data/repositories/recommendations_history_repository_impl.dart';
import 'package:crack_the_code/domain/entities/pedagogy/recommendations_history.dart';
import '../../mocks/mock_use_cases.dart';

void main() {
  group('RecommendationsHistoryRepositoryImpl', () {
    late MockRecommendationsHistoryDao mockDao;
    late RecommendationsHistoryRepositoryImpl repository;

    setUp(() {
      mockDao = MockRecommendationsHistoryDao();
      repository = RecommendationsHistoryRepositoryImpl(dao: mockDao);
    });

    tearDown(() {
      mockDao.clear();
    });

    // Helper to create test recommendations history
    RecommendationsHistory createHistory({
      String id = 'history-1',
      String quizAttemptId = 'quiz-1',
      String userId = 'user-1',
      String subjectId = 'subject-1',
      AssessmentType assessmentType = AssessmentType.readiness,
      int totalRecommendations = 5,
      int criticalGaps = 2,
      int severeGaps = 1,
      DateTime? generatedAt,
    }) {
      return RecommendationsHistory(
        id: id,
        quizAttemptId: quizAttemptId,
        userId: userId,
        subjectId: subjectId,
        assessmentType: assessmentType,
        recommendations: [],
        totalRecommendations: totalRecommendations,
        criticalGaps: criticalGaps,
        severeGaps: severeGaps,
        estimatedMinutesToFix: 30,
        generatedAt: generatedAt ?? DateTime(2024, 1, 15, 10, 0),
      );
    }

    group('saveRecommendations', () {
      test('success_savesToDao', () async {
        final history = createHistory();

        await repository.saveRecommendations(history);

        expect(mockDao.count, 1);
        expect(mockDao.all[history.id], isNotNull);
      });

      test('databaseException_rethrows', () async {
        final history = createHistory();
        mockDao.setNextException(DatabaseException(message: 'DB error'));

        expect(
          () => repository.saveRecommendations(history),
          throwsA(isA<DatabaseException>()),
        );
      });

      test('unknownException_rethrows', () async {
        final history = createHistory();
        mockDao.setNextException(Exception('Unknown error'));

        expect(
          () => repository.saveRecommendations(history),
          throwsException,
        );
      });
    });

    group('updateRecommendations', () {
      test('success_updatesInDao', () async {
        final history = createHistory();
        await repository.saveRecommendations(history);

        final updated = history.copyWith(totalRecommendations: 10);
        await repository.updateRecommendations(updated);

        expect(mockDao.all[history.id]?.totalRecommendations, 10);
      });

      test('databaseException_rethrows', () async {
        final history = createHistory();
        mockDao.setNextException(DatabaseException(message: 'DB error'));

        expect(
          () => repository.updateRecommendations(history),
          throwsA(isA<DatabaseException>()),
        );
      });
    });

    group('getByQuizAttempt', () {
      test('found_returnsHistory', () async {
        final history = createHistory();
        await repository.saveRecommendations(history);

        final result = await repository.getByQuizAttempt('quiz-1');

        expect(result, isNotNull);
        expect(result?.id, 'history-1');
        expect(result?.quizAttemptId, 'quiz-1');
      });

      test('notFound_returnsNull', () async {
        final result = await repository.getByQuizAttempt('non-existent');

        expect(result, isNull);
      });

      test('databaseException_returnsNull', () async {
        mockDao.setNextException(DatabaseException(message: 'DB error'));

        final result = await repository.getByQuizAttempt('quiz-1');

        expect(result, isNull);
      });
    });

    group('getById', () {
      test('found_returnsHistory', () async {
        final history = createHistory();
        await repository.saveRecommendations(history);

        final result = await repository.getById('history-1');

        expect(result, isNotNull);
        expect(result?.id, 'history-1');
      });

      test('notFound_returnsNull', () async {
        final result = await repository.getById('non-existent');

        expect(result, isNull);
      });

      test('databaseException_returnsNull', () async {
        mockDao.setNextException(DatabaseException(message: 'DB error'));

        final result = await repository.getById('history-1');

        expect(result, isNull);
      });
    });

    group('getHistory', () {
      test('success_returnsFilteredHistory', () async {
        await repository.saveRecommendations(createHistory(
          id: 'h1',
          userId: 'user-1',
          assessmentType: AssessmentType.readiness,
        ));
        await repository.saveRecommendations(createHistory(
          id: 'h2',
          quizAttemptId: 'quiz-2',
          userId: 'user-1',
          assessmentType: AssessmentType.knowledge,
        ));
        await repository.saveRecommendations(createHistory(
          id: 'h3',
          quizAttemptId: 'quiz-3',
          userId: 'user-2',
        ));

        final result = await repository.getHistory(userId: 'user-1');

        expect(result.length, 2);
      });

      test('filterByAssessmentType_returnsFiltered', () async {
        await repository.saveRecommendations(createHistory(
          id: 'h1',
          assessmentType: AssessmentType.readiness,
        ));
        await repository.saveRecommendations(createHistory(
          id: 'h2',
          quizAttemptId: 'quiz-2',
          assessmentType: AssessmentType.knowledge,
        ));

        final result = await repository.getHistory(
          userId: 'user-1',
          assessmentType: AssessmentType.readiness,
        );

        expect(result.length, 1);
        expect(result.first.assessmentType, AssessmentType.readiness);
      });

      test('filterBySubjectId_returnsFiltered', () async {
        await repository.saveRecommendations(createHistory(
          id: 'h1',
          subjectId: 'math',
        ));
        await repository.saveRecommendations(createHistory(
          id: 'h2',
          quizAttemptId: 'quiz-2',
          subjectId: 'science',
        ));

        final result = await repository.getHistory(
          userId: 'user-1',
          subjectId: 'math',
        );

        expect(result.length, 1);
        expect(result.first.subjectId, 'math');
      });

      test('filterByHasRecommendations_returnsOnlyWithRecommendations', () async {
        await repository.saveRecommendations(createHistory(
          id: 'h1',
          totalRecommendations: 5,
        ));
        await repository.saveRecommendations(createHistory(
          id: 'h2',
          quizAttemptId: 'quiz-2',
          totalRecommendations: 0,
        ));

        final result = await repository.getHistory(
          userId: 'user-1',
          hasRecommendations: true,
        );

        expect(result.length, 1);
        expect(result.first.totalRecommendations, greaterThan(0));
      });

      test('limitAndOffset_paginatesCorrectly', () async {
        for (int i = 0; i < 10; i++) {
          await repository.saveRecommendations(createHistory(
            id: 'h$i',
            quizAttemptId: 'quiz-$i',
            generatedAt: DateTime(2024, 1, 15 - i),
          ));
        }

        final page1 = await repository.getHistory(userId: 'user-1', limit: 3, offset: 0);
        final page2 = await repository.getHistory(userId: 'user-1', limit: 3, offset: 3);

        expect(page1.length, 3);
        expect(page2.length, 3);
        expect(page1.first.id, isNot(equals(page2.first.id)));
      });

      test('sortedByGeneratedAt_newestFirst', () async {
        await repository.saveRecommendations(createHistory(
          id: 'h1',
          generatedAt: DateTime(2024, 1, 10),
        ));
        await repository.saveRecommendations(createHistory(
          id: 'h2',
          quizAttemptId: 'quiz-2',
          generatedAt: DateTime(2024, 1, 15),
        ));
        await repository.saveRecommendations(createHistory(
          id: 'h3',
          quizAttemptId: 'quiz-3',
          generatedAt: DateTime(2024, 1, 12),
        ));

        final result = await repository.getHistory(userId: 'user-1');

        expect(result[0].id, 'h2'); // Newest
        expect(result[1].id, 'h3');
        expect(result[2].id, 'h1'); // Oldest
      });

      test('databaseException_returnsEmptyList', () async {
        mockDao.setNextException(DatabaseException(message: 'DB error'));

        final result = await repository.getHistory(userId: 'user-1');

        expect(result, isEmpty);
      });
    });

    group('markAsViewed', () {
      test('success_updatesViewMetadata', () async {
        final history = createHistory();
        await repository.saveRecommendations(history);

        await repository.markAsViewed('history-1');

        final updated = mockDao.all['history-1'];
        expect(updated?.viewedAt, isNotNull);
        expect(updated?.lastAccessedAt, isNotNull);
        expect(updated?.viewCount, 1);
      });

      test('multipleCalls_incrementsViewCount', () async {
        final history = createHistory();
        await repository.saveRecommendations(history);

        await repository.markAsViewed('history-1');
        await repository.markAsViewed('history-1');
        await repository.markAsViewed('history-1');

        final updated = mockDao.all['history-1'];
        expect(updated?.viewCount, 3);
      });

      test('nonExistent_doesNotThrow', () async {
        await repository.markAsViewed('non-existent');
        // Should complete without error
      });

      test('databaseException_doesNotThrow', () async {
        mockDao.setNextException(DatabaseException(message: 'DB error'));

        // Should not throw - this is a tracking operation
        await repository.markAsViewed('history-1');
      });
    });

    group('updateLearningPathStatus', () {
      test('markAsStarted_updatesStatus', () async {
        final history = createHistory();
        await repository.saveRecommendations(history);

        await repository.updateLearningPathStatus(
          id: 'history-1',
          learningPathId: 'path-1',
          started: true,
        );

        final updated = mockDao.all['history-1'];
        expect(updated?.learningPathId, 'path-1');
        expect(updated?.learningPathStarted, true);
        expect(updated?.learningPathStartedAt, isNotNull);
      });

      test('markAsCompleted_updatesStatus', () async {
        final history = createHistory();
        await repository.saveRecommendations(history);

        await repository.updateLearningPathStatus(
          id: 'history-1',
          completed: true,
        );

        final updated = mockDao.all['history-1'];
        expect(updated?.learningPathCompleted, true);
        expect(updated?.learningPathCompletedAt, isNotNull);
      });

      test('updateLearningPathId_onlyUpdatesId', () async {
        final history = createHistory();
        await repository.saveRecommendations(history);

        await repository.updateLearningPathStatus(
          id: 'history-1',
          learningPathId: 'new-path',
        );

        final updated = mockDao.all['history-1'];
        expect(updated?.learningPathId, 'new-path');
        expect(updated?.learningPathStarted, false);
        expect(updated?.learningPathCompleted, false);
      });

      test('databaseException_doesNotThrow', () async {
        mockDao.setNextException(DatabaseException(message: 'DB error'));

        await repository.updateLearningPathStatus(
          id: 'history-1',
          started: true,
        );
      });
    });

    group('trackVideoViewed', () {
      test('success_addsVideoToViewedList', () async {
        final history = createHistory();
        await repository.saveRecommendations(history);

        await repository.trackVideoViewed('history-1', 'video-1');

        final updated = mockDao.all['history-1'];
        expect(updated?.viewedVideoIds, contains('video-1'));
      });

      test('multipleVideos_addsAll', () async {
        final history = createHistory();
        await repository.saveRecommendations(history);

        await repository.trackVideoViewed('history-1', 'video-1');
        await repository.trackVideoViewed('history-1', 'video-2');
        await repository.trackVideoViewed('history-1', 'video-3');

        final updated = mockDao.all['history-1'];
        expect(updated?.viewedVideoIds.length, 3);
        expect(updated?.viewedVideoIds, containsAll(['video-1', 'video-2', 'video-3']));
      });

      test('duplicateVideo_doesNotAddTwice', () async {
        final history = createHistory();
        await repository.saveRecommendations(history);

        await repository.trackVideoViewed('history-1', 'video-1');
        await repository.trackVideoViewed('history-1', 'video-1');

        final updated = mockDao.all['history-1'];
        expect(updated?.viewedVideoIds.length, 1);
      });

      test('databaseException_doesNotThrow', () async {
        mockDao.setNextException(DatabaseException(message: 'DB error'));

        await repository.trackVideoViewed('history-1', 'video-1');
      });
    });

    group('dismissRecommendation', () {
      test('success_addsToDismissedList', () async {
        final history = createHistory();
        await repository.saveRecommendations(history);

        await repository.dismissRecommendation('history-1', 'concept-1');

        final updated = mockDao.all['history-1'];
        expect(updated?.dismissedRecommendationIds, contains('concept-1'));
      });

      test('multipleDismissals_addsAll', () async {
        final history = createHistory();
        await repository.saveRecommendations(history);

        await repository.dismissRecommendation('history-1', 'concept-1');
        await repository.dismissRecommendation('history-1', 'concept-2');

        final updated = mockDao.all['history-1'];
        expect(updated?.dismissedRecommendationIds.length, 2);
      });

      test('duplicateConcept_doesNotAddTwice', () async {
        final history = createHistory();
        await repository.saveRecommendations(history);

        await repository.dismissRecommendation('history-1', 'concept-1');
        await repository.dismissRecommendation('history-1', 'concept-1');

        final updated = mockDao.all['history-1'];
        expect(updated?.dismissedRecommendationIds.length, 1);
      });

      test('databaseException_doesNotThrow', () async {
        mockDao.setNextException(DatabaseException(message: 'DB error'));

        await repository.dismissRecommendation('history-1', 'concept-1');
      });
    });

    group('cleanupOldRecommendations', () {
      test('deletesOldRecommendations_returnsCount', () async {
        final now = DateTime.now();
        await repository.saveRecommendations(createHistory(
          id: 'old-1',
          generatedAt: now.subtract(const Duration(days: 100)),
        ));
        await repository.saveRecommendations(createHistory(
          id: 'old-2',
          quizAttemptId: 'quiz-2',
          generatedAt: now.subtract(const Duration(days: 120)),
        ));
        await repository.saveRecommendations(createHistory(
          id: 'recent',
          quizAttemptId: 'quiz-3',
          generatedAt: now.subtract(const Duration(days: 10)),
        ));

        final deleted = await repository.cleanupOldRecommendations(daysOld: 90);

        expect(deleted, 2);
        expect(mockDao.count, 1);
        expect(mockDao.all['recent'], isNotNull);
      });

      test('customDaysOld_respectsParameter', () async {
        final now = DateTime.now();
        await repository.saveRecommendations(createHistory(
          id: 'h1',
          generatedAt: now.subtract(const Duration(days: 35)),
        ));
        await repository.saveRecommendations(createHistory(
          id: 'h2',
          quizAttemptId: 'quiz-2',
          generatedAt: now.subtract(const Duration(days: 25)),
        ));

        final deleted = await repository.cleanupOldRecommendations(daysOld: 30);

        expect(deleted, 1);
        expect(mockDao.count, 1);
      });

      test('noOldRecommendations_returnsZero', () async {
        await repository.saveRecommendations(createHistory(
          generatedAt: DateTime.now().subtract(const Duration(days: 10)),
        ));

        final deleted = await repository.cleanupOldRecommendations(daysOld: 90);

        expect(deleted, 0);
        expect(mockDao.count, 1);
      });

      test('databaseException_returnsZero', () async {
        mockDao.setNextException(DatabaseException(message: 'DB error'));

        final deleted = await repository.cleanupOldRecommendations();

        expect(deleted, 0);
      });
    });

    group('Error Handling', () {
      test('allTrackingMethods_doNotThrowOnError', () async {
        // These methods should not throw as they're tracking operations
        mockDao.setNextException(Exception('Error'));
        await repository.markAsViewed('id');

        mockDao.setNextException(Exception('Error'));
        await repository.updateLearningPathStatus(id: 'id', started: true);

        mockDao.setNextException(Exception('Error'));
        await repository.trackVideoViewed('id', 'video');

        mockDao.setNextException(Exception('Error'));
        await repository.dismissRecommendation('id', 'concept');

        // All should complete without throwing
      });

      test('criticalMethods_throwOnError', () async {
        // Save and update should throw as they're critical operations
        mockDao.setNextException(Exception('Error'));
        expect(
          () => repository.saveRecommendations(createHistory()),
          throwsException,
        );

        mockDao.setNextException(Exception('Error'));
        expect(
          () => repository.updateRecommendations(createHistory()),
          throwsException,
        );
      });

      test('queryMethods_returnNullOrEmpty', () async {
        mockDao.setNextException(Exception('Error'));
        final byId = await repository.getById('id');
        expect(byId, isNull);

        mockDao.setNextException(Exception('Error'));
        final byQuiz = await repository.getByQuizAttempt('quiz');
        expect(byQuiz, isNull);

        mockDao.setNextException(Exception('Error'));
        final history = await repository.getHistory(userId: 'user');
        expect(history, isEmpty);
      });
    });
  });
}
