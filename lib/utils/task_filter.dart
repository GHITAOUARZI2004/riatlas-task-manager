import '../models/task.dart';

List<Task> filterTasks({
  required List<Task> tasks,
  required String search,
  required String status,
  required String priority,
}) {
  return tasks.where((task) {
    // Search filter
    if (search.isNotEmpty) {
      final query = search.toLowerCase();
      final matches = task.title.toLowerCase().contains(query) ||
          task.description.toLowerCase().contains(query) ||
          task.category.toLowerCase().contains(query);
      if (!matches) return false;
    }

    // Status filter
    switch (status) {
      case 'Today':
        if (task.dueDate == null) return false;
        final today = DateTime.now();
        final due = task.dueDate!;
        return due.year == today.year &&
            due.month == today.month &&
            due.day == today.day;
      case 'Completed':
        return task.completed;
      case 'Pending':
        return !task.completed;
      case 'All':
      default:
        break;
    }

    // Priority filter
    if (priority != 'All' && task.priority != priority) {
      return false;
    }

    return true;
  }).toList();
}
