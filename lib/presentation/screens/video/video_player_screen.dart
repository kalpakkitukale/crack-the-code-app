import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:streamshaala/core/config/segment_config.dart';
import 'package:streamshaala/core/constants/route_constants.dart';
import 'package:streamshaala/core/responsive/responsive_builder.dart';
import 'package:streamshaala/core/services/content_index.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/core/extensions/context_extensions.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/domain/entities/user/bookmark.dart';
import 'package:streamshaala/presentation/providers/content/video_provider.dart';
import 'package:streamshaala/presentation/providers/user/bookmark_provider.dart';
import 'package:streamshaala/presentation/screens/video/widgets/video_info_panel.dart';
import 'package:streamshaala/presentation/screens/video/widgets/notes_section.dart';
import 'package:streamshaala/presentation/screens/video/widgets/related_videos.dart';
import 'package:streamshaala/presentation/screens/video/widgets/summary_section.dart';
import 'package:streamshaala/presentation/screens/video/widgets/qa_section.dart';
import 'package:streamshaala/presentation/screens/video/widgets/flashcard_section.dart';
import 'package:streamshaala/presentation/screens/video/widgets/glossary_section.dart';
import 'package:streamshaala/presentation/screens/video/widgets/platform_youtube_player.dart';
import 'package:streamshaala/domain/entities/pedagogy/learning_path_context.dart';
import 'package:streamshaala/presentation/providers/pedagogy/learning_path_provider.dart';
import 'package:streamshaala/presentation/widgets/quiz/quiz_prompt_dialog.dart';
import 'package:streamshaala/presentation/widgets/video/quiz_tab_content.dart';
import 'package:streamshaala/presentation/providers/auth/user_id_provider.dart';

/// Video player state
enum VideoState {
  loading,
  playing,
  paused,
  error,
}

/// Video Player Screen
/// Full-screen video player with notes and related videos
class VideoPlayerScreen extends ConsumerStatefulWidget {
  final String videoId;
  final String? topicId; // Topic ID for quiz loading - passed from navigation
  final LearningPathContext? pathContext; // Optional - only set when viewing from learning path

  const VideoPlayerScreen({
    super.key,
    required this.videoId,
    this.topicId,
    this.pathContext,
  });

