# Quiz Flow Improvements - Technical Implementation Plan

## Branch: `feature/quiz-flow-improvements`

## Overview

This document outlines the technical implementation plan for improving quiz system UI connections in StreamShaala. The quiz system backend is complete; these improvements focus on **user experience and flow connections**.

---

## Current State Summary

### Working Components
- Quiz taking flow (load → answer → complete → results)
- Quiz history with filtering, sorting, pagination
- Quiz statistics and analytics
- Assessment types (readiness, knowledge, practice)
- Learning path integration
- Database persistence

### Missing Connections
1. Post-video quiz prompt
2. Quiz button in video player
3. Chapter completion quiz prompt
4. Junior home quiz section
5. Post-quiz next actions
6. Recommended quizzes widget
7. Practice screen completion

---

## Implementation Phases

---

# PHASE 1: Post-Video Quiz Prompt (HIGH PRIORITY)

## Goal
When student watches 80% of a video, show a prompt encouraging them to take the quiz.

## Files to Modify

### 1. `lib/presentation/screens/video/video_player_screen.dart`

#### Current State (Lines 100-103)
```dart
void _onVideoProgress(double currentTime, double duration) {
  if (widget.pathContext == null) return;
  if (duration <= 0) return;

  final percentage = (currentTime / duration) * 100;
  setState(() {
    _watchedPercentage = percentage;
  });

  // Auto-complete at 80% watched
  if (percentage >= 80 && !_hasMarkedComplete) {
    _markVideoComplete(autoCompleted: true);
  }
}
```

#### Changes Required

1. **Add state variable for quiz prompt**
```dart
bool _hasShownQuizPrompt = false;
```

2. **Modify `_onVideoProgress` to show quiz prompt**
```dart
void _onVideoProgress(double currentTime, double duration) {
  if (duration <= 0) return;

  final percentage = (currentTime / duration) * 100;
  setState(() {
    _watchedPercentage = percentage;
  });

  // Show quiz prompt at 80% watched (only once)
  if (percentage >= 80 && !_hasShownQuizPrompt && widget.topicId != null) {
    _hasShownQuizPrompt = true;
    _showQuizPromptDialog();
  }

  // Handle learning path completion if in path context
  if (widget.pathContext != null && percentage >= 80 && !_hasMarkedComplete) {
    _markVideoComplete(autoCompleted: true);
  }
}
```

3. **Add quiz prompt dialog method**
```dart
void _showQuizPromptDialog() {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => QuizPromptDialog(
      videoTitle: _currentVideo?.title ?? 'this video',
      onTakeQuiz: () {
        Navigator.of(context).pop();
        _navigateToQuiz();
      },
      onLater: () {
        Navigator.of(context).pop();
      },
    ),
  );
}

void _navigateToQuiz() {
  if (widget.topicId != null) {
    const studentId = 'student_001'; // TODO: Get from auth provider
    context.push('/quiz/${widget.topicId}/$studentId');
  }
}
```

### 2. Create New Widget: `lib/presentation/widgets/quiz/quiz_prompt_dialog.dart`

