import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/category.dart';

class CategoryService {
  static Box<Category> get _box => Hive.box<Category>('categories');

  static List<Category> getCategories() => _box.values.toList();

  static List<String> getCategoryNames() =>
      _box.values.map((c) => c.name).toList();

  static Future<void> addCategory(Category category) async {
    await _box.put(category.name, category);
  }

  static Future<void> updateCategory(String oldName, Category category) async {
    await _box.delete(oldName);
    await _box.put(category.name, category);
  }

  static Future<void> deleteCategory(String name) async {
    await _box.delete(name);
  }

  static Future<void> initializeDefaultCategories() async {
    if (_box.isNotEmpty) return;

    final defaults = [
      Category(name: 'Personal', iconName: 'person', colorValue: 0xFF0F766E),
      Category(name: 'Work', iconName: 'work', colorValue: 0xFF2563EB),
      Category(name: 'Study', iconName: 'school', colorValue: 0xFF8B5CF6),
      Category(name: 'Health', iconName: 'favorite', colorValue: 0xFFE11D48),
      Category(name: 'Urgent', iconName: 'priority_high', colorValue: 0xFFD97706),
    ];

    for (final cat in defaults) {
      await _box.put(cat.name, cat);
    }
  }

  // Available icons for selection
  static List<IconData> get availableIcons => [
    Icons.person, Icons.work, Icons.school, Icons.favorite,
    Icons.priority_high, Icons.shopping_cart, Icons.fitness_center,
    Icons.restaurant, Icons.attach_money, Icons.home,
    Icons.flight, Icons.music_note, Icons.palette,
    Icons.code, Icons.book, Icons.pets, Icons.local_hospital,
    Icons.celebration, Icons.family_restroom, Icons.directions_car,
  ];

  // Available colors for selection
  static List<Color> get availableColors => [
    const Color(0xFF0F766E), const Color(0xFF2563EB), const Color(0xFF8B5CF6),
    const Color(0xFFE11D48), const Color(0xFFD97706), const Color(0xFF10B981),
    const Color(0xFFF59E0B), const Color(0xFF06B6D4), const Color(0xFFEC4899),
    const Color(0xFF6366F1), const Color(0xFF14B8A6), const Color(0xFFF97316),
    const Color(0xFF84CC16), const Color(0xFF3B82F6), const Color(0xFFEF4444),
    const Color(0xFF8B5A2B), const Color(0xFF4B5563), const Color(0xFF1E293B),
  ];
}