import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamshaala/core/responsive/responsive_builder.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/core/extensions/context_extensions.dart';
import 'package:streamshaala/core/widgets/cards/video_card.dart';

/// Collection Detail Screen
/// Shows videos in a specific collection
class CollectionDetailScreen extends ConsumerStatefulWidget {
  final String collectionId;

  const CollectionDetailScreen({
    super.key,
    required this.collectionId,
  });

  @override
  ConsumerState<CollectionDetailScreen> createState() => _CollectionDetailScreenState();
}

class _CollectionDetailScreenState extends ConsumerState<CollectionDetailScreen> {
  bool _isGridView = true;

  // Mock collection data
  final Map<String, dynamic> _mockCollection = {
    'id': 'c1',
    'name': 'Exam Preparation',
    'description': 'Important videos for upcoming exams',
    'videoCount': 5,
    'createdAt': '2 weeks ago',
  };

  final List<Map<String, dynamic>> _mockVideos = [
    {
      'id': 'v1',
      'title': 'Introduction to Motion',
      'subject': 'Physics',
      'thumbnail': '',
      'progress': 1.0,
    },
    {
      'id': 'v3',
      'title': 'Speed and Velocity',
      'subject': 'Physics',
      'thumbnail': '',
      'progress': 0.65,
    },
    {
      'id': 'v8',
      'title': 'Organic Chemistry Basics',
      'subject': 'Chemistry',
      'thumbnail': '',
      'progress': 0.0,
    },
    {
      'id': 'v12',
      'title': 'Quadratic Equations',
      'subject': 'Mathematics',
      'thumbnail': '',
      'progress': 0.85,
    },
    {
      'id': 'v15',
      'title': 'Cell Structure',
      'subject': 'Biology',
      'thumbnail': '',
      'progress': 0.45,
    },
  ];

  @override
  Widget build(BuildContext context) {
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
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(child: _buildCollectionInfo()),
          SliverPadding(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            sliver: _isGridView ? _buildGridView(1) : _buildListView(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addVideos,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(child: _buildCollectionInfo()),
          SliverPadding(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            sliver: _isGridView ? _buildGridView(2) : _buildListView(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addVideos,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1400),
                child: _buildCollectionInfo(),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXl),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1400),
                  child: _isGridView
                      ? _buildDesktopGrid()
                      : _buildDesktopList(),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addVideos,
        icon: const Icon(Icons.add),
        label: const Text('Add Videos'),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      floating: true,
      snap: true,
      title: Text(_mockCollection['name']),
      actions: [
        IconButton(
          onPressed: () => setState(() => _isGridView = !_isGridView),
          icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
          tooltip: _isGridView ? 'Switch to list view' : 'Switch to grid view',
        ),
        IconButton(
          onPressed: _editCollection,
          icon: const Icon(Icons.edit),
          tooltip: 'Edit collection',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildCollectionInfo() {
    final theme = Theme.of(context);
    final colorScheme = context.colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _mockCollection['description'],
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: AppTheme.spacingMd),
          Row(
            children: [
              Icon(
                Icons.video_library,
                size: 16,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 4),
              Text(
                '${_mockVideos.length} videos',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(width: AppTheme.spacingMd),
              Text(
                '• Created ${_mockCollection['createdAt']}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingMd),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildGridView(int columns) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        // Aspect ratio: width / height. Lower value = taller cards
        // 0.8 gives enough height for thumbnail (16:9) + title + channel name
        childAspectRatio: 0.8,
        crossAxisSpacing: AppTheme.spacingMd,
        mainAxisSpacing: AppTheme.spacingMd,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => VideoCard(
          videoId: _mockVideos[index]['id'],
          title: _mockVideos[index]['title'],
          thumbnailUrl: _mockVideos[index]['thumbnail'],
          progress: _mockVideos[index]['progress'],
          isGridView: true,
          onTap: () => _onVideoTap(_mockVideos[index]['id']),
        ),
        childCount: _mockVideos.length,
      ),
    );
  }

  Widget _buildListView() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Dismissible(
          key: Key(_mockVideos[index]['id']),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: AppTheme.spacingLg),
            color: Colors.red,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) => _removeVideo(index),
          child: VideoCard(
            videoId: _mockVideos[index]['id'],
            title: _mockVideos[index]['title'],
            thumbnailUrl: _mockVideos[index]['thumbnail'],
            progress: _mockVideos[index]['progress'],
            isGridView: false,
            onTap: () => _onVideoTap(_mockVideos[index]['id']),
          ),
        ),
        childCount: _mockVideos.length,
      ),
    );
  }

  Widget _buildDesktopGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: AppTheme.spacingXl),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        // Aspect ratio: width / height. Lower value = taller cards
        // 0.8 gives enough height for thumbnail (16:9) + title + channel name
        childAspectRatio: 0.8,
        crossAxisSpacing: AppTheme.spacingLg,
        mainAxisSpacing: AppTheme.spacingLg,
      ),
      itemCount: _mockVideos.length,
      itemBuilder: (context, index) => VideoCard(
        videoId: _mockVideos[index]['id'],
        title: _mockVideos[index]['title'],
        thumbnailUrl: _mockVideos[index]['thumbnail'],
        progress: _mockVideos[index]['progress'],
        isGridView: true,
        onTap: () => _onVideoTap(_mockVideos[index]['id']),
      ),
    );
  }

  Widget _buildDesktopList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: AppTheme.spacingXl),
      itemCount: _mockVideos.length,
      itemBuilder: (context, index) => VideoCard(
        videoId: _mockVideos[index]['id'],
        title: _mockVideos[index]['title'],
        thumbnailUrl: _mockVideos[index]['thumbnail'],
        progress: _mockVideos[index]['progress'],
        isGridView: false,
        onTap: () => _onVideoTap(_mockVideos[index]['id']),
      ),
    );
  }

  void _onVideoTap(String videoId) {
    // TODO: Navigate to video player
  }

  void _addVideos() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add videos to collection')),
    );
  }

  void _editCollection() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit collection')),
    );
  }

  void _removeVideo(int index) {
    setState(() {
      _mockVideos.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Video removed from collection')),
    );
  }
}
