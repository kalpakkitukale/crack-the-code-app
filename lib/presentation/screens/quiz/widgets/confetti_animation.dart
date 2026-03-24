import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Confetti Animation Widget
///
/// Displays falling confetti particles for celebrating quiz success.
/// Used when student passes a quiz with animated confetti burst.
class ConfettiAnimation extends StatefulWidget {
  final AnimationController controller;
  final int particleCount;
  final List<Color>? colors;

  const ConfettiAnimation({
    super.key,
    required this.controller,
    this.particleCount = 50,
    this.colors,
  });

  @override
  State<ConfettiAnimation> createState() => _ConfettiAnimationState();
}

class _ConfettiAnimationState extends State<ConfettiAnimation> {
  late List<ConfettiParticle> _particles;

  @override
  void initState() {
    super.initState();
    _initializeParticles();
  }

  /// Initialize confetti particles with random properties
  void _initializeParticles() {
    final random = math.Random();
    final colors = widget.colors ??
        [
          Colors.red,
          Colors.blue,
          Colors.green,
          Colors.yellow,
          Colors.orange,
          Colors.purple,
          Colors.pink,
          Colors.teal,
        ];

    _particles = List.generate(widget.particleCount, (index) {
      return ConfettiParticle(
        color: colors[random.nextInt(colors.length)],
        x: random.nextDouble(),
        y: -0.1 - (random.nextDouble() * 0.2),
        size: 4.0 + random.nextDouble() * 8.0,
        rotation: random.nextDouble() * 2 * math.pi,
        velocityY: 0.3 + random.nextDouble() * 0.4,
        velocityX: -0.2 + random.nextDouble() * 0.4,
        rotationSpeed: -0.5 + random.nextDouble(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _ConfettiPainter(
            particles: _particles,
            progress: widget.controller.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

/// Confetti particle data class
class ConfettiParticle {
  final Color color;
  final double x;
  final double y;
  final double size;
  final double rotation;
  final double velocityY;
  final double velocityX;
  final double rotationSpeed;

  ConfettiParticle({
    required this.color,
    required this.x,
    required this.y,
    required this.size,
    required this.rotation,
    required this.velocityY,
    required this.velocityX,
    required this.rotationSpeed,
  });

  /// Calculate current position based on animation progress
  Offset getPosition(double progress, Size size) {
    final currentX = x + (velocityX * progress);
    final currentY = y + (velocityY * progress);
    return Offset(
      currentX * size.width,
      currentY * size.height,
    );
  }

  /// Calculate current rotation based on animation progress
  double getRotation(double progress) {
    return rotation + (rotationSpeed * progress * 2 * math.pi);
  }

  /// Calculate opacity based on animation progress (fade out at the end)
  double getOpacity(double progress) {
    if (progress < 0.8) {
      return 1.0;
    } else {
      return 1.0 - ((progress - 0.8) / 0.2);
    }
  }
}

/// Custom painter for confetti particles
class _ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  final double progress;

  _ConfettiPainter({
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final position = particle.getPosition(progress, size);
      final rotation = particle.getRotation(progress);
      final opacity = particle.getOpacity(progress);

      // Skip particles that are out of bounds
      if (position.dy > size.height + 20) continue;

      // Save canvas state
      canvas.save();

      // Translate to particle position
      canvas.translate(position.dx, position.dy);

      // Rotate
      canvas.rotate(rotation);

      // Draw confetti piece (rectangle with rounded corners)
      final paint = Paint()
        ..color = particle.color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      final rect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset.zero,
          width: particle.size,
          height: particle.size * 0.6,
        ),
        const Radius.circular(2),
      );

      canvas.drawRRect(rect, paint);

      // Restore canvas state
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
