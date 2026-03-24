/// LearningPathGenerator - Creates personalized learning paths based on gaps
library;

import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/data/datasources/json/concept_json_data_source.dart';
import 'package:crack_the_code/domain/entities/pedagogy/concept_gap.dart';
import 'package:crack_the_code/domain/entities/recommendation/learning_path.dart';
import 'package:crack_the_code/domain/services/gap_analysis_service.dart';

/// Generates personalized learning paths based on detected gaps
class LearningPathGenerator {
  final GapAnalysisService _gapService;
  final ConceptJsonDataSource _conceptDataSource;

  LearningPathGenerator({
    required GapAnalysisService gapService,
    required ConceptJsonDataSource conceptDataSource,
  })  : _gapService = gapService,
        _conceptDataSource = conceptDataSource;

  /// Generate foundation path to fix all gaps before target concept
  Future<LearningPath> generateFoundationPath({
    required String studentId,
    required String targetConceptId,
    required List<ConceptGap> gaps,
    String? subjectId,
  }) async {
    try {
      final nodes = <PathNode>[];

      // Sort gaps by: grade level (lowest first), then dependency order
      final sortedGaps = _sortByDependencyOrder(gaps);

      for (int i = 0; i < sortedGaps.length; i++) {
        final gap = sortedGaps[i];

        // For each gap, add nodes:
        // 1. Video node (primary video for concept)
        if (gap.recommendedVideoIds.isNotEmpty) {
          nodes.add(PathNode(
            id: 'node_${gap.conceptId}_video',
            title: gap.conceptName,
            description: 'Watch video to learn ${gap.conceptName}',
            type: PathNodeType.video,
            entityId: gap.recommendedVideoIds.first,
            estimatedDuration: gap.estimatedFixMinutes ~/ 2,
            difficulty: _getDifficultyForGrade(gap.gradeLevel),
            prerequisites: i > 0 ? ['node_${sortedGaps[i - 1].conceptId}_quiz'] : [],
          ));
        }

        // 2. Practice quiz node
        nodes.add(PathNode(
          id: 'node_${gap.conceptId}_practice',
          title: '${gap.conceptName} Practice',
          description: 'Practice questions for ${gap.conceptName}',
          type: PathNodeType.practice,
          entityId: gap.conceptId,
          estimatedDuration: 5,
          difficulty: _getDifficultyForGrade(gap.gradeLevel),
          prerequisites: ['node_${gap.conceptId}_video'],
        ));

        // 3. Mastery quiz node
        nodes.add(PathNode(
          id: 'node_${gap.conceptId}_quiz',
          title: '${gap.conceptName} Mastery Quiz',
          description: 'Verify your understanding of ${gap.conceptName}',
          type: PathNodeType.quiz,
          entityId: gap.conceptId,
          estimatedDuration: 3,
          difficulty: _getDifficultyForGrade(gap.gradeLevel),
          prerequisites: ['node_${gap.conceptId}_practice'],
        ));
      }

      // Add target concept at the end
      final targetConcept = await _conceptDataSource.getConceptById(targetConceptId);
      if (targetConcept != null) {
        final targetVideos = await _conceptDataSource.getVideosForConcept(targetConceptId);
        final lastGapId = sortedGaps.isNotEmpty ? sortedGaps.last.conceptId : null;

        if (targetVideos.isNotEmpty) {
          nodes.add(PathNode(
            id: 'node_target_${targetConceptId}_video',
            title: 'Goal: ${targetConcept.name}',
            description: 'Your target concept - now you\'re ready!',
            type: PathNodeType.video,
            entityId: targetVideos.first.id,
            estimatedDuration: targetConcept.estimatedMinutes,
            difficulty: _getDifficultyForGrade(targetConcept.gradeLevel),
            prerequisites: lastGapId != null ? ['node_${lastGapId}_quiz'] : [],
          ));
        }
      }

      // Calculate total duration
      final totalDuration = nodes.fold<int>(
        0,
        (sum, node) => sum + node.estimatedDuration,
      );

      return LearningPath(
        id: 'path_${studentId}_${targetConceptId}_${DateTime.now().millisecondsSinceEpoch}',
        studentId: studentId,
        subjectId: subjectId ?? '',
        nodes: nodes,
        createdAt: DateTime.now(),
        lastUpdated: DateTime.now(),
        metadata: {
          'title': 'Foundation Path for ${targetConcept?.name ?? 'Target'}',
          'description': 'Fix ${gaps.length} gaps to master your target concept',
          'estimatedDuration': totalDuration,
        },
      );
    } catch (e, stackTrace) {
      logger.error('Failed to generate foundation path', e, stackTrace);
      rethrow;
    }
  }