```dart
import 'package:flutter/material.dart';

class QuizPromptDialog extends StatelessWidget {
  final String videoTitle;
  final VoidCallback onTakeQuiz;
  final VoidCallback onLater;

  const QuizPromptDialog({
    super.key,
    required this.videoTitle,
    required this.onTakeQuiz,
    required this.onLater,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isJunior = /* check segment config */;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Celebration icon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.celebration,
              size: 48,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            isJunior ? 'Great Job! 🎉' : 'Video Complete!',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // Message
          Text(
            isJunior
              ? 'Ready to show what you learned?'
              : 'Would you like to test your understanding?',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),

          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onLater,
                  child: Text(isJunior ? 'Later' : 'Maybe Later'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: onTakeQuiz,
                  icon: const Icon(Icons.quiz),
                  label: Text(isJunior ? 'Take Quiz!' : 'Take Quiz'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

## Testing Checklist
- [ ] Dialog appears at 80% video completion
- [ ] Dialog only appears once per video session
- [ ] "Take Quiz" navigates to correct quiz
- [ ] "Later" dismisses dialog without navigation
- [ ] Dialog doesn't appear if topicId is null
- [ ] Works correctly in learning path context
- [ ] Junior-friendly messaging when in Junior segment

---

# PHASE 2: Quiz Button in Video Player (MEDIUM PRIORITY)

## Goal
Add a visible "Take Quiz" button in the video player screen so users don't need to navigate back.

## Files to Modify

### 1. `lib/presentation/screens/video/video_player_screen.dart`

#### Option A: Add to AppBar Actions
```dart
AppBar(
  title: Text(_currentVideo?.title ?? 'Video'),
  actions: [
    if (widget.topicId != null)
      IconButton(
        icon: const Icon(Icons.quiz_outlined),
        tooltip: 'Take Quiz',
        onPressed: _navigateToQuiz,
      ),
    // ... other actions
  ],
)
```

#### Option B: Add as Floating Action Button
```dart
Scaffold(
  // ... body
  floatingActionButton: widget.topicId != null
    ? FloatingActionButton.extended(
        onPressed: _navigateToQuiz,
        icon: const Icon(Icons.quiz),
        label: const Text('Take Quiz'),
      )
    : null,
)
```

#### Option C: Add as Tab in Video Info Section (Recommended)
Modify the existing tabs (Info | Notes | Related) to include Quiz tab:

```dart
TabBar(
  tabs: [
    Tab(text: 'Info'),
    Tab(text: 'Notes'),
    if (widget.topicId != null) Tab(text: 'Quiz'),
    Tab(text: 'Related'),
  ],
)

// In TabBarView
if (widget.topicId != null)
  QuizTabContent(
    topicId: widget.topicId!,
    onStartQuiz: _navigateToQuiz,
  ),
```

### 2. Create New Widget: `lib/presentation/widgets/video/quiz_tab_content.dart`

```dart
class QuizTabContent extends StatelessWidget {
  final String topicId;
  final VoidCallback onStartQuiz;

  const QuizTabContent({
    super.key,
    required this.topicId,
    required this.onStartQuiz,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        // Load quiz attempt history for this topic
        final historyAsync = ref.watch(
          quizHistoryProvider((
            filters: QuizFilter(entityId: topicId),
            limit: 5,
            offset: 0,
          )),
        );

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Start Quiz Card
              Card(
                child: ListTile(
                  leading: const Icon(Icons.quiz, size: 40),
                  title: const Text('Topic Quiz'),
                  subtitle: const Text('Test your understanding'),
                  trailing: FilledButton(
                    onPressed: onStartQuiz,
                    child: const Text('Start'),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Previous Attempts
              Text(
                'Your Attempts',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),

              historyAsync.when(
                data: (attempts) {
                  if (attempts.isEmpty) {
                    return const Text('No attempts yet');
                  }
                  return Column(
                    children: attempts.map((attempt) =>
                      QuizAttemptTile(attempt: attempt)
                    ).toList(),
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text('Error: $e'),
              ),
            ],
          ),
        );
      },
    );
  }
}
```

## Testing Checklist
- [ ] Quiz button/tab visible when topicId is provided
- [ ] Quiz button/tab hidden when topicId is null
- [ ] Navigation to quiz works correctly
- [ ] Previous attempts display correctly
- [ ] Works on all screen sizes (mobile, tablet, desktop)

---

# PHASE 3: Chapter Completion Quiz Prompt (HIGH PRIORITY)

## Goal
Detect when all topics in a chapter are completed and prompt user to take chapter quiz.

## Files to Modify

### 1. `lib/presentation/providers/user/progress_provider.dart`

#### Add Chapter Completion Detection
```dart
// Add method to check chapter completion
bool isChapterComplete(String chapterId, List<String> topicIds) {
  final completedTopics = state.progressMap.entries
    .where((e) => topicIds.contains(e.key) && e.value.completed)
    .length;
  return completedTopics == topicIds.length;
}

// Add provider for chapter completion status
final chapterCompletionProvider = Provider.family<bool, ChapterCompletionParams>(
  (ref, params) {
    final progressState = ref.watch(progressProvider);
    return progressState.progressMap.entries
      .where((e) => params.topicIds.contains(e.key) && e.value.completed)
      .length == params.topicIds.length;
  },
);

class ChapterCompletionParams {
  final String chapterId;
  final List<String> topicIds;

