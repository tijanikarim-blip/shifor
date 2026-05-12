import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MusicTheme {
  // Cosmic background colors
  static const Color cosmicBlack = Color(0xFF0A0E17);
  static const Color deepSpace = Color(0xFF1A1E2E);
  static const Color nebulaPurple = Color(0xFF6C63FF);
  static const Color neonPink = Color(0xFFFF2DAA);
  static const Color neonBlue = Color(0xFF00F0FF);
  static const Color neonGreen = Color(0xFF00FF9D);
  static const Color starWhite = Color(0xFFF0F4FF);

  // Glassmorphism colors
  static const Color glassBackground = Color(0x1AFFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);

  // Text colors
  static const Color textPrimary = starWhite;
  static const Color textSecondary = Color(0x99F0F4FF);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: cosmicBlack,
      colorScheme: const ColorScheme.dark(
        primary: neonBlue,
        secondary: neonPink,
        surface: deepSpace,
        background: cosmicBlack,
        onPrimary: cosmicBlack,
        onSecondary: cosmicBlack,
        onSurface: textPrimary,
        onBackground: textPrimary,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.orbitron(
          color: textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.w700,
          shadows: [neonShadow(neonBlue)],
        ),
        displayMedium: GoogleFonts.orbitron(
          color: textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.inter(
          color: textPrimary,
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.inter(
          color: textSecondary,
          fontSize: 14,
        ),
        labelLarge: GoogleFonts.inter(
          color: textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: GoogleFonts.orbitron(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: textPrimary),
      ),
    );
  }

  // Neon glow shadow
  static BoxShadow neonShadow(Color color, {double blurRadius = 12}) {
    return BoxShadow(
      color: color.withOpacity(0.6),
      blurRadius: blurRadius,
      spreadRadius: 2,
    );
  }

  // Glassmorphism container decoration
  static BoxDecoration glassDecoration({
    Color bgColor = glassBackground,
    Color borderColor = glassBorder,
    double borderRadius = 16,
    Color glowColor = neonBlue,
  }) {
    return BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(color: borderColor, width: 1),
      boxShadow: [neonShadow(glowColor, blurRadius: 8)],
      backgroundBlendMode: BlendMode.overlay,
    );
  }

  // Gradient background for screens
  static BoxDecoration cosmicBackground() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [cosmicBlack, deepSpace, Color(0xFF0F1220)],
        stops: [0.0, 0.5, 1.0],
      ),
    );
  }
}
