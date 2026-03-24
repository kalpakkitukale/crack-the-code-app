import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:streamshaala/core/constants/route_constants.dart';
import 'package:streamshaala/core/extensions/context_extensions.dart';
import 'package:streamshaala/core/extensions/datetime_extensions.dart';
import 'package:streamshaala/core/models/assessment_type.dart';
import 'package:streamshaala/core/responsive/responsive_builder.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/domain/entities/pedagogy/quiz_recommendation.dart';
import 'package:streamshaala/domain/entities/quiz/quiz.dart';
import 'package:streamshaala/domain/entities/quiz/quiz_attempt.dart';
import 'package:streamshaala/domain/entities/quiz/quiz_result.dart';
import 'package:streamshaala/domain/repositories/recommendations_history_repository.dart';
import 'package:streamshaala/domain/usecases/pedagogy/get_recommendations_history_usecase.dart';
import 'package:streamshaala/infrastructure/di/injection_container.dart';
import 'package:streamshaala/presentation/providers/user/quiz_history_provider.dart';
import 'package:streamshaala/presentation/widgets/quiz/empty_quiz_state.dart';
import 'package:streamshaala/presentation/widgets/quiz/filter_chips_bar.dart';
import 'package:streamshaala/presentation/widgets/quiz/quiz_filter_chips.dart' show PerformanceFilter, QuizFilterChips, DateRangeFilter;
import 'package:streamshaala/presentation/widgets/quiz/quiz_history_item.dart';

/// Provider for recommendations history repository
final recommendationsHistoryRepositoryProvider = Provider<RecommendationsHistoryRepository>((ref) {
  return injectionContainer.recommendationsHistoryRepository;
});

/// QuizHistoryScreen - Displays all past quiz attempts with filtering and sorting
///
/// Features:
/// - List view of all quiz attempts with detailed information
/// - Filter by subject, level, date range, and performance
/// - Sort by date, score, or duration
/// - Responsive layouts for mobile, tablet, and desktop
/// - Empty state handling
/// - Navigation to quiz results for detailed review
class QuizHistoryScreen extends ConsumerStatefulWidget {
  const QuizHistoryScreen({super.key});

  @override
  ConsumerState<QuizHistoryScreen> createState() => _QuizHistoryScreenState();
}

class _QuizHistoryScreenState extends ConsumerState<QuizHistoryScreen> {
  // Filter state
  final Set<String> _selectedSubjects = {};
  final Set<QuizLevel> _selectedLevels = {};
  DateRangeFilter _selectedDateRange = DateRangeFilter.all;
  PerformanceFilter _selectedPerformance = PerformanceFilter.all;
  AssessmentType? _selectedAssessmentType;
  bool _showOnlyWithRecommendations = false;

  // Sort state
  SortOption _sortOption = SortOption.recentFirst;

  /// Apply filters and sorting to quiz attempts
  List<QuizAttempt> _applyFiltersAndSort(List<QuizAttempt> attempts) {
    var filtered = attempts.where((attempt) {
      // Subject filter
      if (_selectedSubjects.isNotEmpty &&
          attempt.subjectName != null &&
          !_selectedSubjects.contains(attempt.subjectName)) {
        return false;
      }

      // Level filter
      if (_selectedLevels.isNotEmpty && attempt.quizLevel != null) {
        final level = _parseQuizLevel(attempt.quizLevel!);
        if (level != null && !_selectedLevels.contains(level)) {
          return false;
        }
      }

      // Date range filter
      if (!_matchesDateRange(attempt.completedAt)) {
        return false;
      }

      // Performance filter
      if (!_matchesPerformance(attempt.scorePercentage)) {
        return false;
      }

      // Assessment type filter
      if (_selectedAssessmentType != null &&
          attempt.assessmentType != _selectedAssessmentType) {
        return false;
      }

      // Recommendations filter
      if (_showOnlyWithRecommendations && !attempt.hasRecommendations) {
        return false;
      }

      return true;
    }).toList();

    // Apply sorting
    _sortAttempts(filtered);

    return filtered;
  }