  ChapterCompletionParams(this.chapterId, this.topicIds);
}
```

### 2. `lib/presentation/screens/browse/topic_screen.dart`

#### Add Completion Check on Video Complete
```dart
@override
void initState() {
  super.initState();
  // Listen for progress changes
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _checkChapterCompletion();
  });
}

void _checkChapterCompletion() {
  final progressState = ref.read(progressProvider);
  final videos = ref.read(videoProvider).videos;

  final allTopicIds = videos.map((v) => v.topicId).toSet().toList();
  final completedCount = allTopicIds.where((topicId) {
    final progress = progressState.progressMap[topicId];
    return progress?.completed ?? false;
  }).length;

  // Check if just completed (all done and not shown before)
  if (completedCount == allTopicIds.length && !_hasShownChapterComplete) {
    _hasShownChapterComplete = true;
    _showChapterCompleteDialog();
  }
}

void _showChapterCompleteDialog() {
  showDialog(
    context: context,
    builder: (context) => ChapterCompleteDialog(
      chapterName: widget.chapterName,
      onTakeQuiz: () {
        Navigator.of(context).pop();
        _navigateToChapterQuiz();
      },
      onLater: () {
        Navigator.of(context).pop();
      },
    ),
  );
}

void _navigateToChapterQuiz() {
  const studentId = 'student_001';
  context.push('/quiz/${widget.chapterId}/$studentId');
}
```

### 3. Create New Widget: `lib/presentation/widgets/quiz/chapter_complete_dialog.dart`

```dart
class ChapterCompleteDialog extends StatelessWidget {
  final String chapterName;
  final VoidCallback onTakeQuiz;
  final VoidCallback onLater;

