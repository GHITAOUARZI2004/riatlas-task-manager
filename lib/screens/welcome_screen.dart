import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/profile.dart';
import '../services/profile_service.dart';
import '../theme/app_theme.dart';
import 'main_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  late AnimationController _floatController;

  // No more File/XFile/image_picker
  String? _selectedAvatarPath;

  // Your preset avatars
  final List<String> _presetAvatars = [
    'assets/avatars/cute1.png',
    'assets/avatars/cute2.png',
    'assets/avatars/cute3.png',
    'assets/avatars/cute4.png',
    'assets/avatars/cute5.png',
    'assets/avatars/cute6.png',
    'assets/avatars/cute7.png',
    'assets/avatars/cute8.png',
    'assets/avatars/cute9.png',
    'assets/avatars/cute10.png',

  ];

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);
  }

  // Only preset selection (no gallery picker)
  void _selectPresetAvatar(String path) {
    setState(() {
      _selectedAvatarPath = path;
    });
  }

  void _finishSetup() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name first')),
      );
      return;
    }

    final profile = Profile(
      name: name,
      bio: _bioController.text.trim().isNotEmpty
          ? _bioController.text.trim()
          : null,
      avatarUrl: _selectedAvatarPath, // Just store asset path
    );

    await ProfileService.saveProfile(profile);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blush,
      body: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: Image.asset(
                'assets/images/moroccan_mosaic.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Decorative blobs
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                color: AppColors.pinkLight.withAlpha(127),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -30,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withAlpha(51),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              child: Column(
                children: [
                  const SizedBox(height: 15),

                  // Main avatar (no tap to pick gallery)
                  AnimatedBuilder(
                    animation: _floatController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _floatController.value * 10 - 5),
                        child: child,
                      );
                    },
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 6),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.pink.withAlpha(63),
                            blurRadius: 25,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: _selectedAvatarPath != null
                            ? Image.asset(
                                _selectedAvatarPath!,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/images/welcome_avatar.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(
                                      Icons.face_retouching_natural,
                                      size: 80,
                                      color: AppColors.pink,
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 800.ms)
                      .scale(begin: const Offset(0.7, 0.7), curve: Curves.elasticOut, duration: 1000.ms),

                  const SizedBox(height: 12),
                  const Text(
                    "Choose a suggested avatar below",
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),

                  const SizedBox(height: 16),

                  // Suggested preset avatars
                  const Text(
                    "Pick your avatar",
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 60,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _presetAvatars.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final avatarPath = _presetAvatars[index];
                        return GestureDetector(
                          onTap: () => _selectPresetAvatar(avatarPath),
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: _selectedAvatarPath == avatarPath
                                  ? Border.all(color: AppColors.pink, width: 3)
                                  : null,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.pink.withAlpha(38),
                                  blurRadius: 6,
                                )
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(avatarPath, fit: BoxFit.cover),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Greeting text
                  Text(
                    'Marhaba! \uD83D\uDC96',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: AppColors.pinkDark,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                  )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 600.ms)
                      .slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 8),

                  Text(
                    'Welcome to RiAtlas Task\nYour personal productivity companion',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 600.ms),

                  const SizedBox(height: 16),

                  // Divider
                  Container(
                    width: 70,
                    height: 5,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.pink, AppColors.amber],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 500.ms)
                      .scaleX(begin: 0, end: 1, duration: 500.ms),

                  const SizedBox(height: 28),

                  // Name field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.pink.withAlpha(15),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _nameController,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      decoration: const InputDecoration(
                        hintText: 'Your beautiful name',
                        hintStyle: TextStyle(color: AppColors.textLight, fontWeight: FontWeight.normal),
                        prefixIcon: Icon(Icons.stars_rounded, color: AppColors.pink, size: 24),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 500.ms)
                      .slideY(begin: 0.15, end: 0),

                  const SizedBox(height: 16),

                  // Bio field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.pink.withAlpha(15),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _bioController,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      decoration: const InputDecoration(
                        hintText: 'A sweet short bio (optional)',
                        hintStyle: TextStyle(color: AppColors.textLight, fontWeight: FontWeight.normal),
                        prefixIcon: Icon(Icons.auto_awesome_outlined, color: AppColors.pink, size: 22),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 700.ms, duration: 500.ms)
                      .slideY(begin: 0.15, end: 0),

                  const SizedBox(height: 32),

                  // Button
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.pinkDark, AppColors.pink, AppColors.amber],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.pink.withAlpha(89),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _finishSetup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Let\'s Start!',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded, size: 20),
                        ],
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 800.ms, duration: 500.ms)
                      .slideY(begin: 0.15, end: 0)
                      .then()
                      .shimmer(duration: 1500.ms, delay: 1200.ms),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}