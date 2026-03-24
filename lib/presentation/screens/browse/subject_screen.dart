import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:crack_the_code/core/config/segment_config.dart';
import 'package:crack_the_code/core/constants/route_constants.dart';
import 'package:crack_the_code/core/responsive/responsive_builder.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/core/extensions/context_extensions.dart';
import 'package:crack_the_code/core/widgets/cards/subject_card.dart';
import 'package:crack_the_code/core/widgets/error/error_state_widget.dart';
import 'package:crack_the_code/core/widgets/empty/empty_state_widget.dart';
import 'package:crack_the_code/presentation/screens/browse/widgets/breadcrumb_bar.dart';
import 'package:crack_the_code/presentation/providers/content/subject_provider.dart';
import 'package:crack_the_code/presentation/providers/content/board_provider.dart';
import 'package:crack_the_code/core/utils/logger.dart';
import 'package:crack_the_code/presentation/providers/auth/user_id_provider.dart';
import 'package:crack_the_code/presentation/providers/user/subject_progress_provider.dart';

/// Subject List Screen
/// Displays subjects for a selected board
class SubjectScreen extends ConsumerStatefulWidget {
  final String boardId;
  final String? classId;
  final String? streamId;

  const SubjectScreen({
    super.key,
    required this.boardId,
    this.classId,
    this.streamId,
  });

