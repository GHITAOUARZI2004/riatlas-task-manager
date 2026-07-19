import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onToggleComplete;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggleComplete,
    required this.onEdit,
    required this.onDelete,
  });

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return const Color(0xFFE05A7B);
      case 'Medium':
        return const Color(0xFFE4A834);
      case 'Low':
        return const Color(0xFF4CAF50);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 60,
            decoration: BoxDecoration(
              color: _getPriorityColor(task.priority),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Checkbox(
            value: task.completed,
            onChanged: (_) => onToggleComplete(),
            activeColor: const Color(0xFF4CAF50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: task.completed ? Colors.grey : const Color(0xFF4A3438),
                    decoration: task.completed ? TextDecoration.lineThrough : null,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (task.dueDate != null)
                      Text(
                        DateFormat('EEE, MMM d').format(task.dueDate!),
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF0F2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        task.category,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFE05A7B),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getPriorityColor(task.priority).withAlpha(26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.flag,
                  color: _getPriorityColor(task.priority),
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  task.priority,
                  style: TextStyle(
                    fontSize: 12,
                    color: _getPriorityColor(task.priority),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert, color: Colors.grey),
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: onEdit,
                child: const Text('Edit'),
              ),
              PopupMenuItem(
                onTap: onDelete,
                child: const Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}