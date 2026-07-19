import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/task.dart';
import 'models/category.dart';
import 'models/profile.dart';
import 'services/category_service.dart';
import 'services/profile_service.dart';
import 'screens/main_screen.dart';
import 'screens/welcome_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register adapters ONLY once
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(TaskAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(ProfileAdapter());
  }
  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(CategoryAdapter());
  }

  // Open boxes
  await Hive.openBox<Task>('tasks');
  await Hive.openBox<Category>('categories');
  await Hive.openBox<Profile>('profile');
  await Hive.openBox('gamification');

  // Wrap init categories in try/catch to avoid crash
  try {
    await CategoryService.initializeDefaultCategories();
  } catch (_) {}

  runApp(const RiAtlasTaskApp());
}

class RiAtlasTaskApp extends StatelessWidget {
  const RiAtlasTaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RiAtlas Task',
      theme: AppTheme.lightTheme,
      home: ProfileService.hasProfile()
          ? const MainScreen()
          : const WelcomeScreen(),
    );
  }
}