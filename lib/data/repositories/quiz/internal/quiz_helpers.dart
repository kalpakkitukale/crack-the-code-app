/// Shared helper utilities for quiz operations
library;

import 'dart:convert';
import 'dart:math';

import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/domain/entities/quiz/question.dart';
import 'package:streamshaala/domain/entities/quiz/quiz.dart';
import 'package:streamshaala/domain/entities/quiz/quiz_result.dart';
import 'package:streamshaala/domain/entities/quiz/quiz_session.dart';

/// Cryptographically secure random for security-sensitive operations
final secureRandom = Random.secure();

/// Analyze concept performance across all questions in a session
Map<String, ConceptScore> analyzeConceptPerformance(QuizSession session) {
  final conceptScores = <String, ConceptScore>{};

  logger.debug(
      '📊 Analyzing ${session.questions.length} questions for concepts...');
  int questionsWithConcepts = 0;
  int questionsWithoutConcepts = 0;

  for (final question in session.questions) {
    final answer = session.answers[question.id];
    final isCorrect = answer != null && question.isCorrect(answer);

    if (question.conceptTags.isEmpty) {
      questionsWithoutConcepts++;
      logger.warning('⚠️ Question ${question.id} has NO concept tags!');
    } else {
      questionsWithConcepts++;
      logger.debug(
          '   Question ${question.id}: ${question.conceptTags.length} concepts: ${question.conceptTags}');
    }

    for (final concept in question.conceptTags) {
      if (conceptScores.containsKey(concept)) {
        final existing = conceptScores[concept]!;
        conceptScores[concept] = ConceptScore(
          concept: concept,
          total: existing.total + 1,
          correct: existing.correct + (isCorrect ? 1 : 0),
        );
      } else {
        conceptScores[concept] = ConceptScore(
          concept: concept,
          total: 1,
          correct: isCorrect ? 1 : 0,
        );
      }
    }
  }

  logger.info(
      '📊 Questions with concepts: $questionsWithConcepts, without concepts: $questionsWithoutConcepts');
  logger.info('📊 Total unique concepts found: ${conceptScores.length}');

  return conceptScores;
}

/// Identify weak areas (< 60% accuracy)
List<String> identifyWeakAreas(Map<String, ConceptScore> conceptAnalysis) {
  return conceptAnalysis.entries
      .where((e) => e.value.percentage < 60.0)
      .map((e) => e.key)
      .toList();
}

/// Identify strong areas (>= 80% accuracy)
List<String> identifyStrongAreas(Map<String, ConceptScore> conceptAnalysis) {
  return conceptAnalysis.entries
      .where((e) => e.value.percentage >= 80.0)
      .map((e) => e.key)
      .toList();
}

/// Generate recommendation based on performance
String generateRecommendation(bool passed, List<String> weakAreas) {
  if (passed && weakAreas.isEmpty) {
    return 'Excellent work! You have a strong understanding of all concepts.';
  } else if (passed && weakAreas.isNotEmpty) {
    return 'Good job passing! Focus on improving: ${weakAreas.join(", ")}';
  } else if (weakAreas.isNotEmpty) {
    return 'Review these concepts: ${weakAreas.join(", ")}. Then try the quiz again.';
  } else {
    return 'Keep practicing and review the material. You can retake this quiz anytime.';
  }
}

/// Select questions for a specific quiz level
List<Question> selectQuestionsForLevel({
  required List<Question> allQuestions,
  required QuizLevel quizLevel,
  required String entityId,
}) {
  // Determine target question count based on quiz level
  final int targetCount;
  switch (quizLevel) {
    case QuizLevel.video:
      targetCount = 5; // Video quizzes: 5 questions
      break;
    case QuizLevel.topic:
      targetCount = 10; // Topic quizzes: 10 questions
      break;
    case QuizLevel.chapter:
      targetCount = 20; // Chapter quizzes: 20 questions
      break;
    case QuizLevel.subject:
      targetCount = 25; // Subject quizzes: 25 questions
      break;
  }

  // Simply select random questions from the available pool
  return randomSelect(allQuestions, targetCount);
}

