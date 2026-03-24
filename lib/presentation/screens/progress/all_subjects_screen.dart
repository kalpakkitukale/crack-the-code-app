import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';
import 'package:crack_the_code/presentation/screens/progress/widgets/subject_progress.dart';

/// All Subjects Progress Screen
/// Shows complete list of all subjects with their progress
class AllSubjectsScreen extends ConsumerWidget {
  const AllSubjectsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Subjects'),
        elevation: 0,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(AppTheme.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SubjectProgress(), // Shows all subjects without limit
          ],
        ),
      ),
    );
  }
}
