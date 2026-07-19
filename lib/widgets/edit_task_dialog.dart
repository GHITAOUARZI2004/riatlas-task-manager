import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/category_service.dart';

// Unified Morocco color palette (same as home_screen & add dialog)
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

class EditTaskDialog extends StatefulWidget {
  final Task task;
  final Function(Task) onSave;

  const EditTaskDialog({super.key, required this.task, required this.onSave});

  @override
  State<EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  late final _titleController = TextEditingController(text: widget.task.title);
  late final _descController = TextEditingController(text: widget.task.description);
  late String _priority = widget.task.priority;
  late String _category = widget.task.category;
  late DateTime? _dueDate = widget.task.dueDate;

  final _priorities = ['High', 'Medium', 'Low'];

  @override
  Widget build(BuildContext context) {
    final categories = CategoryService.getCategoryNames();

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
                    color: MoroccanPalette.goldAmber.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.edit, color: MoroccanPalette.goldAmber),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Edit Task',
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
                        hintText: 'Description',
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
                    onPressed: () {
                      if (_titleController.text.trim().isEmpty) return;
                      final updated = widget.task.copyWith(
                        title: _titleController.text.trim(),
                        description: _descController.text.trim(),
                        priority: _priority,
                        category: _category,
                        dueDate: _dueDate,
                      );
                      widget.onSave(updated);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MoroccanPalette.deepRose,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Save Changes'),
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