/// Select 5-6 random questions from a specific topic
List<Question> selectTopicQuestions(
    List<Question> allQuestions, String topicId) {
  // Filter questions that belong to this topic
  var topicQuestions =
      allQuestions.where((q) => q.topicIds.contains(topicId)).toList();

  // FALLBACK: If no questions match the topic filter, use all available questions
  if (topicQuestions.isEmpty) {
    logger.warning(
        'No questions found for topic: $topicId. Using all ${allQuestions.length} questions.');
    topicQuestions = allQuestions;
  }

  // Select 5-6 random questions
  final targetCount = 5 + secureRandom.nextInt(2); // 5 or 6
  return randomSelect(topicQuestions, targetCount);
}

/// Select 10-15 random questions from a chapter's topics
List<Question> selectChapterQuestions(
    List<Question> allQuestions, String chapterId) {
  // Get topics for this chapter
  final chapterTopics = getTopicsForChapter(chapterId);

  // Filter questions that belong to any of the chapter's topics
  var chapterQuestions = allQuestions
      .where((q) => q.topicIds.any((topicId) => chapterTopics.contains(topicId)))
      .toList();

  // FALLBACK: If no questions match the topic filter, use all available questions
  if (chapterQuestions.isEmpty) {
    logger.warning(
        'No questions found for chapter topics: $chapterTopics. Using all ${allQuestions.length} questions.');
    chapterQuestions = allQuestions;
  }

  // Select 10-15 random questions
  final targetCount = 10 + secureRandom.nextInt(6); // 10-15
  return randomSelect(chapterQuestions, targetCount);
}

/// Select 20-25 random questions from all topics (subject quiz)
List<Question> selectSubjectQuestions(List<Question> allQuestions) {
  // Select 20-25 random questions from all available
  final targetCount = 20 + secureRandom.nextInt(6); // 20-25
  return randomSelect(allQuestions, targetCount);
}

/// Randomly select a specified number of questions from a list
List<Question> randomSelect(List<Question> questions, int count) {
  if (questions.length <= count) {
    // If we have fewer questions than requested, return all (shuffled)
    final shuffled = List<Question>.from(questions);
    shuffled.shuffle(secureRandom);
    return shuffled;
  }

  // Create a shuffled copy and take the first 'count' items
  final shuffled = List<Question>.from(questions);
  shuffled.shuffle(secureRandom);
  return shuffled.take(count).toList();
}

/// Get topics for a chapter (hardcoded mapping)
/// TODO: Move this to configuration or database
List<String> getTopicsForChapter(String chapterId) {
  // Hardcoded chapter-topic mapping based on Physics data
  const chapterTopicMap = {
    'chapter_laws_of_motion': [
      'topic_newtons_first_law',
      'topic_newtons_second_law',
      'topic_newtons_third_law',
    ],
    'chapter_mechanics': [
      'topic_newtons_first_law',
      'topic_newtons_second_law',
      'topic_newtons_third_law',
      'topic_work_and_energy',
      'topic_kinematics',
      'topic_gravitation',
    ],
    // Electric Charges and Fields chapter
    'ch1_electric_charges': [
      'topic_1_1', // Introduction to Electric Charges
      'topic_1_2', // Coulomb's Law
      'topic_1_3', // Electric Field and Field Lines
      'topic_1_4', // Electric Flux and Gauss's Law
    ],
  };

  return chapterTopicMap[chapterId] ?? [];
}