  const ChapterCompleteDialog({
    super.key,
    required this.chapterName,
    required this.onTakeQuiz,
    required this.onLater,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Trophy icon
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.emoji_events,
              size: 56,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 20),

          // Title
          Text(
            'Chapter Complete! 🏆',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // Message
          Text(
            'You\'ve watched all videos in\n"$chapterName"',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),

          Text(
            'Take the Chapter Quiz to test your mastery!',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),

          // Buttons
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton.icon(
                onPressed: onTakeQuiz,
                icon: const Icon(Icons.quiz),
                label: const Text('Take Chapter Quiz'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: onLater,
                child: const Text('I\'ll do it later'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

### 4. `lib/presentation/screens/browse/chapter_screen.dart`

#### Update Completion Percentage
```dart
// Replace hardcoded 0.0 with actual calculation
Widget _buildChapterCard(Chapter chapter) {
  final progressState = ref.watch(progressProvider);
  final completion = _calculateChapterCompletion(chapter, progressState);

  return ChapterListTile(
    chapterNumber: chapter.number,
    name: chapter.name,
    topicCount: chapter.topics.length,
    videoCount: chapter.totalVideoCount,
    completionPercentage: completion, // Was hardcoded 0.0
    onTap: () => _onChapterSelected(chapter.id),
    onQuizTap: () => _onQuizTap(chapter.id, chapter.name),
  );
}

double _calculateChapterCompletion(Chapter chapter, ProgressState state) {
  if (chapter.topics.isEmpty) return 0.0;

  int completedTopics = 0;
  for (final topic in chapter.topics) {
    final progress = state.progressMap[topic.id];
    if (progress?.completed ?? false) {
      completedTopics++;
    }
  }

  return completedTopics / chapter.topics.length;
}
```

## Testing Checklist
- [ ] Completion percentage shows correctly on chapter cards
- [ ] Dialog appears when all videos in chapter are watched
- [ ] Dialog only appears once per session
- [ ] "Take Chapter Quiz" navigates correctly
- [ ] Chapter completion persists across app restarts

---

# PHASE 4: Junior Home Quiz Section (MEDIUM PRIORITY)

## Goal
Add a kid-friendly quiz progress section to the Junior home screen.

## Files to Modify

### 1. `lib/presentation/screens/home/home_screen.dart`

#### Add Quiz Section for Junior
```dart
// In _buildMobileLayoutJunior() around line 163
Widget _buildMobileLayoutJunior(SegmentSettings settings, double spacing) {
  return SingleChildScrollView(
    child: Column(
      children: [
        // Welcome section
        _buildWelcomeSection(),
        SizedBox(height: spacing),

        // Daily Challenge (existing)
        if (settings.showDailyChallenge) ...[
          const DailyChallengeCard(),
          SizedBox(height: spacing),
        ],

        // NEW: Quiz Adventures Section for Junior
        const JuniorQuizProgressSection(),
        SizedBox(height: spacing),

        // Continue Path Card (existing)
        const ContinuePathCard(),
        // ... rest of layout
      ],
    ),
  );
}
```

### 2. Create New Widget: `lib/presentation/widgets/home/junior_quiz_progress_section.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JuniorQuizProgressSection extends ConsumerWidget {
  const JuniorQuizProgressSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentQuizzes = ref.watch(recentQuizzesProvider(5));
    final stats = ref.watch(quizStatisticsProvider('student_001'));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with fun icon
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.star,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'My Quiz Adventures',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Stats Row
            stats.when(
              data: (data) => _buildStatsRow(context, data),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => const SizedBox.shrink(),
            ),

            const SizedBox(height: 16),

            // Recent Quizzes
            recentQuizzes.when(
              data: (quizzes) {
                if (quizzes.isEmpty) {
                  return _buildEmptyState(context);
                }
                return _buildRecentQuizzes(context, quizzes);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => const SizedBox.shrink(),
            ),

            const SizedBox(height: 12),

            // View All Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => context.push('/quiz-history'),
                child: const Text('See All My Quizzes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, QuizStatistics stats) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(
          icon: Icons.check_circle,
          color: Colors.green,
          value: '${stats.totalAttempts}',
          label: 'Quizzes',
        ),
        _buildStatItem(
          icon: Icons.emoji_events,
          color: Colors.amber,
          value: '${stats.averageScore.toInt()}%',
          label: 'Avg Score',
        ),
        _buildStatItem(
          icon: Icons.local_fire_department,
          color: Colors.orange,
          value: '${stats.currentStreak}',
          label: 'Day Streak',
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color color,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentQuizzes(BuildContext context, List<QuizAttempt> quizzes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Quizzes',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        ...quizzes.take(3).map((quiz) => _buildQuizItem(context, quiz)),
      ],
    );
  }

  Widget _buildQuizItem(BuildContext context, QuizAttempt quiz) {
    final passed = quiz.passed;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: passed ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: passed ? Colors.green.shade200 : Colors.orange.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(
            passed ? Icons.check_circle : Icons.replay,
            color: passed ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quiz.topicName ?? quiz.chapterName ?? 'Quiz',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${quiz.scorePercentage.toInt()}% - ${_formatDate(quiz.completedAt)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            passed ? '⭐' : '💪',
            style: const TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(
            Icons.quiz_outlined,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          const Text(
            'No quizzes yet!',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            'Watch videos and take quizzes to see your progress here',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    return '${date.day}/${date.month}';
  }
}
```

## Testing Checklist
- [ ] Section appears on Junior home screen
- [ ] Stats display correctly (total, average, streak)
- [ ] Recent quizzes show with pass/fail indication
- [ ] Empty state shows when no quizzes taken
- [ ] "See All" navigates to quiz history
- [ ] Kid-friendly icons and colors

---

# PHASE 5: Post-Quiz Next Actions (MEDIUM PRIORITY)

## Goal
Add action buttons on quiz results screen for better flow continuation.

## Files to Modify

### 1. `lib/presentation/screens/quiz/quiz_results_screen.dart`

#### Add Next Actions Section
```dart
// After results display, add:
Widget _buildNextActions(BuildContext context, QuizResult result) {
  final passed = result.passed;

  return Card(
    margin: const EdgeInsets.all(16),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What\'s Next?',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          if (passed) ...[
            // Passed: Review, Next Topic, or Another Quiz
            _buildActionButton(
              context,
              icon: Icons.visibility,
              label: 'Review Answers',
              subtitle: 'See explanations for all questions',
              onTap: () => _navigateToReview(context, result),
            ),
            const SizedBox(height: 8),
            _buildActionButton(
              context,
              icon: Icons.skip_next,
              label: 'Next Topic',
              subtitle: 'Continue learning',
              onTap: () => _navigateToNextTopic(context),
              primary: true,
            ),
            const SizedBox(height: 8),
            _buildActionButton(
              context,
              icon: Icons.quiz,
              label: 'Take Another Quiz',
              subtitle: 'Practice more',
              onTap: () => _navigateToQuizSelection(context),
            ),
          ] else ...[
            // Failed: Review, Rewatch Videos, Retry
            _buildActionButton(
              context,
              icon: Icons.visibility,
              label: 'Review Answers',
              subtitle: 'Learn from your mistakes',
              onTap: () => _navigateToReview(context, result),
            ),
            const SizedBox(height: 8),
            _buildActionButton(
              context,
              icon: Icons.play_circle,
              label: 'Watch Videos Again',
              subtitle: 'Review the topic videos',
              onTap: () => _navigateToVideos(context),
              primary: true,
            ),
            const SizedBox(height: 8),
            _buildActionButton(
              context,
              icon: Icons.refresh,
              label: 'Retry Quiz',
              subtitle: 'Try again when ready',
              onTap: () => _retryQuiz(context),
            ),
          ],
        ],
      ),
    ),
  );
}

Widget _buildActionButton(
  BuildContext context, {
  required IconData icon,
  required String label,
  required String subtitle,
  required VoidCallback onTap,
  bool primary = false,
}) {
  return Material(
    color: primary
      ? Theme.of(context).colorScheme.primaryContainer
      : Colors.transparent,
    borderRadius: BorderRadius.circular(12),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: primary
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: primary
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade600,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: primary
                        ? Theme.of(context).colorScheme.primary
                        : null,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    ),
  );
}

// Navigation methods
void _navigateToReview(BuildContext context, QuizResult result) {
  context.push('/quiz/review', extra: result);
}

void _navigateToNextTopic(BuildContext context) {
  // Get next topic from learning path or browse
  context.pop(); // Go back to topic screen
}

void _navigateToVideos(BuildContext context) {
  context.pop(); // Go back to video list
}

void _retryQuiz(BuildContext context) {
  // Reload quiz with same entity ID
  // Implementation depends on how quiz was started
}

void _navigateToQuizSelection(BuildContext context) {
  context.push('/practice');
}
```

## Testing Checklist
- [ ] Next actions section appears after quiz completion
- [ ] Different actions shown for pass vs fail
- [ ] All navigation buttons work correctly
- [ ] Primary action is visually highlighted
- [ ] Retry quiz works correctly

---

# PHASE 6: Practice Screen Completion (HIGH PRIORITY)

## Goal
Complete the TODO implementations in PracticeScreen.

## Files to Modify

### 1. `lib/presentation/screens/practice/practice_screen.dart`

#### Replace TODOs with Implementations

```dart
// Line 216: "Start Practice Quiz"
_buildActionCard(
  title: 'Start Practice Quiz',
  icon: Icons.play_arrow,
  color: Colors.teal,
  onTap: () {
    // Show quiz selection bottom sheet
    _showQuizSelectionSheet(context);
  },
),

// Line 228: "Mock Test"
_buildActionCard(
  title: 'Mock Test',
  icon: Icons.timer,
  color: Colors.orange,
  onTap: () {
    // Navigate to mock test selection
    _showMockTestSheet(context);
  },
),

// Line 241: "Weak Areas"
_buildActionCard(
  title: 'Weak Areas',
  icon: Icons.trending_down,
  color: Colors.red,
  onTap: () {
    // Navigate to weak areas screen
    context.push('/practice/weak-areas');
  },
),
```

### 2. Add Quiz Selection Bottom Sheet

```dart
void _showQuizSelectionSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) => QuizSelectionSheet(
        scrollController: scrollController,
        onQuizSelected: (entityId, assessmentType) {
          Navigator.pop(context);
          context.push('/quiz/$entityId/student_001?type=${assessmentType.queryValue}');
        },
      ),
    ),
  );
}
```

### 3. Create New Widget: `lib/presentation/widgets/practice/quiz_selection_sheet.dart`

```dart
class QuizSelectionSheet extends ConsumerWidget {
  final ScrollController scrollController;
  final Function(String entityId, AssessmentType type) onQuizSelected;

