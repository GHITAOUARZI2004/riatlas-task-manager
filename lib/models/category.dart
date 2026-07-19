import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 2)
class Category extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String iconName;

  @HiveField(2)
  int colorValue;

  @HiveField(3)
  DateTime createdAt;

  Category({
    required this.name,
    required this.iconName,
    required this.colorValue,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Color get color => Color(colorValue);
}
