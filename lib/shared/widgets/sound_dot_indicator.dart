import 'package:flutter/material.dart';

class SoundDotIndicator extends StatelessWidget {
  final int totalDots;
  final int activeIndex;
  final Color activeColor;
  final Color inactiveColor;

  const SoundDotIndicator({
    super.key,
    required this.totalDots,
    required this.activeIndex,
    this.activeColor = const Color(0xFFFFD700),
    this.inactiveColor = const Color(0xFFE0E0E0),
  });

  @override
  Widget build(BuildContext context) {
    if (totalDots <= 1) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalDots, (i) {
        final isActive = i == activeIndex;
        return Container(
          width: isActive ? 8 : 6,
          height: isActive ? 8 : 6,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? activeColor : inactiveColor,
          ),
        );
      }),
    );
  }
}
