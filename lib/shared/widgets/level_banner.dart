import 'package:flutter/material.dart';
import 'package:crack_the_code/shared/models/level.dart';

class LevelBanner extends StatelessWidget {
  final Level level;
  final String lang;
  final int weekNumber;
  final int dayNumber;

  const LevelBanner({
    super.key,
    required this.level,
    this.lang = 'en',
    this.weekNumber = 1,
    this.dayNumber = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: level.colorValue.withValues(alpha: 0.12),
        border: Border(
          bottom: BorderSide(color: level.colorValue.withValues(alpha: 0.3), width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: level.colorValue.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: level.colorValue.withValues(alpha: 0.4)),
            ),
            child: Center(
              child: Text(
                '${level.number}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: level.colorValue,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Level ${level.number}: ${level.nameForLang(lang)}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: level.colorValue,
                  ),
                ),
                Text(
                  'Week $weekNumber · Day $dayNumber · ${level.starDisplay}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
