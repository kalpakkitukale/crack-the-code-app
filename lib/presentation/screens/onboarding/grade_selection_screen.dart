// Grade Selection Screen
// Shown to Junior users after onboarding to select their grade level

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:crack_the_code/core/config/segment_config.dart';
import 'package:crack_the_code/presentation/providers/user/user_profile_provider.dart';

/// Grade Selection Screen for Junior segment
class GradeSelectionScreen extends ConsumerStatefulWidget {
  const GradeSelectionScreen({super.key});

  @override
  ConsumerState<GradeSelectionScreen> createState() =>
      _GradeSelectionScreenState();
}

class _GradeSelectionScreenState extends ConsumerState<GradeSelectionScreen>
    with SingleTickerProviderStateMixin {
  int? _selectedGrade;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final settings = SegmentConfig.settings;

    // Get available grades for this segment
    final grades = List.generate(
      settings.maxGrade - settings.minGrade + 1,
      (index) => settings.minGrade + index,
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 48),

            // Mascot/Icon
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.school,
                size: 60,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 32),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'What grade are you in?',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 12),

            // Subtitle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'We\'ll show you lessons made just for your grade!',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 48),

            // Grade buttons grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: grades.length,
                  itemBuilder: (context, index) {
                    final grade = grades[index];
                    return _GradeButton(
                      grade: grade,
                      isSelected: _selectedGrade == grade,
                      color: _gradeColors[index % _gradeColors.length],
                      onTap: () => _selectGrade(grade),
                    );
                  },
                ),
              ),
            ),

            // Continue button
            Padding(
              padding: const EdgeInsets.all(24),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _selectedGrade != null ? 1.0 : 0.5,
                child: FilledButton(
                  onPressed: _selectedGrade != null ? _continue : null,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _selectedGrade != null
                            ? 'Start Learning!'
                            : 'Pick your grade',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_selectedGrade != null) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _selectGrade(int grade) {
    setState(() {
      _selectedGrade = grade;
    });
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  Future<void> _continue() async {
    if (_selectedGrade == null) return;

    // Save grade to user profile
    await ref.read(userProfileProvider.notifier).setGrade(_selectedGrade!);

    if (mounted) {
      // Navigate to home
      context.go('/home');
    }
  }
}

/// Grade colors for visual variety
const _gradeColors = [
  Color(0xFF4CAF50), // Green
  Color(0xFF2196F3), // Blue
  Color(0xFFFF9800), // Orange
  Color(0xFF9C27B0), // Purple
  Color(0xFFE91E63), // Pink
  Color(0xFF00BCD4), // Cyan
];

/// Individual grade button widget
class _GradeButton extends StatelessWidget {
  final int grade;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _GradeButton({
    required this.grade,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 3,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Grade number
            Text(
              '$grade',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : color,
              ),
            ),
            const SizedBox(height: 4),
            // Grade label
            Text(
              _getGradeLabel(grade),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.9)
                    : color.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getGradeLabel(int grade) {
    switch (grade) {
      case 1:
        return '1st Grade';
      case 2:
        return '2nd Grade';
      case 3:
        return '3rd Grade';
      default:
        return 'Class $grade';
    }
  }
}