/// Extract quiz metadata from entityId and title
///
/// Parses quiz information to extract meaningful breadcrumb data.
///
/// Returns a map with subjectId, subjectName, chapterId, chapterName,
/// topicId, topicName, videoTitle
Future<Map<String, String?>> extractQuizMetadata({
  String? entityId,
  QuizLevel? quizLevel,
  String? quizTitle,
}) async {
  logger.info('🔍 extractQuizMetadata called with:');
  logger.info('  entityId: $entityId');
  logger.info('  quizLevel: $quizLevel');
  logger.info('  quizTitle: $quizTitle');

  final metadata = <String, String?>{
    'subjectId': null,
    'subjectName': null,
    'chapterId': null,
    'chapterName': null,
    'topicId': null,
    'topicName': null,
    'videoTitle': null,
  };

  if (quizLevel == null) {
    logger.warning('Missing quizLevel for metadata extraction');
    return metadata;
  }

  // Parse the quiz title to extract the name part (before " - ")
  String? extractedName;
  if (quizTitle != null) {
    final titleParts = quizTitle.split(' - ');
    extractedName = titleParts.isNotEmpty ? titleParts[0].trim() : quizTitle;
  }

  // If no title, try to extract name from entityId
  if (extractedName == null && entityId != null) {
    String cleanedId = entityId;
    cleanedId = cleanedId.replaceFirst(RegExp(r'^(ch|topic|video)[\d_]+'), '');
    cleanedId = cleanedId.replaceAll('_', ' ');
    extractedName = cleanedId
        .split(' ')
        .map((word) {
          if (word.isEmpty) return '';
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ')
        .trim();

    if (extractedName.isEmpty) {
      extractedName = null;
    }
  }

  // Infer subject name from entityId
  String? subjectName;
  if (entityId != null) {
    if (entityId.toLowerCase().contains('physic')) {
      subjectName = 'Physics';
      metadata['subjectId'] = 'physics';
    } else if (entityId.toLowerCase().contains('math')) {
      subjectName = 'Mathematics';
      metadata['subjectId'] = 'math';
    } else if (entityId.toLowerCase().contains('chem')) {
      subjectName = 'Chemistry';
      metadata['subjectId'] = 'chemistry';
    } else if (entityId.toLowerCase().contains('bio')) {
      subjectName = 'Biology';
      metadata['subjectId'] = 'biology';
    }
  }

  // Extract metadata based on quiz level
  switch (quizLevel) {
    case QuizLevel.subject:
      metadata['subjectName'] = extractedName;
      metadata['subjectId'] = entityId;
      break;

    case QuizLevel.chapter:
      metadata['chapterName'] = extractedName ?? 'Chapter';
      metadata['chapterId'] = entityId;
      metadata['subjectName'] = subjectName ?? 'Physics';
      break;

    case QuizLevel.topic:
      metadata['topicName'] = extractedName;
      metadata['topicId'] = entityId;

      if (entityId != null && entityId.contains('_')) {
        final parts = entityId.split('_');
        if (parts.length >= 2) {
          final chapterNum = parts[1];
          metadata['chapterName'] = 'Ch$chapterNum';
          metadata['chapterId'] = 'ch$chapterNum';
        }
      }

      metadata['subjectName'] = subjectName ?? 'Physics';
      break;

    case QuizLevel.video:
      metadata['videoTitle'] = extractedName;
      metadata['topicName'] = extractedName;
      metadata['topicId'] = entityId;
      metadata['subjectName'] = subjectName ?? 'Physics';
      break;
  }

  logger.info('✅ Extracted metadata:');
  logger.info('  subjectId: ${metadata['subjectId']}');
  logger.info('  subjectName: ${metadata['subjectName']}');
  logger.info('  chapterId: ${metadata['chapterId']}');
  logger.info('  chapterName: ${metadata['chapterName']}');
  logger.info('  topicId: ${metadata['topicId']}');
  logger.info('  topicName: ${metadata['topicName']}');
  logger.info('  videoTitle: ${metadata['videoTitle']}');

  return metadata;
}

/// Format a name component from entityId
String formatName(String component) {
  // Common subject name mappings
  final subjectMap = {
    'math': 'Mathematics',
    'physics': 'Physics',
    'chemistry': 'Chemistry',
    'biology': 'Biology',
    'english': 'English',
    'hindi': 'Hindi',
    'history': 'History',
    'geography': 'Geography',
    'civics': 'Civics',
    'economics': 'Economics',
    'science': 'Science',
  };

  // Check if it's a known subject
  if (subjectMap.containsKey(component.toLowerCase())) {
    return subjectMap[component.toLowerCase()]!;
  }

  // Otherwise, capitalize first letter and replace underscores with spaces
  return component
      .split('_')
      .map((word) =>
          word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1).toLowerCase())
      .join(' ');
}

/// Extract subject name from quiz title
/// Quiz titles are in format like: "Introduction to Electric Charges - Topic Quiz"
String extractSubjectNameFromTitle(String title) {
  final cleanTitle = title
      .replaceAll(
          RegExp(r'\s*-\s*(Topic|Chapter|Subject|Video)\s+Quiz\s*$'), '')
      .trim();

  return cleanTitle.isNotEmpty ? cleanTitle : title;
}

/// Generate daily challenge seed based on current date
int getDailyChallengeSeeds() {
  final now = DateTime.now();
  final dateString = '${now.year}-${now.month}-${now.day}-streamshaala-daily';
  final hashBytes = utf8.encode(dateString);
  final hash = hashBytes.fold<int>(0, (prev, byte) => prev * 31 + byte);
  return hash.abs();
}
