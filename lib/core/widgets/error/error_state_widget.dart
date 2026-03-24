import 'package:flutter/material.dart';
import 'package:streamshaala/core/theme/app_theme.dart';

/// Error State Widget
/// Displays error message with optional retry button
class ErrorStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;
  final String? retryButtonText;

  const ErrorStateWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline,
    this.retryButtonText = 'Retry',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: AppTheme.spacingLg),
            Text(
              'Oops! Something went wrong',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppTheme.spacingXl),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(retryButtonText!),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingXl,
                    vertical: AppTheme.spacingMd,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Network Error State Widget
/// Specialized error widget for network-related errors
class NetworkErrorWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const NetworkErrorWidget({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorStateWidget(
      message: 'Please check your internet connection and try again',
      onRetry: onRetry,
      icon: Icons.wifi_off,
      retryButtonText: 'Try Again',
    );
  }
}

/// Not Found Error Widget
/// For 404-style errors
class NotFoundErrorWidget extends StatelessWidget {
  final String? message;
  final VoidCallback? onGoBack;

  const NotFoundErrorWidget({
    super.key,
    this.message,
    this.onGoBack,
  });

  @override
  Widget build(BuildContext context) {
    return ErrorStateWidget(
      message: message ?? 'The content you\'re looking for doesn\'t exist',
      onRetry: onGoBack,
      icon: Icons.search_off,
      retryButtonText: 'Go Back',
    );
  }
}
