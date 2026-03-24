import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:crack_the_code/core/responsive/responsive_builder.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/core/extensions/context_extensions.dart';
import 'package:crack_the_code/core/widgets/error/error_state_widget.dart';
import 'package:crack_the_code/core/widgets/empty/empty_state_widget.dart';
import 'package:crack_the_code/presentation/providers/content/board_provider.dart';
import 'package:crack_the_code/presentation/screens/browse/widgets/board_card.dart';
import 'package:crack_the_code/core/utils/logger.dart';

/// Board Selection Screen
/// Displays available educational boards (CBSE, State boards, etc.)
class BoardScreen extends ConsumerStatefulWidget {
  const BoardScreen({super.key});

  @override
  ConsumerState<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends ConsumerState<BoardScreen> {
  @override
  void initState() {
    super.initState();
    // Load boards on screen init
    Future.microtask(() {
      ref.read(boardProvider.notifier).loadBoards();
    });
  }

  @override
  Widget build(BuildContext context) {
    final boardState = ref.watch(boardProvider);

    // Loading state (first load)
    if (boardState.isLoading && boardState.boards.isEmpty) {
      return Scaffold(
        body: CustomScrollView(
          slivers: [
            _buildSliverAppBar(),
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      );
    }

    // Error state (no data)
    if (boardState.error != null && boardState.boards.isEmpty) {
      return Scaffold(
        body: CustomScrollView(
          slivers: [
            _buildSliverAppBar(),
            SliverFillRemaining(
              child: ErrorStateWidget(
                message: boardState.error!,
                onRetry: () => ref.read(boardProvider.notifier).refresh(),
              ),
            ),
          ],
        ),
      );
    }

    // Empty state
    if (boardState.boards.isEmpty) {
      return Scaffold(
        body: CustomScrollView(
          slivers: [
            _buildSliverAppBar(),
            const SliverFillRemaining(
              child: EmptyStateWidget(
                icon: Icons.school_outlined,
                title: 'No Boards',
                message: 'No educational boards available',
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
    final boardState = ref.watch(boardProvider);
    final boards = boardState.boards;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
        onRefresh: () => ref.read(boardProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            _buildSliverAppBar(showLoading: boardState.isLoading),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppTheme.spacingMd,
                AppTheme.spacingMd,
                AppTheme.spacingMd,
                80 + AppTheme.spacingMd, // Navigation bar height (80) + spacing
              ),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: AppTheme.spacingMd,
                  mainAxisSpacing: AppTheme.spacingMd,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final board = boards[index];
                    return BoardCard(
                      name: board.name,
                      fullName: board.description,
                      icon: Icons.school,
                      color: const Color(0xFF2196F3),
                      studentCount: 0,
                      classRange: 'Class 1-12',
                      onTap: () => _onBoardSelected(board.id),
                    );
                  },
                  childCount: boards.length,
                ),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildTabletLayout() {
    final boardState = ref.watch(boardProvider);
    final boards = boardState.boards;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
        onRefresh: () => ref.read(boardProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            _buildSliverAppBar(showLoading: boardState.isLoading),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppTheme.spacingLg,
                AppTheme.spacingLg,
                AppTheme.spacingLg,
                80 + AppTheme.spacingLg, // Navigation bar height (80) + spacing
              ),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.9,
                  crossAxisSpacing: AppTheme.spacingLg,
                  mainAxisSpacing: AppTheme.spacingLg,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final board = boards[index];
                    return BoardCard(
                      name: board.name,
                      fullName: board.description,
                      icon: Icons.school,
                      color: const Color(0xFF4CAF50),
                      studentCount: 0,
                      classRange: 'Class 1-12',
                      onTap: () => _onBoardSelected(board.id),
                    );
                  },
                  childCount: boards.length,
                ),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    final boardState = ref.watch(boardProvider);
    final boards = boardState.boards;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
        onRefresh: () => ref.read(boardProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            _buildSliverAppBar(showLoading: boardState.isLoading),
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
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 0.95,
                        crossAxisSpacing: AppTheme.spacingLg,
                        mainAxisSpacing: AppTheme.spacingLg,
                      ),
                      itemCount: boards.length,
                      itemBuilder: (context, index) {
                        final board = boards[index];
                        return BoardCard(
                          name: board.name,
                          fullName: board.description,
                          icon: Icons.school,
                          color: const Color(0xFFFF9800),
                          studentCount: 0,
                          classRange: 'Class 1-12',
                          onTap: () => _onBoardSelected(board.id),
                        );
                      },
                    ),
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

  SliverAppBar _buildSliverAppBar({bool showLoading = false}) {
    return SliverAppBar(
      floating: true,
      snap: true,
      title: Row(
        children: [
          Icon(
            Icons.explore,
            color: context.colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            'Select Your Board',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        if (showLoading)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
        else
          IconButton(
            onPressed: () {
              // TODO: Open filter/sort options
            },
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter',
          ),
        const SizedBox(width: 8),
      ],
    );
  }

  void _onBoardSelected(String boardId) {
    logger.info('BoardScreen: Board selected: $boardId');

    // Navigate after frame to avoid Navigator deadlock
    Future.microtask(() {
      final path = '/browse/board/$boardId/subjects';
      logger.debug('BoardScreen: Navigating to $path');

      try {
        context.push(path);
        logger.debug('BoardScreen: Navigation initiated successfully');
      } catch (e, stackTrace) {
        logger.error('BoardScreen: Navigation error: $e\n$stackTrace');
      }
    });
  }
}
