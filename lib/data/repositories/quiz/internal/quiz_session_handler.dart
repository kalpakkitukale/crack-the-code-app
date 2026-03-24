/// Handler for quiz session operations
library;

import 'dart:convert';
import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import 'package:crack_the_code/core/errors/exceptions.dart';
import 'package:crack_the_code/core/errors/failures.dart';
import 'package:crack_the_code/core/models/assessment_type.dart';
import 'package:crack_the_code/core/services/quiz_retry_queue.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/core/utils/validation_helpers.dart';
import 'package:crack_the_code/data/datasources/json/quiz_json_datasource.dart';
import 'package:crack_the_code/data/datasources/local/database/dao/question_dao.dart';
import 'package:crack_the_code/data/datasources/local/database/dao/quiz_attempt_dao.dart';
import 'package:crack_the_code/data/datasources/local/database/dao/quiz_dao.dart';
import 'package:crack_the_code/data/datasources/local/database/dao/quiz_session_dao.dart';
import 'package:crack_the_code/data/models/quiz/question_model.dart';
import 'package:crack_the_code/data/models/quiz/quiz_attempt_model.dart';
import 'package:crack_the_code/data/models/quiz/quiz_model.dart';
import 'package:crack_the_code/data/models/quiz/quiz_session_model.dart';
import 'package:crack_the_code/data/repositories/quiz/internal/quiz_helpers.dart'
    as helpers;
import 'package:crack_the_code/domain/entities/quiz/quiz.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_attempt_status.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_result.dart';
import 'package:crack_the_code/domain/entities/quiz/quiz_session.dart';

const _uuid = Uuid();

/// Handles quiz session operations (loadQuiz, submitAnswer, completeQuiz, etc.)
class QuizSessionHandler {
  final QuestionDao _questionDao;
  final QuizDao _quizDao;
  final QuizSessionDao _sessionDao;
  final QuizAttemptDao _attemptDao;
  final QuizJsonDataSource _jsonDataSource;

  /// Optional profile ID for multi-profile support
  String? profileId;

  QuizSessionHandler({
    required QuestionDao questionDao,
    required QuizDao quizDao,
    required QuizSessionDao sessionDao,
    required QuizAttemptDao attemptDao,
    required QuizJsonDataSource jsonDataSource,
  })  : _questionDao = questionDao,
        _quizDao = quizDao,
        _sessionDao = sessionDao,
        _attemptDao = attemptDao,
        _jsonDataSource = jsonDataSource;

  /// Process any pending quiz attempts from the retry queue
  Future<int> processRetryQueue() async {
    return QuizRetryQueue.processQueue((attempt) async {
      try {
        await _attemptDao.insert(attempt);
        return true;
      } catch (e) {
        logger.warning(
            'Retry queue: Failed to save attempt ${attempt.id}: $e');
        return false;
      }
    });
  }

