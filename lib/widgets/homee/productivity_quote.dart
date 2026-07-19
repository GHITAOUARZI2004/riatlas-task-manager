import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';

class ProductivityQuote extends StatelessWidget {
  const ProductivityQuote({super.key});

  @override
  Widget build(BuildContext context) {
    final quotes = [
      'Small progress every day leads to big achievements.',
      'Discipline beats motivation.',
      'Every task completed is a step toward success.',
      'Stay focused. Stay consistent.',
      "Today's effort creates tomorrow's success.",
      'Little by little, a little becomes a lot.',
      'One task at a time.',
      'Success begins with a checklist.',
    ];

    final quote = quotes[DateTime.now().day % quotes.length];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.pinkLight, AppColors.blush],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.pink.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          const Icon(Icons.format_quote, color: AppColors.pink, size: 28)
              .animate()
              .fadeIn(duration: 400.ms)
              .then()
              .rotate(begin: -0.1, end: 0.1, duration: 600.ms)
              .then()
              .rotate(begin: 0.1, end: -0.1, duration: 600.ms),
          const SizedBox(height: 12),
          Text(
            '"$quote"',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.pinkDark,
              fontStyle: FontStyle.italic,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          )
              .animate()
              .fadeIn(delay: 200.ms, duration: 500.ms),
          const SizedBox(height: 12),
          // Decorative dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.pink, shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Container(width: 4, height: 4, decoration: BoxDecoration(color: AppColors.pink.withValues(alpha: 0.5), shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.amber, shape: BoxShape.circle)),
            ],
          ),
        ],
      ),
    );
  }
}