/// JSON data source for loading quiz data from asset files
library;

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:streamshaala/core/errors/exceptions.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/data/models/quiz/question_model.dart';
import 'package:streamshaala/data/models/quiz/quiz_model.dart';

/// Data source for reading quiz JSON files from assets
///
/// This datasource handles loading quiz data from JSON files stored in
/// the assets folder. It supports caching for performance and provides
/// methods to load quizzes by entity ID or quiz ID.
class QuizJsonDataSource {
  /// Cache for loaded quizzes by quiz ID
  final Map<String, QuizModel> _quizzesCache = {};

  /// Cache for loaded questions by question ID
  final Map<String, QuestionModel> _questionsCache = {};

  /// Cache for quiz data (quiz + questions) by entity ID
  final Map<String, ({QuizModel quiz, List<QuestionModel> questions})> _entityQuizCache = {};

  /// Load quiz and questions by entity ID (video/topic/chapter/subject)
  ///
  /// This method loads the quiz JSON file associated with an entity ID.
  /// The file should be located at: assets/data/quizzes/{entityId}_quiz.json
  ///
  /// Returns a map containing both the quiz and its questions.
  /// Throws [AssetNotFoundException] if the file doesn't exist.
  /// Throws [JsonParseException] if the JSON is malformed.
  Future<({QuizModel quiz, List<QuestionModel> questions})> loadQuizByEntityId(String entityId) async {
    try {
      // Check cache first
      if (_entityQuizCache.containsKey(entityId)) {
        logger.debug('Quiz for entity $entityId loaded from cache');
        return _entityQuizCache[entityId]!;
      }

      // Try multiple file path patterns for flexibility
      // Search across ALL subject directories, not just physics
      // Order matters: try simple patterns first as they match most files
      final subjectDirs = ['physics', 'mathematics', 'science', 'english', 'hindi', 'evs', 'chemistry', 'biology'];
      final possiblePaths = <String>[];

      // Generate paths for each subject directory
      for (final subject in subjectDirs) {
        possiblePaths.addAll([
          'assets/data/quizzes/$subject/$entityId.json',          // Direct match
          'assets/data/quizzes/$subject/subject_$entityId.json',  // Subject-level
          'assets/data/quizzes/$subject/chapter_$entityId.json',  // Chapter-level
          'assets/data/quizzes/$subject/topic_$entityId.json',    // Topic-level
        ]);
      }

      // Add legacy/fallback patterns
      possiblePaths.addAll([
        'assets/data/quizzes/${entityId}_quiz.json',            // Legacy: entity_quiz.json
        'assets/data/quizzes/$entityId.json',                   // Simple: entity.json
      ]);

      String? jsonString;
      String? successfulPath;

      for (final path in possiblePaths) {
        try {
          logger.debug('Attempting to load quiz from: $path');
          jsonString = await rootBundle.loadString(path);
          successfulPath = path;
          logger.info('Successfully loaded quiz from: $path');
          break;
        } catch (e) {
          logger.debug('Quiz file not found at: $path');
          continue;
        }
      }

      if (jsonString == null || successfulPath == null) {
        throw AssetNotFoundException(
          message: 'Quiz file not found for entity',
          assetPath: possiblePaths.join(', '),
          details: 'Tried multiple paths but none were found',
        );
      }

      // Parse JSON
      final jsonData = json.decode(jsonString) as Map<String, dynamic>;

      // Parse quiz
      final quizJson = jsonData['quiz'] as Map<String, dynamic>;
      final quiz = QuizModel.fromJson(quizJson);

      // Parse questions
      final questionsJson = jsonData['questions'] as List<dynamic>;
      final questions = questionsJson
          .map((q) => QuestionModel.fromJson(q as Map<String, dynamic>))
          .toList();

      // Validate that quiz question IDs match the actual questions
      final questionIds = questions.map((q) => q.id).toSet();
      final quizQuestionIds = (json.decode(quiz.questionIds) as List)
          .map((e) => e.toString())
          .toList();
      final missingIds = quizQuestionIds
          .where((id) => !questionIds.contains(id))
          .toList();

      if (missingIds.isNotEmpty) {
        logger.warning(
          'Quiz ${quiz.id} references missing question IDs: $missingIds',
        );
      }

      // Cache the results
      final quizData = (quiz: quiz, questions: questions);
      _entityQuizCache[entityId] = quizData;
      _quizzesCache[quiz.id] = quiz;
      for (final question in questions) {
        _questionsCache[question.id] = question;
      }

      logger.info(
        'Loaded quiz: ${quiz.id} with ${questions.length} questions',
      );

      return quizData;
    } catch (e, stackTrace) {
      logger.error('Failed to load quiz for entity: $entityId', e, stackTrace);

      // Re-throw AssetNotFoundException if it was already thrown
      if (e is AssetNotFoundException) {
        rethrow;
      }

      if (e is FlutterError && e.toString().contains('Unable to load asset')) {
        throw AssetNotFoundException(
          message: 'Quiz file not found for entity',
          assetPath: 'assets/data/quizzes/[multiple paths attempted]',
          details: e,
        );
      }

      throw JsonParseException(
        message: 'Failed to parse quiz JSON: ${e.toString()}',
        filePath: 'assets/data/quizzes/$entityId',
        details: e,
      );
    }
  }

