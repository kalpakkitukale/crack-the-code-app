import 'package:flutter/material.dart';
import 'package:crack_the_code/core/errors/failures.dart';
import 'package:crack_the_code/core/errors/error_messages.dart';
import 'package:crack_the_code/core/theme/app_theme.dart';

/// Reusable error state widget with user-friendly messages
/// Shows error icon, message, help text, and retry button
class ErrorStateWidget extends StatelessWidget {
  final Failure failure;
  final VoidCallback? onRetry;
  final String? customMessage;
  final bool compact;

  const ErrorStateWidget({
    super.key,
    required this.failure,
    this.onRetry,
    this.customMessage,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final errorMessage = customMessage ?? ErrorMessages.getErrorMessage(failure);
    final helpText = ErrorMessages.getHelpText(failure);
    final isRetryable = ErrorMessages.isRetryable(failure);
    final retryLabel = ErrorMessages.getRetryActionLabel(failure);

    if (compact) {
      return _buildCompactError(
        context,
        colorScheme,
        errorMessage,
        isRetryable,
        retryLabel,
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Error icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colorScheme.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  _getErrorIcon(),
                  size: 40,
                  color: colorScheme.error,
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingLg),

            // Error message
            Text(
              errorMessage,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            // Help text
            if (helpText != null) ...[
              const SizedBox(height: AppTheme.spacingSm),
              Text(
                helpText,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            // Retry button
            if (isRetryable && onRetry != null) ...[
              const SizedBox(height: AppTheme.spacingLg),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(retryLabel),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCompactError(
    BuildContext context,
    ColorScheme colorScheme,
    String errorMessage,
    bool isRetryable,
    String retryLabel,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        border: Border.all(
          color: colorScheme.error.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _getErrorIcon(),
            color: colorScheme.error,
            size: 20,
          ),
          const SizedBox(width: AppTheme.spacingSm),
          Expanded(
            child: Text(
              errorMessage,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onErrorContainer,
                  ),
            ),
          ),
          if (isRetryable && onRetry != null) ...[
            const SizedBox(width: AppTheme.spacingSm),
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(retryLabel),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getErrorIcon() {
    if (failure is NetworkFailure) {
      return Icons.wifi_off;
    } else if (failure is DatabaseFailure) {
      return Icons.storage;
    } else if (failure is CacheFailure) {
      return Icons.folder_off;
    } else if (failure is ValidationFailure) {
      return Icons.edit_off;
    } else if (failure is ServerFailure) {
      return Icons.cloud_off;
    } else {
      return Icons.error_outline;
    }
  }
}

/// Extension to show error snackbar
extension ErrorSnackbar on BuildContext {
  void showErrorSnackbar(Failure failure, {VoidCallback? onRetry}) {
    final errorMessage = ErrorMessages.getErrorMessage(failure);
    final isRetryable = ErrorMessages.isRetryable(failure);
    final retryLabel = ErrorMessages.getRetryActionLabel(failure);

    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              _getSnackbarIcon(failure),
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(errorMessage),
            ),
          ],
        ),
        action: isRetryable && onRetry != null
            ? SnackBarAction(
                label: retryLabel,
                onPressed: onRetry,
                textColor: Colors.white,
              )
            : null,
        duration: Duration(seconds: isRetryable ? 5 : 3),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(this).colorScheme.error,
      ),
    );
  }

  IconData _getSnackbarIcon(Failure failure) {
    if (failure is NetworkFailure) {
      return Icons.wifi_off;
    } else if (failure is DatabaseFailure) {
      return Icons.storage;
    } else if (failure is ServerFailure) {
      return Icons.cloud_off;
    } else {
      return Icons.error_outline;
    }
  }
}
