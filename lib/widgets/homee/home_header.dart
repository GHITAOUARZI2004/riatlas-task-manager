import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final String userAvatar;
  final VoidCallback onNotificationTap;

  const HomeHeader({
    super.key,
    required this.userName,
    required this.userAvatar,
    required this.onNotificationTap,
  });

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 6) return 'Layla sa\'ida'; // Good night
    if (hour < 12) return 'Sabah al-khair'; // Good morning
    if (hour < 17) return 'Masaa al-nur'; // Good afternoon
    if (hour < 21) return 'Masaa al-khair'; // Good evening
    return 'Layla sa\'ida'; // Good night
  }

  String get _emoji {
    final hour = DateTime.now().hour;
    if (hour < 6) return '\uD83C\udf19'; // Moon
    if (hour < 12) return '\u2600\ufe0f'; // Sun
    if (hour < 17) return '\u26c5'; // Partly cloudy
    if (hour < 21) return '\uD83C\udf05'; // Sunset
    return '\uD83C\udf19'; // Moon
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Avatar with pink gradient
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.pinkDark, AppColors.pink],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.pink.withValues(alpha: 0.25),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              userAvatar,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),

        // Greeting with Moroccan touch
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '$_greeting $_emoji',
                    style: const TextStyle(
                      color: AppColors.pinkDark,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // Notification button with pink accent
        GestureDetector(
          onTap: onNotificationTap,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.pink.withValues(alpha: 0.06),
                  blurRadius: 10,
                ),
              ],
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: AppColors.pink,
              size: 20,
            ),
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(duration: 500.ms)
        .slideX(begin: -0.1, end: 0, duration: 500.ms);
  }
}