/// Quiz generation service for intelligent question selection
library;

import 'package:streamshaala/domain/entities/quiz/question.dart';
import 'package:streamshaala/domain/entities/quiz/quiz.dart';

/// Configuration for question difficulty distribution
class DifficultyDistribution {
  final double basicPercentage;
  final double intermediatePercentage;
  final double advancedPercentage;

  const DifficultyDistribution({
    required this.basicPercentage,
    required this.intermediatePercentage,
    required this.advancedPercentage,
  });

  /// Default distribution: 40% basic, 40% intermediate, 20% advanced
  static const DifficultyDistribution defaultDistribution = DifficultyDistribution(
    basicPercentage: 0.4,
    intermediatePercentage: 0.4,
    advancedPercentage: 0.2,
  );

  /// Validate distribution sums to 1.0
  bool get isValid =>
      (basicPercentage + intermediatePercentage + advancedPercentage - 1.0).abs() < 0.001;
}

/// Parameters for quiz generation
class QuizGenerationParams {
  final QuizLevel level;
  final String entityId;
  final List<String>? topicIds; // For chapter/subject level quizzes
  final DifficultyDistribution distribution;
  final int? customQuestionCount;

  const QuizGenerationParams({
    required this.level,
    required this.entityId,
    this.topicIds,
    this.distribution = DifficultyDistribution.defaultDistribution,
    this.customQuestionCount,
  });

  /// Get expected question count for the quiz level
  int get questionCount {
    if (customQuestionCount != null) return customQuestionCount!;

    switch (level) {
      case QuizLevel.video:
        return 5;
      case QuizLevel.topic:
        return 10;
      case QuizLevel.chapter:
        return 20;
      case QuizLevel.subject:
        return 50;
    }
  }

  /// Get expected counts for each difficulty level
  Map<String, int> get difficultyCounts {
    final total = questionCount;
    return {
      'basic': (total * distribution.basicPercentage).round(),
      'intermediate': (total * distribution.intermediatePercentage).round(),
      'advanced': (total * distribution.advancedPercentage).round(),
    };
  }
}

/// Result of quiz generation
class QuizGenerationResult {
  final List<String> selectedQuestionIds;
  final Map<String, int> actualDifficultyCounts;
  final bool hasInsufficientQuestions;
  final String? warning;

  const QuizGenerationResult({
    required this.selectedQuestionIds,
    required this.actualDifficultyCounts,
    this.hasInsufficientQuestions = false,
    this.warning,
  });
}

/// Service for generating quizzes with intelligent question selection
abstract class QuizGenerationService {
  /// Generate a quiz by selecting questions based on parameters
  ///
  /// This method intelligently selects questions from the available pool
  /// following the difficulty distribution and ensuring variety.
  ///
  /// For hierarchical quizzes (chapter/subject level):
  /// - If topicIds are provided, questions are pulled from those topics
  /// - Questions are distributed evenly across topics when possible
  /// - Difficulty distribution is maintained across all selected questions
  ///
  /// Returns a [QuizGenerationResult] with selected question IDs and metadata
  Future<QuizGenerationResult> generateQuiz({
    required QuizGenerationParams params,
    required List<Question> availableQuestions,
  });

  /// Filter questions by topic IDs
  ///
  /// Returns questions that belong to any of the specified topics
  List<Question> filterByTopics(
    List<Question> questions,
    List<String> topicIds,
  ) {
    return questions.where((q) {
      return q.topicIds.any((topicId) => topicIds.contains(topicId));
    }).toList();
  }

  /// Group questions by difficulty level
  Map<String, List<Question>> groupByDifficulty(List<Question> questions) {
    final Map<String, List<Question>> grouped = {
      'basic': [],
      'intermediate': [],
      'advanced': [],
    };

    for (final question in questions) {
      final difficulty = question.difficulty.toLowerCase();
      if (grouped.containsKey(difficulty)) {
        grouped[difficulty]!.add(question);
      }
    }

    return grouped;
  }

  /// Select questions from a pool with randomization
  ///
  /// Ensures variety by shuffling and selecting the requested count
  List<Question> selectRandomQuestions(
    List<Question> pool,
    int count,
  ) {
    final shuffled = List<Question>.from(pool)..shuffle();
    return shuffled.take(count).toList();
  }
}

/// Default implementation of QuizGenerationService
class DefaultQuizGenerationService implements QuizGenerationService {
  const DefaultQuizGenerationService();

