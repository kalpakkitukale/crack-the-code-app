import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:streamshaala/core/responsive/responsive_builder.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/core/extensions/context_extensions.dart';
import 'package:streamshaala/core/widgets/empty/empty_state_widget.dart';
import 'package:streamshaala/core/widgets/error/error_widget.dart';
import 'package:streamshaala/core/widgets/loaders/shimmer_loading.dart';
import 'package:streamshaala/domain/entities/user/collection.dart';
import 'package:streamshaala/presentation/providers/user/collection_provider.dart';

/// Collections Screen
/// Displays all user-created video collections
class CollectionsScreen extends ConsumerWidget {
  const CollectionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionState = ref.watch(collectionProvider);

    return ResponsiveBuilder(
      builder: (context, deviceType) {
        return Scaffold(
          appBar: _buildAppBar(context),
          body: _buildBody(context, ref, collectionState, deviceType),
          floatingActionButton: _buildFab(context, ref),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Icon(Icons.folder, color: context.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            'Collections',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    CollectionState state,
    DeviceType deviceType,
  ) {
    // Loading state
    if (state.isLoading) {
      return _buildLoadingState(deviceType);
    }

    // Error state
    if (state.error != null) {
      return DataErrorWidget(
        errorMessage: state.error,
        onRetry: () => ref.read(collectionProvider.notifier).refresh(),
      );
    }

    // Empty state
    if (state.collections.isEmpty) {
      return EmptyStates.noCollections(
        onCreateCollection: () => _showCreateDialog(context, ref),
      );
    }

    // Collections list/grid
    return RefreshIndicator(
      onRefresh: () => ref.read(collectionProvider.notifier).refresh(),
      child: _buildCollectionsList(context, ref, state.collections, deviceType),
    );
  }

  Widget _buildLoadingState(DeviceType deviceType) {
    final columns = deviceType == DeviceType.mobile ? 1 : (deviceType == DeviceType.tablet ? 2 : 3);
    final padding = deviceType == DeviceType.mobile ? AppTheme.spacingMd : AppTheme.spacingLg;

    if (columns == 1) {
      return ListView.builder(
        padding: EdgeInsets.all(padding),
        itemCount: 4,
        itemBuilder: (context, index) => const Padding(
          padding: EdgeInsets.only(bottom: AppTheme.spacingMd),
          child: _CollectionCardSkeleton(),
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(padding),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        childAspectRatio: 1.1,
        crossAxisSpacing: AppTheme.spacingMd,
        mainAxisSpacing: AppTheme.spacingMd,
      ),
      itemCount: 6,
      itemBuilder: (context, index) => const _CollectionCardSkeleton(),
    );
  }

  Widget _buildCollectionsList(
    BuildContext context,
    WidgetRef ref,
    List<Collection> collections,
    DeviceType deviceType,
  ) {
    final padding = deviceType == DeviceType.mobile
        ? AppTheme.spacingMd
        : (deviceType == DeviceType.tablet ? AppTheme.spacingLg : AppTheme.spacingXl);

    if (deviceType == DeviceType.mobile) {
      return ListView.builder(
        padding: EdgeInsets.all(padding),
        itemCount: collections.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
          child: _CollectionCard(
            collection: collections[index],
            onTap: () => context.push('/collections/${collections[index].id}'),
            onEdit: () => _showEditDialog(context, ref, collections[index]),
            onDelete: () => _showDeleteDialog(context, ref, collections[index]),
          ),
        ),
      );
    }

    final columns = deviceType == DeviceType.tablet ? 2 : 3;
    final content = GridView.builder(
      padding: EdgeInsets.all(padding),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        childAspectRatio: deviceType == DeviceType.tablet ? 1.1 : 1.2,
        crossAxisSpacing: AppTheme.spacingMd,
        mainAxisSpacing: AppTheme.spacingMd,
      ),
      itemCount: collections.length,
      itemBuilder: (context, index) => _CollectionCard(
        collection: collections[index],
        onTap: () => context.push('/collections/${collections[index].id}'),
        onEdit: () => _showEditDialog(context, ref, collections[index]),
        onDelete: () => _showDeleteDialog(context, ref, collections[index]),
      ),
    );

    if (deviceType == DeviceType.desktop) {
      return Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1400),
          child: content,
        ),
      );
    }

