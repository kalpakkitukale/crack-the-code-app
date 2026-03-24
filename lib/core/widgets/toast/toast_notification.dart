/// Toast notification widget for displaying user feedback
///
/// Provides a Material Design 3 compliant toast notification system
/// with support for different types, actions, and accessibility.
library;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:streamshaala/core/theme/app_theme.dart';

/// Types of toast notifications
enum ToastType {
  /// Informational message (blue)
  info,

  /// Success message (green)
  success,

  /// Warning message (orange)
  warning,

  /// Error message (red)
  error,
}

/// Toast notification duration
enum ToastDuration {
  /// Short duration (2 seconds)
  short,

  /// Medium duration (3.5 seconds)
  medium,

  /// Long duration (5 seconds)
  long,
}

/// Toast notification data
class ToastData {
  final String message;
  final ToastType type;
  final ToastDuration duration;
  final IconData? icon;
  final VoidCallback? action;
  final String? actionLabel;

  const ToastData({
    required this.message,
    this.type = ToastType.info,
    this.duration = ToastDuration.medium,
    this.icon,
    this.action,
    this.actionLabel,
  });

  Duration get durationValue {
    switch (duration) {
      case ToastDuration.short:
        return const Duration(seconds: 2);
      case ToastDuration.medium:
        return const Duration(milliseconds: 3500);
      case ToastDuration.long:
        return const Duration(seconds: 5);
    }
  }

  IconData get defaultIcon {
    switch (type) {
      case ToastType.info:
        return icon ?? Icons.info_outline;
      case ToastType.success:
        return icon ?? Icons.check_circle_outline;
      case ToastType.warning:
        return icon ?? Icons.warning_amber_outlined;
      case ToastType.error:
        return icon ?? Icons.error_outline;
    }
  }
}

/// Toast notification manager
///
/// Use this as a singleton to show toast notifications throughout the app.
class ToastManager {
  ToastManager._();

  static final ToastManager _instance = ToastManager._();
  static ToastManager get instance => _instance;

  final _toastController = StreamController<ToastData>.broadcast();
  Stream<ToastData> get toastStream => _toastController.stream;

  /// Show a toast notification
  void show(ToastData toast) {
    _toastController.add(toast);
  }

  /// Show an info toast
  void info(String message, {ToastDuration duration = ToastDuration.medium}) {
    show(ToastData(message: message, type: ToastType.info, duration: duration));
  }

  /// Show a success toast
  void success(String message, {ToastDuration duration = ToastDuration.medium}) {
    show(ToastData(message: message, type: ToastType.success, duration: duration));
  }

  /// Show a warning toast
  void warning(String message, {ToastDuration duration = ToastDuration.medium}) {
    show(ToastData(message: message, type: ToastType.warning, duration: duration));
  }

  /// Show an error toast
  void error(String message, {ToastDuration duration = ToastDuration.long}) {
    show(ToastData(message: message, type: ToastType.error, duration: duration));
  }

  /// Show a toast with an undo action
  void undoable({
    required String message,
    required VoidCallback onUndo,
  }) {
    show(ToastData(
      message: message,
      type: ToastType.info,
      duration: ToastDuration.long,
      action: onUndo,
      actionLabel: 'Undo',
    ));
  }

  void dispose() {
    _toastController.close();
  }
}

/// Global toast manager instance
final toastManager = ToastManager.instance;

/// Toast overlay widget
///
/// Wrap your MaterialApp or root widget with this to enable toast notifications.
class ToastOverlay extends StatefulWidget {
  final Widget child;

  const ToastOverlay({
    super.key,
    required this.child,
  });

  @override
  State<ToastOverlay> createState() => _ToastOverlayState();
}

class _ToastOverlayState extends State<ToastOverlay> {
  final List<_ToastEntry> _toasts = [];
  StreamSubscription<ToastData>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = toastManager.toastStream.listen(_onToast);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _onToast(ToastData toast) {
    final entry = _ToastEntry(
      toast: toast,
      key: UniqueKey(),
    );

    setState(() {
      _toasts.add(entry);
    });

    // Auto-dismiss after duration
    Future.delayed(toast.durationValue, () {
      if (mounted) {
        _dismissToast(entry.key);
      }
    });
  }