  @override
  ConsumerState<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends ConsumerState<VideoPlayerScreen> with WidgetsBindingObserver {
  bool _isFullScreen = false;
  int _selectedTab = 0; // 0: Info, 1: Notes, 2: Quiz (if available), 3: Related

  // Learning path completion tracking
  double _watchedPercentage = 0.0;
  double _currentVideoTime = 0.0; // Current position in seconds for notes
  DateTime? _startTime;
  bool _hasMarkedComplete = false;

  // Quiz prompt tracking
  bool _hasShownQuizPrompt = false;

  // Error handling
  VideoState _videoState = VideoState.loading;
  String? _errorMessage;
  int _retryCount = 0;
  static const int _maxRetries = 3;

  @override
  void initState() {
    super.initState();
    if (widget.pathContext != null) {
      _startTime = DateTime.now();
      WidgetsBinding.instance.addObserver(this); // Track app lifecycle for path context
    }
  }

  @override
  void dispose() {
    if (widget.pathContext != null) {
      WidgetsBinding.instance.removeObserver(this);
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle app going to background while in learning path
    if (widget.pathContext == null) return;

    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      // Save progress when app goes to background
      // The platform youtube player already handles this
    }
  }

  /// Handle video progress updates from the player
  void _onVideoProgress(double currentTime, double duration) {
    if (!mounted) return; // Safety check for async callbacks
    if (duration <= 0) return;

    final percentage = (currentTime / duration) * 100;
    setState(() {
      _watchedPercentage = percentage;
      _currentVideoTime = currentTime;
    });

    // Show quiz prompt at 80% watched (for all videos with topicId)
    if (percentage >= 80 && !_hasShownQuizPrompt) {
      _hasShownQuizPrompt = true;
      _showQuizPromptDialog();
    }

    // Auto-complete at 80% watched (only for learning path context)
    if (widget.pathContext != null && percentage >= 80 && !_hasMarkedComplete) {
      _markVideoComplete(autoCompleted: true);
    }
  }

  /// Get the current video title from provider or content index
  String _getVideoTitle() {
    // Try video provider first
    final videoState = ref.read(videoProvider);
    final video = videoState.getVideoByYoutubeId(widget.videoId);
    if (video != null && video.title.isNotEmpty) {
      return video.title;
    }

    // Fallback to content index
    final contentIndex = ContentIndex();
    final indexedVideo = contentIndex.getVideoByYoutubeId(widget.videoId);
    if (indexedVideo != null && indexedVideo.title.isNotEmpty) {
      return indexedVideo.title;
    }

    return '';
  }

  /// Get the topic ID for quiz navigation
  String? _getTopicId() {
    // First check widget parameter
    if (widget.topicId != null && widget.topicId!.isNotEmpty) {
      return widget.topicId;
    }

    // Try video provider
    final videoState = ref.read(videoProvider);
    final video = videoState.getVideoByYoutubeId(widget.videoId);
    if (video?.topicId != null && video!.topicId!.isNotEmpty) {
      return video.topicId;
    }

    // Fallback to content index
    final contentIndex = ContentIndex();
    final indexedVideo = contentIndex.getVideoByYoutubeId(widget.videoId);
    return indexedVideo?.topicId;
  }

  /// Get the chapter ID for glossary/study tools
  String? _getChapterId() {
    final contentIndex = ContentIndex();

    // First try from video provider
    final videoState = ref.read(videoProvider);
    final video = videoState.getVideoByYoutubeId(widget.videoId);
    if (video != null) {
      final chapter = contentIndex.getParentChapter(video.id);
      if (chapter != null) {
        return chapter.id;
      }
    }

    // Fallback to content index directly
    final indexedVideo = contentIndex.getVideoByYoutubeId(widget.videoId);
    if (indexedVideo != null) {
      final chapter = contentIndex.getParentChapter(indexedVideo.id);
      return chapter?.id;
    }

    return null;
  }

  /// Get the subject ID for study tools context
  String? _getSubjectId() {
    final chapterId = _getChapterId();
    if (chapterId == null) return null;

    final contentIndex = ContentIndex();
    final subject = contentIndex.getParentSubject(chapterId);
    return subject?.id;
  }

  /// Show quiz prompt dialog after video reaches 80%
  void _showQuizPromptDialog() {
    final topicId = _getTopicId();

    // Only show prompt if we have a topic ID for the quiz
    if (topicId == null || topicId.isEmpty) {
      logger.debug('Quiz prompt skipped: No topicId available for video ${widget.videoId}');
      return;
    }

    // Don't show dialog if we're in landscape mode (fullscreen video)
    if (context.isLandscape) {
      // Reset flag so it can show when returning to portrait
      _hasShownQuizPrompt = false;
      return;
    }

    logger.info('Showing quiz prompt for video: ${widget.videoId}, topic: $topicId');

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => QuizPromptDialog(
        videoTitle: _getVideoTitle(),
        onTakeQuiz: () {
          Navigator.of(dialogContext).pop();
          _navigateToQuizFromPrompt(topicId);
        },
        onLater: () {
          Navigator.of(dialogContext).pop();
          // Show a subtle snackbar reminder
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text('You can take the quiz anytime from the menu'),
                  ],
                ),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 3),
                action: SnackBarAction(
                  label: 'Take Now',
                  textColor: Colors.white,
                  onPressed: () => _navigateToQuizFromPrompt(topicId),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  /// Navigate to quiz from the prompt dialog
  void _navigateToQuizFromPrompt(String topicId) {
    final studentId = ref.read(effectiveUserIdProvider);
    final quizPath = RouteConstants.getQuizPath(topicId, studentId);

    logger.info('Navigating to quiz from prompt: $topicId');
    Future.microtask(() {
      if (mounted) {
        context.push(quizPath);
      }
    });
  }

  /// Mark video as complete in the learning path
  Future<void> _markVideoComplete({bool autoCompleted = false}) async {
    if (_hasMarkedComplete) return;
    if (widget.pathContext == null) return;

    setState(() {
      _hasMarkedComplete = true;
    });

    final timeSpent = _startTime != null
        ? DateTime.now().difference(_startTime!).inSeconds
        : 0;

    // Mark node complete in provider
    await ref.read(learningPathProvider.notifier).completeNode(
      nodeId: widget.pathContext!.nodeId,
      score: _watchedPercentage,
      metadata: {
        'type': 'video',
        'watchedPercentage': _watchedPercentage,
        'autoCompleted': autoCompleted,
        'timeSpent': timeSpent,
      },
    );

    // Show success feedback
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              const Text('Video completed!'),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  /// Build "Mark Complete" button for learning path context
  Widget? _buildMarkCompleteButton() {
    if (widget.pathContext == null) return null;

    return FloatingActionButton.extended(
      onPressed: _hasMarkedComplete ? null : () => _markVideoComplete(autoCompleted: false),
      icon: Icon(_hasMarkedComplete ? Icons.check_circle : Icons.check),
      label: Text(_hasMarkedComplete ? 'Completed' : 'Mark Complete'),
      backgroundColor: _hasMarkedComplete ? Colors.green : null,
      tooltip: _hasMarkedComplete
          ? 'Video marked as complete'
          : 'Mark this video as complete for your learning path',
    );
  }

  /// Handle video loading error
  void _onVideoError(dynamic error) {
    if (!mounted) return; // Safety check for async callbacks
    logger.error('Video load failed for ${widget.videoId}', error);

    setState(() {
      _videoState = VideoState.error;
      _errorMessage = 'Could not load video. Please check your connection and try again.';
    });

    // Show error dialog if in learning path context
    if (widget.pathContext != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showErrorDialog();
        }
      });
    }
  }

