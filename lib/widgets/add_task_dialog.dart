import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/category_service.dart';

// Unified Morocco color palette (same across whole app)
class MoroccanPalette {
  static const Color blushPink = Color(0xFFFFF0F2);
  static const Color deepRose = Color(0xFFE05A7B);
  static const Color vibrantPink = Color(0xFFFF7B9C);
  static const Color softPink = Color(0xFFFFD6E0);
  static const Color terracotta = Color(0xFFE27356);
  static const Color goldAmber = Color(0xFFE4A834);
  static const Color mintSage = Color(0xFF7BC9A5);
  static const Color darkEspresso = Color(0xFF4A3438);
  static const Color softCream = Color(0xFFFFFBFA);
  static const Color moroccanBlue = Color(0xFF3A7CA5);
  static const Color glowPink = Color(0xFFFFB6C8);
}

class AddTaskDialog extends StatefulWidget {
  final Function(Task) onSave;

  const AddTaskDialog({super.key, required this.onSave});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String _priority = 'Medium';
  String _category = 'Personal';
  DateTime? _dueDate;

  final _priorities = ['High', 'Medium', 'Low'];

  @override
  Widget build(BuildContext context) {
    final categories = CategoryService.getCategoryNames();
    if (!categories.contains(_category) && categories.isNotEmpty) {
      _category = categories.first;
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: MoroccanPalette.softCream,
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: MoroccanPalette.vibrantPink.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.add_task, color: MoroccanPalette.vibrantPink),
                ),
                const SizedBox(width: 12),
                const Text(
                  'New Task',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: MoroccanPalette.darkEspresso,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _titleController,
                      style: const TextStyle(color: MoroccanPalette.darkEspresso),
                      decoration: InputDecoration(
                        hintText: 'Task title',
                        hintStyle: TextStyle(color: MoroccanPalette.darkEspresso.withValues(alpha: 0.5)),
                        prefixIcon: const Icon(Icons.title, color: MoroccanPalette.vibrantPink),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: MoroccanPalette.vibrantPink),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _descController,
                      maxLines: 2,
                      style: const TextStyle(color: MoroccanPalette.darkEspresso),
                      decoration: InputDecoration(
                        hintText: 'Description (optional)',
                        hintStyle: TextStyle(color: MoroccanPalette.darkEspresso.withValues(alpha: 0.5)),
                        prefixIcon: const Icon(Icons.description_outlined, color: MoroccanPalette.vibrantPink),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: MoroccanPalette.vibrantPink),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Priority',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: MoroccanPalette.darkEspresso,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _priorities.map((p) {
                        final isSelected = _priority == p;
                        final colors = {
                          'High': MoroccanPalette.terracotta,
                          'Medium': MoroccanPalette.goldAmber,
                          'Low': MoroccanPalette.mintSage,
                        };
                        return ChoiceChip(
                          label: Text(p),
                          selected: isSelected,
                          onSelected: (_) => setState(() => _priority = p),
                          selectedColor: colors[p]?.withValues(alpha: 0.2),
                          backgroundColor: MoroccanPalette.blushPink,
                          labelStyle: TextStyle(
                            color: isSelected ? colors[p] : MoroccanPalette.darkEspresso.withValues(alpha: 0.6),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Category',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: MoroccanPalette.darkEspresso,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: categories.map((c) {
                        final isSelected = _category == c;
                        return ChoiceChip(
                          label: Text(c),
                          selected: isSelected,
                          onSelected: (_) => setState(() => _category = c),
                          selectedColor: MoroccanPalette.vibrantPink.withValues(alpha: 0.15),
                          backgroundColor: MoroccanPalette.blushPink,
                          labelStyle: TextStyle(
                            color: isSelected ? MoroccanPalette.deepRose : MoroccanPalette.darkEspresso.withValues(alpha: 0.6),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.calendar_today, color: MoroccanPalette.vibrantPink),
                      title: Text(
                        _dueDate == null ? 'Set due date' : _dueDate.toString().split(' ')[0],
                        style: TextStyle(
                          color: _dueDate == null
                              ? MoroccanPalette.darkEspresso.withValues(alpha: 0.4)
                              : MoroccanPalette.darkEspresso,
                        ),
                      ),
                      trailing: _dueDate != null
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18, color: MoroccanPalette.terracotta),
                              onPressed: () => setState(() => _dueDate = null),
                            )
                          : null,
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _dueDate ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) setState(() => _dueDate = picked);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      side: const BorderSide(color: MoroccanPalette.vibrantPink),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: MoroccanPalette.deepRose),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_titleController.text.trim().isEmpty) return;
                      final task = Task(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: _titleController.text.trim(),
                        description: _descController.text.trim(),
                        priority: _priority,
                        category: _category,
                        dueDate: _dueDate,
                        xpReward: _priority == 'High' ? 20 : _priority == 'Medium' ? 15 : 10,
                      );
                      await widget.onSave(task);
                      if (context.mounted) Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MoroccanPalette.deepRose,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Add Task'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }
}