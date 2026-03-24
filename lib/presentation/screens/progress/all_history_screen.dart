import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/presentation/screens/progress/widgets/watch_history.dart';

/// All Watch History Screen
/// Shows complete watch history without limits
class AllHistoryScreen extends ConsumerWidget {
  const AllHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watch History'),
        elevation: 0,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(AppTheme.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WatchHistory(), // Shows all history without limit
          ],
        ),
      ),
    );
  }
}
