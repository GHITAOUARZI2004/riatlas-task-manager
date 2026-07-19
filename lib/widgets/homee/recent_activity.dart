import 'package:flutter/material.dart';
import '../../models/task.dart';
import '../../theme/app_theme.dart';

class RecentActivity extends StatelessWidget {
  final List<Task> tasks;

  const RecentActivity({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    final recentTasks = tasks.where((t) => t.completed).toList()
      ..sort((a, b) => (b.completedAt ?? DateTime(0)).compareTo(a.completedAt ?? DateTime(0)));

    if (recentTasks.isEmpty) return const SizedBox();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              'Recently Completed',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          ...recentTasks.take(3).map((task) => _buildActivityItem(task)),
        ],
      ),
    );
  }

  Widget _buildActivityItem(Task task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.check, color: AppColors.success, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              task.title,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '+${task.xpReward} XP',
            style: const TextStyle(
              color: AppColors.amber,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
