import 'package:flutter/material.dart';
import 'package:streamshaala/core/theme/app_theme.dart';

/// A tile widget for displaying search suggestions in autocomplete
class SearchSuggestionTile extends StatelessWidget {
  final String suggestion;
  final String query;
  final VoidCallback onTap;

  const SearchSuggestionTile({
    super.key,
    required this.suggestion,
    required this.query,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMd,
          vertical: AppTheme.spacingSm + 4,
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              size: 20,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            const SizedBox(width: AppTheme.spacingMd),
            Expanded(
              child: _buildHighlightedText(
                suggestion,
                query,
                theme,
              ),
            ),
            Icon(
              Icons.north_west,
              size: 16,
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }

  /// Build text with the matching part highlighted
  Widget _buildHighlightedText(
    String text,
    String query,
    ThemeData theme,
  ) {
    if (query.isEmpty) {
      return Text(
        text,
        style: theme.textTheme.bodyLarge,
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final startIndex = lowerText.indexOf(lowerQuery);

    if (startIndex == -1) {
      return Text(
        text,
        style: theme.textTheme.bodyLarge,
      );
    }

    final endIndex = startIndex + query.length;
    final beforeMatch = text.substring(0, startIndex);
    final match = text.substring(startIndex, endIndex);
    final afterMatch = text.substring(endIndex);

    return RichText(
      text: TextSpan(
        style: theme.textTheme.bodyLarge,
        children: [
          TextSpan(text: beforeMatch),
          TextSpan(
            text: match,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          TextSpan(text: afterMatch),
        ],
      ),
    );
  }
}
