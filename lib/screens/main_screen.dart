import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'statistics_screen.dart';
import 'categories_screen.dart';
import 'profile_screen.dart';
import 'calendar_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;

  late AnimationController _controller;
  late Animation<double> _navBarScale;
  late Animation<double> _calendarBounce;

  final List<Widget> _screens = const [
    HomeScreen(),
    StatisticsScreen(),
    CalendarScreen(),
    CategoriesScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _navBarScale = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _calendarBounce = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentIndex = index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: isSelected ? _navBarScale.value : 1.0,
              child: child,
            );
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  if (isSelected)
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.pink.withValues(alpha: 0.18),
                            AppColors.amber.withValues(alpha: 0.08),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.pink.withValues(alpha: 0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                  Icon(
                    icon,
                    color: isSelected ? AppColors.pinkDark : AppColors.textLight,
                    size: isSelected ? 26 : 22,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? AppColors.pinkDark : AppColors.textLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarButton() {
    return AnimatedBuilder(
      animation: _calendarBounce,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.95 + (_calendarBounce.value * 0.05),
          child: child,
        );
      },
      child: GestureDetector(
        onTap: () => setState(() => _currentIndex = 2),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.pinkDark, AppColors.pink],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.pink.withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.calendar_today_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),

            // Cute white bow
            Positioned(
              top: -4,
              left: -6,
              child: Transform.rotate(
                angle: -0.15,
                child: Container(
                  width: 28,
                  height: 14,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(12),
                      right: Radius.circular(12),
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.pink,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Small sparkle star
            Positioned(
              top: -2,
              right: -4,
              child: Icon(
                Icons.star_rounded,
                color: AppColors.amber.withValues(alpha: 0.8),
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _navBarScale.value,
            child: child,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.98),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: AppColors.pink.withValues(alpha: 0.12),
                blurRadius: 20,
                offset: const Offset(0, -6),
                spreadRadius: 2,
              ),
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.9),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 12),
              child: Row(
                children: [
                  _buildNavItem(0, Icons.home_rounded, 'Home'),
                  _buildNavItem(1, Icons.bar_chart_rounded, 'Stats'),
                  const SizedBox(width: 12),
                  _buildCalendarButton(),
                  const SizedBox(width: 12),
                  _buildNavItem(3, Icons.folder_rounded, 'Categories'),
                  _buildNavItem(4, Icons.person_rounded, 'Profile'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}