  /// Parse quiz level string to enum
  QuizLevel? _parseQuizLevel(String level) {
    switch (level.toLowerCase()) {
      case 'video':
        return QuizLevel.video;
      case 'topic':
        return QuizLevel.topic;
      case 'chapter':
        return QuizLevel.chapter;
      case 'subject':
        return QuizLevel.subject;
      default:
        return null;
    }
  }

  /// Check if date matches selected range
  bool _matchesDateRange(DateTime date) {
    switch (_selectedDateRange) {
      case DateRangeFilter.all:
        return true;
      case DateRangeFilter.today:
        return date.isToday;
      case DateRangeFilter.thisWeek:
        return date.isThisWeek;
      case DateRangeFilter.thisMonth:
        return date.isThisMonth;
    }
  }

  /// Check if performance matches filter
  bool _matchesPerformance(double score) {
    switch (_selectedPerformance) {
      case PerformanceFilter.all:
        return true;
      case PerformanceFilter.passed:
        return score >= 60;
      case PerformanceFilter.failed:
        return score < 60;
    }
  }

  /// Sort attempts based on selected option
  void _sortAttempts(List<QuizAttempt> attempts) {
    switch (_sortOption) {
      case SortOption.recentFirst:
        attempts.sort((a, b) => b.completedAt.compareTo(a.completedAt));
        break;
      case SortOption.highestScore:
        attempts.sort((a, b) => b.scorePercentage.compareTo(a.scorePercentage));
        break;
      case SortOption.lowestScore:
        attempts.sort((a, b) => a.scorePercentage.compareTo(b.scorePercentage));
        break;
      case SortOption.longestDuration:
        attempts.sort((a, b) => b.timeTaken.compareTo(a.timeTaken));
        break;
    }
  }

  /// Get available subjects from attempts
  List<String> _getAvailableSubjects(List<QuizAttempt> attempts) {
    return attempts
        .where((a) => a.subjectName != null)
        .map((a) => a.subjectName!)
        .toSet()
        .toList()
      ..sort();
  }

  /// Clear all filters
  void _clearAllFilters() {
    setState(() {
      _selectedSubjects.clear();
      _selectedLevels.clear();
      _selectedDateRange = DateRangeFilter.all;
      _selectedPerformance = PerformanceFilter.all;
      _selectedAssessmentType = null;
      _showOnlyWithRecommendations = false;
    });
  }

  /// Handle subject filter toggle
  void _toggleSubjectFilter(String subject) {
    setState(() {
      if (_selectedSubjects.contains(subject)) {
        _selectedSubjects.remove(subject);
      } else {
        _selectedSubjects.add(subject);
      }
    });
  }

  /// Handle level filter toggle
  void _toggleLevelFilter(QuizLevel level) {
    setState(() {
      if (_selectedLevels.contains(level)) {
        _selectedLevels.remove(level);
      } else {
        _selectedLevels.add(level);
      }
    });
  }

  /// Handle date range change
  void _changeDateRange(DateRangeFilter range) {
    setState(() {
      _selectedDateRange = range;
    });
  }

  /// Handle performance filter change
  void _changePerformanceFilter(PerformanceFilter performance) {
    setState(() {
      _selectedPerformance = performance;
    });
  }

  /// Handle sort option change
  void _changeSortOption(SortOption? option) {
    if (option != null) {
      setState(() {
        _sortOption = option;
      });
    }
  }

  /// Handle assessment type filter change
  void _changeAssessmentTypeFilter(AssessmentType? type) {
    setState(() {
      _selectedAssessmentType = type;
      // If a specific assessment type is selected, clear recommendations filter
      if (type != null) {
        _showOnlyWithRecommendations = false;
      }
    });
  }

  /// Handle recommendations filter toggle
  void _toggleRecommendationsFilter(bool show) {
    setState(() {
      _showOnlyWithRecommendations = show;
      // If showing only with recommendations, clear assessment type filter
      if (show) {
        _selectedAssessmentType = null;
      }
    });
  }

