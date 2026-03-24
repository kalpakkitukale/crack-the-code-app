import 'package:flutter/material.dart';
import 'package:crack_the_code/shared/models/category.dart';

class CategoryBadge extends StatelessWidget {
  final PhonogramCategory category;
  final bool isCompact;

  const CategoryBadge({
    super.key,
    required this.category,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: category.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            category.displayName,
            style: TextStyle(
              fontSize: 11,
              color: category.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: category.colorLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: category.color.withValues(alpha: 0.3)),
      ),
      child: Text(
        category.displayName,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: category.color,
        ),
      ),
    );
  }
}
