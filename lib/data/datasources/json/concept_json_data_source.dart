/// ConceptJsonDataSource - Loads concept data from JSON assets
library;

import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/domain/entities/pedagogy/concept.dart';
import 'package:crack_the_code/domain/entities/pedagogy/video_checkpoint.dart';

/// Data source for loading concept data from JSON files
class ConceptJsonDataSource {
  static const String _conceptsPath = 'assets/data/pedagogy/concepts.json';
  static const String _videosPath = 'assets/data/pedagogy/videos_by_concept.json';
  static const String _prerequisiteChainsPath = 'assets/data/pedagogy/prerequisite_chains.json';

  List<Concept>? _cachedConcepts;
  List<VideoConceptMapping>? _cachedVideos;
  Map<String, List<String>>? _cachedPrerequisiteChains;

  /// Load all concepts from JSON
  Future<List<Concept>> loadConcepts() async {
    if (_cachedConcepts != null) {
      return _cachedConcepts!;
    }

    try {
      final jsonString = await rootBundle.loadString(_conceptsPath);
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      final conceptsList = jsonData['concepts'] as List<dynamic>;

      _cachedConcepts = conceptsList
          .map((json) => _parseConcept(json as Map<String, dynamic>))
          .toList();

      logger.debug('Loaded ${_cachedConcepts!.length} concepts from JSON');
      return _cachedConcepts!;
    } catch (e, stackTrace) {
      logger.error('Failed to load concepts from JSON', e, stackTrace);
      return [];
    }
  }

  /// Load concepts by subject
  Future<List<Concept>> loadConceptsBySubject(String subject) async {
    final concepts = await loadConcepts();
    return concepts.where((c) => c.subject == subject).toList();
  }

  /// Load concepts by grade level
  Future<List<Concept>> loadConceptsByGrade(int gradeLevel) async {
    final concepts = await loadConcepts();
    return concepts.where((c) => c.gradeLevel == gradeLevel).toList();
  }

  /// Load concepts by subject and grade
  Future<List<Concept>> loadConceptsBySubjectAndGrade({
    required String subject,
    required int gradeLevel,
  }) async {
    final concepts = await loadConcepts();
    return concepts
        .where((c) => c.subject == subject && c.gradeLevel == gradeLevel)
        .toList();
  }

  /// Get concept by ID
  Future<Concept?> getConceptById(String conceptId) async {
    final concepts = await loadConcepts();
    try {
      return concepts.firstWhere((c) => c.id == conceptId);
    } catch (_) {
      return null;
    }
  }

  /// Get all prerequisites for a concept (recursive)
  Future<List<Concept>> getPrerequisiteChain(String conceptId) async {
    final concepts = await loadConcepts();
    final conceptMap = {for (var c in concepts) c.id: c};

    final result = <Concept>[];
    final visited = <String>{};

    void traverse(String id) {
      if (visited.contains(id)) return;
      visited.add(id);

      final concept = conceptMap[id];
      if (concept == null) return;

      for (final prereqId in concept.prerequisiteIds) {
        traverse(prereqId);
      }

      result.add(concept);
    }

    final concept = conceptMap[conceptId];
    if (concept != null) {
      for (final prereqId in concept.prerequisiteIds) {
        traverse(prereqId);
      }
    }

    return result;
  }

  /// Load video mappings from JSON
  Future<List<VideoConceptMapping>> loadVideoMappings() async {
    if (_cachedVideos != null) {
      return _cachedVideos!;
    }

    try {
      final jsonString = await rootBundle.loadString(_videosPath);
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      final videosList = jsonData['videos'] as List<dynamic>;

      _cachedVideos = videosList
          .map((json) => _parseVideoMapping(json as Map<String, dynamic>))
          .toList();

      logger.debug('Loaded ${_cachedVideos!.length} video mappings from JSON');
      return _cachedVideos!;
    } catch (e, stackTrace) {
      logger.error('Failed to load video mappings from JSON', e, stackTrace);
      return [];
    }
  }

