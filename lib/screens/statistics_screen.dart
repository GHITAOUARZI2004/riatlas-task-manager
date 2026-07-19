import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/hive_service.dart';
import '../services/category_service.dart';
import '../theme/app_theme.dart';

class AchievementBadge {
  final String title;
  final String emoji;
  final bool unlocked;
  AchievementBadge({required this.title, required this.emoji, required this.unlocked});
}

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});
  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  int get totalTasks => HiveService.getTasks().length;
  int get completedTasks => HiveService.getTasks().where((t) => t.completed).length;
  int get pendingTasks => totalTasks - completedTasks;
  double get progress => totalTasks == 0 ? 0 : completedTasks / totalTasks;
  int get categoryCount => CategoryService.getCategories().length;
  int get completionRate =>
      totalTasks == 0 ? 0 : ((completedTasks / totalTasks) * 100).round();

  int get todayTasks {
    final today = DateTime.now();
    return HiveService.getTasks().where((task) {
      if (task.dueDate == null) return false;
      return task.dueDate!.year == today.year &&
          task.dueDate!.month == today.month &&
          task.dueDate!.day == today.day;
    }).length;
  }

  Map<String, int> get categoryStats {
    final stats = <String, int>{};
    for (final task in HiveService.getTasks()) {
      stats[task.category] = (stats[task.category] ?? 0) + 1;
    }
    return stats;
  }

  Map<String, int> get weeklyStats {
    final stats = {
      'Mon': 0,
      'Tue': 0,
      'Wed': 0,
      'Thu': 0,
      'Fri': 0,
      'Sat': 0,
      'Sun': 0
    };
    for (final task in HiveService.getTasks()) {
      if (!task.completed) continue;
      if (task.dueDate == null) continue;
      final dayName = [
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat',
        'Sun'
      ][task.dueDate!.weekday - 1];
      stats[dayName] = (stats[dayName] ?? 0) + 1;
    }
    return stats;
  }

  Map<String, int> get priorityStats {
    final tasks = HiveService.getTasks();
    return {
      'High': tasks.where((t) => t.priority == 'High').length,
      'Medium': tasks.where((t) => t.priority == 'Medium').length,
      'Low': tasks.where((t) => t.priority == 'Low').length
    };
  }

  int get currentStreak {
    final completed = HiveService.getTasks()
        .where((t) => t.completedAt != null)
        .map((t) => DateTime(t.completedAt!.year, t.completedAt!.month, t.completedAt!.day))
        .toSet()
        .toList();
    completed.sort((a, b) => b.compareTo(a));
    if (completed.isEmpty) return 0;
    int streak = 0;
    DateTime expected =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    for (final day in completed) {
      if (day == expected) {
        streak++;
        expected = expected.subtract(const Duration(days: 1));
      } else if (day == expected.subtract(const Duration(days: 1)) && streak == 0) {
        streak = 1;
        expected = day.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }

  List<AchievementBadge> get achievementBadges => [
        AchievementBadge(title: 'First Task', emoji: '🏆', unlocked: totalTasks >= 1),
        AchievementBadge(title: '5 Tasks Done', emoji: '🔥', unlocked: completedTasks >= 5),
        AchievementBadge(title: 'Halfway There', emoji: '⭐', unlocked: completionRate >= 50),
        AchievementBadge(title: 'Master', emoji: '🚀', unlocked: completedTasks >= 20),
        AchievementBadge(title: 'Organized', emoji: '📂', unlocked: categoryCount >= 5),
        AchievementBadge(title: 'Champion', emoji: '💎', unlocked: completedTasks >= 50),
      ];

  List<String> get smartInsights {
    final insights = <String>[];
    final tasks = HiveService.getTasks();
    if (tasks.isEmpty) {
      insights.add('Start adding tasks to unlock productivity insights.');
      return insights;
    }
    final work = tasks.where((t) => t.category == 'Work').length;
    final personal = tasks.where((t) => t.category == 'Personal').length;
    if (work > personal) {
      insights.add('💼 Work tasks dominate your list.');
    } else if (personal > work) {
      insights.add('🏡 Personal tasks lead the way.');
    }
    final overdue = tasks
        .where((t) =>
            !t.completed &&
            t.dueDate != null &&
            t.dueDate!.isBefore(DateTime.now()))
        .length;
    if (overdue > 0) {
      insights.add('⚠️ You have $overdue overdue tasks.');
    }
    if (completionRate >= 80) {
      insights.add('🎯 Excellent productivity!');
    } else if (completionRate >= 50) {
      insights.add('🌿 Steady progress, keep going!');
    } else {
      insights.add('🚀 Complete a few tasks to boost productivity.');
    }
    if (todayTasks > 0) {
      insights.add('📅 $todayTasks task(s) due today.');
    }
    return insights;
  }

  final quotes = [
    'Small progress every day leads to big achievements.',
    'Discipline beats motivation.',
    'Every task completed is a step toward success.',
    'Stay focused. Stay consistent.',
    "Today's effort creates tomorrow's success.",
    'Little by little, a little becomes a lot.',
    'One task at a time.',
    'Success begins with a checklist.'
  ];
  String get quoteOfTheDay => quotes[DateTime.now().day % quotes.length];

  // Unified gradient border wrapper (same as all other screens)
  Widget _gradientBorderWrapper({
    required Widget child,
    required double borderRadius,
    double borderWidth = 1.8,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          colors: [
            AppColors.pink.withValues(alpha: 0.55),
            AppColors.amber.withValues(alpha: 0.45),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.pink.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      padding: EdgeInsets.all(borderWidth),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(borderRadius - borderWidth),
        ),
        child: child,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _scaleAnim = Tween<double>(begin: 0.94, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Moroccan mosaic background (match other screens)
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/moroccan_mosaic.png'),
            fit: BoxFit.cover,
            opacity: 0.16,
          ),
          color: AppColors.blush,
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _animController,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnim.value,
                child: Transform.scale(
                  scale: _scaleAnim.value,
                  child: child,
                ),
              );
            },
            child: ValueListenableBuilder<List<Task>>(
              valueListenable: HiveService.notifier,
              builder: (context, tasks, _) {
                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                  children: [
                    // Page Header
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.pink.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(
                            Icons.insert_chart_rounded,
                            color: AppColors.pink,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Statistics',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.pinkDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    _buildProgressCard(),
                    const SizedBox(height: 20),
                    _buildStatsGrid(),
                    const SizedBox(height: 20),
                    _buildStreakCard(),
                    const SizedBox(height: 20),
                    _buildWeeklyActivity(),
                    const SizedBox(height: 20),
                    _buildCategoryBreakdown(),
                    const SizedBox(height: 20),
                    _buildPriorityDistribution(),
                    const SizedBox(height: 20),
                    _buildAchievements(),
                    const SizedBox(height: 20),
                    _buildSmartInsights(),
                    const SizedBox(height: 20),
                    _buildQuoteCard(),
                    const SizedBox(height: 40),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressCard() {
    return _gradientBorderWrapper(
      borderRadius: 28,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28 - 1.8),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 18,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Column(
          children: [
            const Text(
              'Productivity',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 140,
                  height: 140,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Completed',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              '$completedTasks of $totalTasks tasks finished',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              progress == 1
                  ? 'Excellent! Everything is done 🎉'
                  : 'Keep going! Every task counts 🌿',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    final items = [
      _GridItem('Total', totalTasks.toString(), Icons.assignment, AppColors.primary),
      _GridItem('Done', completedTasks.toString(), Icons.check_circle, AppColors.success),
      _GridItem('Pending', pendingTasks.toString(), Icons.schedule, AppColors.warning),
      _GridItem('Today', todayTasks.toString(), Icons.today, AppColors.terracotta),
      _GridItem('Categories', categoryCount.toString(), Icons.folder, Colors.deepPurple),
      _GridItem('Rate', '$completionRate%', Icons.emoji_events, AppColors.amber),
    ];
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1,
      children: items.map((item) => _buildGridCard(item)).toList(),
    );
  }

  Widget _buildGridCard(_GridItem item) {
    return _gradientBorderWrapper(
      borderRadius: 20,
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: item.color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(item.icon, color: item.color, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              item.value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakCard() {
    return _gradientBorderWrapper(
      borderRadius: 24,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24 - 1.8),
          gradient: const LinearGradient(
            colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.local_fire_department, color: Colors.white, size: 48),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Streak',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Text(
                    '$currentStreak Days 🔥',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyActivity() {
    final stats = weeklyStats;
    final max = stats.values.every((e) => e == 0) ? 1 : stats.values.reduce((a, b) => a > b ? a : b);
    return _buildSectionCard(
      title: 'Weekly Activity',
      child: SizedBox(
        height: 160,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: stats.entries.map((entry) {
            final value = entry.value / max;
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  entry.value.toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                const SizedBox(height: 6),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: 22,
                  height: 90 * value + 8,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryLight],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  entry.key,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCategoryBreakdown() {
    final stats = categoryStats;
    if (stats.isEmpty) return const SizedBox();
    final maxValue = stats.values.reduce((a, b) => a > b ? a : b);
    return _buildSectionCard(
      title: 'Tasks by Category',
      child: Column(
        children: stats.entries
            .map((entry) => _buildBarRow(entry.key, entry.value, maxValue, AppColors.primary))
            .toList(),
      ),
    );
  }

  Widget _buildPriorityDistribution() {
    final stats = priorityStats;
    final max = stats.values.reduce((a, b) => a > b ? a : b);
    final colors = {
      'High': AppColors.highPriority,
      'Medium': AppColors.mediumPriority,
      'Low': AppColors.lowPriority
    };
    return _buildSectionCard(
      title: 'Priority Distribution',
      child: Column(
        children: stats.entries
            .map((entry) => _buildBarRow(entry.key, entry.value, max, colors[entry.key] ?? AppColors.primary))
            .toList(),
      ),
    );
  }

  Widget _buildBarRow(String label, int value, int max, Color color) {
    final p = max == 0 ? 0.0 : value / max;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: p,
                minHeight: 8,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            value.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements() {
    return _buildSectionCard(
      title: 'Achievements',
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: achievementBadges.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.4,
        ),
        itemBuilder: (_, index) {
          final badge = achievementBadges[index];
          return Container(
            decoration: BoxDecoration(
              color: badge.unlocked ? AppColors.primary.withValues(alpha: 0.08) : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: badge.unlocked
                    ? AppColors.primary.withValues(alpha: 0.3)
                    : Colors.grey.shade200,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  badge.unlocked ? badge.emoji : '🔒',
                  style: const TextStyle(fontSize: 28),
                ),
                const SizedBox(height: 6),
                Text(
                  badge.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: badge.unlocked ? AppColors.textPrimary : AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  badge.unlocked ? 'Unlocked' : 'Locked',
                  style: TextStyle(
                    fontSize: 11,
                    color: badge.unlocked ? AppColors.success : AppColors.textLight,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSmartInsights() {
    return _buildSectionCard(
      title: 'Smart Insights',
      icon: Icons.auto_awesome,
      iconColor: Colors.deepPurple,
      child: Column(
        children: smartInsights
            .map((text) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.lightbulb, color: AppColors.amber, size: 18),
                      const SizedBox(width: 8),
                      Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildQuoteCard() {
    return _gradientBorderWrapper(
      borderRadius: 28,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28 - 1.8),
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.gold],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const Icon(Icons.format_quote, color: Colors.white, size: 32),
            const SizedBox(height: 12),
            Text(
              '"$quoteOfTheDay"',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required Widget child,
    IconData? icon,
    Color? iconColor,
  }) {
    return _gradientBorderWrapper(
      borderRadius: 24,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, color: iconColor ?? AppColors.primary, size: 20),
                  const SizedBox(width: 8)
                ],
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _GridItem {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  _GridItem(this.label, this.value, this.icon, this.color);
}