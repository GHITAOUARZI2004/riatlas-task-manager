import 'package:flutter/material.dart';
import '../../models/task.dart';
import '../../theme/app_theme.dart';

class SwipeableTaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onArchive;

  const SwipeableTaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onChanged,
    required this.onEdit,
    required this.onDelete,
    required this.onArchive,
  });

  Color _priorityColor() {
    switch (task.priority) {
      case 'High': return AppColors.highPriority;
      case 'Medium': return AppColors.mediumPriority;
      case 'Low': return AppColors.lowPriority;
      default: return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.textPrimary.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Checkbox
              Checkbox(
                value: task.completed,
                onChanged: onChanged,
                activeColor: AppColors.success,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              const SizedBox(width: 8),
              // Priority indicator
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: _priorityColor(),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        decoration: task.completed ? TextDecoration.lineThrough : null,
                        color: task.completed ? AppColors.textLight : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _priorityColor().withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            task.priority,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: _priorityColor(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (task.dueDate != null)
                          Text(
                            task.dueDate.toString().split(' ')[0],
                            style: const TextStyle(fontSize: 11, color: AppColors.textLight),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              // Category chip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  task.category,
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}