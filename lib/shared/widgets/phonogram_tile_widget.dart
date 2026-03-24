import 'package:flutter/material.dart';
import 'package:crack_the_code/shared/models/phonogram.dart';

class PhonogramTileWidget extends StatefulWidget {
  final Phonogram phonogram;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isGreyedOut;
  final double size;

  const PhonogramTileWidget({
    super.key,
    required this.phonogram,
    this.onTap,
    this.onLongPress,
    this.isGreyedOut = false,
    this.size = 64,
  });

  @override
  State<PhonogramTileWidget> createState() => _PhonogramTileWidgetState();
}

class _PhonogramTileWidgetState extends State<PhonogramTileWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _bounceController.forward().then((_) => _bounceController.reverse());
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.phonogram.color;
    final opacity = widget.isGreyedOut ? 0.3 : 1.0;
    final fontSize = widget.size * 0.35;

    return GestureDetector(
      onTap: _handleTap,
      onLongPress: widget.onLongPress,
      child: AnimatedBuilder(
        animation: _bounceAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _bounceAnimation.value,
            child: child,
          );
        },
        child: Opacity(
          opacity: opacity,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(widget.size * 0.2),
              border: Border.all(color: color.withValues(alpha: 0.4), width: 2),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.phonogram.text,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w800,
                    color: color,
                    letterSpacing: 1,
                  ),
                ),
                if (widget.phonogram.isMultiSound)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        widget.phonogram.soundCount,
                        (i) => Container(
                          width: 4,
                          height: 4,
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