  @override
  Future<QuizGenerationResult> generateQuiz({
    required QuizGenerationParams params,
    required List<Question> availableQuestions,
  }) async {
    // Validate distribution
    if (!params.distribution.isValid) {
      throw ArgumentError('Difficulty distribution must sum to 1.0');
    }

    // Filter questions by topics if specified
    List<Question> candidateQuestions = availableQuestions;
    if (params.topicIds != null && params.topicIds!.isNotEmpty) {
      candidateQuestions = filterByTopics(availableQuestions, params.topicIds!);
    }

    // Group questions by difficulty
    final grouped = groupByDifficulty(candidateQuestions);

    // Get target counts for each difficulty
    final targetCounts = params.difficultyCounts;

    // Select questions for each difficulty level
    final selectedQuestions = <Question>[];
    final actualCounts = <String, int>{
      'basic': 0,
      'intermediate': 0,
      'advanced': 0,
    };

    // Select basic questions
    final basicCount = targetCounts['basic']!;
    final basicPool = grouped['basic']!;
    if (basicPool.length >= basicCount) {
      final selected = selectRandomQuestions(basicPool, basicCount);
      selectedQuestions.addAll(selected);
      actualCounts['basic'] = selected.length;
    } else {
      selectedQuestions.addAll(basicPool);
      actualCounts['basic'] = basicPool.length;
    }

    // Select intermediate questions
    final intermediateCount = targetCounts['intermediate']!;
    final intermediatePool = grouped['intermediate']!;
    if (intermediatePool.length >= intermediateCount) {
      final selected = selectRandomQuestions(intermediatePool, intermediateCount);
      selectedQuestions.addAll(selected);
      actualCounts['intermediate'] = selected.length;
    } else {
      selectedQuestions.addAll(intermediatePool);
      actualCounts['intermediate'] = intermediatePool.length;
    }

    // Select advanced questions
    final advancedCount = targetCounts['advanced']!;
    final advancedPool = grouped['advanced']!;
    if (advancedPool.length >= advancedCount) {
      final selected = selectRandomQuestions(advancedPool, advancedCount);
      selectedQuestions.addAll(selected);
      actualCounts['advanced'] = selected.length;
    } else {
      selectedQuestions.addAll(advancedPool);
      actualCounts['advanced'] = advancedPool.length;
    }

    // Check if we have enough questions
    final hasInsufficient = selectedQuestions.length < params.questionCount;
    String? warning;

    if (hasInsufficient) {
      final deficit = params.questionCount - selectedQuestions.length;
      warning = 'Insufficient questions: needed ${params.questionCount}, found ${selectedQuestions.length}. '
                'Missing $deficit questions.';

      // Try to fill the gap with questions from other difficulties
      final remaining = params.questionCount - selectedQuestions.length;
      if (remaining > 0) {
        final allAvailable = [
          ...basicPool.where((q) => !selectedQuestions.contains(q)),
          ...intermediatePool.where((q) => !selectedQuestions.contains(q)),
          ...advancedPool.where((q) => !selectedQuestions.contains(q)),
        ];

        if (allAvailable.isNotEmpty) {
          final additional = selectRandomQuestions(allAvailable, remaining);
          selectedQuestions.addAll(additional);

          // Update actual counts
          for (final q in additional) {
            final diff = q.difficulty.toLowerCase();
            if (actualCounts.containsKey(diff)) {
              actualCounts[diff] = actualCounts[diff]! + 1;
            }
          }

          warning = '$warning Filled with ${additional.length} questions from available pool.';
        }
      }
    }

    // Shuffle final selection for randomness
    final shuffled = List<Question>.from(selectedQuestions)..shuffle();

    return QuizGenerationResult(
      selectedQuestionIds: shuffled.map((q) => q.id).toList(),
      actualDifficultyCounts: actualCounts,
      hasInsufficientQuestions: hasInsufficient,
      warning: warning,
    );
  }

  @override
  List<Question> filterByTopics(
    List<Question> questions,
    List<String> topicIds,
  ) {
    return questions.where((q) {
      return q.topicIds.any((topicId) => topicIds.contains(topicId));
    }).toList();
  }

  @override
  Map<String, List<Question>> groupByDifficulty(List<Question> questions) {
    final Map<String, List<Question>> grouped = {
      'basic': [],
      'intermediate': [],
      'advanced': [],
    };

    for (final question in questions) {
      final difficulty = question.difficulty.toLowerCase();
      if (grouped.containsKey(difficulty)) {
        grouped[difficulty]!.add(question);
      }
    }

    return grouped;
  }

  @override
  List<Question> selectRandomQuestions(
    List<Question> pool,
    int count,
  ) {
    final shuffled = List<Question>.from(pool)..shuffle();
    return shuffled.take(count).toList();
  }
}
