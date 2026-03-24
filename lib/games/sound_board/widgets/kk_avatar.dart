import 'package:flutter/material.dart';

class KKAvatar extends StatefulWidget {
  final double size;
  final bool animate;

  const KKAvatar({super.key, this.size = 48, this.animate = true});

  @override
  State<KKAvatar> createState() => _KKAvatarState();
}

class _KKAvatarState extends State<KKAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounce;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _bounce = Tween<double>(begin: 0, end: -4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    if (widget.animate) {
      _startIdleAnimation();
    }
  }

  void _startIdleAnimation() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _controller.forward().then((_) {
          _controller.reverse().then((_) {
            if (mounted) _startIdleAnimation();
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bounce,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _bounce.value),
          child: child,
        );
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A1832), Color(0xFF0A0618)],
          ),
          border: Border.all(
            color: const Color(0xFFFFD700).withValues(alpha: 0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFD700).withValues(alpha: 0.2),
              blurRadius: 8,
            ),
          ],
        ),
        child: Center(
          child: Text(
            'KK',
            style: TextStyle(
              fontSize: widget.size * 0.35,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFFFD700),
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}
