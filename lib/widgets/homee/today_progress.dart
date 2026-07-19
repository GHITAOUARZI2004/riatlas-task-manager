import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class TodayProgress extends StatelessWidget {
  final double progress;
  final int completed;
  final int total;
  final int streak;

  const TodayProgress({
    super.key,
    required this.progress,
    required this.completed,
    required this.total,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.04),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Today's Progress",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              if (streak > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.amber.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.local_fire_department, color: AppColors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '$streak day streak',
                        style: const TextStyle(color: AppColors.amber, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '$completed of $total tasks completed',
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
        ],
      ),
    );
  }
}