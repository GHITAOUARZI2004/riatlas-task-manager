import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;
import '../models/category.dart';
import '../services/category_service.dart';
import '../services/hive_service.dart';
import '../theme/app_theme.dart';
import '../widgets/category_dialog.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  IconData _getIcon(String name) {
    final map = <String, IconData>{
      'favorite': Icons.favorite,
      'auto_awesome': Icons.auto_awesome,
      'cruelty_free': Icons.cruelty_free,
      'cake': Icons.cake,
      'icecream': Icons.icecream,
      'cookie': Icons.cookie,
      'pets': Icons.pets,
      'flutter_dash': Icons.flutter_dash,
      'face_3': Icons.face_3,
      'spa': Icons.spa,
      'music_note': Icons.music_note,
      'coffee': Icons.coffee,
      'celebration': Icons.celebration,
      'shopping_bag': Icons.shopping_bag,
      'nightlight_round': Icons.nightlight_round,
      'wb_sunny': Icons.wb_sunny,
    };
    return map[name] ?? Icons.folder;
  }

  int _getTaskCount(String categoryName) {
    return HiveService.getTasks().where((t) => t.category == categoryName).length;
  }

  // Reusable gradient border wrapper (same as Settings screen)
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

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => CategoryDialog(
        onSave: (category) async {
          await CategoryService.addCategory(category);
          if (mounted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {});
            });
          }
        },
      ),
    );
  }

  void _showEditDialog(Category category) {
    showDialog(
      context: context,
      builder: (_) => CategoryDialog(
        category: category,
        onSave: (updated) async {
          await CategoryService.updateCategory(category.name, updated);
          if (mounted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {});
            });
          }
        },
      ),
    );
  }

  void _deleteCategory(Category category) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        elevation: 12,
        child: _gradientBorderWrapper(
          borderRadius: 32,
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32 - 1.8),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.98),
                  Colors.white.withValues(alpha: 0.92),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.pink.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.pink.withValues(alpha: 0.15),
                        blurRadius: 6,
                        offset: const Offset(2, 3),
                      )
                    ],
                  ),
                  child: const Icon(Icons.delete_outline, color: AppColors.pink, size: 44),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Delete Category?',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  '"${category.name}" will be removed. Tasks in this category will keep the label.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    height: 1.45,
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: AppColors.textLight.withValues(alpha: 0.5),
                            width: 1.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(dialogContext);
                          await CategoryService.deleteCategory(category.name);
                          if (mounted) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              setState(() {});
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          elevation: 4,
                        ),
                        child: const Text(
                          'Delete',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = CategoryService.getCategories();

    return MoroccanBackgroundWrapper(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            floating: true,
            elevation: 0,
            backgroundColor: AppColors.background.withValues(alpha: 0.85),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              title: Row(
                children: [
                  _gradientBorderWrapper(
                    borderRadius: 18,
                    borderWidth: 1.5,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.pink.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(18 - 1.5),
                      ),
                      child: const Icon(Icons.folder, color: AppColors.pink, size: 22),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Categories',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: AppColors.pinkDark,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.pinkDark, AppColors.pink],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.pink.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white, size: 24),
                  onPressed: _showAddDialog,
                  splashRadius: 24,
                ),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              height: 3,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.pink, AppColors.amber, AppColors.primaryLight],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  _gradientBorderWrapper(
                    borderRadius: 20,
                    borderWidth: 1.2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.pink.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(20 - 1.2),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.folder_outlined, size: 14, color: AppColors.pink),
                          const SizedBox(width: 6),
                          Text(
                            '${categories.length} ${categories.length == 1 ? 'category' : 'categories'}',
                            style: const TextStyle(
                              color: AppColors.pink,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      _buildDot(AppColors.pink, 0),
                      const SizedBox(width: 6),
                      _buildDot(AppColors.amber, 100),
                      const SizedBox(width: 6),
                      _buildDot(AppColors.primaryLight, 200),
                    ],
                  ),
                ],
              ),
            ),
          ),

          categories.isEmpty
              ? SliverFillRemaining(child: _buildEmptyState())
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final cat = categories[index];
                      final taskCount = _getTaskCount(cat.name);
                      return _buildCategoryCard(cat, taskCount, index);
                    },
                    childCount: categories.length,
                  ),
                ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(Category cat, int taskCount, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: _gradientBorderWrapper(
        borderRadius: 28,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.96),
                Colors.white.withValues(alpha: 0.88),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28 - 1.8),
            boxShadow: [
              BoxShadow(
                color: AppColors.pink.withValues(alpha: 0.12),
                blurRadius: 12,
                offset: const Offset(0, 5),
                spreadRadius: 1,
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.7),
                blurRadius: 6,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      cat.color.withValues(alpha: 0.18),
                      cat.color.withValues(alpha: 0.08),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: cat.color.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(1, 2),
                    )
                  ],
                ),
                child: Icon(_getIcon(cat.iconName), color: cat.color, size: 26),
              ),
              const SizedBox(width: 18),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cat.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.pink.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$taskCount ${taskCount == 1 ? 'task' : 'tasks'}',
                            style: const TextStyle(
                              color: AppColors.pink,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        if (taskCount > 0)
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: (taskCount / 20).clamp(0.0, 1.0),
                                minHeight: 5,
                                backgroundColor: Colors.grey.shade100,
                                valueColor: AlwaysStoppedAnimation(cat.color.withValues(alpha: 0.6)),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.pink.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () => _showEditDialog(cat),
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      color: AppColors.pink,
                      splashRadius: 20,
                      tooltip: 'Edit',
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () => _deleteCategory(cat),
                      icon: Icon(Icons.delete_outline, size: 18, color: Colors.grey.shade400),
                      splashRadius: 20,
                      tooltip: 'Delete',
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: (index * 80).ms)
        .slideY(begin: 0.2, end: 0, duration: 400.ms, curve: Curves.easeOut);
  }

  Widget _buildDot(Color color, int delayMs) {
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.45),
        shape: BoxShape.circle,
      ),
    )
        .animate()
        .fadeIn(delay: (300 + delayMs).ms)
        .then()
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.2, 1.2),
          duration: 1000.ms,
        )
        .then()
        .scale(
          begin: const Offset(1.2, 1.2),
          end: const Offset(0.8, 0.8),
          duration: 1000.ms,
        );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _gradientBorderWrapper(
            borderRadius: 36,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.pinkLight, AppColors.background],
                ),
                borderRadius: BorderRadius.circular(36 - 1.8),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.pink.withValues(alpha: 0.1),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: const Icon(Icons.folder_outlined, size: 52, color: AppColors.pink),
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms)
              .then()
              .shimmer(duration: 1200.ms, delay: 500.ms),
          const SizedBox(height: 26),
          const Text(
            'No categories yet',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.pinkDark,
            ),
          )
              .animate()
              .fadeIn(delay: 200.ms),
          const SizedBox(height: 10),
          const Text(
            'Tap the pink + button to create\nyour first cute category!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              height: 1.5,
              fontSize: 14,
            ),
          )
              .animate()
              .fadeIn(delay: 300.ms),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDot(AppColors.pink, 0),
              const SizedBox(width: 8),
              _buildDot(AppColors.amber, 100),
              const SizedBox(width: 8),
              _buildDot(AppColors.primaryLight, 200),
              const SizedBox(width: 8),
              _buildDot(AppColors.terracotta, 300),
            ],
          ),
        ],
      ),
    );
  }
}

