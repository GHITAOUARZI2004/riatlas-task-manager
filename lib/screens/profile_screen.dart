import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../services/profile_service.dart';
import '../services/gamification_service.dart';
import '../services/hive_service.dart';
import '../theme/app_theme.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ProfileService.getProfile();
    final name = profile?.name ?? 'User';
    final bio = profile?.bio;
    final avatarPath = profile?.avatarUrl;
    final level = GamificationService.getCurrentLevel();
    final xp = GamificationService.getCurrentXp();
    final nextLevelXp = GamificationService.getXpForNextLevel();
    final xpProgress = GamificationService.getXpProgress();
    final tasks = HiveService.getTasks();
    final completedTasks = tasks.where((t) => t.completed).length;
    final totalTasks = tasks.length;

    return MoroccanBackgroundWrapper(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: _buildAnimatedHeader(name, bio, avatarPath, level, completedTasks, totalTasks),
          ),
          SliverToBoxAdapter(
            child: _buildXpCard(level, xp, nextLevelXp, xpProgress),
          ),
          SliverToBoxAdapter(
            child: _buildStatsGrid(completedTasks, totalTasks, tasks),
          ),
          SliverToBoxAdapter(
            child: _buildAchievementsPreview(completedTasks),
          ),
          SliverToBoxAdapter(
            child: _buildSettingsSection(),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildAnimatedHeader(String name, String? bio, String? avatarPath, int level, int completed, int total) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/moroccan_mosaic.png'),
          fit: BoxFit.cover,
          opacity: 0.25,
        ),
        gradient: const LinearGradient(
          colors: [AppColors.pinkDark, AppColors.pink, AppColors.amber],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: AppColors.pink.withValues(alpha: 0.6),
          width: 2.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.35),
            blurRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          const Positioned(
            top: -10,
            left: -10,
            child: MoroccanZelligeTile(size: 20, color: Colors.white24),
          ),
          const Positioned(
            bottom: -5,
            right: 20,
            child: MoroccanZelligeTile(size: 28, color: Colors.white12),
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
                      ),
                      child: const Icon(Icons.settings, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              AnimatedCuteAvatar(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.pink.withValues(alpha: 0.7), width: 3),
                        ),
                        child: ClipOval(
                          child: avatarPath != null
                              ? Image.asset(
                                  avatarPath,
                                  fit: BoxFit.cover,
                                )
                              : Center(
                                  child: Text(
                                    name.isNotEmpty ? name[0].toUpperCase() : 'U',
                                    style: const TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(color: Colors.black12, offset: Offset(0, 2), blurRadius: 4)
                                      ]
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              if (bio != null && bio.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  bio,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.pink.withValues(alpha: 0.5), width: 1.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: AppColors.amber, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Level $level',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 1,
                      height: 14,
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$completed / $total tasks',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildXpCard(int level, int xp, int nextLevelXp, int xpProgress) {
    final progress = xpProgress / 100;

    return CuteGlassmorphicCard(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.amber.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.local_fire_department, color: AppColors.amber, size: 18),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Experience',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Lvl $level',
                    style: const TextStyle(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: progress.clamp(0.0, 1.0)),
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return LinearProgressIndicator(
                    value: value,
                    minHeight: 12,
                    backgroundColor: AppColors.primaryLight.withValues(alpha: 0.5),
                    valueColor: const AlwaysStoppedAnimation(AppColors.amber),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$xpProgress XP',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                ),
                Text(
                  '$nextLevelXp XP for Level ${level + 1}',
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(int completed, int total, List tasks) {
    final pending = total - completed;
    final streak = _calculateStreak(tasks);

    final stats = [
      _StatItem('Completed', completed.toString(), Icons.check_circle, AppColors.success),
      _StatItem('Pending', pending.toString(), Icons.schedule, AppColors.warning),
      _StatItem('Streak', '$streak', Icons.local_fire_department, AppColors.terracotta),
      _StatItem('Total', total.toString(), Icons.assignment, AppColors.primary),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: stats.map((stat) => Expanded(
          child: Container(
            margin: EdgeInsets.only(right: stat == stats.last ? 0 : 8),
            child: CuteGlassmorphicCard(
              shadowColor: stat.color,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: stat.color.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(stat.icon, color: stat.color, size: 20),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      stat.value,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      stat.label,
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildAchievementsPreview(int completed) {
    final badges = [
      _Badge('First Task', Icons.emoji_events, completed >= 1, AppColors.amber),
      _Badge('5 Done', Icons.local_fire_department, completed >= 5, AppColors.terracotta),
      _Badge('20 Master', Icons.star, completed >= 20, AppColors.primary),
      _Badge('50 Champ', Icons.diamond, completed >= 50, Colors.deepPurple),
    ];

    return CuteGlassmorphicCard(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Achievements',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Transform.translate(
                  offset: const Offset(8, 0),
                  child: const MoroccanZelligeTile(size: 14, color: AppColors.mint),
                )
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: badges.map((badge) => Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      gradient: badge.unlocked 
                        ? LinearGradient(
                            colors: [badge.color.withValues(alpha: 0.2), badge.color.withValues(alpha: 0.05)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : LinearGradient(colors: [Colors.grey.shade100, Colors.grey.shade50]),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: badge.unlocked
                            ? badge.color.withValues(alpha: 0.4)
                            : Colors.grey.shade200,
                        width: 2,
                      ),
                      boxShadow: badge.unlocked 
                        ? [BoxShadow(color: badge.color.withValues(alpha: 0.1), offset: const Offset(0, 4), blurRadius: 0)] 
                        : [],
                    ),
                    child: badge.unlocked
                        ? AnimatedAchievementBadge(label: '', icon: badge.icon, customColor: badge.color)
                        : Icon(badge.icon, color: AppColors.textLight.withValues(alpha: 0.6), size: 24),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    badge.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: badge.unlocked ? AppColors.textPrimary : AppColors.textLight,
                    ),
                  ),
                ],
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    final settings = [
      _Setting('Edit Profile', Icons.person_outline, AppColors.primary, () => _showEditProfile()),
      _Setting('Notifications', Icons.notifications_outlined, AppColors.terracotta, () {}),
      _Setting('App Theme', Icons.palette_outlined, AppColors.amber, () {}),
      _Setting('Help & Support', Icons.help_outline, AppColors.success, () {}),
      _Setting('Settings', Icons.settings, AppColors.textSecondary, () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SettingsScreen()),
      )),
    ];

    return CuteGlassmorphicCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: settings.asMap().entries.map((entry) {
            final setting = entry.value;
            final isLast = entry.key == settings.length - 1;
            return Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: setting.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(setting.icon, color: setting.color, size: 20),
                  ),
                  title: Text(setting.label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.textPrimary)),
                  trailing: const Icon(Icons.chevron_right, color: AppColors.textLight),
                  onTap: setting.onTap,
                ),
                if (!isLast) Divider(height: 1, indent: 68, endIndent: 20, color: AppColors.primaryLight.withValues(alpha: 0.4)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showEditProfile() {
    final profile = ProfileService.getProfile();
    final nameController = TextEditingController(text: profile?.name ?? '');
    final bioController = TextEditingController(text: profile?.bio ?? '');

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        backgroundColor: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.pink.withValues(alpha: 0.5), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Edit Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: 'Your name', prefixIcon: Icon(Icons.person, color: AppColors.primary)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: bioController,
                maxLines: 2,
                decoration: const InputDecoration(hintText: 'Bio (optional)', prefixIcon: Icon(Icons.edit, color: AppColors.terracotta)),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.textLight, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Cute3DButton(
                      baseColor: AppColors.primary,
                      shadowColor: AppColors.primaryDark,
                      onPressed: () async {
                        final updated = profile?.copyWith(
                          name: nameController.text.trim(),
                          bio: bioController.text.trim().isEmpty ? null : bioController.text.trim(),
                        );
                        Navigator.pop(context);
                        if (updated != null) {
                          await ProfileService.saveProfile(updated);
                          if (mounted) setState(() {});
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _calculateStreak(List tasks) {
    int streak = 0;
    final now = DateTime.now();
    for (int i = 0; i < 365; i++) {
      final day = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
      final hasCompleted = tasks.any((t) {
        final completedAt = t.completedAt;
        if (completedAt == null) return false;
        final completedDay = DateTime(completedAt.year, completedAt.month, completedAt.day);
        return completedDay == day;
      });
      if (hasCompleted) { streak++; } else if (i == 0) { continue; } else { break; }
    }
    return streak;
  }
}

// ==========================================================================
// DECORATION MODULE HOOKS & UTILITIES
// ==========================================================================

class CuteGlassmorphicCard extends StatelessWidget {
  final Widget child;
  final Color shadowColor;

  const CuteGlassmorphicCard({
    super.key,
    required this.child,
    this.shadowColor = AppColors.primaryDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.pink.withValues(alpha: 0.45),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withValues(alpha: 0.06),
            offset: const Offset(0, 6),
            blurRadius: 10, 
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: child,
      ),
    );
  }
}

class AnimatedCuteAvatar extends StatefulWidget {
  final Widget child;
  const AnimatedCuteAvatar({super.key, required this.child});

  @override
  State<AnimatedCuteAvatar> createState() => _AnimatedCuteAvatarState();
}

class _AnimatedCuteAvatarState extends State<AnimatedCuteAvatar> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2200),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _animation, child: widget.child);
  }
}

class AnimatedAchievementBadge extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color customColor;

  const AnimatedAchievementBadge({
    super.key,
    required this.label,
    required this.icon,
    required this.customColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(icon, color: customColor, size: 26),
    );
  }
}

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

class MoroccanZelligeTile extends StatelessWidget {
  final double size;
  final Color color;
  const MoroccanZelligeTile({super.key, this.size = 20, this.color = AppColors.mint});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.785398,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(size * 0.2),
        ),
      ),
    );
  }
}

// Data classes
class _StatItem {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  _StatItem(this.label, this.value, this.icon, this.color);
}

class _Badge {
  final String label;
  final IconData icon;
  final bool unlocked;
  final Color color;
  _Badge(this.label, this.icon, this.unlocked, this.color);
}

class _Setting {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  _Setting(this.label, this.icon, this.color, this.onTap);
}

// Dummy missing widget
class Cute3DButton extends StatelessWidget {
  final Widget child;
  final Color baseColor;
  final Color shadowColor;
  final VoidCallback onPressed;

  const Cute3DButton({
    super.key,
    required this.child,
    required this.baseColor,
    required this.shadowColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: baseColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}