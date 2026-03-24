import 'dart:math';

import 'package:flutter/material.dart';

class ParticleBurst extends StatefulWidget {
  final Color color;
  final int particleCount;
  final Duration duration;
  final VoidCallback? onComplete;

  const ParticleBurst({
    super.key,
    this.color = const Color(0xFFFFD700),
    this.particleCount = 8,
    this.duration = const Duration(milliseconds: 500),
    this.onComplete,
  });

  @override
  State<ParticleBurst> createState() => _ParticleBurstState();
}

class _ParticleBurstState extends State<ParticleBurst>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> _particles;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _particles = List.generate(widget.particleCount, (_) {
      final angle = _random.nextDouble() * 2 * pi;
      final distance = 30.0 + _random.nextDouble() * 20.0;
      return _Particle(
        dx: cos(angle) * distance,
        dy: sin(angle) * distance,
        size: 3.0 + _random.nextDouble() * 3.0,
      );
    });

    _controller.forward().then((_) => widget.onComplete?.call());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          size: const Size(100, 100),
          painter: _ParticlePainter(
            particles: _particles,
            progress: _controller.value,
            color: widget.color,
          ),
        );
      },
    );
  }
}

class _Particle {
  final double dx;
  final double dy;
  final double size;

  _Particle({required this.dx, required this.dy, required this.size});
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;
  final Color color;

  _ParticlePainter({
    required this.particles,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()..color = color.withValues(alpha: 1.0 - progress);

    for (final p in particles) {
      final offset = center + Offset(p.dx * progress, p.dy * progress);
      final radius = p.size * (1.0 - progress * 0.5);
      canvas.drawCircle(offset, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter old) =>
      old.progress != progress;
}
