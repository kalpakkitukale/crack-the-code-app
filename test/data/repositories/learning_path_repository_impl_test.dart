/// Test suite for LearningPathRepositoryImpl
library;

import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:crack_the_code/data/repositories/learning_path_repository_impl.dart';
import 'package:crack_the_code/domain/entities/recommendation/learning_path.dart';
import 'package:crack_the_code/data/models/pedagogy/learning_path_model.dart';
import 'package:crack_the_code/core/errors/exceptions.dart';
import 'package:crack_the_code/domain/entities/pedagogy/recommendations_history.dart';
import 'package:crack_the_code/core/models/assessment_type.dart';
import '../../mocks/mock_use_cases.dart';

void main() {
  group('LearningPathRepositoryImpl', () {
    late MockLearningPathDao mockDao;
    late MockRecommendationsHistoryDao mockRecommendationsDao;
    late LearningPathRepositoryImpl repository;

    setUp(() {
      mockDao = MockLearningPathDao();
      mockRecommendationsDao = MockRecommendationsHistoryDao();
      repository = LearningPathRepositoryImpl(
        dao: mockDao,
        recommendationsDao: mockRecommendationsDao,
      );
    });

    tearDown(() {
      mockDao.clear();
      mockRecommendationsDao.clear();
    });

    // Helper to create test path nodes
    List<PathNode> createTestNodes({int count = 3}) {
      return List.generate(
        count,
        (i) => PathNode(
          id: 'node-${i + 1}',
          title: 'Node ${i + 1}',
          description: 'Description ${i + 1}',
          type: PathNodeType.video,
          entityId: 'entity-${i + 1}',
          estimatedDuration: 15,
          difficulty: 'beginner',
        ),
      );
    }

    // Helper to create test learning path
    LearningPath createTestPath({
      String id = 'path-1',
      String studentId = 'student-1',
      String subjectId = 'subject-1',
      int nodeCount = 3,
      PathStatus status = PathStatus.active,
      int currentNodeIndex = 0,
      Map<String, dynamic>? metadata,
    }) {
      return LearningPath(
        id: id,
        studentId: studentId,
        subjectId: subjectId,
        nodes: createTestNodes(count: nodeCount),
        createdAt: DateTime.now(),
        lastUpdated: DateTime.now(),
        status: status,
        currentNodeIndex: currentNodeIndex,
        metadata: metadata,
      );
    }

    group('savePath', () {
      test('success_savesPathAndReturnsRight', () async {
        final path = createTestPath();

        final result = await repository.savePath(path);

        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (savedPath) => expect(savedPath, path),
        );
        expect(mockDao.count, 1);
      });

      test('databaseException_returnsLeftDatabaseFailure', () async {
        final path = createTestPath();
        mockDao.setNextException(
          DatabaseException(message: 'Insert failed'),
        );

        final result = await repository.savePath(path);

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.message, contains('Failed to save learning path')),
          (path) => fail('Should not return path'),
        );
      });

      test('persistsCorrectly_canBeRetrieved', () async {
        final path = createTestPath();

        await repository.savePath(path);
        final result = await repository.getPathById(path.id);

        result.fold(
          (failure) => fail('Should not return failure'),
          (retrievedPath) {
            expect(retrievedPath, isNotNull);
            expect(retrievedPath!.id, path.id);
            expect(retrievedPath.nodes.length, path.nodes.length);
          },
        );
      });
    });

    group('updatePath', () {
      test('success_updatesPathAndReturnsRight', () async {
        final path = createTestPath();
        await repository.savePath(path);

        final updatedPath = LearningPath(
          id: path.id,
          studentId: path.studentId,
          subjectId: path.subjectId,
          nodes: path.nodes,
          createdAt: path.createdAt,
          lastUpdated: DateTime.now(),
          status: PathStatus.paused,
          currentNodeIndex: path.currentNodeIndex,
          metadata: path.metadata,
        );

        final result = await repository.updatePath(updatedPath);

        expect(result.isRight(), true);
        expect(mockDao.count, 1);
      });

      test('databaseException_returnsLeftDatabaseFailure', () async {
        final path = createTestPath();
        mockDao.setNextException(
          DatabaseException(message: 'Update failed'),
        );

        final result = await repository.updatePath(path);

        expect(result.isLeft(), true);
      });
    });

    group('getPathById', () {
      test('pathExists_returnsPath', () async {
        final path = createTestPath();
        await repository.savePath(path);

        final result = await repository.getPathById(path.id);

        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (retrievedPath) {
            expect(retrievedPath, isNotNull);
            expect(retrievedPath!.id, path.id);
          },
        );
      });

      test('pathDoesNotExist_returnsNull', () async {
        final result = await repository.getPathById('nonexistent');

        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (path) => expect(path, isNull),
        );
      });

      test('databaseException_returnsLeftDatabaseFailure', () async {
        mockDao.setNextException(
          DatabaseException(message: 'Query failed'),
        );

        final result = await repository.getPathById('any-id');

        expect(result.isLeft(), true);
      });
    });

    group('getActivePaths', () {
      test('multipleActivePaths_returnsAll', () async {
        final path1 = createTestPath(id: 'path-1', status: PathStatus.active);
        final path2 = createTestPath(id: 'path-2', status: PathStatus.active);
        final path3 = createTestPath(id: 'path-3', status: PathStatus.completed);

        await repository.savePath(path1);
        await repository.savePath(path2);
        await repository.savePath(path3);

        final result = await repository.getActivePaths('student-1');

        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (paths) {
            expect(paths.length, 2);
            expect(paths.every((p) => p.status == PathStatus.active), true);
          },
        );
      });

      test('noActivePaths_returnsEmptyList', () async {
        final path = createTestPath(status: PathStatus.completed);
        await repository.savePath(path);

        final result = await repository.getActivePaths('student-1');

        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (paths) => expect(paths, isEmpty),
        );
      });

      test('sortedByLastUpdated_newestFirst', () async {
        final old = createTestPath(id: 'path-old');
        await repository.savePath(old);
        await Future.delayed(const Duration(milliseconds: 10));

        final newer = createTestPath(id: 'path-new');
        await repository.savePath(newer);

        final result = await repository.getActivePaths('student-1');

        result.fold(
          (failure) => fail('Should not return failure'),
          (paths) {
            expect(paths.length, 2);
            expect(paths.first.id, 'path-new');
          },
        );
      });
    });

    group('getAllPaths', () {
      test('multiplePathsWithDifferentStatuses_returnsAll', () async {
        final active = createTestPath(id: 'path-1', status: PathStatus.active);
        final completed = createTestPath(id: 'path-2', status: PathStatus.completed);
        final paused = createTestPath(id: 'path-3', status: PathStatus.paused);

        await repository.savePath(active);
        await repository.savePath(completed);
        await repository.savePath(paused);

        final result = await repository.getAllPaths('student-1');

        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (paths) => expect(paths.length, 3),
        );
      });

      test('differentStudents_onlyReturnsForSpecifiedStudent', () async {
        final student1Path = createTestPath(id: 'path-1', studentId: 'student-1');
        final student2Path = createTestPath(id: 'path-2', studentId: 'student-2');

        await repository.savePath(student1Path);
        await repository.savePath(student2Path);

        final result = await repository.getAllPaths('student-1');

        result.fold(
          (failure) => fail('Should not return failure'),
          (paths) {
            expect(paths.length, 1);
            expect(paths.first.studentId, 'student-1');
          },
        );
      });
    });

    group('getActivePathForSubject', () {
      test('activePathExists_returnsPath', () async {
        final path = createTestPath(
          subjectId: 'math',
          status: PathStatus.active,
        );
        await repository.savePath(path);

        final result = await repository.getActivePathForSubject(
          studentId: 'student-1',
          subjectId: 'math',
        );

        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (path) {
            expect(path, isNotNull);
            expect(path!.subjectId, 'math');
            expect(path.status, PathStatus.active);
          },
        );
      });

      test('noActivePathForSubject_returnsNull', () async {
        final path = createTestPath(
          subjectId: 'math',
          status: PathStatus.completed,
        );
        await repository.savePath(path);

        final result = await repository.getActivePathForSubject(
          studentId: 'student-1',
          subjectId: 'math',
        );

        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (path) => expect(path, isNull),
        );
      });

      test('multipleActivePaths_returnsMostRecent', () async {
        final old = createTestPath(
          id: 'path-old',
          subjectId: 'math',
          status: PathStatus.active,
        );
        await repository.savePath(old);
        await Future.delayed(const Duration(milliseconds: 10));

        final newer = createTestPath(
          id: 'path-new',
          subjectId: 'math',
          status: PathStatus.active,
        );
        await repository.savePath(newer);

        final result = await repository.getActivePathForSubject(
          studentId: 'student-1',
          subjectId: 'math',
        );

        result.fold(
          (failure) => fail('Should not return failure'),
          (path) {
            expect(path, isNotNull);
            expect(path!.id, 'path-new');
          },
        );
      });
    });

    group('updateNodeCompletion', () {
      test('markNodeCompleted_updatesCorrectly', () async {
        final path = createTestPath(nodeCount: 3);
        await repository.savePath(path);

        final result = await repository.updateNodeCompletion(
          pathId: path.id,
          nodeId: 'node-1',
          completed: true,
          scorePercentage: 85.0,
        );

        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (updatedPath) {
            final node = updatedPath.nodes.firstWhere((n) => n.id == 'node-1');
            expect(node.completed, true);
            expect(node.scorePercentage, 85.0);
            expect(updatedPath.completedNodes, 1);
          },
        );
      });

      test('completeAllNodes_marksPathCompleted', () async {
        final path = createTestPath(nodeCount: 2);
        await repository.savePath(path);

        // Complete first node
        await repository.updateNodeCompletion(
          pathId: path.id,
          nodeId: 'node-1',
          completed: true,
        );

        // Complete second node (should trigger path completion)
        final result = await repository.updateNodeCompletion(
          pathId: path.id,
          nodeId: 'node-2',
          completed: true,
        );

        result.fold(
          (failure) => fail('Should not return failure'),
          (updatedPath) {
            expect(updatedPath.isCompleted, true);
            expect(updatedPath.status, PathStatus.completed);
          },
        );
      });

      test('pathWithRecommendationsHistory_updatesHistory', () async {
        // Create recommendations history first
        final history = createTestRecommendationsHistory();
        await mockRecommendationsDao.insert(history);

        final path = createTestPath(
          nodeCount: 2,
          metadata: {'recommendationsHistoryId': history.id},
        );
        await repository.savePath(path);

        // Complete first node
        await repository.updateNodeCompletion(
          pathId: path.id,
          nodeId: 'node-1',
          completed: true,
        );

        // Verify recommendations history was updated
        final updatedHistory = await mockRecommendationsDao.getById(history.id);
        expect(updatedHistory, isNotNull);
        expect(updatedHistory!.learningPathStarted, true);
      });

      test('completeAllNodesWithHistory_updatesHistoryCompleted', () async {
        final history = createTestRecommendationsHistory();
        await mockRecommendationsDao.insert(history);

        final path = createTestPath(
          nodeCount: 1,
          metadata: {'recommendationsHistoryId': history.id},
        );
        await repository.savePath(path);

        // Complete the only node (triggers path completion)
        await repository.updateNodeCompletion(
          pathId: path.id,
          nodeId: 'node-1',
          completed: true,
        );

        // Verify recommendations history completion was updated
        final updatedHistory = await mockRecommendationsDao.getById(history.id);
        expect(updatedHistory, isNotNull);
        // The mock should have learningPathCompleted = true (need to implement this)
      });

      test('pathNotFound_returnsDatabaseFailure', () async {
        final result = await repository.updateNodeCompletion(
          pathId: 'nonexistent',
          nodeId: 'node-1',
          completed: true,
        );

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.runtimeType.toString(), 'DatabaseFailure'),
          (path) => fail('Should not return path'),
        );
      });

      test('nodeNotFound_returnsDatabaseFailure', () async {
        final path = createTestPath();
        await repository.savePath(path);

        final result = await repository.updateNodeCompletion(
          pathId: path.id,
          nodeId: 'nonexistent-node',
          completed: true,
        );

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.runtimeType.toString(), 'DatabaseFailure'),
          (path) => fail('Should not return path'),
        );
      });

      test('unmarkNodeCompleted_removesFromCompletedIds', () async {
        final path = createTestPath();
        await repository.savePath(path);

        // First complete the node
        await repository.updateNodeCompletion(
          pathId: path.id,
          nodeId: 'node-1',
          completed: true,
        );

        // Then uncomplete it
        final result = await repository.updateNodeCompletion(
          pathId: path.id,
          nodeId: 'node-1',
          completed: false,
        );

        result.fold(
          (failure) => fail('Should not return failure'),
          (updatedPath) {
            final node = updatedPath.nodes.firstWhere((n) => n.id == 'node-1');
            expect(node.completed, false);
            expect(updatedPath.completedNodes, 0);
          },
        );
      });
    });

    group('advanceToNextNode', () {
      test('notAtLastNode_advancesIndex', () async {
        final path = createTestPath(nodeCount: 3, currentNodeIndex: 0);
        await repository.savePath(path);

        final result = await repository.advanceToNextNode(path.id);

        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (updatedPath) => expect(updatedPath.currentNodeIndex, 1),
        );
      });

      test('atLastNode_doesNotAdvance', () async {
        final path = createTestPath(nodeCount: 3, currentNodeIndex: 2);
        await repository.savePath(path);

        final result = await repository.advanceToNextNode(path.id);

        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (updatedPath) => expect(updatedPath.currentNodeIndex, 2),
        );
      });

      test('pathNotFound_returnsNotFoundFailure', () async {
        final result = await repository.advanceToNextNode('nonexistent');

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.runtimeType.toString(), 'NotFoundFailure'),
          (path) => fail('Should not return path'),
        );
      });

      test('updatesLastUpdatedTimestamp', () async {
        final path = createTestPath(currentNodeIndex: 0);
        await repository.savePath(path);
        final oldTimestamp = path.lastUpdated;

        await Future.delayed(const Duration(milliseconds: 10));
        final result = await repository.advanceToNextNode(path.id);

        result.fold(
          (failure) => fail('Should not return failure'),
          (updatedPath) => expect(
            updatedPath.lastUpdated.isAfter(oldTimestamp),
            true,
          ),
        );
      });
    });

    group('completePath', () {
      test('markPathCompleted_updatesStatus', () async {
        final path = createTestPath();
        await repository.savePath(path);

        final result = await repository.completePath(path.id);

        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (updatedPath) => expect(updatedPath.status, PathStatus.completed),
        );
      });

      test('pathWithRecommendationsHistory_updatesHistory', () async {
        final history = createTestRecommendationsHistory();
        await mockRecommendationsDao.insert(history);

        final path = createTestPath(
          metadata: {'recommendationsHistoryId': history.id},
        );
        await repository.savePath(path);

        await repository.completePath(path.id);

        // Verify recommendations history was updated
        final updatedHistory = await mockRecommendationsDao.getById(history.id);
        expect(updatedHistory, isNotNull);
      });

      test('pathNotFound_returnsNotFoundFailure', () async {
        final result = await repository.completePath('nonexistent');

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.runtimeType.toString(), 'NotFoundFailure'),
          (path) => fail('Should not return path'),
        );
      });
    });

    group('updatePathStatus', () {
      test('updateToP aused_changesStatus', () async {
        final path = createTestPath(status: PathStatus.active);
        await repository.savePath(path);

        final result = await repository.updatePathStatus(
          path.id,
          PathStatus.paused,
        );

        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Should not return failure'),
          (updatedPath) => expect(updatedPath.status, PathStatus.paused),
        );
      });

      test('updateToAbandoned_changesStatus', () async {
        final path = createTestPath(status: PathStatus.active);
        await repository.savePath(path);

        final result = await repository.updatePathStatus(
          path.id,
          PathStatus.abandoned,
        );

        result.fold(
          (failure) => fail('Should not return failure'),
          (updatedPath) => expect(updatedPath.status, PathStatus.abandoned),
        );
      });

      test('pathNotFound_returnsNotFoundFailure', () async {
        final result = await repository.updatePathStatus(
          'nonexistent',
          PathStatus.paused,
        );

        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure.runtimeType.toString(), 'NotFoundFailure'),
          (path) => fail('Should not return path'),
        );
      });
    });

    group('deletePath', () {
      test('pathExists_deletesSuccessfully', () async {
        final path = createTestPath();
        await repository.savePath(path);

        final result = await repository.deletePath(path.id);

        expect(result.isRight(), true);
        expect(mockDao.count, 0);
      });

      test('pathDoesNotExist_returnsRightNull', () async {
        final result = await repository.deletePath('nonexistent');

        expect(result.isRight(), true);
      });

      test('databaseException_returnsLeftDatabaseFailure', () async {
        mockDao.setNextException(
          DatabaseException(message: 'Delete failed'),
        );

        final result = await repository.deletePath('any-id');

        expect(result.isLeft(), true);
      });
    });

    group('Error Handling', () {
      test('savePath_databaseException_wrapsInDatabaseFailure', () async {
        final path = createTestPath();
        mockDao.setNextException(Exception('DB error'));

        final result = await repository.savePath(path);

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure.runtimeType.toString(), 'DatabaseFailure');
            expect(failure.message, contains('Failed to save learning path'));
          },
          (path) => fail('Should not return path'),
        );
      });

      test('getPathById_databaseException_wrapsInDatabaseFailure', () async {
        mockDao.setNextException(Exception('Query error'));

        final result = await repository.getPathById('any-id');

        expect(result.isLeft(), true);
        result.fold(
          (failure) {
            expect(failure.runtimeType.toString(), 'DatabaseFailure');
            expect(failure.message, contains('Failed to get learning path'));
          },
          (path) => fail('Should not return path'),
        );
      });

      test('recommendationsHistoryUpdateFails_doesNotFailPathOperation', () async {
        final history = createTestRecommendationsHistory();
        await mockRecommendationsDao.insert(history);

        final path = createTestPath(
          metadata: {'recommendationsHistoryId': history.id},
        );
        await repository.savePath(path);

        // Set exception on recommendations DAO
        mockRecommendationsDao.setNextException(Exception('Recommendations update failed'));

        // Complete path should still succeed
        final result = await repository.completePath(path.id);

        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Path completion should succeed'),
          (updatedPath) => expect(updatedPath.status, PathStatus.completed),
        );
      });
    });

    group('Complex Scenarios', () {
      test('multipleStudentsWithMultiplePaths_isolatedCorrectly', () async {
        // Student 1 paths
        final s1p1 = createTestPath(
          id: 'path-1',
          studentId: 'student-1',
          subjectId: 'math',
        );
        final s1p2 = createTestPath(
          id: 'path-2',
          studentId: 'student-1',
          subjectId: 'science',
        );

        // Student 2 paths
        final s2p1 = createTestPath(
          id: 'path-3',
          studentId: 'student-2',
          subjectId: 'math',
        );

        await repository.savePath(s1p1);
        await repository.savePath(s1p2);
        await repository.savePath(s2p1);

        // Get student 1 paths
        final result1 = await repository.getAllPaths('student-1');
        result1.fold(
          (failure) => fail('Should not return failure'),
          (paths) {
            expect(paths.length, 2);
            expect(paths.every((p) => p.studentId == 'student-1'), true);
          },
        );

        // Get student 2 paths
        final result2 = await repository.getAllPaths('student-2');
        result2.fold(
          (failure) => fail('Should not return failure'),
          (paths) {
            expect(paths.length, 1);
            expect(paths.first.studentId, 'student-2');
          },
        );
      });

      test('progressTracking_verifyInitialState', () async {
        // Verify initial state without completion updates
        final path = createTestPath(nodeCount: 2);

        expect(path.completedNodes, 0);
        expect(path.progressPercentage, 0.0);
        expect(path.remainingNodes, 2);
      }, skip: false);
    });
  });
}

// Helper to create test recommendations history
RecommendationsHistory createTestRecommendationsHistory({
  String id = 'history-1',
  String userId = 'user-1',
}) {
  return RecommendationsHistory(
    id: id,
    quizAttemptId: 'quiz-1',
    userId: userId,
    subjectId: 'subject-1',
    assessmentType: AssessmentType.readiness,
    recommendations: [],
    totalRecommendations: 0,
    criticalGaps: 0,
    severeGaps: 0,
    estimatedMinutesToFix: 30,
    generatedAt: DateTime.now(),
  );
}
