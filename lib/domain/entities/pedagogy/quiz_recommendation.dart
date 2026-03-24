/// Quiz recommendation entities that bridge quiz results with pedagogy system
library;

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:streamshaala/core/models/assessment_type.dart';
import 'package:streamshaala/domain/entities/pedagogy/concept_gap.dart';
import 'package:streamshaala/domain/entities/content/video.dart';

part 'quiz_recommendation.freezed.dart';
part 'quiz_recommendation.g.dart';

/// Represents a single recommendation to fix a knowledge gap identified in a quiz.
///
/// Combines a [ConceptGap] with concrete [Video] recommendations and metadata
/// to help users understand what to learn next.
@freezed
class QuizRecommendation with _$QuizRecommendation {
  const factory QuizRecommendation({
    /// The knowledge gap this recommendation addresses
    required ConceptGap gap,

    /// Videos recommended to fix this gap (ordered by relevance)
    required List<Video> recommendedVideos,

    /// The topic/subject this gap belongs to (for grouping)
    required String topicName,

    /// Estimated time to fix this gap by watching recommended videos (minutes)
    required int estimatedFixMinutes,

    /// Whether user has dismissed this recommendation
    @Default(false) bool dismissed,

    /// Whether user has acted on this recommendation (started path or browsed videos)
    @Default(false) bool acted,

    /// When this recommendation was generated
    required DateTime generatedAt,
  }) = _QuizRecommendation;

  const QuizRecommendation._();

  factory QuizRecommendation.fromJson(Map<String, dynamic> json) =>
      _$QuizRecommendationFromJson(json);

  /// Get the primary (most relevant) video recommendation
  Video? get primaryVideo =>
      recommendedVideos.isNotEmpty ? recommendedVideos.first : null;

  /// Get formatted time estimate (e.g., "15 min", "1h 20m")
  String get formattedTimeEstimate {
    if (estimatedFixMinutes < 60) {
      return '$estimatedFixMinutes min';
    } else {
      final hours = estimatedFixMinutes ~/ 60;
      final minutes = estimatedFixMinutes % 60;
      if (minutes == 0) {
        return '${hours}h';
      }
      return '${hours}h ${minutes}m';
    }
  }

  /// Check if this is a high-priority recommendation (critical or severe gap)
  bool get isHighPriority =>
      gap.severity == GapSeverity.critical ||
      gap.severity == GapSeverity.severe;

  /// Check if this recommendation has videos available
  bool get hasVideos => recommendedVideos.isNotEmpty;

  /// Get number of recommended videos
  int get videoCount => recommendedVideos.length;

  /// Get concept mastery percentage (0-100)
  double get masteryPercentage => gap.currentMastery;

  /// Get severity level for UI display
  GapSeverity get severity => gap.severity;

  /// Get priority score for sorting
  int get priorityScore => gap.priorityScore;

  /// Get concept name for display
  String get conceptName => gap.conceptName;

  /// Get blocking impact (how many concepts this blocks)
  int get blockingImpact => gap.blockedConcepts.length;

  /// Get text explaining why this matters
  String get whyItMatters {
    if (blockingImpact >= 5) {
      return 'This concept blocks $blockingImpact other topics. Master it first!';
    } else if (blockingImpact >= 3) {
      return 'Understanding this unlocks $blockingImpact more topics';
    } else if (blockingImpact > 0) {
      return 'Needed for $blockingImpact related concepts';
    } else {
      return 'Important foundational concept';
    }
  }
}

/// Collection of recommendations generated from a quiz result.
///
/// Provides helpers for displaying and navigating recommendations in the UI.
@freezed
class RecommendationsBundle with _$RecommendationsBundle {
  const factory RecommendationsBundle({
    /// ID of the quiz result these recommendations are for
    required String quizResultId,

    /// Type of assessment (readiness or knowledge)
    required AssessmentType assessmentType,

    /// All recommendations sorted by priority (highest first)
    required List<QuizRecommendation> recommendations,

    /// When these recommendations were generated
    required DateTime generatedAt,

    /// Total estimated time to fix all gaps (minutes)
    required int totalEstimatedMinutes,

    /// Subject name for context
    String? subjectName,

    /// Quiz score percentage for display
    double? quizScore,
  }) = _RecommendationsBundle;

  const RecommendationsBundle._();

  factory RecommendationsBundle.fromJson(Map<String, dynamic> json) =>
      _$RecommendationsBundleFromJson(json);

  /// Get top 3 recommendations for preview
  List<QuizRecommendation> get top3 => recommendations.take(3).toList();

  /// Get critical recommendations only
  List<QuizRecommendation> get criticalRecommendations =>
      recommendations
          .where((r) => r.gap.severity == GapSeverity.critical)
          .toList();

  /// Get severe recommendations only
  List<QuizRecommendation> get severeRecommendations =>
      recommendations
          .where((r) => r.gap.severity == GapSeverity.severe)
          .toList();

