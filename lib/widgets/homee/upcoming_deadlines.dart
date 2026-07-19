import 'package:flutter/material.dart';
import '../../models/task.dart';
import '../../theme/app_theme.dart';

class UpcomingDeadlines extends StatelessWidget {
  final List<Task> tasks;

  const UpcomingDeadlines({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              'Upcoming Deadlines',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          ...tasks.take(3).map((task) => _buildDeadlineItem(task)),
        ],
      ),
    );
  }

  Widget _buildDeadlineItem(Task task) {
    if (task.dueDate == null) return const SizedBox();

    final now = DateTime.now();
    final difference = task.dueDate!.difference(now).inDays;

    String dueText;
    Color dueColor;
    if (difference == 0) {
      dueText = 'Today';
      dueColor = AppColors.terracotta;
    } else if (difference == 1) {
      dueText = 'Tomorrow';
      dueColor = AppColors.amber;
    } else {
      dueText = '${task.dueDate!.day}/${task.dueDate!.month}/${task.dueDate!.year}';
      dueColor = AppColors.textSecondary;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.03),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.push_pin, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  dueText,
                  style: TextStyle(color: dueColor, fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
