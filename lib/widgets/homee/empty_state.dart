import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Cute sleeping cat illustration
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.pinkLight.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: AppColors.pink.withValues(alpha: 0.06),
                  blurRadius: 20,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: Image.asset(
                'assets/images/empty_state.png',
                fit: BoxFit.cover,
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms)
              .slideY(begin: 0.2, end: 0)
              .then()
              .shimmer(duration: 1200.ms, delay: 500.ms),

          const SizedBox(height: 28),

          Text(
            'No tasks yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.pinkDark,
                ),
          )
              .animate()
              .fadeIn(delay: 200.ms, duration: 400.ms),

          const SizedBox(height: 8),

          const Text(
            'Tap the + button to add your first task!\nLet\'s get productive together',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          )
              .animate()
              .fadeIn(delay: 300.ms, duration: 400.ms),

          const SizedBox(height: 16),

          // Decorative flower dots
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

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildDot(Color color, int delayMs) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.4),
        shape: BoxShape.circle,
      ),
    )
        .animate()
        .fadeIn(delay: (400 + delayMs).ms)
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
}