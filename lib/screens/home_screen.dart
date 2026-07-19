import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/hive_service.dart';
import '../services/profile_service.dart';
import '../widgets/task/task_card.dart';
import '../widgets/add_task_dialog.dart';
import '../widgets/edit_task_dialog.dart';

class MoroccanPalette {
  static const Color blushPink = Color(0xFFFFF0F2);
  static const Color deepRose = Color(0xFFE05A7B);
  static const Color vibrantPink = Color(0xFFFF7B9C);
  static const Color softPink = Color(0xFFFFD6E0);
  static const Color terracotta = Color(0xFFE27356);
  static const Color goldAmber = Color(0xFFE4A834);
  static const Color mintSage = Color(0xFF7BC9A5);
  static const Color darkEspresso = Color(0xFF4A3438);
  static const Color completedGreen = Color(0xFF4CAF50);
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late AnimationController _fadeController;
  late AnimationController _pulseController;

  String _searchText = '';
  String _selectedCategory = 'All';
  List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  // Load categories from Hive (async)
  Future<void> _loadCategories() async {
    final List<Map<String, dynamic>> savedCats = await HiveService.getCategories();
    setState(() {
      _categories = [
        {
          'name': 'All',
          'icon': Icons.grid_view_rounded,
          'color': MoroccanPalette.vibrantPink
        }
      ];
      _categories.addAll(savedCats);
    });
  }

  // Navigate to Categories screen & refresh categories after returning
  Future<void> _goToCategories() async {
    await Navigator.pushNamed(context, '/categories');
    await _loadCategories();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _fadeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MoroccanPalette.blushPink,
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.03,
              child: Image.asset(
                'assets/images/moroccan_mosaic.png',
                repeat: ImageRepeat.repeat,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildSearchBar(),
                  const SizedBox(height: 20),
                  _buildProgressCard(),
                  const SizedBox(height: 24),
                  _buildCategoriesSection(),
                  const SizedBox(height: 20),
                  _buildTaskCounters(),
                  const SizedBox(height: 24),
                  _buildTasksSection(),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: MoroccanPalette.deepRose,
        foregroundColor: Colors.white,
        onPressed: _showAddTaskDialog,
        label: const Text('Add Task'),
        icon: const Icon(Icons.add),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final profile = ProfileService.getProfile();
    final String userName = profile?.name ?? 'Ghita';
    final String? avatarPath = profile?.avatarUrl;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Good Morning,',
                style: TextStyle(
                  fontSize: 18,
                  color: MoroccanPalette.darkEspresso,
                ),
              ),
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: MoroccanPalette.deepRose,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Let\'s make today productive 🌸',
                style: TextStyle(
                  fontSize: 14,
                  color: MoroccanPalette.darkEspresso,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(13),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.notifications_none, color: MoroccanPalette.deepRose),
        ),
        const SizedBox(width: 12),
        CircleAvatar(
          radius: 28,
          backgroundColor: MoroccanPalette.softPink,
          backgroundImage: avatarPath != null ? AssetImage(avatarPath) : null,
          child: avatarPath == null
              ? const Icon(Icons.person, color: MoroccanPalette.deepRose)
              : null,
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: MoroccanPalette.vibrantPink),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchText = val),
              decoration: const InputDecoration(
                hintText: 'Search tasks...',
                border: InputBorder.none,
              ),
            ),
          ),
          Icon(Icons.filter_list, color: MoroccanPalette.vibrantPink),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    final stats = HiveService.getTodayStats();
    final profile = ProfileService.getProfile();

    final int currentXp = profile?.totalXp ?? 0;
    final int currentLevel = profile?.level ?? 1;
    const int xpForNext = 100;
    final double xpProgress = (currentXp % xpForNext) / xpForNext;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: stats['progress'] ?? 0.0,
                      backgroundColor: MoroccanPalette.softPink,
                      color: MoroccanPalette.deepRose,
                      strokeWidth: 8,
                    ),
                    Text(
                      '${((stats['progress'] ?? 0.0) * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: MoroccanPalette.darkEspresso,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Today\'s Goal',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: MoroccanPalette.darkEspresso,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${stats['completed'] ?? 0} / ${stats['total'] ?? 0} Tasks Completed',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.local_fire_department, color: Colors.orange, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${stats['streak'] ?? 0} Day Streak',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: MoroccanPalette.goldAmber.withAlpha(51),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.star, color: MoroccanPalette.goldAmber),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Level $currentLevel',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: MoroccanPalette.darkEspresso,
                          ),
                        ),
                        Text(
                          '$currentXp XP',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: xpProgress,
                  backgroundColor: MoroccanPalette.softPink,
                  color: MoroccanPalette.deepRose,
                  borderRadius: BorderRadius.circular(10),
                  minHeight: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Fixed categories section (no overflow, dynamic categories)
  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: MoroccanPalette.darkEspresso,
              ),
            ),
            TextButton(
              onPressed: _goToCategories,
              child: const Text(
                'View all',
                style: TextStyle(color: MoroccanPalette.deepRose),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Increased height to prevent overflow
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final cat = _categories[index];
              final isSelected = _selectedCategory == cat['name'];
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat['name']),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Critical for overflow
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected ? cat['color'] : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(13),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(
                          cat['icon'],
                          color: isSelected ? Colors.white : cat['color'],
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 6), // Spacing between icon and text
                      Text(
                        cat['name'],
                        style: TextStyle(
                          color: isSelected ? cat['color'] : Colors.grey,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTaskCounters() {
    final counters = HiveService.getTaskCounters();
    return Row(
      children: [
        Expanded(
          child: _buildCounterCard(
            title: 'High Priority',
            count: counters['high'] ?? 0,
            icon: Icons.star,
            color: MoroccanPalette.deepRose,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildCounterCard(
            title: 'Due Today',
            count: counters['dueToday'] ?? 0,
            icon: Icons.access_time,
            color: MoroccanPalette.goldAmber,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildCounterCard(
            title: 'Completed',
            count: counters['completed'] ?? 0,
            icon: Icons.check_circle,
            color: MoroccanPalette.completedGreen,
          ),
        ),
      ],
    );
  }

  Widget _buildCounterCard({
    required String title,
    required int count,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: color.withAlpha(51), width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: MoroccanPalette.darkEspresso,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          const Text('Tasks', style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildTasksSection() {
    final tasks = HiveService.getFilteredTasks(
      category: _selectedCategory,
      search: _searchText,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Today\'s Tasks',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: MoroccanPalette.darkEspresso,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'View all',
                style: TextStyle(color: MoroccanPalette.deepRose),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TaskCard(
                task: task,
                onToggleComplete: () => _toggleTaskComplete(task),
                onEdit: () => _showEditTaskDialog(task),
                onDelete: () => _deleteTask(task),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (_) => AddTaskDialog(
        onSave: (task) async {
          await HiveService.addTask(task);
          setState(() {});
        },
      ),
    );
  }

  void _showEditTaskDialog(Task task) {
    showDialog(
      context: context,
      builder: (_) => EditTaskDialog(
        task: task,
        onSave: (updated) async {
          await HiveService.updateTask(updated);
          setState(() {});
        },
      ),
    );
  }

  Future<void> _toggleTaskComplete(Task task) async {
    task.completed = !task.completed;
    if (task.completed) {
      task.completedAt = DateTime.now();
      await ProfileService.updateXp(task.xpReward);
    } else {
      task.completedAt = null;
    }
    await HiveService.updateTask(task);
    setState(() {});
  }

  Future<void> _deleteTask(Task task) async {
    await HiveService.deleteTask(task);
    setState(() {});
  }
}