  /// Show error dialog with retry and skip options
  void _showErrorDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber, color: Colors.orange),
            const SizedBox(width: 8),
            const Text('Video Unavailable'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_errorMessage ?? 'We couldn\'t load this video right now.'),
            const SizedBox(height: 16),
            if (_retryCount < _maxRetries)
              Text(
                'Retry attempt: ${_retryCount + 1}/$_maxRetries',
                style: TextStyle(
                  fontSize: 12,
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
        actions: [
          if (_retryCount < _maxRetries)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _retryVideoLoad();
              },
              child: const Text('Retry'),
            ),
          if (widget.pathContext != null)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _skipVideo();
              },
              child: const Text('Skip Video'),
            ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Return to path
            },
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  /// Retry loading the video
  void _retryVideoLoad() {
    logger.info('Retrying video load (attempt ${_retryCount + 1})');

    setState(() {
      _retryCount++;
      _videoState = VideoState.loading;
      _errorMessage = null;
    });

    // The player will automatically retry with a new widget build
  }

  /// Skip the video in learning path context
  void _skipVideo() {
    if (widget.pathContext == null) return;

    logger.info('Skipping video ${widget.videoId} due to error');

    // Navigate first, then update state after navigation completes
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Video skipped - you can return later to watch'),
        duration: Duration(seconds: 3),
      ),
    );

    Navigator.pop(context);

    // Mark as complete with 'skipped' metadata AFTER navigation completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(learningPathProvider.notifier).completeNode(
        nodeId: widget.pathContext!.nodeId,
        metadata: {
          'type': 'video',
          'skipped': true,
          'reason': 'video_unavailable',
          'errorMessage': _errorMessage,
        },
      );
    });
  }

  /// Handle video ready state
  void _onVideoReady() {
    if (!mounted) return; // Safety check for async callbacks
    setState(() {
      _videoState = VideoState.playing;
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Wrap with PopScope to return completion result when navigating back
    return PopScope(
      canPop: widget.pathContext == null,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) return;

        // Return completion result if in path context
        if (widget.pathContext != null) {
          final timeSpent = _startTime != null
              ? DateTime.now().difference(_startTime!).inSeconds
              : 0;

          Navigator.pop(
            context,
            CompletionResult.video(
              nodeId: widget.pathContext!.nodeId,
              watchedPercentage: _watchedPercentage,
              timeSpent: timeSpent,
              autoCompleted: _hasMarkedComplete,
            ),
          );
        }
      },
      child: ResponsiveBuilder(
        builder: (context, deviceType) {
          switch (deviceType) {
            case DeviceType.mobile:
              return _buildMobileLayout();
            case DeviceType.tablet:
              return _buildTabletLayout();
            case DeviceType.desktop:
              return _buildDesktopLayout();
          }
        },
      ),
    );
  }

  Widget _buildMobileLayout() {
    final bookmarkState = ref.watch(bookmarkProvider);
    final isBookmarked = bookmarkState.bookmarks.any((b) => b.videoId == widget.videoId);
    final isLandscape = context.isLandscape;

    // In landscape mode, always show fullscreen video without any UI chrome
    if (isLandscape) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Fullscreen video - fills entire screen
            PlatformYoutubePlayer(
              videoId: widget.videoId,
              autoPlay: true,
              useAspectRatio: false,
              onFullscreenChanged: (isFullscreen) {
                setState(() {
                  _isFullScreen = isFullscreen;
                });
              },
              onProgress: _onVideoProgress,
            ),

            // Back button overlay in top-left corner
            Positioned(
              top: 8 + MediaQuery.of(context).padding.top,
              left: 8,
              child: Material(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(24),
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(24),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Portrait mode - scrollable layout with tabs
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Player'),
        actions: [
          IconButton(
            onPressed: _toggleBookmark,
            icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
            tooltip: isBookmarked ? 'Remove Bookmark' : 'Bookmark',
          ),
          IconButton(
            onPressed: _shareVideo,
            icon: const Icon(Icons.share),
            tooltip: 'Share',
          ),
          IconButton(
            onPressed: _startQuiz,
            icon: const Icon(Icons.quiz_outlined),
            tooltip: 'Take Quiz',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Video Player - Fixed at top
              AspectRatio(
                aspectRatio: 16 / 9,
                child: PlatformYoutubePlayer(
                  videoId: widget.videoId,
                  autoPlay: true,
                  onFullscreenChanged: (isFullscreen) {
                    setState(() {
                      _isFullScreen = isFullscreen;
                    });
                  },
                  onProgress: _onVideoProgress,
                ),
              ),

              // Tabs - Fixed below video
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: context.colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildTab('Info', 0),
                      _buildTab('Summary', 1),
                      _buildTab('Notes', 2),
                      if (!SegmentConfig.isJunior) _buildTab('Q&A', 3),
                      _buildTab('Cards', _getCardsTabIndex()),
                      _buildTab('Glossary', _getGlossaryTabIndex()),
                      if (_getTopicId() != null) _buildTab('Quiz', _getQuizTabIndex()),
                      _buildTab('Related', _getRelatedTabIndex()),
                    ],
                  ),
                ),
              ),

              // Tab Content - Scrollable content
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: _buildTabContent(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildMarkCompleteButton(),
    );
  }

  Widget _buildTabletLayout() {
    final bookmarkState = ref.watch(bookmarkProvider);
    final isBookmarked = bookmarkState.bookmarks.any((b) => b.videoId == widget.videoId);

    return Scaffold(
      appBar: _isFullScreen ? null : AppBar(
        title: const Text('Video Player'),
        actions: [
          IconButton(
            onPressed: _toggleBookmark,
            icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
            tooltip: isBookmarked ? 'Remove Bookmark' : 'Bookmark',
          ),
          IconButton(
            onPressed: _shareVideo,
            icon: const Icon(Icons.share),
            tooltip: 'Share',
          ),
          IconButton(
            onPressed: _startQuiz,
            icon: const Icon(Icons.quiz_outlined),
            tooltip: 'Take Quiz',
          ),
        ],
      ),
      body: Column(
        children: [
          // Video Player
          AspectRatio(
            aspectRatio: 16 / 9,
            child: PlatformYoutubePlayer(
              videoId: widget.videoId,
              autoPlay: true,
              onProgress: _onVideoProgress,
            ),
          ),

          // Content below video
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: Info, Notes, and Quiz
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      // Tabs
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: context.colorScheme.outline.withValues(alpha: 0.2),
                            ),
                          ),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildTab('Info', 0),
                              _buildTab('Summary', 1),
                              _buildTab('Notes', 2),
                              if (!SegmentConfig.isJunior) _buildTab('Q&A', 3),
                              _buildTab('Cards', _getCardsTabIndex()),
                              _buildTab('Glossary', _getGlossaryTabIndex()),
                              if (_getTopicId() != null) _buildTab('Quiz', _getQuizTabIndex()),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: _buildTabletTabContent(),
                      ),
                    ],
                  ),
                ),

                // Right: Related Videos
                SizedBox(
                  width: 320,
                  child: const RelatedVideos(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    final bookmarkState = ref.watch(bookmarkProvider);
    final isBookmarked = bookmarkState.bookmarks.any((b) => b.videoId == widget.videoId);

    return Scaffold(
      appBar: _isFullScreen ? null : AppBar(
        title: const Text('Video Player'),
        actions: [
          IconButton(
            onPressed: _toggleBookmark,
            icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
            tooltip: isBookmarked ? 'Remove Bookmark' : 'Bookmark',
          ),
          IconButton(
            onPressed: _shareVideo,
            icon: const Icon(Icons.share),
            tooltip: 'Share',
          ),
          IconButton(
            onPressed: _startQuiz,
            icon: const Icon(Icons.quiz_outlined),
            tooltip: 'Take Quiz',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1600),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: Video and Info/Notes
              Expanded(
                flex: 7,
                child: Column(
                  children: [
                    // Video Player
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        color: Colors.black,
                        child: PlatformYoutubePlayer(
                          videoId: widget.videoId,
                          autoPlay: true,
                          onProgress: _onVideoProgress,
                        ),
                      ),
                    ),

                    // Tabs and Content
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: context.colorScheme.outline.withValues(alpha: 0.2),
                                ),
                              ),
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _buildTab('Info', 0),
                                  _buildTab('Summary', 1),
                                  _buildTab('Notes', 2),
                                  if (!SegmentConfig.isJunior) _buildTab('Q&A', 3),
                                  _buildTab('Cards', _getCardsTabIndex()),
                                  _buildTab('Glossary', _getGlossaryTabIndex()),
                                  if (_getTopicId() != null) _buildTab('Quiz', _getQuizTabIndex()),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: _buildTabletTabContent(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Right: Related Videos Sidebar
              SizedBox(
                width: 380,
                child: const RelatedVideos(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Get tab index for Cards tab (varies based on whether Q&A is shown)
  int _getCardsTabIndex() {
    // Info=0, Summary=1, Notes=2, Q&A=3 (if not Junior), Cards=3 or 4
    return SegmentConfig.isJunior ? 3 : 4;
  }

  /// Get tab index for Glossary tab
  int _getGlossaryTabIndex() {
    // Cards index + 1
    return _getCardsTabIndex() + 1;
  }

  /// Get tab index for Quiz tab (varies based on segment and topic availability)
  int _getQuizTabIndex() {
    // Glossary index + 1
    return _getGlossaryTabIndex() + 1;
  }

  /// Get tab index for Related tab (last tab)
  int _getRelatedTabIndex() {
    final hasQuizTab = _getTopicId() != null;
    return hasQuizTab ? _getQuizTabIndex() + 1 : _getGlossaryTabIndex() + 1;
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTab == index;
    return InkWell(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingLg,
          vertical: AppTheme.spacingMd,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected
                  ? context.colorScheme.primary
                  : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected
                ? context.colorScheme.primary
                : context.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    final hasQuizTab = _getTopicId() != null;
    final cardsIndex = _getCardsTabIndex();
    final glossaryIndex = _getGlossaryTabIndex();
    final quizIndex = _getQuizTabIndex();
    final relatedIndex = _getRelatedTabIndex();

    switch (_selectedTab) {
      case 0:
        return const VideoInfoPanel();
      case 1:
        return SummarySection(videoId: widget.videoId);
      case 2:
        return NotesSection(getCurrentTimestamp: () => _currentVideoTime);
      case 3:
        // Q&A tab (only shown for non-Junior segments)
        if (!SegmentConfig.isJunior) {
          return QASection(videoId: widget.videoId);
        }
        // For Junior, index 3 is Cards
        return FlashcardSection(topicId: _getTopicId());
      default:
        // Dynamic tabs based on segment
        if (_selectedTab == cardsIndex) {
          return FlashcardSection(topicId: _getTopicId());
        }
        if (_selectedTab == glossaryIndex) {
          return GlossarySection(
            chapterId: _getChapterId(),
            subjectId: _getSubjectId(),
          );
        }
        if (hasQuizTab && _selectedTab == quizIndex) {
          return QuizTabContent(
            topicId: _getTopicId()!,
            topicName: _getVideoTitle(),
            onStartQuiz: _startQuiz,
          );
        }
        if (_selectedTab == relatedIndex) {
          return const RelatedVideos();
        }
        return const SizedBox();
    }
  }

  /// Build tab content for tablet layout (without Related Videos as a tab)
  Widget _buildTabletTabContent() {
    final hasQuizTab = _getTopicId() != null;
    final cardsIndex = _getCardsTabIndex();
    final glossaryIndex = _getGlossaryTabIndex();
    final quizIndex = _getQuizTabIndex();

    switch (_selectedTab) {
      case 0:
        return const VideoInfoPanel();
      case 1:
        return SummarySection(videoId: widget.videoId);
      case 2:
        return NotesSection(getCurrentTimestamp: () => _currentVideoTime);
      case 3:
        // Q&A tab (only shown for non-Junior segments)
        if (!SegmentConfig.isJunior) {
          return QASection(videoId: widget.videoId);
        }
        // For Junior, index 3 is Cards
        return FlashcardSection(topicId: _getTopicId());
      default:
        // Dynamic tabs based on segment
        if (_selectedTab == cardsIndex) {
          return FlashcardSection(topicId: _getTopicId());
        }
        if (_selectedTab == glossaryIndex) {
          return GlossarySection(
            chapterId: _getChapterId(),
            subjectId: _getSubjectId(),
          );
        }
        if (hasQuizTab && _selectedTab == quizIndex) {
          return QuizTabContent(
            topicId: _getTopicId()!,
            topicName: _getVideoTitle(),
            onStartQuiz: _startQuiz,
          );
        }
        return const VideoInfoPanel(); // Fallback
    }
  }

  void _toggleBookmark() {
    final bookmarkState = ref.read(bookmarkProvider);
    final isBookmarked = bookmarkState.bookmarks.any((b) => b.videoId == widget.videoId);

    if (isBookmarked) {
      // Remove bookmark
      ref.read(bookmarkProvider.notifier).removeBookmark(widget.videoId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bookmark removed'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // Add bookmark
      final videoTitle = _getVideoTitle();
      final bookmark = Bookmark(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        videoId: widget.videoId,
        title: videoTitle.isNotEmpty ? videoTitle : 'Video ${widget.videoId}',
        createdAt: DateTime.now(),
      );
      ref.read(bookmarkProvider.notifier).addBookmark(bookmark);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Video bookmarked'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _shareVideo() {
    final videoUrl = 'https://youtube.com/watch?v=${widget.videoId}';
    final title = _getVideoTitle();
    final videoTitle = title.isNotEmpty ? title : 'Video ${widget.videoId}';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Share Video'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              videoTitle,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingSm),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              ),
              child: SelectableText(
                videoUrl,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                    ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingSm),
            Text(
              'Copy this link to share with others',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          FilledButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: videoUrl));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Link copied to clipboard'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: const Icon(Icons.copy, size: 18),
            label: const Text('Copy Link'),
          ),
        ],
      ),
    );
  }

  void _startQuiz() {
    // Get topicId either from widget parameter or video provider or content index
    String? topicId = widget.topicId;

    // Fallback 1: Try to look it up from video provider (current topic's videos)
    if (topicId == null || topicId.isEmpty) {
      final videoState = ref.read(videoProvider);
      final video = videoState.getVideoByYoutubeId(widget.videoId);
      topicId = video?.topicId;
    }

    // Fallback 2: Try to look it up from global ContentIndex (all indexed videos)
    if (topicId == null || topicId.isEmpty) {
      final contentIndex = ContentIndex();
      final video = contentIndex.getVideoByYoutubeId(widget.videoId);
      topicId = video?.topicId;
      if (topicId != null) {
        logger.debug('Found topicId from ContentIndex: $topicId');
      }
    }

    if (topicId == null || topicId.isEmpty) {
      logger.warning('Cannot start quiz: topicId not available for video: ${widget.videoId}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to load quiz. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Navigate to quiz screen using topicId
    // Videos have quizzes at the topic level, not individual video level
    final studentId = ref.read(effectiveUserIdProvider);
    final quizPath = RouteConstants.getQuizPath(topicId, studentId);

    logger.info('Starting quiz for topic: $topicId (video: ${widget.videoId})');
    Future.microtask(() {
      context.push(quizPath);
    });
  }
}
