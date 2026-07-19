import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/task.dart';

class HiveService {
  static final ValueNotifier<List<Task>> _notifier = ValueNotifier<List<Task>>([]);
  static ValueNotifier<List<Task>> get notifier => _notifier;

  static Box<Task> get _box => Hive.box<Task>('tasks');

  // ✅ Fixed: Added () to the getter so it returns a Box, not a Function reference
  static Box _categoryBox() => Hive.box('categories');

  static List<Task> getTasks() {
    final tasks = _box.values.toList();
    _notifier.value = List.from(tasks);
    return tasks;
  }

  static Task? getTask(String id) => _box.get(id);

  static Future<void> addTask(Task task) async {
    await _box.put(task.id, task);
    _notifier.value = List.from(_box.values.toList());
  }

  static Future<void> updateTask(Task task) async {
    await _box.put(task.id, task);
    _notifier.value = List.from(_box.values.toList());
  }

  static Future<void> deleteTask(Task task) async {
    await _box.delete(task.id);
    _notifier.value = List.from(_box.values.toList());
  }

  static Future<void> clearAll() async {
    await _box.clear();
    _notifier.value = [];
  }

  static List<Task> getFilteredTasks({
    required String category,
    required String search,
  }) {
    final tasks = getTasks();
    return tasks.where((task) {
      final matchCategory = category == 'All' || task.category == category;
      final matchSearch = task.title.toLowerCase().contains(search.toLowerCase()) ||
          task.description.toLowerCase().contains(search.toLowerCase());
      return matchCategory && matchSearch;
    }).toList();
  }

  static Map<String, dynamic> getTodayStats() {
    final tasks = getTasks();
    final completed = tasks.where((t) => t.completed).length;
    final total = tasks.length;
    final progress = total > 0 ? completed / total : 0.0;

    return {
      'completed': completed,
      'total': total,
      'progress': progress,
      'xp': 620,
      'xpProgress': 0.7,
      'streak': 8,
    };
  }

  static Map<String, int> getTaskCounters() {
    final tasks = getTasks();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return {
      'high': tasks.where((t) => t.priority == 'High' && !t.completed).length,
      'dueToday': tasks.where((t) {
        if (t.dueDate == null || t.completed) return false;
        final taskDate = DateTime(t.dueDate!.year, t.dueDate!.month, t.dueDate!.day);
        return taskDate == today;
      }).length,
      'completed': tasks.where((t) => t.completed).length,
    };
  }

  // ========== CATEGORY METHODS ==========
  static Future<List<Map<String, dynamic>>> getCategories() async {
    final List<Map<String, dynamic>> categoryList = [];
    // ✅ Fixed: Call _categoryBox() to get the actual Box instance
    for (var item in _categoryBox().values) {
      if (item is Map) {
        categoryList.add(Map<String, dynamic>.from(item));
      }
    }
    return categoryList;
  }

  static Future<void> addCategory(Map<String, dynamic> categoryData) async {
    await _categoryBox().add(categoryData);
  }

  static Future<void> deleteCategory(int index) async {
    await _categoryBox().deleteAt(index);
  }

  static Future<void> clearCategories() async {
    await _categoryBox().clear();
  }
}