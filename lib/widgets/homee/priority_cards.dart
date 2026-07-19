import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class PriorityCards extends StatelessWidget {
  final int high;
  final int medium;
  final int low;
  final String selectedPriority;
  final ValueChanged<String> onPrioritySelected;

  const PriorityCards({
    super.key,
    required this.high,
    required this.medium,
    required this.low,
    required this.selectedPriority,
    required this.onPrioritySelected,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _PriorityItem('High', high, AppColors.highPriority),
      _PriorityItem('Medium', medium, AppColors.mediumPriority),
      _PriorityItem('Low', low, AppColors.lowPriority),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: items.map((item) {
          final isSelected = selectedPriority == item.label;
          return Expanded(
            child: GestureDetector(
              onTap: () => onPrioritySelected(isSelected ? 'All' : item.label),
              child: Container(
                margin: EdgeInsets.only(right: item.label != 'Low' ? 10 : 0),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: isSelected ? item.color : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.textPrimary.withValues(alpha: 0.04),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      item.count.toString(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : item.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white70 : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _PriorityItem {
  final String label;
  final int count;
  final Color color;
  _PriorityItem(this.label, this.count, this.color);
}
