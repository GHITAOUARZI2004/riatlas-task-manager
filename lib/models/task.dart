import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  bool completed;

  @HiveField(4)
  DateTime? dueDate;

  @HiveField(5)
  String priority;

  @HiveField(6)
  String category;

  @HiveField(7)
  DateTime? completedAt;

  @HiveField(8)
  int xpReward;

  @HiveField(9)
  DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.completed = false,
    this.dueDate,
    this.priority = 'Medium',
    this.category = 'Personal',
    this.completedAt,
    this.xpReward = 10,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? completed,
    DateTime? dueDate,
    String? priority,
    String? category,
    DateTime? completedAt,
    int? xpReward,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      completedAt: completedAt ?? this.completedAt,
      xpReward: xpReward ?? this.xpReward,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}