// ==========================================================================
// MOROCCAN DECORATION WRAPPER MODULE
// ==========================================================================

class MoroccanBackgroundWrapper extends StatelessWidget {
  final Widget body;
  const MoroccanBackgroundWrapper({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/moroccan_mosaic.png'),
            fit: BoxFit.cover,
            opacity: 0.16,
          ),
        ),
        child: Stack(
          children: [
            const Positioned(top: 140, left: 15, child: _MoroccanStarSparks(color: AppColors.amber, size: 24, delay: 0)),
            const Positioned(bottom: 260, right: 20, child: _MoroccanStarSparks(color: AppColors.pink, size: 32, delay: 600)),
            const Positioned(top: 460, right: 15, child: _MoroccanStarSparks(color: AppColors.terracotta, size: 20, delay: 1200)),
            const Positioned(bottom: 110, left: 30, child: _MoroccanStarSparks(color: AppColors.mint, size: 26, delay: 400)),

            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 600) {
                    return Center(child: Container(constraints: const BoxConstraints(maxWidth: 600), child: body));
                  }
                  return body;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoroccanStarSparks extends StatefulWidget {
  final Color color;
  final double size;
  final int delay;

  const _MoroccanStarSparks({
    required this.color,
    required this.size,
    required this.delay,
  });

  @override
  State<_MoroccanStarSparks> createState() => _MoroccanStarSparksState();
}

class _MoroccanStarSparksState extends State<_MoroccanStarSparks> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _floatingAnim;
  late final Animation<double> _rotationAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _floatingAnim = Tween<double>(begin: 0, end: 15).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 1.0, curve: Curves.easeInOutQuad)),
    );

    _rotationAnim = Tween<double>(begin: 0, end: math.pi).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 1.0, curve: Curves.linear)),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatingAnim.value),
          child: Opacity(
            opacity: 0.35,
            child: Transform.rotate(
              angle: _rotationAnim.value,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      color: widget.color,
                      borderRadius: BorderRadius.circular(widget.size * 0.2),
                    ),
                  ),
                  Transform.rotate(
                    angle: math.pi / 4,
                    child: Container(
                      width: widget.size,
                      height: widget.size,
                      decoration: BoxDecoration(
                        color: widget.color,
                        borderRadius: BorderRadius.circular(widget.size * 0.2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}