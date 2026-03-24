import 'package:flutter/material.dart';

/// Animated wrapper for learning path nodes
///
/// Provides visual feedback when a node is completed with
/// scale and glow animations.
class NodeCompletionAnimation extends StatefulWidget {
  final Widget child;
  final bool isCompleted;
  final VoidCallback? onAnimationComplete;
  final Color? glowColor;

  const NodeCompletionAnimation({
    super.key,
    required this.child,
    required this.isCompleted,
    this.onAnimationComplete,
    this.glowColor,
  });

  @override
  State<NodeCompletionAnimation> createState() =>
      _NodeCompletionAnimationState();
}

class _NodeCompletionAnimationState extends State<NodeCompletionAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    if (widget.isCompleted) {
      _playAnimation();
    }
  }

  @override
  void didUpdateWidget(NodeCompletionAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Trigger animation when completion status changes
    if (!oldWidget.isCompleted && widget.isCompleted) {
      _playAnimation();
    } else if (oldWidget.isCompleted && !widget.isCompleted) {
      _controller.reverse();
    }
  }

  void _playAnimation() {
    _controller.forward().then((_) {
      // Reverse after a short delay
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          _controller.reverse().then((_) {
            widget.onAnimationComplete?.call();
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final glowColor = widget.glowColor ?? Colors.green;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: widget.isCompleted
                  ? [
                      BoxShadow(
                        color: glowColor.withOpacity(0.5 * _glowAnimation.value),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ]
                  : null,
            ),
            child: widget.child,
          ),
        );
      },
    );
  }
}