  const QuizSelectionSheet({
    super.key,
    required this.scrollController,
    required this.onQuizSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjects = ref.watch(subjectProvider);

    return Column(
      children: [
        // Handle bar
        Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(2),
          ),
        ),

        // Title
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Select Quiz',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),

        // Quiz Type Selection
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _buildTypeChip(context, 'Topic Quiz', Icons.topic, true),
              const SizedBox(width: 8),
              _buildTypeChip(context, 'Chapter Quiz', Icons.menu_book, false),
              const SizedBox(width: 8),
              _buildTypeChip(context, 'Subject Quiz', Icons.school, false),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Subject/Quiz List
        Expanded(
          child: ListView(
            controller: scrollController,
            children: subjects.subjects.map((subject) =>
              _buildSubjectSection(context, subject)
            ).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSubjectSection(BuildContext context, Subject subject) {
    return ExpansionTile(
      leading: Icon(Icons.subject, color: subject.color),
      title: Text(subject.name),
      children: [
        // List chapters with quiz options
        ...subject.chapters.map((chapter) => ListTile(
          leading: const Icon(Icons.quiz_outlined),
          title: Text(chapter.name),
          subtitle: Text('${chapter.topics.length} topics'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => onQuizSelected(chapter.id, AssessmentType.knowledge),
        )),
      ],
    );
  }

  Widget _buildTypeChip(BuildContext context, String label, IconData icon, bool selected) {
    return FilterChip(
      label: Text(label),
      avatar: Icon(icon, size: 18),
      selected: selected,
      onSelected: (value) {
        // Handle type selection
      },
    );
  }
}
```

### 4. Create Weak Areas Screen: `lib/presentation/screens/practice/weak_areas_screen.dart`

```dart
class WeakAreasScreen extends ConsumerWidget {
  const WeakAreasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(quizStatisticsProvider('student_001'));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weak Areas'),
      ),
      body: stats.when(
        data: (data) {
          if (data.weakTopics.isEmpty) {
            return _buildNoWeakAreas(context);
          }
          return _buildWeakAreasList(context, data.weakTopics);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildWeakAreasList(BuildContext context, List<WeakTopic> topics) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: topics.length,
      itemBuilder: (context, index) {
        final topic = topics[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircularProgressIndicator(
              value: topic.averageScore / 100,
              backgroundColor: Colors.grey.shade200,
              color: _getScoreColor(topic.averageScore),
            ),
            title: Text(topic.name),
            subtitle: Text(
              'Average: ${topic.averageScore.toInt()}% | ${topic.attempts} attempts',
            ),
            trailing: FilledButton(
              onPressed: () {
                context.push('/quiz/${topic.id}/student_001');
              },
              child: const Text('Practice'),
            ),
          ),
        );
      },
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  Widget _buildNoWeakAreas(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.emoji_events, size: 64, color: Colors.amber),
          const SizedBox(height: 16),
          Text(
            'Great job!',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('You don\'t have any weak areas right now.'),
        ],
      ),
    );
  }
}
```

### 5. Add Route for Weak Areas

```dart
// In app_router.dart
GoRoute(
  path: '/practice/weak-areas',
  name: 'weakAreas',
  builder: (context, state) => const WeakAreasScreen(),
),
```

## Testing Checklist
- [ ] "Start Practice Quiz" opens selection sheet
- [ ] Quiz selection shows subjects and chapters
- [ ] Selecting a quiz navigates correctly
- [ ] "Mock Test" shows mock test options
- [ ] "Weak Areas" navigates to weak areas screen
- [ ] Weak areas display correctly with scores
- [ ] Practice button works for each weak topic

---

# PHASE 7: Recommended Quizzes Widget (MEDIUM PRIORITY)

## Goal
Add a "Recommended Quizzes" section on home screen based on weak areas.

## Files to Create/Modify

### 1. Create Widget: `lib/presentation/widgets/home/recommended_quizzes_section.dart`

```dart
class RecommendedQuizzesSection extends ConsumerWidget {
  const RecommendedQuizzesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(quizStatisticsProvider('student_001'));

    return stats.when(
      data: (data) {
        if (data.weakTopics.isEmpty) {
          return const SizedBox.shrink(); // Don't show if no weak areas
        }
        return _buildSection(context, data.weakTopics.take(3).toList());
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildSection(BuildContext context, List<WeakTopic> weakTopics) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.recommend, color: Colors.orange),
                const SizedBox(width: 8),
                Text(
                  'Recommended Practice',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'These topics need more practice',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
            const SizedBox(height: 12),

            ...weakTopics.map((topic) => _buildRecommendationTile(context, topic)),

            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.push('/practice/weak-areas'),
              child: const Text('See All Weak Areas'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationTile(BuildContext context, WeakTopic topic) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        dense: true,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${topic.averageScore.toInt()}%',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.orange.shade700,
            ),
          ),
        ),
        title: Text(
          topic.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: TextButton(
          onPressed: () {
            context.push('/quiz/${topic.id}/student_001');
          },
          child: const Text('Practice'),
        ),
      ),
    );
  }
}
```

### 2. Add to Home Screen

```dart
// In home_screen.dart, add to appropriate layout
const RecommendedQuizzesSection(),
SizedBox(height: spacing),
```

## Testing Checklist
- [ ] Section appears when user has weak areas
- [ ] Section hidden when no weak areas
- [ ] Shows top 3 weak topics
- [ ] "Practice" navigates to quiz
- [ ] "See All" navigates to weak areas screen

---

## Implementation Order Summary

| Phase | Priority | Estimated Effort | Dependencies |
|-------|----------|------------------|--------------|
| Phase 1: Post-Video Quiz Prompt | HIGH | 2-3 hours | None |
| Phase 2: Quiz Button in Video Player | MEDIUM | 2-3 hours | None |
| Phase 3: Chapter Completion Prompt | HIGH | 4-5 hours | Progress tracking |
| Phase 4: Junior Home Quiz Section | MEDIUM | 3-4 hours | Quiz history provider |
| Phase 5: Post-Quiz Next Actions | MEDIUM | 2-3 hours | None |
| Phase 6: Practice Screen Completion | HIGH | 4-5 hours | Quiz selection logic |
| Phase 7: Recommended Quizzes Widget | MEDIUM | 2-3 hours | Quiz statistics |

**Total Estimated Effort: 19-26 hours**

---

## File Change Summary

### New Files to Create
1. `lib/presentation/widgets/quiz/quiz_prompt_dialog.dart`
2. `lib/presentation/widgets/quiz/chapter_complete_dialog.dart`
3. `lib/presentation/widgets/video/quiz_tab_content.dart`
4. `lib/presentation/widgets/home/junior_quiz_progress_section.dart`
5. `lib/presentation/widgets/practice/quiz_selection_sheet.dart`
6. `lib/presentation/screens/practice/weak_areas_screen.dart`
7. `lib/presentation/widgets/home/recommended_quizzes_section.dart`

### Files to Modify
1. `lib/presentation/screens/video/video_player_screen.dart`
2. `lib/presentation/screens/browse/topic_screen.dart`
3. `lib/presentation/screens/browse/chapter_screen.dart`
4. `lib/presentation/screens/home/home_screen.dart`
5. `lib/presentation/screens/quiz/quiz_results_screen.dart`
6. `lib/presentation/screens/practice/practice_screen.dart`
7. `lib/presentation/providers/user/progress_provider.dart`
8. `lib/presentation/navigation/app_router.dart`

---

## Next Steps

1. Start with Phase 1 (Post-Video Quiz Prompt) - highest impact, lowest effort
2. Proceed to Phase 3 (Chapter Completion) - high impact
3. Complete Phase 6 (Practice Screen) - fixes broken feature
4. Add remaining phases in priority order

---

*Document created: January 29, 2026*
*Branch: feature/quiz-flow-improvements*
