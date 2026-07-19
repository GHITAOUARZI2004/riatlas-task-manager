import 'package:flutter/material.dart';
import '../../models/task.dart';
import '../../theme/app_theme.dart';

class MiniCalendar extends StatelessWidget {
  final List<Task> tasks;

  const MiniCalendar({super.key, required this.tasks});

  Map<DateTime, int> get _completionMap {
    final map = <DateTime, int>{};
    for (final task in tasks) {
      if (!task.completed || task.completedAt == null) continue;
      final date = DateTime(task.completedAt!.year, task.completedAt!.month, task.completedAt!.day);
      map[date] = (map[date] ?? 0) + 1;
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final map = _completionMap;
    final today = DateTime.now();
    final startDate = today.subtract(const Duration(days: 20));

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
          const Row(
            children: [
              Icon(Icons.calendar_today, color: AppColors.primary, size: 18),
              SizedBox(width: 8),
              Text(
                'Activity Calendar',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 21,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              childAspectRatio: 1,
            ),
            itemBuilder: (_, index) {
              final day = startDate.add(Duration(days: index));
              final completed = map[day] ?? 0;
              final isToday = day.year == today.year && day.month == today.month && day.day == today.day;

              Color color;
              if (isToday) {
                color = AppColors.primary;
              } else if (completed == 0) {
                color = Colors.grey.shade200;
              } else if (completed <= 2) {
                color = AppColors.primaryLight.withValues(alpha: 0.4);
              } else {
                color = AppColors.primary;
              }

              return Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6),
                ),
                alignment: Alignment.center,
                child: isToday
                    ? const Icon(Icons.circle, color: Colors.white, size: 6)
                    : null,
              );
            },
          ),
        ],
      ),
    );
  }
}