  /// Show filters bottom sheet (mobile only)
  void _showFiltersBottomSheet(List<String> availableSubjects) {
    context.showCustomBottomSheet(
      child: Container(
        padding: EdgeInsets.only(
          left: AppTheme.spacingMd,
          right: AppTheme.spacingMd,
          top: AppTheme.spacingMd,
          bottom: context.viewInsets.bottom + AppTheme.spacingMd,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              children: [
                Text(
                  'Filter Quiz History',
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  tooltip: 'Close filter',
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),

            // Filters
            QuizFilterChips(
              selectedSubjects: _selectedSubjects,
              selectedLevels: _selectedLevels,
              selectedDateRange: _selectedDateRange,
              selectedPerformance: _selectedPerformance,
              availableSubjects: availableSubjects,
              onSubjectToggle: _toggleSubjectFilter,
              onLevelToggle: _toggleLevelFilter,
              onDateRangeChanged: _changeDateRange,
              onPerformanceChanged: _changePerformanceFilter,
              onClearAll: _clearAllFilters,
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Apply button
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Apply Filters'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch the quiz history provider with no filters (get all attempts)
    final quizHistoryAsync = ref.watch(
      quizHistoryProvider((filters: null, limit: null, offset: null)),
    );

    return quizHistoryAsync.when(
      loading: () => _buildLoadingScaffold(),
      error: (error, stack) => _buildErrorScaffold(error.toString()),
      data: (allAttempts) {
        final filteredAttempts = _applyFiltersAndSort(allAttempts);
        final availableSubjects = _getAvailableSubjects(allAttempts);

        return ResponsiveBuilder(
          builder: (context, deviceType) {
            switch (deviceType) {
              case DeviceType.mobile:
                return _buildMobileLayout(
                  allAttempts,
                  filteredAttempts,
                  availableSubjects,
                );
              case DeviceType.tablet:
                return _buildTabletLayout(
                  allAttempts,
                  filteredAttempts,
                  availableSubjects,
                );
              case DeviceType.desktop:
                return _buildDesktopLayout(
                  allAttempts,
                  filteredAttempts,
                  availableSubjects,
                );
            }
          },
        );
      },
    );
  }

  /// Build loading scaffold
  Widget _buildLoadingScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz History'),
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  /// Build error scaffold
  Widget _buildErrorScaffold(String error) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz History'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: context.colorScheme.error,
              ),
              const SizedBox(height: AppTheme.spacingMd),
              Text(
                'Failed to load quiz history',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppTheme.spacingSm),
              Text(
                error,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppTheme.spacingLg),
              ElevatedButton.icon(
                onPressed: () {
                  // Invalidate the provider to retry
                  ref.invalidate(quizHistoryProvider);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build mobile layout (single column with bottom sheet filters)
  Widget _buildMobileLayout(
    List<QuizAttempt> allAttempts,
    List<QuizAttempt> filteredAttempts,
    List<String> availableSubjects,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz History'),
        actions: [
          // Filter button
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFiltersBottomSheet(availableSubjects),
            tooltip: 'Filter',
          ),
          // Sort menu
          _buildSortMenu(),
        ],
      ),
      body: Column(
        children: [
          // Assessment type and recommendations filter bar
          FilterChipsBar(
            selectedType: _selectedAssessmentType,
            showOnlyWithRecommendations: _showOnlyWithRecommendations,
            onTypeChanged: _changeAssessmentTypeFilter,
            onRecommendationsFilterChanged: _toggleRecommendationsFilter,
          ),
          // History list
          Expanded(
            child: _buildHistoryList(allAttempts, filteredAttempts),
          ),
        ],
      ),
    );
  }

  /// Build tablet layout (two-column grid)
  Widget _buildTabletLayout(
    List<QuizAttempt> allAttempts,
    List<QuizAttempt> filteredAttempts,
    List<String> availableSubjects,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz History'),
        actions: [_buildSortMenu()],
      ),
      body: Column(
        children: [
          // Assessment type and recommendations filter bar
          FilterChipsBar(
            selectedType: _selectedAssessmentType,
            showOnlyWithRecommendations: _showOnlyWithRecommendations,
            onTypeChanged: _changeAssessmentTypeFilter,
            onRecommendationsFilterChanged: _toggleRecommendationsFilter,
          ),

          // Subject/Level/Date/Performance Filters
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: context.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: QuizFilterChips(
              selectedSubjects: _selectedSubjects,
              selectedLevels: _selectedLevels,
              selectedDateRange: _selectedDateRange,
              selectedPerformance: _selectedPerformance,
              availableSubjects: availableSubjects,
              onSubjectToggle: _toggleSubjectFilter,
              onLevelToggle: _toggleLevelFilter,
              onDateRangeChanged: _changeDateRange,
              onPerformanceChanged: _changePerformanceFilter,
              onClearAll: _clearAllFilters,
            ),
          ),

          // History grid
          Expanded(
            child: _buildHistoryGrid(
              allAttempts: allAttempts,
              filteredAttempts: filteredAttempts,
              crossAxisCount: 2,
            ),
          ),
        ],
      ),
    );
  }