  @override
  ConsumerState<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends ConsumerState<SubjectScreen> {
  bool _isGridView = true;

  @override
  void initState() {
    super.initState();

    logger.info('SubjectScreen.initState: boardId=${widget.boardId}, classId=${widget.classId}, streamId=${widget.streamId}');

    // Load subjects on screen init
    Future.microtask(() async {
      try {
        logger.debug('SubjectScreen: Loading subjects in Future.microtask');

        var boardState = ref.read(boardProvider);
        logger.debug('SubjectScreen: boardState loaded, boards.length=${boardState.boards.length}');

        // CRITICAL FIX: Load boards if empty (happens when navigating from search → video → subject)
        if (boardState.boards.isEmpty) {
          logger.warning('SubjectScreen: Boards not loaded, loading now...');

          // Show loading state while boards load
          final currentSubjectState = ref.read(subjectProvider);
          ref.read(subjectProvider.notifier).state = currentSubjectState.copyWith(
            isLoading: true,
            error: null,
          );

          await ref.read(boardProvider.notifier).loadBoards();
          boardState = ref.read(boardProvider);
          logger.info('SubjectScreen: Boards loaded, count=${boardState.boards.length}');

          // ERROR PROPAGATION: Show error to user instead of silent failure
          if (boardState.boards.isEmpty) {
            logger.error('SubjectScreen: Still no boards available after loading!');
            ref.read(subjectProvider.notifier).state = currentSubjectState.copyWith(
              isLoading: false,
              error: 'Unable to load boards. Please check your connection and try again.',
            );
            return;
          }

          // Reset loading state after boards loaded successfully
          ref.read(subjectProvider.notifier).state = currentSubjectState.copyWith(
            isLoading: false,
            error: null,
          );
        }

        if (boardState.boards.isEmpty) {
          logger.error('SubjectScreen: No boards available!');
          final currentSubjectState = ref.read(subjectProvider);
          ref.read(subjectProvider.notifier).state = currentSubjectState.copyWith(
            isLoading: false,
            error: 'No boards available. Please try again later.',
          );
          return;
        }
        final board = boardState.boards.firstWhere(
          (b) => b.id == widget.boardId,
          orElse: () {
            logger.warning('SubjectScreen: Board ${widget.boardId} not found, using first board');
            return boardState.boards.first;
          },
        );

        logger.debug('SubjectScreen: Found board ${board.id}, classes.length=${board.classes.length}');

        // ERROR PROPAGATION: Show error to user instead of silent failure
        if (board.classes.isEmpty) {
          logger.error('SubjectScreen: No classes available for board ${board.id}!');
          final currentSubjectState = ref.read(subjectProvider);
          ref.read(subjectProvider.notifier).state = currentSubjectState.copyWith(
            isLoading: false,
            error: 'This board has no classes available. Please select a different board.',
          );
          return;
        }

        // Use provided classId/streamId or defaults from first class/stream
        final classId = widget.classId ?? board.classes.first.id;
        final firstClass = board.classes.firstWhere(
          (c) => c.id == classId,
          orElse: () => board.classes.first,
        );

        // Check if streams are available
        if (firstClass.streams.isEmpty) {
          logger.error('SubjectScreen: No streams available for class ${firstClass.id}!');
          final currentSubjectState = ref.read(subjectProvider);
          ref.read(subjectProvider.notifier).state = currentSubjectState.copyWith(
            isLoading: false,
            error: 'This class has no streams available. Please select a different class.',
          );
          return;
        }
        final streamId = widget.streamId ?? firstClass.streams.first.id;

        logger.info('SubjectScreen: Loading subjects for boardId=${ widget.boardId}, classId=$classId, streamId=$streamId');

        ref.read(subjectProvider.notifier).loadSubjects(
          boardId: widget.boardId,
          classId: classId,
          streamId: streamId,
        );
      } catch (e, stackTrace) {
        logger.error('SubjectScreen.initState error: $e\n$stackTrace');

        // ERROR PROPAGATION: Show error to user instead of silent failure
        final currentSubjectState = ref.read(subjectProvider);
        ref.read(subjectProvider.notifier).state = currentSubjectState.copyWith(
          isLoading: false,
          error: 'Failed to load subjects: ${e.toString()}',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final subjectState = ref.watch(subjectProvider);

    // Loading state (first load)
    if (subjectState.isLoading && subjectState.subjects.isEmpty) {
      return Scaffold(
        body: CustomScrollView(
          slivers: [
            _buildSliverAppBar(showLoading: true),
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      );
    }

    // Error state
    if (subjectState.error != null && subjectState.subjects.isEmpty) {
      return Scaffold(
        body: CustomScrollView(
          slivers: [
            _buildSliverAppBar(),
            SliverFillRemaining(
              child: ErrorStateWidget(
                message: subjectState.error!,
                onRetry: () => ref.read(subjectProvider.notifier).refresh(),
              ),
            ),
          ],
        ),
      );
    }

    // CRITICAL FIX: Empty state (no subjects loaded but no error/loading)
    // This happens when initState fails silently or data loading is incomplete
    if (subjectState.subjects.isEmpty && !subjectState.isLoading) {
      return Scaffold(
        body: CustomScrollView(
          slivers: [
            _buildSliverAppBar(),
            SliverFillRemaining(
              child: EmptyStateWidget(
                icon: Icons.school_outlined,
                title: 'No Subjects Available',
                message: 'Unable to load subjects for this board.\nPlease try selecting a different board or check your connection.',
              ),
            ),
          ],
        ),
      );
    }

    // Success state
    return ResponsiveBuilder(
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
    );
  }

  Widget _buildMobileLayout() {
    final subjectState = ref.watch(subjectProvider);
    final settings = SegmentConfig.settings;
    final spacing = AppTheme.spacingMd * settings.touchTargetScale;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
        onRefresh: () => ref.read(subjectProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            _buildSliverAppBar(showLoading: subjectState.isLoading),
            // Simplified breadcrumbs for Junior (no board selection)
            if (!settings.simplifiedBrowseHierarchy)
              SliverToBoxAdapter(
                child: BreadcrumbBar(
                  items: [
                    BreadcrumbItem(label: 'Boards', onTap: () => context.go('/browse')),
                    BreadcrumbItem(label: widget.boardId.toUpperCase()),
                  ],
                ),
              )
            else
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: spacing,
                    vertical: spacing / 2,
                  ),
                  child: Text(
                    'Pick a subject to learn!',
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: context.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                spacing,
                spacing,
                spacing,
                80 + spacing, // Navigation bar height (80) + spacing
              ),
              sliver: _isGridView
                  ? _buildGridView(2, subjectState.subjects)
                  : _buildListView(subjectState.subjects),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildTabletLayout() {
    final subjectState = ref.watch(subjectProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
        onRefresh: () => ref.read(subjectProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            _buildSliverAppBar(showLoading: subjectState.isLoading),
            SliverToBoxAdapter(
              child: BreadcrumbBar(
                items: [
                  BreadcrumbItem(label: 'Boards', onTap: () => context.go('/browse')),
                  BreadcrumbItem(label: widget.boardId.toUpperCase()),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppTheme.spacingLg,
                AppTheme.spacingLg,
                AppTheme.spacingLg,
                80 + AppTheme.spacingLg, // Navigation bar height (80) + spacing
              ),
              sliver: _isGridView
                  ? _buildGridView(3, subjectState.subjects)
                  : _buildListView(subjectState.subjects),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    final subjectState = ref.watch(subjectProvider);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
        onRefresh: () => ref.read(subjectProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            _buildSliverAppBar(showLoading: subjectState.isLoading),
            SliverToBoxAdapter(
              child: BreadcrumbBar(
                items: [
                  BreadcrumbItem(label: 'Boards', onTap: () => context.go('/browse')),
                  BreadcrumbItem(label: widget.boardId.toUpperCase()),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppTheme.spacingXl,
                AppTheme.spacingLg,
                AppTheme.spacingXl,
                100, // Bottom navigation bar + extra spacing
              ),
              sliver: SliverToBoxAdapter(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1400),
                    child: _isGridView
                        ? _buildDesktopGrid(subjectState.subjects)
                        : _buildDesktopList(subjectState.subjects),
                  ),
                ),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildGridView(int columns, List subjects) {
    final settings = SegmentConfig.settings;
    final spacing = AppTheme.spacingMd * settings.touchTargetScale;
    // Junior gets larger cards (lower aspect ratio = taller cards)
    final aspectRatio = SegmentConfig.isCrackTheCode ? 0.75 : 0.85;

    // Watch subject progress and convert to Map for O(1) lookups
    final subjectProgressAsync = ref.watch(subjectProgressListProvider);
    final progressMap = subjectProgressAsync.when(
      data: (progressList) => {for (var p in progressList) p.subjectId: p.progressPercentage},
      loading: () => <String, double>{},
      error: (_, __) => <String, double>{},
    );

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        childAspectRatio: aspectRatio,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final subject = subjects[index];

          // O(1) lookup from progress map
          final progress = progressMap[subject.id] ?? 0.0;

          return SubjectCard(
            name: subject.name,
            icon: SubjectColors.getSubjectIcon(subject.name),
            color: SubjectColors.getSubjectColor(subject.name),
            chapterCount: subject.totalChapters,
            progress: progress,
            onTap: () => _onSubjectSelected(subject.id),
            onQuizTap: () => _onQuizTap(subject.id, subject.name),
            onPreAssessmentTap: () => _onReadinessQuizTap(subject.id, subject.name),
          );
        },
        childCount: subjects.length,
      ),
    );
  }

  Widget _buildListView(List subjects) {
    // Watch subject progress and convert to Map for O(1) lookups
    final subjectProgressAsync = ref.watch(subjectProgressListProvider);
    final progressMap = subjectProgressAsync.when(
      data: (progressList) => {for (var p in progressList) p.subjectId: p.progressPercentage},
      loading: () => <String, double>{},
      error: (_, __) => <String, double>{},
    );

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final subject = subjects[index];

          // O(1) lookup from progress map
          final progress = progressMap[subject.id] ?? 0.0;

          return SubjectListTile(
            name: subject.name,
            icon: SubjectColors.getSubjectIcon(subject.name),
            color: SubjectColors.getSubjectColor(subject.name),
            chapterCount: subject.totalChapters,
            progress: progress,
            onTap: () => _onSubjectSelected(subject.id),
            onQuizTap: () => _onQuizTap(subject.id, subject.name),
            onPreAssessmentTap: () => _onReadinessQuizTap(subject.id, subject.name),
          );
        },
        childCount: subjects.length,
      ),
    );
  }

  Widget _buildDesktopGrid(List subjects) {
    // Watch subject progress and convert to Map for O(1) lookups
    final subjectProgressAsync = ref.watch(subjectProgressListProvider);
    final progressMap = subjectProgressAsync.when(
      data: (progressList) => {for (var p in progressList) p.subjectId: p.progressPercentage},
      loading: () => <String, double>{},
      error: (_, __) => <String, double>{},
    );

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.9,
        crossAxisSpacing: AppTheme.spacingLg,
        mainAxisSpacing: AppTheme.spacingLg,
      ),
      itemCount: subjects.length,
      itemBuilder: (context, index) {
        final subject = subjects[index];

        // O(1) lookup from progress map
        final progress = progressMap[subject.id] ?? 0.0;

        return SubjectCard(
          name: subject.name,
          icon: SubjectColors.getSubjectIcon(subject.name),
          color: SubjectColors.getSubjectColor(subject.name),
          chapterCount: subject.totalChapters,
          progress: progress,
          onTap: () => _onSubjectSelected(subject.id),
          onQuizTap: () => _onQuizTap(subject.id, subject.name),
          onPreAssessmentTap: () => _onReadinessQuizTap(subject.id, subject.name),
        );
      },
    );
  }

  Widget _buildDesktopList(List subjects) {
    // Watch subject progress and convert to Map for O(1) lookups
    final subjectProgressAsync = ref.watch(subjectProgressListProvider);
    final progressMap = subjectProgressAsync.when(
      data: (progressList) => {for (var p in progressList) p.subjectId: p.progressPercentage},
      loading: () => <String, double>{},
      error: (_, __) => <String, double>{},
    );

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: subjects.length,
      itemBuilder: (context, index) {
        final subject = subjects[index];

        // O(1) lookup from progress map
        final progress = progressMap[subject.id] ?? 0.0;

        return SubjectListTile(
          name: subject.name,
          icon: SubjectColors.getSubjectIcon(subject.name),
          color: SubjectColors.getSubjectColor(subject.name),
          chapterCount: subject.totalChapters,
          progress: progress,
          onTap: () => _onSubjectSelected(subject.id),
          onQuizTap: () => _onQuizTap(subject.id, subject.name),
          onPreAssessmentTap: () => _onReadinessQuizTap(subject.id, subject.name),
        );
      },
    );
  }

  SliverAppBar _buildSliverAppBar({bool showLoading = false}) {
    final settings = SegmentConfig.settings;
    final isJunior = SegmentConfig.isCrackTheCode;

    return SliverAppBar(
      floating: true,
      snap: true,
      toolbarHeight: isJunior ? 64 : 56,
      title: Row(
        children: [
          if (isJunior) ...[
            Icon(
              Icons.menu_book,
              color: context.colorScheme.primary,
              size: 28,
            ),
            const SizedBox(width: 8),
          ],
          Text(
            isJunior ? 'My Subjects' : 'Subjects',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: isJunior ? 22 : 20,
            ),
          ),
          if (showLoading) ...[
            const SizedBox(width: 12),
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ],
        ],
      ),
      actions: [
        // Hide view toggle for Junior (always grid)
        if (!settings.simplifiedBrowseHierarchy)
          IconButton(
            onPressed: () => setState(() => _isGridView = !_isGridView),
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            tooltip: _isGridView ? 'List View' : 'Grid View',
          ),
        // Hide filter for Junior
        if (!settings.simplifiedBrowseHierarchy)
          IconButton(
            onPressed: () {
              // TODO: Filter subjects
            },
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter',
          ),
        const SizedBox(width: 8),
      ],
    );
  }

  void _onSubjectSelected(String subjectId) {
    logger.info('SubjectScreen: Subject selected: $subjectId');

    // Navigate after frame to avoid Navigator deadlock
    Future.microtask(() {
      final path = '/browse/board/${widget.boardId}/subject/$subjectId/chapters';
      logger.debug('SubjectScreen: Navigating to $path');

      try {
        context.push(path);
        logger.debug('SubjectScreen: Navigation successful');
      } catch (e, stackTrace) {
        logger.error('SubjectScreen: Navigation error: $e\n$stackTrace');
      }
    });
  }

  void _onQuizTap(String subjectId, String subjectName) {
    // Navigate after frame to avoid provider mutation during build
    Future.microtask(() {
      final studentId = ref.read(effectiveUserIdProvider);
      context.push('/quiz/$subjectId/$studentId');
    });
  }

  void _onReadinessQuizTap(String subjectId, String subjectName) {
    logger.info('SubjectScreen: Readiness quiz selected for: $subjectName ($subjectId)');

    // Navigate after frame to avoid provider mutation during build
    Future.microtask(() {
      final studentId = ref.read(effectiveUserIdProvider);
      final quizPath = RouteConstants.getQuizPathWithType(
        subjectId,
        studentId,
        assessmentType: 'readiness',
      );

      logger.debug('SubjectScreen: Navigating to readiness quiz: $quizPath');

      try {
        context.push(quizPath);
        logger.debug('SubjectScreen: Readiness quiz navigation successful');
      } catch (e, stackTrace) {
        logger.error('SubjectScreen: Readiness quiz navigation error: $e\n$stackTrace');
      }
    });
  }
}
