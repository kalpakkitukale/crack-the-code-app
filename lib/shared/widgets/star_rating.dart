import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final int stars;
  final int maxStars;
  final double starSize;
  final Color filledColor;
  final Color emptyColor;

  const StarRating({
    super.key,
    required this.stars,
    this.maxStars = 3,
    this.starSize = 24,
    this.filledColor = const Color(0xFFFFD700),
    this.emptyColor = const Color(0xFFE0E0E0),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxStars, (i) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Icon(
            i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
            size: starSize,
            color: i < stars ? filledColor : emptyColor,
          ),
        );
      }),
    );
  }
}