  /// Build desktop layout (three-column with sidebar filters)
  Widget _buildDesktopLayout(
    List<QuizAttempt> allAttempts,
    List<QuizAttempt> filteredAttempts,
    List<String> availableSubjects,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz History'),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar filters
          Container(
            width: 280,
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              border: Border(
                right: BorderSide(
                  color: context.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Sort dropdown
                  Text(
                    'Sort By',
                    style: context.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingSm),
                  DropdownButtonFormField<SortOption>(
                    value: _sortOption,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingMd,
                        vertical: AppTheme.spacingSm,
                      ),
                    ),
                    items: SortOption.values.map((option) {
                      return DropdownMenuItem(
                        value: option,
                        child: Text(_getSortOptionLabel(option)),
                      );
                    }).toList(),
                    onChanged: _changeSortOption,
                  ),
                  const SizedBox(height: AppTheme.spacingLg),
                  const Divider(),
                  const SizedBox(height: AppTheme.spacingLg),

                  // Subject/Level/Date/Performance Filters
                  QuizFilterChips(
                    selectedSubjects: _selectedSubjects,
                    selectedLevels: _selectedLevels,
                    selectedDateRange: _selectedDateRange,
                    selectedPerformance: _selectedPerformance,
                    availableSubjects: availableSubjects,
                    onSubjectToggle: _toggleSubjectFilter,
                    onLevelToggle: _toggleLevelFilter,
                    onDateRangeChanged: _changeDateRange,
                    onPerformanceChanged: _changePerformanceFilter,
                    onClearAll: _clearAllFilters,
                  ),
                ],
              ),
            ),
          ),

          // Main content
          Expanded(
            child: Column(
              children: [
                // Assessment type and recommendations filter bar
                FilterChipsBar(
                  selectedType: _selectedAssessmentType,
                  showOnlyWithRecommendations: _showOnlyWithRecommendations,
                  onTypeChanged: _changeAssessmentTypeFilter,
                  onRecommendationsFilterChanged: _toggleRecommendationsFilter,
                ),

                // History grid
                Expanded(
                  child: _buildHistoryGrid(
                    allAttempts: allAttempts,
                    filteredAttempts: filteredAttempts,
                    crossAxisCount: 3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build history list view
  Widget _buildHistoryList(
    List<QuizAttempt> allAttempts,
    List<QuizAttempt> filteredAttempts,
  ) {
    if (allAttempts.isEmpty) {
      return EmptyQuizState(
        type: EmptyStateType.noHistory,
        onAction: _handleTakeFirstQuiz,
      );
    }

    if (filteredAttempts.isEmpty) {
      return EmptyQuizState(
        type: EmptyStateType.noFilteredResults,
        onAction: _clearAllFilters,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      itemCount: filteredAttempts.length,
      itemBuilder: (context, index) {
        final attempt = filteredAttempts[index];
        return QuizHistoryItem(
          quizName: _getQuizName(attempt),
          subjectName: attempt.subjectName ?? 'Unknown Subject',
          quizLevel: _parseQuizLevel(attempt.quizLevel ?? 'topic') ?? QuizLevel.topic,
          completedAt: attempt.completedAt,
          scorePercentage: attempt.scorePercentage,
          correctAnswers: attempt.correctAnswers ?? 0,
          totalQuestions: attempt.totalQuestions ?? 0,
          timeSpent: Duration(seconds: attempt.timeTaken),
          onViewDetails: () => _viewQuizDetails(attempt),
          // CRITICAL FIX: Always allow viewing recommendations for readiness quizzes
          // The _viewRecommendations method will check if they actually exist
          // This fixes the issue where hasRecommendations flag is false but recommendations exist in DB
          onViewRecommendations: attempt.assessmentType == 'readiness'
              ? () => _viewRecommendations(attempt)
              : (attempt.hasRecommendations ? () => _viewRecommendations(attempt) : null),
          // Pass breadcrumb metadata
          chapterName: attempt.chapterName,
          topicName: attempt.topicName,
          videoTitle: attempt.videoTitle,
          // Pass recommendation metadata
          assessmentType: attempt.assessmentType,
          hasRecommendations: attempt.hasRecommendations,
          recommendationCount: attempt.recommendationCount,
          recommendationStatus: attempt.recommendationStatus,
        );
      },
    );
  }

  /// Build history grid view
  Widget _buildHistoryGrid({
    required List<QuizAttempt> allAttempts,
    required List<QuizAttempt> filteredAttempts,
    required int crossAxisCount,
  }) {
    if (allAttempts.isEmpty) {
      return EmptyQuizState(
        type: EmptyStateType.noHistory,
        onAction: _handleTakeFirstQuiz,
      );
    }

    if (filteredAttempts.isEmpty) {
      return EmptyQuizState(
        type: EmptyStateType.noFilteredResults,
        onAction: _clearAllFilters,
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: AppTheme.spacingMd,
        mainAxisSpacing: AppTheme.spacingMd,
        childAspectRatio: 1.5,
      ),
      itemCount: filteredAttempts.length,
      itemBuilder: (context, index) {
        final attempt = filteredAttempts[index];
        return QuizHistoryItem(
          quizName: _getQuizName(attempt),
          subjectName: attempt.subjectName ?? 'Unknown Subject',
          quizLevel: _parseQuizLevel(attempt.quizLevel ?? 'topic') ?? QuizLevel.topic,
          completedAt: attempt.completedAt,
          scorePercentage: attempt.scorePercentage,
          correctAnswers: attempt.correctAnswers ?? 0,
          totalQuestions: attempt.totalQuestions ?? 0,
          timeSpent: Duration(seconds: attempt.timeTaken),
          onViewDetails: () => _viewQuizDetails(attempt),
          // CRITICAL FIX: Always allow viewing recommendations for readiness quizzes
          // The _viewRecommendations method will check if they actually exist
          // This fixes the issue where hasRecommendations flag is false but recommendations exist in DB
          onViewRecommendations: attempt.assessmentType == 'readiness'
              ? () => _viewRecommendations(attempt)
              : (attempt.hasRecommendations ? () => _viewRecommendations(attempt) : null),
          // Pass breadcrumb metadata
          chapterName: attempt.chapterName,
          topicName: attempt.topicName,
          videoTitle: attempt.videoTitle,
          // Pass recommendation metadata
          assessmentType: attempt.assessmentType,
          hasRecommendations: attempt.hasRecommendations,
          recommendationCount: attempt.recommendationCount,
          recommendationStatus: attempt.recommendationStatus,
        );
      },
    );
  }

  /// Get quiz name from attempt (with fallback)
  String _getQuizName(QuizAttempt attempt) {
    // Try to construct name from metadata
    if (attempt.topicName != null) {
      return attempt.topicName!;
    } else if (attempt.chapterName != null) {
      return attempt.chapterName!;
    } else if (attempt.subjectName != null) {
      return '${attempt.subjectName} Quiz';
    } else {
      return 'Quiz #${attempt.id.substring(0, 8)}';
    }
  }

  /// Build sort menu button
  Widget _buildSortMenu() {
    return PopupMenuButton<SortOption>(
      icon: const Icon(Icons.sort),
      tooltip: 'Sort',
      onSelected: _changeSortOption,
      itemBuilder: (context) => SortOption.values.map((option) {
        return PopupMenuItem(
          value: option,
          child: Row(
            children: [
              if (_sortOption == option)
                Icon(
                  Icons.check,
                  size: 18,
                  color: context.colorScheme.primary,
                ),
              if (_sortOption != option) const SizedBox(width: 18),
              const SizedBox(width: AppTheme.spacingXs),
              Text(_getSortOptionLabel(option)),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// Get sort option label
  String _getSortOptionLabel(SortOption option) {
    switch (option) {
      case SortOption.recentFirst:
        return 'Recent First';
      case SortOption.highestScore:
        return 'Highest Score';
      case SortOption.lowestScore:
        return 'Lowest Score';
      case SortOption.longestDuration:
        return 'Longest Duration';
    }
  }

  /// Handle take first quiz - Navigate to home screen for quiz selection
  void _handleTakeFirstQuiz() {
    // Navigate to home screen where users can browse content and take quizzes
    context.go(RouteConstants.home);
  }

  /// View recommendations for a quiz attempt
  Future<void> _viewRecommendations(QuizAttempt attempt) async {
    if (!attempt.hasRecommendations) {
      return;
    }

    try {
      // Show loading indicator
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Fetch recommendations history
      final repository = ref.read(recommendationsHistoryRepositoryProvider);
      final useCase = GetRecommendationsHistoryUseCase(repository: repository);
      final history = await useCase.getByQuizAttempt(attempt.id);

      if (!mounted) return;
      Navigator.of(context).pop(); // Dismiss loading dialog

      if (history == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No recommendations found for this quiz'),
          ),
        );
        return;
      }

      // Convert RecommendationsHistory to RecommendationsBundle
      final bundle = RecommendationsBundle(
        quizResultId: history.quizAttemptId,
        assessmentType: history.assessmentType,
        recommendations: history.activeRecommendations,
        generatedAt: history.generatedAt,
        totalEstimatedMinutes: history.estimatedMinutesToFix,
        subjectName: attempt.subjectName,
        quizScore: attempt.scorePercentage,
      );

      // Navigate to recommendations screen
      context.push(
        RouteConstants.recommendations,
        extra: bundle,
      );
    } catch (e, stackTrace) {
      logger.error('Failed to load recommendations', e, stackTrace);

      if (!mounted) return;
      Navigator.of(context).pop(); // Dismiss loading dialog if still showing

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load recommendations: $e'),
        ),
      );
    }
  }

  /// View quiz details - Navigate to results screen with historical attempt data
  void _viewQuizDetails(QuizAttempt attempt) {
    // Build questionResults map from attempt data
    final questionResults = <String, bool>{};

    if (attempt.questions != null && attempt.answers.isNotEmpty) {
      for (final question in attempt.questions!) {
        final answer = attempt.answers[question.id];
        final isCorrect = answer != null && question.isCorrect(answer);
        questionResults[question.id] = isCorrect;
      }
    }

    // Convert QuizAttempt to QuizResult for display
    final result = QuizResult(
      sessionId: attempt.id,
      correctAnswers: attempt.correctAnswers ?? 0,
      totalQuestions: attempt.totalQuestions ?? 0,
      timeTaken: Duration(seconds: attempt.timeTaken),
      scorePercentage: attempt.scorePercentage,
      passed: attempt.passed,
      evaluatedAt: attempt.completedAt,
      questionResults: questionResults,
      conceptAnalysis: null,
      weakAreas: null,
      strongAreas: null,
      recommendation: null,
      questions: attempt.questions,
      answers: attempt.answers,
      quizLevel: attempt.quizLevel,
      subjectName: attempt.subjectName,
      chapterName: attempt.chapterName,
      topicName: attempt.topicName,
      videoTitle: null,
    );

    // Navigate to results screen with assessment type in query parameter
    final resultsPath = RouteConstants.getQuizResultsPath(attempt.quizId, 'student_id');

    // Pass recommendationsHistoryId if available so recommendations can be loaded directly
    final queryParams = <String, String>{
      'type': attempt.assessmentType.queryValue,
    };
    if (attempt.recommendationsHistoryId != null) {
      queryParams['recHistoryId'] = attempt.recommendationsHistoryId!;
    }
    final queryString = queryParams.entries.map((e) => '${e.key}=${e.value}').join('&');
    final pathWithParams = '$resultsPath?$queryString';

    context.push(
      pathWithParams,
      extra: result,
    );
  }
}

/// Sort options
enum SortOption {
  recentFirst,
  highestScore,
  lowestScore,
  longestDuration,
}