  void _dismissToast(Key key) {
    setState(() {
      _toasts.removeWhere((e) => e.key == key);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_toasts.isNotEmpty)
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).padding.bottom + 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _toasts.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(
                    left: AppTheme.spacingMd,
                    right: AppTheme.spacingMd,
                    bottom: AppTheme.spacingSm,
                  ),
                  child: ToastWidget(
                    key: entry.key,
                    toast: entry.toast,
                    onDismiss: () => _dismissToast(entry.key),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

class _ToastEntry {
  final ToastData toast;
  final Key key;

  _ToastEntry({required this.toast, required this.key});
}

/// Individual toast notification widget
class ToastWidget extends StatefulWidget {
  final ToastData toast;
  final VoidCallback? onDismiss;

  const ToastWidget({
    super.key,
    required this.toast,
    this.onDismiss,
  });

  @override
  State<ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _dismiss() async {
    await _controller.reverse();
    widget.onDismiss?.call();
  }

  Color _getBackgroundColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (widget.toast.type) {
      case ToastType.info:
        return colorScheme.primaryContainer;
      case ToastType.success:
        return const Color(0xFF4CAF50).withValues(alpha: 0.15);
      case ToastType.warning:
        return const Color(0xFFFF9800).withValues(alpha: 0.15);
      case ToastType.error:
        return colorScheme.errorContainer;
    }
  }

  Color _getForegroundColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (widget.toast.type) {
      case ToastType.info:
        return colorScheme.onPrimaryContainer;
      case ToastType.success:
        return const Color(0xFF2E7D32);
      case ToastType.warning:
        return const Color(0xFFE65100);
      case ToastType.error:
        return colorScheme.onErrorContainer;
    }
  }

  Color _getIconColor(BuildContext context) {
    switch (widget.toast.type) {
      case ToastType.info:
        return Theme.of(context).colorScheme.primary;
      case ToastType.success:
        return const Color(0xFF4CAF50);
      case ToastType.warning:
        return const Color(0xFFFF9800);
      case ToastType.error:
        return Theme.of(context).colorScheme.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Semantics(
          label: '${widget.toast.type.name}: ${widget.toast.message}',
          liveRegion: true,
          child: Material(
            elevation: AppTheme.elevation2,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            color: _getBackgroundColor(context),
            child: InkWell(
              onTap: _dismiss,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingMd,
                  vertical: AppTheme.spacingSm,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      widget.toast.defaultIcon,
                      size: 20,
                      color: _getIconColor(context),
                    ),
                    const SizedBox(width: AppTheme.spacingSm),
                    Flexible(
                      child: Text(
                        widget.toast.message,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: _getForegroundColor(context),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (widget.toast.action != null) ...[
                      const SizedBox(width: AppTheme.spacingSm),
                      TextButton(
                        onPressed: () {
                          widget.toast.action?.call();
                          _dismiss();
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacingSm,
                          ),
                          minimumSize: const Size(48, 36),
                        ),
                        child: Text(
                          widget.toast.actionLabel ?? 'Action',
                          style: TextStyle(
                            color: _getIconColor(context),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Extension for showing toasts from BuildContext
extension ToastExtension on BuildContext {
  /// Show an info toast
  void showInfoToast(String message) {
    toastManager.info(message);
  }

  /// Show a success toast
  void showSuccessToast(String message) {
    toastManager.success(message);
  }

  /// Show a warning toast
  void showWarningToast(String message) {
    toastManager.warning(message);
  }

  /// Show an error toast
  void showErrorToast(String message) {
    toastManager.error(message);
  }

  /// Show an undoable toast
  void showUndoableToast(String message, VoidCallback onUndo) {
    toastManager.undoable(message: message, onUndo: onUndo);
  }
}
