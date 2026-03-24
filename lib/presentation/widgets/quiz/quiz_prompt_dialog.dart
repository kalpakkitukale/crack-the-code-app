import 'package:flutter/material.dart';
import 'package:crack_the_code/core/config/segment_config.dart';

/// Dialog that prompts user to take a quiz after watching a video
/// Shows different messaging for Junior vs other segments
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
    final isJunior = SegmentConfig.isCrackTheCode;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.all(24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Celebration icon with animated feel
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.8, end: 1.0),
            duration: const Duration(milliseconds: 500),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isJunior
                      ? [Colors.amber.shade300, Colors.orange.shade400]
                      : [theme.colorScheme.primaryContainer, theme.colorScheme.primary.withValues(alpha: 0.3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (isJunior ? Colors.amber : theme.colorScheme.primary).withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                isJunior ? Icons.celebration : Icons.check_circle,
                size: 56,
                color: isJunior ? Colors.white : theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Title
          Text(
            isJunior ? 'Great Job! 🎉' : 'Video Complete!',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),

          // Video title (truncated if too long)
          if (videoTitle.isNotEmpty) ...[
            Text(
              'You watched:',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              videoTitle,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Question
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.quiz_outlined,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    isJunior
                        ? 'Ready to show what you learned?'
                        : 'Would you like to test your understanding?',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Buttons
          Row(
            children: [
              // Later button
              Expanded(
                child: OutlinedButton(
                  onPressed: onLater,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    isJunior ? 'Later' : 'Maybe Later',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Take Quiz button
              Expanded(
                flex: isJunior ? 2 : 1,
                child: FilledButton.icon(
                  onPressed: onTakeQuiz,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: isJunior
                        ? Colors.green.shade600
                        : theme.colorScheme.primary,
                  ),
                  icon: Icon(
                    isJunior ? Icons.star : Icons.quiz,
                    size: 20,
                  ),
                  label: Text(
                    isJunior ? 'Take Quiz!' : 'Take Quiz',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Skip hint for non-junior
          if (!isJunior) ...[
            const SizedBox(height: 12),
            Text(
              'Quiz helps reinforce what you learned',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