  /// Generate path from subject gap analysis
  Future<LearningPath> generatePathFromAnalysis({
    required String studentId,
    required String subjectId,
    required String subjectName,
    required int targetGrade,
    required List<ConceptGap> gaps,
  }) async {
    try {
      final sortedGaps = _sortByDependencyOrder(gaps);
      final nodes = <PathNode>[];

      // Group gaps by grade for structured learning
      final gapsByGrade = <int, List<ConceptGap>>{};
      for (final gap in sortedGaps) {
        gapsByGrade.putIfAbsent(gap.gradeLevel, () => []).add(gap);
      }

      final sortedGrades = gapsByGrade.keys.toList()..sort();

      for (final grade in sortedGrades) {
        final gradeGaps = gapsByGrade[grade]!;

        // Add grade revision node (milestone-like)
        nodes.add(PathNode(
          id: 'node_grade_${grade}_start',
          title: 'Class $grade Foundation',
          description: 'Master ${gradeGaps.length} concepts from Class $grade',
          type: PathNodeType.revision,
          entityId: 'grade_$grade',
          estimatedDuration: 0,
          difficulty: _getDifficultyForGrade(grade),
          prerequisites: nodes.isNotEmpty ? [nodes.last.id] : [],
        ));

        for (final gap in gradeGaps) {
          // Video node
          if (gap.recommendedVideoIds.isNotEmpty) {
            nodes.add(PathNode(
              id: 'node_${gap.conceptId}_video',
              title: gap.conceptName,
              description: 'Learn ${gap.conceptName}',
              type: PathNodeType.video,
              entityId: gap.recommendedVideoIds.first,
              estimatedDuration: gap.estimatedFixMinutes ~/ 2,
              difficulty: _getDifficultyForGrade(gap.gradeLevel),
              prerequisites: [nodes.last.id],
            ));
          }

          // Quiz node
          nodes.add(PathNode(
            id: 'node_${gap.conceptId}_quiz',
            title: '${gap.conceptName} Quiz',
            description: 'Test your understanding',
            type: PathNodeType.quiz,
            entityId: gap.conceptId,
            estimatedDuration: 5,
            difficulty: _getDifficultyForGrade(gap.gradeLevel),
            prerequisites: ['node_${gap.conceptId}_video'],
          ));
        }
      }

      // Final assessment node
      nodes.add(PathNode(
        id: 'node_final_assessment',
        title: 'Final Assessment',
        description: 'Prove you\'re ready for Class $targetGrade',
        type: PathNodeType.assessment,
        entityId: 'assessment_$subjectId',
        estimatedDuration: 20,
        difficulty: 'intermediate',
        prerequisites: nodes.isNotEmpty ? [nodes.last.id] : [],
      ));

      final totalDuration = nodes.fold<int>(
        0,
        (sum, node) => sum + node.estimatedDuration,
      );

      return LearningPath(
        id: 'path_${studentId}_${subjectId}_${DateTime.now().millisecondsSinceEpoch}',
        studentId: studentId,
        subjectId: subjectId,
        nodes: nodes,
        createdAt: DateTime.now(),
        lastUpdated: DateTime.now(),
        metadata: {
          'title': '$subjectName Foundation Path',
          'description': 'Get ready for Class $targetGrade $subjectName',
          'estimatedDuration': totalDuration,
        },
      );
    } catch (e, stackTrace) {
      logger.error('Failed to generate path from analysis', e, stackTrace);
      rethrow;
    }
  }

  /// Topological sort of gaps based on prerequisite dependencies
  List<ConceptGap> _sortByDependencyOrder(List<ConceptGap> gaps) {
    // First sort by grade level
    final sorted = List<ConceptGap>.from(gaps)
      ..sort((a, b) {
        // Primary: grade level ascending
        final gradeCompare = a.gradeLevel.compareTo(b.gradeLevel);
        if (gradeCompare != 0) return gradeCompare;

        // Secondary: priority score descending
        return b.priorityScore.compareTo(a.priorityScore);
      });

    // Then apply topological sort for dependency order
    final result = <ConceptGap>[];
    final visited = <String>{};
    final gapMap = {for (var g in sorted) g.conceptId: g};

    void visit(ConceptGap gap) {
      if (visited.contains(gap.conceptId)) return;
      visited.add(gap.conceptId);

      // Visit dependencies first (concepts that this gap depends on)
      // Note: We check if dependent is also a gap
      for (final gapToCheck in sorted) {
        if (gapToCheck.blockedConcepts.contains(gap.conceptId) &&
            !visited.contains(gapToCheck.conceptId)) {
          visit(gapToCheck);
        }
      }

      result.add(gap);
    }

    for (final gap in sorted) {
      visit(gap);
    }

    return result;
  }

  /// Get difficulty string for grade level
  String _getDifficultyForGrade(int gradeLevel) {
    if (gradeLevel <= 4) return 'basic';
    if (gradeLevel <= 7) return 'intermediate';
    return 'advanced';
  }

  /// Generate quick review path for a concept
  Future<LearningPath> generateQuickReviewPath({
    required String studentId,
    required String conceptId,
    required String conceptName,
  }) async {
    final videos = await _conceptDataSource.getVideosForConcept(conceptId);

    final nodes = <PathNode>[
      if (videos.isNotEmpty)
        PathNode(
          id: 'node_${conceptId}_review_video',
          title: 'Review: $conceptName',
          description: 'Quick video review',
          type: PathNodeType.video,
          entityId: videos.first.id,
          estimatedDuration: 10,
          difficulty: 'intermediate',
          prerequisites: [],
        ),
      PathNode(
        id: 'node_${conceptId}_review_practice',
        title: 'Practice: $conceptName',
        description: 'Quick practice questions',
        type: PathNodeType.practice,
        entityId: conceptId,
        estimatedDuration: 5,
        difficulty: 'intermediate',
        prerequisites: videos.isNotEmpty ? ['node_${conceptId}_review_video'] : [],
      ),
    ];

    return LearningPath(
      id: 'review_path_${studentId}_${conceptId}_${DateTime.now().millisecondsSinceEpoch}',
      studentId: studentId,
      subjectId: '',
      nodes: nodes,
      createdAt: DateTime.now(),
      lastUpdated: DateTime.now(),
      metadata: {
        'title': 'Quick Review: $conceptName',
        'description': 'Refresh your understanding',
        'estimatedDuration': 15,
      },
    );
  }
}