  /// Load a quiz for a specific entity
  Future<Either<Failure, QuizSession>> loadQuiz({
    required String entityId,
    required String studentId,
    AssessmentType assessmentType = AssessmentType.practice,
    Future<Either<Failure, QuizSession?>> Function(String)? getActiveSession,
    Future<Either<Failure, void>> Function(String)? deleteSession,
  }) async {
    // Validate inputs
    final validation = ValidationHelpers.validateRequiredIds({
      'entityId': entityId,
      'studentId': studentId,
    });

    if (validation.isLeft()) {
      return Left(validation.fold(
        (failure) => failure,
        (_) => const ValidationFailure(message: 'Validation failed'),
      ));
    }

    try {
      logger.info('Loading quiz for entity: $entityId, student: $studentId');

      // Use profileId if set, otherwise fall back to provided studentId
      final effectiveStudentId = profileId ?? studentId;

      // Check for any active sessions and complete them before starting fresh
      if (getActiveSession != null && deleteSession != null) {
        final activeSessionResult = await getActiveSession(effectiveStudentId);
        final activeSession = activeSessionResult.fold(
          (failure) {
            logger.debug(
                'Could not check for active session: ${failure.message}');
            return null;
          },
          (session) => session,
        );

        if (activeSession != null) {
          logger.info('Found existing active session: ${activeSession.id}');
          logger.info('Deleting abandoned session without saving to history');
          await deleteSession(activeSession.id);
        }
      }

      // Handle special case for daily challenge
      QuizModel? quizModel;
      List<QuestionModel> questionModels = [];

      if (entityId == 'daily_challenge') {
        logger.info('Loading daily challenge quiz from database');

        final allQuestionIds = await _questionDao.getAllIds();

        if (allQuestionIds.isEmpty) {
          logger.warning('No questions available for daily challenge');
          return Left(NotFoundFailure(
            message:
                'No questions available. Watch more videos to unlock daily challenges!',
            entityType: 'Quiz',
            entityId: entityId,
          ));
        }

        // Randomly select 5 question IDs with date-based seed
        final seed = helpers.getDailyChallengeSeeds();
        final random = Random(seed);

        final shuffledIds = List<String>.from(allQuestionIds);
        shuffledIds.shuffle(random);
        final selectedIds = shuffledIds.take(5).toList();

        questionModels = await _questionDao.getByIds(selectedIds);

        final now = DateTime.now();
        final questionIdsList = questionModels.map((q) => q.id).toList();
        quizModel = QuizModel(
          id: 'daily_challenge_${now.year}_${now.month}_${now.day}',
          level: 'student',
          entityId: 'daily_challenge',
          questionIds: jsonEncode(questionIdsList),
          timeLimit: 300,
          passingScore: 0.6,
          title: 'Daily Challenge',
          config: null,
        );

        logger.info(
            'Daily challenge quiz created with ${questionModels.length} questions');
      } else {
        // Load quiz from JSON
        logger.info('Loading quiz from JSON for entity: $entityId');

        try {
          final quizData = await _jsonDataSource.loadQuizByEntityId(entityId);

          await _questionDao.insertBatch(quizData.questions);
          await _quizDao.insert(quizData.quiz);

          quizModel = quizData.quiz;
          questionModels = quizData.questions;

          logger.info(
              'Quiz loaded from JSON and saved to database: ${quizData.quiz.title}');
        } catch (e) {
          logger.warning(
              'Failed to load quiz from JSON for entity: $entityId', e);
          return Left(NotFoundFailure(
            message: 'Quiz not found for this content',
            entityType: 'Quiz',
            entityId: entityId,
          ));
        }
      }

      final quiz = quizModel.toEntity();

      // Load questions from database if not already loaded
      if (questionModels.isEmpty) {
        questionModels = await _questionDao.getByIds(quiz.questionIds);
      }
      if (questionModels.isEmpty) {
        logger.warning('No questions found for quiz: ${quiz.id}');
        return Left(NotFoundFailure(
          message: 'No questions available for this quiz',
          entityType: 'Question',
          entityId: quiz.id,
        ));
      }

      final allQuestions = questionModels.map((m) => m.toEntity()).toList();

      // Apply random selection based on quiz level
      final questions = helpers.selectQuestionsForLevel(
        allQuestions: allQuestions,
        quizLevel: quiz.level,
        entityId: entityId,
      );

      logger.info(
          'Selected ${questions.length} questions from ${allQuestions.length} available for ${quiz.level} quiz');

      // Create new session
      final sessionId = _uuid.v4();
      final session = QuizSession(
        id: sessionId,
        quizId: quiz.id,
        studentId: effectiveStudentId,
        questions: questions,
        startTime: DateTime.now(),
        state: QuizSessionState.notStarted,
        assessmentType: assessmentType,
      );

      // Save session to database
      final sessionModel = QuizSessionModel.fromPartialEntity(
        id: session.id,
        quizId: session.quizId,
        studentId: session.studentId,
        startTime: session.startTime,
        state: session.state,
        currentQuestionIndex: session.currentQuestionIndex,
        answers: session.answers,
        selectedQuestionIds: questions.map((q) => q.id).toList(),
        assessmentType: assessmentType,
      );

      await _sessionDao.insert(sessionModel);

      logger.info(
          'Quiz session created: $sessionId (type: ${assessmentType.name})');
      return Right(session);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error loading quiz', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to load quiz',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error loading quiz', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  /// Load a quiz by its ID
  Future<Either<Failure, QuizSession>> loadQuizById({
    required String quizId,
    required String studentId,
    AssessmentType assessmentType = AssessmentType.practice,
  }) async {
    try {
      logger.info('Loading quiz by ID: $quizId for student: $studentId');

      // Get quiz
      final quizModel = await _quizDao.getById(quizId);
      if (quizModel == null) {
        logger.warning('Quiz not found: $quizId');
        return Left(NotFoundFailure(
          message: 'Quiz not found',
          entityType: 'Quiz',
          entityId: quizId,
        ));
      }

      final quiz = quizModel.toEntity();

      // Load questions
      final questionModels = await _questionDao.getByIds(quiz.questionIds);
      final questions = questionModels.map((m) => m.toEntity()).toList();

      // Use profileId if set, otherwise fall back to provided studentId
      final effectiveStudentId = profileId ?? studentId;

      // Create new session
      final sessionId = _uuid.v4();
      final session = QuizSession(
        id: sessionId,
        quizId: quiz.id,
        studentId: effectiveStudentId,
        questions: questions,
        startTime: DateTime.now(),
        state: QuizSessionState.notStarted,
        assessmentType: assessmentType,
      );

      // Save session
      final sessionModel = QuizSessionModel.fromPartialEntity(
        id: session.id,
        quizId: session.quizId,
        studentId: session.studentId,
        startTime: session.startTime,
        state: session.state,
        currentQuestionIndex: session.currentQuestionIndex,
        answers: session.answers,
        selectedQuestionIds: questions.map((q) => q.id).toList(),
        assessmentType: assessmentType,
      );

      await _sessionDao.insert(sessionModel);

      logger.info(
          'Quiz session created: $sessionId (type: ${assessmentType.name})');
      return Right(session);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error loading quiz by ID', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to load quiz',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error loading quiz by ID', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  /// Resume an existing session
  Future<Either<Failure, QuizSession>> resumeSession(String sessionId) async {
    try {
      logger.info('Resuming quiz session: $sessionId');

      final sessionModel = await _sessionDao.getById(sessionId);
      if (sessionModel == null) {
        logger.warning('Session not found: $sessionId');
        return Left(NotFoundFailure(
          message: 'Quiz session not found',
          entityType: 'QuizSession',
          entityId: sessionId,
        ));
      }

      // Load questions - use the selected question IDs from the session
      final selectedIds =
          jsonDecode(sessionModel.selectedQuestionIds) as List;
      final questionIdsList = selectedIds.cast<String>();

      final questionModels = await _questionDao.getByIds(questionIdsList);

      // Reorder to match original order
      final questionMap = {for (var q in questionModels) q.id: q};
      final orderedQuestionModels = questionIdsList
          .where((id) => questionMap.containsKey(id))
          .map((id) => questionMap[id]!)
          .toList();

      final questions =
          orderedQuestionModels.map((m) => m.toEntity()).toList();

      // Reconstruct session
      final partial = sessionModel.toPartialEntity();
      final session = QuizSession(
        id: sessionModel.id,
        quizId: sessionModel.quizId,
        studentId: sessionModel.studentId,
        questions: questions,
        startTime: partial['startTime'] as DateTime,
        state: partial['state'] as QuizSessionState,
        currentQuestionIndex: partial['currentQuestionIndex'] as int,
        answers: partial['answers'] as Map<String, String>,
        endTime: partial['endTime'] as DateTime?,
        assessmentType: partial['assessmentType'] as AssessmentType,
      );

      logger.info(
          'Quiz session resumed: $sessionId (type: ${session.assessmentType.name})');
      return Right(session);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error resuming session', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to resume quiz session',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error resuming session', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  /// Submit an answer for a question
  Future<Either<Failure, QuizSession>> submitAnswer({
    required String sessionId,
    required String questionId,
    required String answer,
    int? currentQuestionIndex,
  }) async {
    try {
      logger.debug(
          'Submitting answer for session: $sessionId, question: $questionId');

      final sessionModel = await _sessionDao.getById(sessionId);
      if (sessionModel == null) {
        logger.warning('Session not found: $sessionId');
        return Left(NotFoundFailure(
          message: 'Quiz session not found',
          entityType: 'QuizSession',
          entityId: sessionId,
        ));
      }

      // Load questions with original order preserved
      final selectedIds =
          jsonDecode(sessionModel.selectedQuestionIds) as List;
      final questionIdsList = selectedIds.cast<String>();
      final questionModels = await _questionDao.getByIds(questionIdsList);

      final questionMap = {for (var q in questionModels) q.id: q};
      final orderedQuestionModels = questionIdsList
          .where((id) => questionMap.containsKey(id))
          .map((id) => questionMap[id]!)
          .toList();

      final questions =
          orderedQuestionModels.map((m) => m.toEntity()).toList();

      // Reconstruct partial session data
      final partial = sessionModel.toPartialEntity();

      // Add answer to existing answers
      final existingAnswers = partial['answers'] as Map<String, String>;
      final updatedAnswers = Map<String, String>.from(existingAnswers);
      updatedAnswers[questionId] = answer;

      // Use UI state's question index if provided
      final nextIndex =
          currentQuestionIndex ?? (partial['currentQuestionIndex'] as int);

      // Create updated session
      final updatedSession = QuizSession(
        id: sessionModel.id,
        quizId: sessionModel.quizId,
        studentId: sessionModel.studentId,
        questions: questions,
        startTime: partial['startTime'] as DateTime,
        state: QuizSessionState.inProgress,
        currentQuestionIndex: nextIndex,
        answers: updatedAnswers,
        endTime: partial['endTime'] as DateTime?,
        assessmentType: partial['assessmentType'] as AssessmentType,
      );

      // Save to database
      final updatedSessionModel = QuizSessionModel.fromPartialEntity(
        id: updatedSession.id,
        quizId: updatedSession.quizId,
        studentId: updatedSession.studentId,
        startTime: updatedSession.startTime,
        state: updatedSession.state,
        currentQuestionIndex: updatedSession.currentQuestionIndex,
        answers: updatedSession.answers,
        selectedQuestionIds:
            updatedSession.questions.map((q) => q.id).toList(),
        endTime: updatedSession.endTime,
        assessmentType: updatedSession.assessmentType,
      );

      await _sessionDao.update(updatedSessionModel);

      logger.debug('Answer submitted successfully');
      return Right(updatedSession);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error submitting answer', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to submit answer',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error submitting answer', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  /// Clear all answers in a session
  Future<Either<Failure, QuizSession>> clearAllAnswers(
      String sessionId) async {
    try {
      logger.info('Clearing all answers for session: $sessionId');

      final result = await resumeSession(sessionId);

      return result.fold(
        (failure) => Left(failure),
        (session) async {
          final updatedSession = session.copyWith(
            answers: {},
          );

          final sessionModel = QuizSessionModel.fromPartialEntity(
            id: updatedSession.id,
            quizId: updatedSession.quizId,
            studentId: updatedSession.studentId,
            startTime: updatedSession.startTime,
            state: updatedSession.state,
            currentQuestionIndex: updatedSession.currentQuestionIndex,
            answers: updatedSession.answers,
            selectedQuestionIds:
                updatedSession.questions.map((q) => q.id).toList(),
            endTime: updatedSession.endTime,
            assessmentType: updatedSession.assessmentType,
          );

          await _sessionDao.update(sessionModel);

          logger.info('All answers cleared successfully from database');
          return Right(updatedSession);
        },
      );
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error clearing answers', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to clear answers',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error clearing answers', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  /// Complete a quiz session and calculate results
  Future<Either<Failure, QuizResult>> completeQuiz(String sessionId) async {
    try {
      logger.info('Completing quiz session: $sessionId');

      final result = await resumeSession(sessionId);

      return result.fold(
        (failure) => Left(failure),
        (session) async {
          // Calculate results
          final questionResults = <String, bool>{};
          int correctCount = 0;

          for (final question in session.questions) {
            final answer = session.answers[question.id];
            final isCorrect = answer != null && question.isCorrect(answer);
            questionResults[question.id] = isCorrect;
            if (isCorrect) correctCount++;
          }

          final totalQuestions = session.questions.length;
          final scorePercentage = (correctCount / totalQuestions) * 100;

          // Get quiz to check passing score
          final quizModel = await _quizDao.getById(session.quizId);

          logger.info(
              '🔍 DEBUG: Quiz lookup for session.quizId: ${session.quizId}');
          logger.info('🔍 DEBUG: QuizModel found: ${quizModel != null}');

          final passingScore = quizModel?.passingScore ?? 0.75;
          final passed = (scorePercentage / 100) >= passingScore;

          // Calculate concept analysis
          logger.info('📊 Analyzing concept performance...');
          final conceptAnalysis =
              helpers.analyzeConceptPerformance(session);
          logger.info(
              '📊 Concept analysis results: ${conceptAnalysis.length} concepts analyzed');

          // Identify weak and strong areas
          var weakAreas = helpers.identifyWeakAreas(conceptAnalysis);
          var strongAreas = helpers.identifyStrongAreas(conceptAnalysis);

          // Fallback for quizzes without concept tags
          if (conceptAnalysis.isEmpty && scorePercentage < 60.0) {
            final fallbackWeakArea = session.quizId;
            weakAreas = [fallbackWeakArea];
            logger.warning(
                '⚠️ No concept tags found, using fallback weak area: $fallbackWeakArea');
          }

          // Calculate time taken
          final timeTaken = DateTime.now().difference(session.startTime);

          // Extract metadata
          final quiz = quizModel?.toEntity();
          QuizLevel? quizLevel = quiz?.level;
          String? entityId = quiz?.entityId;
          String? quizTitle = quiz?.title;

          // Infer level from quizId pattern if quiz is null
          if (quiz == null && session.quizId.isNotEmpty) {
            logger.warning(
                'Quiz model is NULL - inferring metadata from session');
            if (session.quizId.startsWith('subject_')) {
              quizLevel = QuizLevel.subject;
              entityId = session.quizId;
            } else if (session.quizId.startsWith('chapter_')) {
              quizLevel = QuizLevel.chapter;
              entityId = session.quizId;
            } else if (session.quizId.startsWith('topic_')) {
              quizLevel = QuizLevel.topic;
              entityId = session.quizId;
            } else if (session.quizId.startsWith('video_')) {
              quizLevel = QuizLevel.video;
              entityId = session.quizId;
            }
          }

          final metadata = await helpers.extractQuizMetadata(
            entityId: entityId,
            quizLevel: quizLevel,
            quizTitle: quizTitle,
          );

          // Create quiz result
          final quizResult = QuizResult(
            sessionId: sessionId,
            totalQuestions: totalQuestions,
            correctAnswers: correctCount,
            scorePercentage: scorePercentage,
            passed: passed,
            questionResults: questionResults,
            timeTaken: timeTaken,
            evaluatedAt: DateTime.now(),
            conceptAnalysis: conceptAnalysis,
            weakAreas: weakAreas,
            strongAreas: strongAreas,
            recommendation: helpers.generateRecommendation(passed, weakAreas),
            questions: session.questions,
            answers: session.answers,
            quizLevel: quizLevel?.toString().split('.').last,
            subjectName: metadata['subjectName'],
            chapterName: metadata['chapterName'],
            topicName: metadata['topicName'],
            videoTitle: null,
          );

          // Save quiz attempt
          final attemptId = sessionId;
          final attemptModel = QuizAttemptModel(
            id: attemptId,
            quizId: session.quizId,
            studentId: session.studentId,
            answers: session.answers,
            score: scorePercentage / 100,
            passed: passed,
            completedAt: DateTime.now(),
            timeTaken: timeTaken.inSeconds,
            startTime: session.startTime,
            totalQuestions: totalQuestions,
            correctAnswers: correctCount,
            quizLevel: quizLevel?.toString().split('.').last,
            subjectId: metadata['subjectId'],
            subjectName: metadata['subjectName'],
            chapterId: metadata['chapterId'],
            chapterName: metadata['chapterName'],
            topicId: metadata['topicId'],
            topicName: metadata['topicName'],
            videoTitle: metadata['videoTitle'],
            questions: session.questions,
            status: QuizAttemptStatus.completed,
            assessmentType: session.assessmentType,
          );

          // Attempt to save to database
          try {
            await _attemptDao.insert(attemptModel);
          } catch (e, stackTrace) {
            logger.error(
                '✗ CRITICAL ERROR: Failed to save quiz attempt to database!',
                e,
                stackTrace);

            // Save to retry queue for later persistence
            try {
              await QuizRetryQueue.enqueue(attemptModel);
              logger.info(
                  'Quiz attempt added to retry queue for later persistence');
            } catch (queueError) {
              logger.error('Failed to add to retry queue: $queueError');
            }
          }

          // Update session state
          final completedSession = session.copyWith(
            state: QuizSessionState.completed,
            endTime: DateTime.now(),
          );

          final sessionModel = QuizSessionModel.fromPartialEntity(
            id: completedSession.id,
            quizId: completedSession.quizId,
            studentId: completedSession.studentId,
            startTime: completedSession.startTime,
            state: completedSession.state,
            currentQuestionIndex: completedSession.currentQuestionIndex,
            answers: completedSession.answers,
            selectedQuestionIds:
                completedSession.questions.map((q) => q.id).toList(),
            endTime: completedSession.endTime,
            assessmentType: completedSession.assessmentType,
          );

          await _sessionDao.update(sessionModel);

          logger.info(
              'Quiz completed: ${quizResult.scoreDisplay} (${quizResult.percentageDisplay})');
          return Right(quizResult);
        },
      );
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error completing quiz', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to complete quiz',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error completing quiz', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  /// Pause a session
  Future<Either<Failure, QuizSession>> pauseSession(String sessionId) async {
    try {
      logger.info('Pausing quiz session: $sessionId');

      final result = await resumeSession(sessionId);

      return result.fold(
        (failure) => Left(failure),
        (session) async {
          final pausedSession =
              session.copyWith(state: QuizSessionState.paused);

          final sessionModel = QuizSessionModel.fromPartialEntity(
            id: pausedSession.id,
            quizId: pausedSession.quizId,
            studentId: pausedSession.studentId,
            startTime: pausedSession.startTime,
            state: pausedSession.state,
            currentQuestionIndex: pausedSession.currentQuestionIndex,
            answers: pausedSession.answers,
            selectedQuestionIds:
                pausedSession.questions.map((q) => q.id).toList(),
            endTime: pausedSession.endTime,
            assessmentType: pausedSession.assessmentType,
          );

          await _sessionDao.update(sessionModel);

          logger.info('Quiz session paused');
          return Right(pausedSession);
        },
      );
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error pausing session', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to pause quiz',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error pausing session', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  /// Get the active session for a student
  Future<Either<Failure, QuizSession?>> getActiveSession(
      String studentId) async {
    try {
      // Use profileId if set, otherwise fall back to provided studentId
      final effectiveStudentId = profileId ?? studentId;
      logger.debug('Getting active session for student: $effectiveStudentId');

      final sessionModel =
          await _sessionDao.getActiveSession(effectiveStudentId);

      if (sessionModel == null) {
        return const Right(null);
      }

      // Resume the session to get full details
      return await resumeSession(sessionModel.id);
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error getting active session', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to get active session',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error getting active session', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }

  /// Delete a session
  Future<Either<Failure, void>> deleteSession(String sessionId) async {
    try {
      logger.info('Deleting quiz session: $sessionId');

      await _sessionDao.delete(sessionId);

      logger.info('Quiz session deleted');
      return const Right(null);
    } on NotFoundException catch (e, stackTrace) {
      logger.warning('Session not found', e, stackTrace);
      return Left(NotFoundFailure(
        message: 'Quiz session not found',
        entityType: 'QuizSession',
        entityId: sessionId,
      ));
    } on DatabaseException catch (e, stackTrace) {
      logger.error('Database error deleting session', e, stackTrace);
      return Left(DatabaseFailure(
        message: 'Failed to delete quiz session',
        details: e.message,
      ));
    } catch (e, stackTrace) {
      logger.error('Unknown error deleting session', e, stackTrace);
      return Left(UnknownFailure(
        message: 'An unexpected error occurred',
        details: e.toString(),
      ));
    }
  }
}
