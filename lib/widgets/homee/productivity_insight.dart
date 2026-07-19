import 'package:flutter/material.dart';
import '../../models/task.dart';
import '../../theme/app_theme.dart';

class ProductivityInsight extends StatelessWidget {
  final List<Task> tasks;

  const ProductivityInsight({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) return const SizedBox();

    final completed = tasks.where((t) => t.completed).length;
    final rate = tasks.isEmpty ? 0 : (completed / tasks.length * 100).round();

    String message;
    IconData icon;
    Color color;

    if (rate >= 80) {
      message = 'Outstanding! You\'re on fire 🔥';
      icon = Icons.emoji_events;
      color = AppColors.amber;
    } else if (rate >= 50) {
      message = 'Great progress! Keep the momentum 🌿';
      icon = Icons.trending_up;
      color = AppColors.success;
    } else if (rate >= 20) {
      message = 'Good start! Stay consistent 💪';
      icon = Icons.star;
      color = AppColors.primary;
    } else {
      message = 'Let\'s get some tasks done today! 🚀';
      icon = Icons.lightbulb_outline;
      color = AppColors.terracotta;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}