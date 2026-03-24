// Content Filter Service
// Filters content based on parental control settings for Junior segment

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/core/config/segment_config.dart';
import 'package:crack_the_code/domain/entities/content/video.dart';
import 'package:crack_the_code/domain/entities/parental/parental_settings.dart';
import 'package:crack_the_code/presentation/providers/parental/parental_controls_provider.dart';

/// Content Filter Service
/// Filters videos and quizzes based on parental control settings
class ContentFilterService {
  final ParentalSettings settings;

  ContentFilterService(this.settings);

  /// Check if content filtering is active
  bool get isFilteringActive =>
      SegmentConfig.settings.showParentalControls && settings.isEnabled;

  /// Filter a list of videos based on parental settings
  List<Video> filterVideos(List<Video> videos) {
    if (!isFilteringActive) return videos;

    return videos.where((video) {
      // Check difficulty filter
      if (!_passesDifficultyFilter(video.difficulty)) {
        return false;
      }

      // Check hidden subjects filter
      if (_isSubjectHidden(video.topicId)) {
        return false;
      }

      return true;
    }).toList();
  }

  /// Filter a single video
  bool isVideoAllowed(Video video) {
    if (!isFilteringActive) return true;

    return _passesDifficultyFilter(video.difficulty) &&
        !_isSubjectHidden(video.topicId);
  }

  /// Check if a difficulty level is allowed
  bool _passesDifficultyFilter(String difficulty) {
    final normalizedDifficulty = difficulty.toLowerCase();

    switch (settings.difficultyFilter) {
      case DifficultyFilter.easyOnly:
        return normalizedDifficulty == 'easy' ||
            normalizedDifficulty == 'beginner' ||
            normalizedDifficulty == 'basic';

      case DifficultyFilter.easyMedium:
        return normalizedDifficulty != 'hard' &&
            normalizedDifficulty != 'advanced' &&
            normalizedDifficulty != 'expert' &&
            normalizedDifficulty != 'difficult';

      case DifficultyFilter.all:
        return true;
    }
  }

  /// Check if a subject/topic is hidden
  bool _isSubjectHidden(String topicId) {
    if (settings.hiddenSubjects.isEmpty) return false;

    // Check if the topicId starts with any hidden subject prefix
    // Subject IDs are typically formatted as "subject_physics" or similar
    for (final hiddenSubject in settings.hiddenSubjects) {
      if (topicId.toLowerCase().contains(hiddenSubject.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  /// Check if a subject ID is allowed
  bool isSubjectAllowed(String subjectId) {
    if (!isFilteringActive) return true;
    return !_isSubjectHidden(subjectId);
  }

  /// Get allowed difficulty levels as strings for display
  List<String> get allowedDifficultyLevels {
    switch (settings.difficultyFilter) {
      case DifficultyFilter.easyOnly:
        return ['Easy', 'Beginner', 'Basic'];
      case DifficultyFilter.easyMedium:
        return ['Easy', 'Beginner', 'Basic', 'Medium', 'Intermediate'];
      case DifficultyFilter.all:
        return ['Easy', 'Medium', 'Hard', 'All Levels'];
    }
  }

  /// Get a display message for current filter status
  String get filterStatusMessage {
    if (!isFilteringActive) {
      return 'All content available';
    }

    final parts = <String>[];

    if (settings.difficultyFilter != DifficultyFilter.all) {
      parts.add(settings.difficultyFilter.displayName);
    }

    if (settings.hiddenSubjects.isNotEmpty) {
      parts.add('${settings.hiddenSubjects.length} subject(s) hidden');
    }

    return parts.isEmpty ? 'All content available' : parts.join(' • ');
  }
}

/// Provider for the content filter service
final contentFilterServiceProvider = Provider<ContentFilterService>((ref) {
  final parentalState = ref.watch(parentalControlsProvider);
  return ContentFilterService(parentalState.settings);
});

/// Provider for checking if content filtering is active
final isContentFilteringActiveProvider = Provider<bool>((ref) {
  final filterService = ref.watch(contentFilterServiceProvider);
  return filterService.isFilteringActive;
});

/// Extension for filtering video lists with the provider
extension VideoListFiltering on List<Video> {
  /// Filter videos using the content filter service
  List<Video> applyParentalFilters(ContentFilterService filterService) {
    return filterService.filterVideos(this);
  }
}
