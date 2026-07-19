import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  DateTime _selectedDate = DateTime.now();

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

  // Reusable gradient border wrapper (matches your other screens)
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.pink.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(Icons.calendar_today_rounded, color: AppColors.pink, size: 22),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Calendar',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.pinkDark,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Calendar Picker Card
                  _gradientBorderWrapper(
                    borderRadius: 28,
                    child: Container(
                      padding: const EdgeInsets.all(16),
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
                          ),
                        ],
                      ),
                      child: CalendarDatePicker(
                        initialDate: _selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2035),
                        onDateChanged: (date) {
                          setState(() => _selectedDate = date);
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Selected Date Card
                  _gradientBorderWrapper(
                    borderRadius: 24,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24 - 1.8),
                        color: Colors.white.withValues(alpha: 0.96),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Selected Date',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textLight,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.pinkDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}