  /// Load a specific quiz by its ID
  ///
  /// This is useful when you know the quiz ID but not necessarily the entity ID.
  /// However, since quiz files are organized by entity ID, this method will
  /// search through cached quizzes first. If not found, you should use
  /// [loadQuizByEntityId] instead.
  QuizModel? getQuizById(String quizId) {
    logger.debug('Getting quiz from cache: $quizId');
    return _quizzesCache[quizId];
  }

  /// Get a specific question by its ID
  ///
  /// Returns the question from cache if it has been loaded previously.
  /// Returns null if the question hasn't been loaded yet.
  QuestionModel? getQuestionById(String questionId) {
    logger.debug('Getting question from cache: $questionId');
    return _questionsCache[questionId];
  }

  /// Get multiple questions by their IDs
  ///
  /// Returns a list of questions for the given IDs. Only returns questions
  /// that are currently in the cache. Returns an empty list if none are found.
  List<QuestionModel> getQuestionsByIds(List<String> questionIds) {
    logger.debug('Getting ${questionIds.length} questions from cache');
    return questionIds
        .map((id) => _questionsCache[id])
        .whereType<QuestionModel>()
        .toList();
  }

  /// Load all available quizzes
  ///
  /// This method scans the assets/data/quizzes directory for all quiz files
  /// and loads them. This is useful for pre-caching or displaying a list of
  /// available quizzes.
  ///
  /// Note: Due to Flutter asset loading limitations, this requires the entity
  /// IDs to be known in advance or registered in a manifest file.
  Future<List<QuizModel>> loadAllQuizzes() async {
    try {
      logger.info('Loading all quizzes from manifest');

      // Load quiz manifest file if it exists
      try {
        final manifestPath = 'assets/data/quizzes/manifest.json';
        final manifestString = await rootBundle.loadString(manifestPath);
        final manifestData = json.decode(manifestString) as Map<String, dynamic>;
        final entityIds = (manifestData['quizzes'] as List<dynamic>)
            .map((e) => e.toString())
            .toList();

        logger.info('Found ${entityIds.length} quizzes in manifest');

        // Load each quiz
        final quizzes = <QuizModel>[];
        for (final entityId in entityIds) {
          try {
            final quizData = await loadQuizByEntityId(entityId);
            quizzes.add(quizData.quiz);
          } catch (e) {
            logger.warning('Failed to load quiz for entity $entityId: $e');
          }
        }

        return quizzes;
      } catch (e) {
        logger.warning(
          'Manifest file not found or invalid, returning cached quizzes',
        );
        return _quizzesCache.values.toList();
      }
    } catch (e, stackTrace) {
      logger.error('Failed to load all quizzes', e, stackTrace);
      throw JsonParseException(
        message: 'Failed to load quiz list: ${e.toString()}',
        filePath: 'assets/data/quizzes/manifest.json',
        details: e,
      );
    }
  }

  /// Clear all caches
  ///
  /// This removes all cached quiz and question data from memory.
  /// The next access will reload from assets.
  void clearCache() {
    logger.info('Clearing quiz JSON data source cache');
    _quizzesCache.clear();
    _questionsCache.clear();
    _entityQuizCache.clear();
  }

  /// Clear cache for a specific entity
  ///
  /// This removes the quiz data associated with a particular entity ID.
  void clearEntityCache(String entityId) {
    logger.debug('Clearing cache for entity: $entityId');
    final quizData = _entityQuizCache.remove(entityId);
    if (quizData != null) {
      _quizzesCache.remove(quizData.quiz.id);
      for (final question in quizData.questions) {
        _questionsCache.remove(question.id);
      }
    }
  }

  /// Get cache statistics
  ///
  /// Returns information about the current cache state.
  /// Useful for debugging and monitoring.
  Map<String, int> getCacheStats() {
    return {
      'quizzes': _quizzesCache.length,
      'questions': _questionsCache.length,
      'entities': _entityQuizCache.length,
    };
  }

  /// Check if a quiz is cached for an entity
  ///
  /// Returns true if the quiz data for the given entity ID is in cache.
  bool isEntityCached(String entityId) {
    return _entityQuizCache.containsKey(entityId);
  }

  /// Pre-load quiz data for an entity
  ///
  /// Loads and caches quiz data for later use. This is useful for
  /// pre-fetching quiz data before the user starts the quiz.
  /// Returns true if successful, false if the quiz doesn't exist.
  Future<bool> preloadQuiz(String entityId) async {
    try {
      await loadQuizByEntityId(entityId);
      return true;
    } catch (e) {
      logger.warning('Failed to preload quiz for entity $entityId: $e');
      return false;
    }
  }

  /// Pre-load multiple quizzes
  ///
  /// Loads multiple quiz files in parallel for better performance.
  /// Returns a map of entity ID to success status.
  Future<Map<String, bool>> preloadQuizzes(List<String> entityIds) async {
    logger.info('Preloading ${entityIds.length} quizzes');

    final results = <String, bool>{};
    await Future.wait(
      entityIds.map((entityId) async {
        results[entityId] = await preloadQuiz(entityId);
      }),
    );

    final successCount = results.values.where((v) => v).length;
    logger.info('Preloaded $successCount/${entityIds.length} quizzes');

    return results;
  }
}

