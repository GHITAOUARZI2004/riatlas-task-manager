import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ==========================================================================
// 1. CUTE MOROCCAN COLOR PALETTE
// ==========================================================================
class AppColors {
  // Primary - Vibrant Cute Pink (Bougainvillea & Moroccan Rose)
  static const Color primary = Color(0xFFF472B6);      // Cute Pink
  static const Color primaryDark = Color(0xFFDB2777);  // Deep Rose
  static const Color primaryLight = Color(0xFFFCE7F3); // Soft Blush

  // Secondary & Accents - Golden Sands & Clay
  static const Color amber = Color(0xFFF59E0B);        // Warm Lantern Gold
  static const Color amberDark = Color(0xFFB8864A);
  static const Color gold = Color(0xFFC89B3C);
  static const Color terracotta = Color(0xFFE07A5F);   // Moroccan Clay
  static const Color terracottaLight = Color(0xFFF2A08E);
  static const Color mint = Color(0xFF2DD4BF);         // Fresh Mint Contrast

  // Pink Extras
  static const Color pink = Color(0xFFF472B6);
  static const Color pinkLight = Color(0xFFFBCFE8);
  static const Color pinkDark = Color(0xFFEC4899);
  static const Color rose = Color(0xFFF43F5E);
  static const Color blush = Color(0xFFFFF1F2);

  // Backgrounds & Surfaces (Translucent to let mosaic pattern peek through safely)
  static const Color background = Color(0xFFFFF1F2);   // Softest Rose Tint
  static final Color surface = Colors.white.withValues(alpha: 0.85); 
  static final Color cardBg = Colors.white.withValues(alpha: 0.90);

  // Text (Deep Espresso/Plum tones instead of harsh black for a cuter look)
  static const Color textPrimary = Color(0xFF3F2E3E);   // Deep Plum Wood
  static const Color textSecondary = Color(0xFF867070); // Warm Muted Taupe
  static const Color textLight = Color(0xFFD4ADFC);     // Soft Lavender

  // Semantic
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // Priority
  static const Color highPriority = Color(0xFFE11D48);
  static const Color mediumPriority = Color(0xFFF59E0B);
  static const Color lowPriority = Color(0xFF10B981);
}

// ==========================================================================
// 2. FLUTTER THEME DATA
// ==========================================================================
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      // Set to transparent so the background layout wrapper renders the image without blockage
      scaffoldBackgroundColor: Colors.transparent, 
      
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryLight,
        secondary: AppColors.amber,
        secondaryContainer: AppColors.amberDark,
        surface: Colors.white,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
      ),

      // Text Theme
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        displayMedium: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        titleLarge: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        titleMedium: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        bodyLarge: GoogleFonts.poppins(fontSize: 16, color: AppColors.textPrimary),
        bodyMedium: GoogleFonts.poppins(fontSize: 14, color: AppColors.textSecondary),
        labelLarge: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
      ),

      // Transparent AppBar look over your mosaic asset
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),

      // Glossy Rounded Card Styling
      cardTheme: CardThemeData(
        elevation: 0, 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24), 
          side: const BorderSide(color: Colors.white, width: 1.5), 
        ),
        color: AppColors.cardBg,
        shadowColor: AppColors.textPrimary.withValues(alpha: 0.04),
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textLight,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 12),
      ),

      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      // Cute Chips
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.primaryLight,
        side: BorderSide.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        labelStyle: const TextStyle(fontSize: 12, color: AppColors.primaryDark, fontWeight: FontWeight.w600),
      ),

      // Input Fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
      ),

      // Dialogs
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        backgroundColor: Colors.white,
      ),
    );
  }
}

// ==========================================================================
// 3. MOSAIC BACKGROUND LAYOUT WRAPPER
// Replace your Scaffolds with this widget to apply the background image
// ==========================================================================
class MoroccanBackgroundWrapper extends StatelessWidget {
  final Widget child;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? appBar;

  const MoroccanBackgroundWrapper({
    super.key, 
    required this.child, 
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.background, 
        image: DecorationImage(
          image: AssetImage('assets/images/moroccan_mosaic.png'),
          fit: BoxFit.cover,
          opacity: 0.12, // Keeps your pattern visible without overwhelming your app's text
        ),
      ),
      child: Scaffold(
        appBar: appBar,
        body: SafeArea(child: child),
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}

// ==========================================================================
// 4. CUTE 3D INTERACTIVE BUTTON
// Use this widget inside your views to get a responsive 3D click effect
// ==========================================================================
class Cute3DButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color baseColor;
  final Color shadowColor;

  const Cute3DButton({
    super.key, 
    required this.onPressed, 
    required this.child,
    this.baseColor = AppColors.primary,
    this.shadowColor = AppColors.primaryDark,
  });

  @override
  State<Cute3DButton> createState() => _Cute3DButtonState();
}

class _Cute3DButtonState extends State<Cute3DButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 60),
        padding: EdgeInsets.only(
          top: _isPressed ? 5.0 : 0.0, 
          bottom: _isPressed ? 0.0 : 5.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: _isPressed 
              ? [] 
              : [
                  BoxShadow(
                    color: widget.shadowColor,
                    offset: const Offset(0, 5), 
                  ),
                ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: widget.baseColor,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: DefaultTextStyle(
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            child: Center(widthFactor: 1.0, child: widget.child),
          ),
        ),
      ),
    );
  }
}