  /// Get moderate recommendations only
  List<QuizRecommendation> get moderateRecommendations =>
      recommendations
          .where((r) => r.gap.severity == GapSeverity.moderate)
          .toList();

  /// Get mild recommendations only
  List<QuizRecommendation> get mildRecommendations =>
      recommendations.where((r) => r.gap.severity == GapSeverity.mild).toList();

  /// Count of critical gaps
  int get criticalCount => criticalRecommendations.length;

  /// Count of severe gaps
  int get severeCount => severeRecommendations.length;

  /// Count of moderate gaps
  int get moderateCount => moderateRecommendations.length;

  /// Count of mild gaps
  int get mildCount => mildRecommendations.length;

  /// Total number of recommendations
  int get totalCount => recommendations.length;

  /// Check if there are any recommendations
  bool get hasRecommendations => recommendations.isNotEmpty;

  /// Check if there are no recommendations (perfect score)
  bool get isEmpty => recommendations.isEmpty;

  /// Get formatted total time estimate
  String get formattedTotalTime {
    if (totalEstimatedMinutes < 60) {
      return '$totalEstimatedMinutes min';
    } else {
      final hours = totalEstimatedMinutes ~/ 60;
      final minutes = totalEstimatedMinutes % 60;
      if (minutes == 0) {
        return '${hours}h';
      }
      return '${hours}h ${minutes}m';
    }
  }

  /// Get all recommended videos (no duplicates)
  List<Video> get allRecommendedVideos {
    final videoIds = <String>{};
    final videos = <Video>[];

    for (final recommendation in recommendations) {
      for (final video in recommendation.recommendedVideos) {
        if (!videoIds.contains(video.id)) {
          videoIds.add(video.id);
          videos.add(video);
        }
      }
    }

    return videos;
  }

  /// Get title for UI based on assessment type
  String get title {
    switch (assessmentType) {
      case AssessmentType.readiness:
        return 'Your Learning Path';
      case AssessmentType.knowledge:
        return 'Areas to Review';
      case AssessmentType.practice:
        return 'Practice Recommendations';
    }
  }

  /// Get subtitle for UI based on assessment type and score
  String get subtitle {
    switch (assessmentType) {
      case AssessmentType.readiness:
        if (isEmpty) {
          return 'Great foundation! You\'re ready to advance.';
        } else if (criticalCount > 0) {
          return 'We\'ve identified your learning priorities';
        } else {
          return 'Strengthen these concepts to accelerate your progress';
        }
      case AssessmentType.knowledge:
        if (isEmpty) {
          return 'Perfect! You\'ve mastered this material.';
        } else {
          return 'Review these areas to improve your understanding';
        }
      case AssessmentType.practice:
        if (isEmpty) {
          return 'Excellent! No recommendations needed.';
        } else {
          return 'Here are some areas you can practice more';
        }
    }
  }

  /// Get instructions text for recommendations screen
  String get instructions {
    switch (assessmentType) {
      case AssessmentType.readiness:
        return 'Based on your assessment, we recommend focusing on these concepts first. '
            'They\'re foundational and will help you understand more advanced topics.';
      case AssessmentType.knowledge:
        return 'These are the areas where you can improve. '
            'Review the recommended videos to strengthen your understanding.';
      case AssessmentType.practice:
        return 'Here are some concepts you can practice more. '
            'Review these videos to strengthen your skills.';
    }
  }

  /// Get primary action button text
  String get primaryActionText {
    switch (assessmentType) {
      case AssessmentType.readiness:
        return 'Start Your Journey';
      case AssessmentType.knowledge:
        return 'Continue Improving';
      case AssessmentType.practice:
        return 'Practice More';
    }
  }

  /// Get secondary action button text
  String get secondaryActionText => 'Browse Videos';

  /// Get encouragement message based on gaps
  String get encouragementMessage {
    if (isEmpty) {
      return 'Outstanding! You have no knowledge gaps in this area.';
    }

    switch (assessmentType) {
      case AssessmentType.readiness:
        if (criticalCount > 0) {
          return 'Don\'t worry! Everyone starts somewhere. '
              'We\'ll guide you step-by-step through these concepts.';
        } else if (severeCount > 0) {
          return 'You have a decent foundation. '
              'Let\'s strengthen these key concepts to accelerate your learning.';
        } else {
          return 'You\'re almost there! '
              'Just a few concepts to review and you\'ll be ready to advance.';
        }
      case AssessmentType.knowledge:
        if (criticalCount > 0) {
          return 'These topics need more attention. '
              'Review the material and practice more.';
        } else {
          return 'You\'re doing well! '
              'A bit more review will help solidify your understanding.';
        }
      case AssessmentType.practice:
        if (criticalCount > 0) {
          return 'These are important concepts. '
              'Practice with these videos to improve your understanding.';
        } else {
          return 'Good work! '
              'A little more practice will help you master these concepts.';
        }
    }
  }
}
