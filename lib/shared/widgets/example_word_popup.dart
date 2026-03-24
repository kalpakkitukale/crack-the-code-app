import 'package:flutter/material.dart';

class ExampleWordPopup extends StatefulWidget {
  final String word;
  final String emoji;
  final Duration displayDuration;
  final VoidCallback? onDismissed;

  const ExampleWordPopup({
    super.key,
    required this.word,
    this.emoji = '',
    this.displayDuration = const Duration(seconds: 2),
    this.onDismissed,
  });

  @override
  State<ExampleWordPopup> createState() => _ExampleWordPopupState();
}

class _ExampleWordPopupState extends State<ExampleWordPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    final total = widget.displayDuration.inMilliseconds + 400;
    _controller = AnimationController(
      duration: Duration(milliseconds: total),
      vsync: this,
    );

    _opacity = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 10),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 70),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 20),
    ]).animate(_controller);

    _slide = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: const Offset(0, 0.3), end: Offset.zero),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: ConstantTween(Offset.zero),
        weight: 90,
      ),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward().then((_) => widget.onDismissed?.call());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _opacity,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.emoji.isNotEmpty) ...[
                Text(widget.emoji, style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 6),
              ],
              Text(
                widget.word,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
