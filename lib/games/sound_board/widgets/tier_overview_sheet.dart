import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crack_the_code/shared/providers/tier_progress_provider.dart';

class TierOverviewSheet extends ConsumerWidget {
  const TierOverviewSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tierProgress = ref.watch(tierProgressProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF1A1832),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Text(
                'Your Word Journey',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              ...List.generate(10, (i) {
                final tier = i + 1;
                final unlocked = tierProgress.isTierUnlocked(tier);
                final percent = tierProgress.masteryForTier(tier);
                final name = tierProgress.tierName(tier);

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: unlocked
                        ? const Color(0xFFFFD700).withValues(alpha: 0.06)
                        : Colors.white.withValues(alpha: 0.02),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: unlocked
                          ? const Color(0xFFFFD700).withValues(alpha: 0.2)
                          : Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: unlocked
                              ? const Color(0xFFFFD700).withValues(alpha: 0.15)
                              : Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: unlocked
                              ? Text(
                                  '$tier',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFFFFD700),
                                  ),
                                )
                              : Icon(Icons.lock,
                                  size: 18,
                                  color: Colors.white.withValues(alpha: 0.2)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: unlocked
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.4),
                              ),
                            ),
                            const SizedBox(height: 6),
                            if (unlocked) ...[
                              ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: LinearProgressIndicator(
                                  value: percent,
                                  minHeight: 4,
                                  backgroundColor:
                                      Colors.white.withValues(alpha: 0.08),
                                  valueColor: const AlwaysStoppedAnimation(
                                      Color(0xFFFFD700)),
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${(percent * 100).toInt()}% complete',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white.withValues(alpha: 0.4),
                                ),
                              ),
                            ] else
                              Text(
                                'Master 50% of Tier ${tier - 1} to unlock',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white.withValues(alpha: 0.3),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
