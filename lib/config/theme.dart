import 'package:flutter/material.dart';

class AppTheme {
  // ── Palette ──
  static const Color primary = Color(0xFFFE7F2D);       // orange
  static const Color primaryLight = Color(0xFFEAECF0);  // light gray
  static const Color secondary = Color(0xFF233D4D);     // dark blue
  static const Color darkBg = Color(0xFF000000);        // black
  static const Color darkCard = Color(0xFF233D4D);      // dark blue
  static const Color darkSurface = Color(0xFF1A2F3D);   // slightly lighter blue
  static const Color accent = Color(0xFFFE7F2D);        // orange
  static const Color success = Color(0xFF2ED573);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFFF4757);
  static const Color glassWhite = Color(0x18EAECF0);
  static const Color glassWhiteStrong = Color(0x2AEAECF0);

  // ── Gradients ──
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF233D4D), Color(0xFFFE7F2D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF1A2F3D), Color(0xFF000000)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFFE7F2D), Color(0xFF233D4D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Glass decoration ──
  static BoxDecoration glassCard({
    double radius = 16,
    double blur = 20,
    Color? borderColor,
    Color? bgColor,
  }) {
    return BoxDecoration(
      color: bgColor ?? glassWhite,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderColor ?? Colors.white.withValues(alpha: 0.08)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          blurRadius: blur,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  static BoxDecoration glassCardDark({
    double radius = 16,
    double blur = 24,
  }) {
    return BoxDecoration(
      color: darkCard,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      boxShadow: [
        BoxShadow(
          color: primary.withValues(alpha: 0.08),
          blurRadius: blur,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // ── Theme ──
  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primary,
      scaffoldBackgroundColor: darkBg,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: darkCard,
        error: error,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          letterSpacing: -0.3,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          fontSize: 15,
          color: Color(0xFFB0B0C8),
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 13,
          color: Color(0xFF8888A0),
          height: 1.4,
        ),
        labelLarge: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: glassWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primaryLight, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: error),
        ),
        labelStyle: const TextStyle(color: Color(0xFF8888A0), fontSize: 14),
        hintStyle: const TextStyle(color: Color(0xFF555570), fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: glassWhite,
        labelStyle: const TextStyle(color: Colors.white, fontSize: 13),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkCard.withValues(alpha: 0.95),
        selectedItemColor: primaryLight,
        unselectedItemColor: const Color(0xFF555570),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
      ),
    );
  }
}

// ── Extensions ──
extension GradientExtension on Widget {
  Widget gradientBg() {
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
      child: this,
    );
  }
}