    return content;
  }

  Widget _buildFab(BuildContext context, WidgetRef ref) {
    return FloatingActionButton.extended(
      onPressed: () => _showCreateDialog(context, ref),
      icon: const Icon(Icons.add),
      label: const Text('New Collection'),
    );
  }

  void _showCreateDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Create Collection'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Collection Name',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: AppTheme.spacingMd),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Collection name is required')),
                );
                return;
              }

              Navigator.pop(dialogContext);
              final success = await ref.read(collectionProvider.notifier).createCollection(
                    name: name,
                    description: descController.text.trim().isNotEmpty ? descController.text.trim() : null,
                  );

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 'Collection created' : 'Failed to create collection'),
                    backgroundColor: success ? AppTheme.successColor : AppTheme.errorColor,
                  ),
                );
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    ).then((_) {
      nameController.dispose();
      descController.dispose();
    });
  }

  void _showEditDialog(BuildContext context, WidgetRef ref, Collection collection) {
    final nameController = TextEditingController(text: collection.name);
    final descController = TextEditingController(text: collection.description ?? '');

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Collection'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Collection Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppTheme.spacingMd),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Collection name is required')),
                );
                return;
              }

              Navigator.pop(dialogContext);
              final success = await ref.read(collectionProvider.notifier).updateCollection(
                    id: collection.id,
                    name: name,
                    description: descController.text.trim().isNotEmpty ? descController.text.trim() : null,
                  );

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 'Collection updated' : 'Failed to update collection'),
                    backgroundColor: success ? AppTheme.successColor : AppTheme.errorColor,
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    ).then((_) {
      nameController.dispose();
      descController.dispose();
    });
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, Collection collection) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Collection'),
        content: Text(
          'Are you sure you want to delete "${collection.name}"?\n\n'
          'This will remove ${collection.videoCount} video${collection.videoCount == 1 ? '' : 's'} from this collection.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              final success = await ref.read(collectionProvider.notifier).deleteCollection(collection.id);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 'Collection deleted' : 'Failed to delete collection'),
                    backgroundColor: success ? AppTheme.successColor : AppTheme.errorColor,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

/// Collection card widget
class _CollectionCard extends StatelessWidget {
  final Collection collection;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CollectionCard({
    required this.collection,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  /// Format a DateTime to a relative time string
  String _formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return years == 1 ? '1 year ago' : '$years years ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return months == 1 ? '1 month ago' : '$months months ago';
    } else if (difference.inDays > 7) {
      final weeks = (difference.inDays / 7).floor();
      return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
    } else if (difference.inDays > 0) {
      return difference.inDays == 1 ? 'Yesterday' : '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return difference.inHours == 1 ? '1 hour ago' : '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return difference.inMinutes == 1 ? '1 minute ago' : '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail/Cover
            Container(
              height: 120,
              color: colorScheme.surfaceContainerHighest,
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.video_library,
                      size: 48,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  // Video count badge
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${collection.videoCount} video${collection.videoCount == 1 ? '' : 's'}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  // Menu button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: PopupMenuButton(
                      icon: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.more_vert, color: Colors.white, size: 18),
                      ),
                      tooltip: 'Collection options',
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 18),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 18, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Delete', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'edit') {
                          onEdit();
                        } else if (value == 'delete') {
                          onDelete();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Collection Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      collection.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (collection.description != null && collection.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Expanded(
                        child: Text(
                          collection.description!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatRelativeTime(collection.updatedAt),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        if (collection.hasVideos) ...[
                          const Spacer(),
                          Text(
                            collection.formattedTotalDuration,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton loading widget for collection cards
class _CollectionCardSkeleton extends StatelessWidget {
  const _CollectionCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            color: colorScheme.surfaceContainerHighest,
          ),
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMd),
            child: ShimmerLoading(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonLine(width: 150, height: 16),
                  const SizedBox(height: 8),
                  SkeletonLine(width: 100, height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
