import 'package:flutter/material.dart';
import '../../models/task.dart';
import '../../theme/app_theme.dart';

class TodaySchedule extends StatelessWidget {
  final List<Task> tasks;

  const TodaySchedule({super.key, required this.tasks});

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
              "Today's Schedule",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          ...tasks.take(3).map((task) => _buildTaskItem(task)),
        ],
      ),
    );
  }

  Widget _buildTaskItem(Task task) {
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
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: task.completed ? AppColors.success : AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              task.title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                decoration: task.completed ? TextDecoration.lineThrough : null,
                color: task.completed ? AppColors.textLight : AppColors.textPrimary,
              ),
            ),
          ),
          if (task.dueDate != null)
            Text(
              '${task.dueDate!.hour.toString().padLeft(2, '0')}:${task.dueDate!.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(color: AppColors.textLight, fontSize: 12),
            ),
        ],
      ),
    );
  }
}