import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class SmartSearch extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onChipSelected;

  const SmartSearch({
    super.key,
    required this.controller,
    required this.onSearchChanged,
    required this.onChipSelected,
  });

  @override
  Widget build(BuildContext context) {
    final chips = ['Today', 'Completed', 'High', 'Work', 'Personal'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          // Search field
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.textPrimary.withValues(alpha: 0.04),
                  blurRadius: 8,
                ),
              ],
            ),
            child: TextField(
              controller: controller,
              onChanged: onSearchChanged,
              decoration: const InputDecoration(
                hintText: 'Search tasks...',
                hintStyle: TextStyle(color: AppColors.textLight),
                prefixIcon: Icon(Icons.search, color: AppColors.textLight),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: chips.map((chip) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    label: Text(chip),
                    onPressed: () => onChipSelected(chip),
                    backgroundColor: Colors.white,
                    side: BorderSide(color: AppColors.textLight.withValues(alpha: 0.3)),
                    labelStyle: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}