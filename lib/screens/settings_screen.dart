import 'package:flutter/material.dart';
import '../services/hive_service.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  bool _notifications = true;
  bool _soundEffects = true;
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.94, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Helper: Wraps a widget in a gradient border container
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

  // Premium Cute Glass Card - Fixed with gradient border wrapper
  Widget _cuteCard({required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: _gradientBorderWrapper(
        borderRadius: 28,
        child: Container(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
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
          child: child,
        ),
      ),
    );
  }

  Widget _buildToggleTile(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return _cuteCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: 0.18),
                  color.withValues(alpha: 0.08),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(1, 2),
                )
              ],
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColors.textPrimary,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 12.5,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.pink.withValues(alpha: 0.75),
            activeThumbColor: AppColors.pinkDark,
            inactiveTrackColor: Colors.grey.shade200,
            inactiveThumbColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap, {
    bool danger = false,
  }) {
    return _cuteCard(
      padding: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: danger
                  ? [
                      AppColors.error.withValues(alpha: 0.18),
                      AppColors.error.withValues(alpha: 0.08),
                    ]
                  : [
                      color.withValues(alpha: 0.18),
                      color.withValues(alpha: 0.08),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: (danger ? AppColors.error : color).withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(1, 2),
              )
            ],
          ),
          child: Icon(
            icon,
            color: danger ? AppColors.error : color,
            size: 24,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: danger ? AppColors.error : AppColors.textPrimary,
            height: 1.1,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.textLight,
              fontSize: 12.5,
              height: 1.2,
            ),
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.textLight.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.arrow_forward_ios_rounded,
            color: AppColors.textLight.withValues(alpha: 0.8),
            size: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 16, top: 10),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 20,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.pink, AppColors.amber],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
              color: AppColors.pinkDark.withValues(alpha: 0.85),
              letterSpacing: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
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
              boxShadow: [
                BoxShadow(
                  color: AppColors.pink.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.error.withValues(alpha: 0.15),
                        blurRadius: 6,
                        offset: const Offset(2, 3),
                      )
                    ],
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.error,
                    size: 44,
                  ),
                ),
                const SizedBox(height: 22),
                const Text(
                  'Clear All Data?',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'This will permanently delete all your tasks & progress. This action cannot be undone.',
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
                          await HiveService.clearAll();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('All data cleared successfully!'),
                                backgroundColor: AppColors.success,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              ),
                            );
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
                          'Clear All',
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

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        elevation: 12,
        child: _gradientBorderWrapper(
          borderRadius: 32,
          child: Container(
            padding: const EdgeInsets.all(30),
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
              boxShadow: [
                BoxShadow(
                  color: AppColors.pink.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.pink, AppColors.amber],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(26),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.pink.withValues(alpha: 0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: const Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'RiAtlas Task',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Version 1.0.0',
                  style: TextStyle(
                    color: AppColors.textLight,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Your personal productivity companion.\nStay organized, stay motivated.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    height: 1.5,
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.amber, AppColors.pink],
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'developed by Rita',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.pink,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      'Close',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/moroccan_mosaic.png'),
            fit: BoxFit.cover,
            opacity: 0.14,
          ),
          color: AppColors.blush,
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              ),
            );
          },
          child: Column(
            children: [
              // Custom AppBar
              Container(
                padding: const EdgeInsets.only(
                  top: 48,
                  bottom: 18,
                  left: 22,
                  right: 22,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: _gradientBorderWrapper(
                        borderRadius: 18,
                        borderWidth: 1.5,
                        child: Container(
                          padding: const EdgeInsets.all(11),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(18 - 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.pink.withValues(alpha: 0.08),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              )
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            size: 18,
                            color: AppColors.pinkDark,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    const Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              // Main Content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildSectionTitle('Preferences'),
                    _buildToggleTile(
                      'Notifications',
                      'Get reminded about due tasks',
                      Icons.notifications_outlined,
                      AppColors.terracotta,
                      _notifications,
                      (v) => setState(() => _notifications = v),
                    ),
                    _buildToggleTile(
                      'Sound Effects',
                      'Play sounds on task completion',
                      Icons.volume_up_outlined,
                      AppColors.primary,
                      _soundEffects,
                      (v) => setState(() => _soundEffects = v),
                    ),
                    _buildToggleTile(
                      'Dark Mode',
                      'Switch to dark theme',
                      Icons.dark_mode_outlined,
                      AppColors.amber,
                      _darkMode,
                      (v) => setState(() => _darkMode = v),
                    ),

                    const SizedBox(height: 12),
                    _buildSectionTitle('Data Management'),
                    _buildActionTile(
                      'Export Data',
                      'Save your tasks to a file',
                      Icons.download_outlined,
                      AppColors.success,
                      () {},
                    ),
                    _buildActionTile(
                      'Import Data',
                      'Load tasks from a file',
                      Icons.upload_outlined,
                      AppColors.primary,
                      () {},
                    ),
                    _buildActionTile(
                      'Clear All Data',
                      'Permanently delete everything',
                      Icons.delete_forever,
                      AppColors.error,
                      _showClearDataDialog,
                      danger: true,
                    ),

                    const SizedBox(height: 12),
                    _buildSectionTitle('About'),
                    _buildActionTile(
                      'About RiAtlas',
                      'Version 1.0.0',
                      Icons.info_outline,
                      AppColors.primary,
                      _showAboutDialog,
                    ),
                    _buildActionTile(
                      'Privacy Policy',
                      'How we handle your data',
                      Icons.shield_outlined,
                      AppColors.primary,
                      () {},
                    ),

                    const SizedBox(height: 40),

                    // Cute Footer
                    Column(
                      children: [
                        Container(
                          width: 44,
                          height: 5,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.amber.withValues(alpha: 0.7),
                                AppColors.pink.withValues(alpha: 0.6),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'RiAtlas Task v1.0.0',
                          style: TextStyle(
                            color: AppColors.textLight,
                            fontSize: 12.5,
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}