  /// Get videos for a concept
  Future<List<VideoConceptMapping>> getVideosForConcept(String conceptId) async {
    final videos = await loadVideoMappings();
    return videos.where((v) => v.conceptId == conceptId).toList();
  }

  /// Get primary video for a concept
  Future<VideoConceptMapping?> getPrimaryVideoForConcept(String conceptId) async {
    final videos = await getVideosForConcept(conceptId);
    try {
      return videos.firstWhere((v) => v.isPrimary);
    } catch (_) {
      return videos.isNotEmpty ? videos.first : null;
    }
  }

  /// Parse concept from JSON
  Concept _parseConcept(Map<String, dynamic> json) {
    return Concept(
      id: json['id'] as String,
      name: json['name'] as String,
      gradeLevel: json['gradeLevel'] as int,
      subject: json['subject'] as String,
      chapterId: json['chapterId'] as String,
      prerequisiteIds: List<String>.from(json['prerequisiteIds'] as List? ?? []),
      dependentIds: List<String>.from(json['dependentIds'] as List? ?? []),
      videoIds: List<String>.from(json['videoIds'] as List? ?? []),
      questionIds: List<String>.from(json['questionIds'] as List? ?? []),
      estimatedMinutes: json['estimatedMinutes'] as int? ?? 15,
      difficulty: json['difficulty'] as String? ?? 'intermediate',
      keywords: List<String>.from(json['keywords'] as List? ?? []),
    );
  }

  /// Parse video mapping from JSON
  VideoConceptMapping _parseVideoMapping(Map<String, dynamic> json) {
    final checkpointsList = json['checkpoints'] as List<dynamic>? ?? [];
    final checkpoints = checkpointsList.map((cp) {
      final cpMap = cp as Map<String, dynamic>;
      return VideoCheckpoint(
        id: '${json['id']}_cp_${cpMap['timestamp']}',
        videoId: json['id'] as String,
        timestampSeconds: cpMap['timestamp'] as int,
        questionId: cpMap['questionId'] as String,
        replayStartSeconds: cpMap['replayStart'] as int? ?? (cpMap['timestamp'] as int) - 60,
        replayEndSeconds: cpMap['replayEnd'] as int? ?? cpMap['timestamp'] as int,
      );
    }).toList();

    return VideoConceptMapping(
      id: json['id'] as String,
      conceptId: json['conceptId'] as String,
      youtubeId: json['youtubeId'] as String,
      title: json['title'] as String,
      duration: json['duration'] as int,
      isPrimary: json['isPrimary'] as bool? ?? false,
      checkpoints: checkpoints,
      preQuizQuestionIds: List<String>.from(json['preQuizQuestionIds'] as List? ?? []),
      postQuizQuestionIds: List<String>.from(json['postQuizQuestionIds'] as List? ?? []),
    );
  }

  /// Clear cached data
  void clearCache() {
    _cachedConcepts = null;
    _cachedVideos = null;
    _cachedPrerequisiteChains = null;
  }
}

/// Video to concept mapping with checkpoints
class VideoConceptMapping {
  final String id;
  final String conceptId;
  final String youtubeId;
  final String title;
  final int duration;
  final bool isPrimary;
  final List<VideoCheckpoint> checkpoints;
  final List<String> preQuizQuestionIds;
  final List<String> postQuizQuestionIds;

  const VideoConceptMapping({
    required this.id,
    required this.conceptId,
    required this.youtubeId,
    required this.title,
    required this.duration,
    required this.isPrimary,
    required this.checkpoints,
    required this.preQuizQuestionIds,
    required this.postQuizQuestionIds,
  });

  /// Get formatted duration
  String get formattedDuration {
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Get duration in minutes
  int get durationMinutes => (duration / 60).ceil();
}
