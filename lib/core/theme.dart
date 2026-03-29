import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CyberTheme {
  // 🎨 Core Color Palette (Dark)
  static const Color backgroundDark = Color(0xFF00012B);    // Midnight Blue
  static const Color surfaceDark = Color(0xFF0A0D3A);       // Deep Space Navy
  static const Color primaryAccent = Color(0xFF00E5FF); // Neon Cyan
  static const Color dangerRed = Color(0xFFFF3B30);     // Critical Alerts
  static const Color textWhite = Color(0xFFFFFFFF);     // Primary Text
  static const Color textGrey = Color(0xFF8E8E93);      // Subtitles

  // 🎨 Core Color Palette (Light)
  static const Color backgroundLight = Color(0xFFF2F2F7);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textBlack = Color(0xFF000000);

  // For backwards compatibility during migration
  static const Color background = backgroundDark;
  static const Color surface = surfaceDark;

  // 🧬 Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,
      primaryColor: primaryAccent,
      cardColor: surfaceDark,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.bold, color: textWhite),
        headlineMedium: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w600, color: textWhite),
        bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500, color: textWhite),
        bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.normal, color: textGrey),
      ),
      colorScheme: const ColorScheme.dark(
        primary: primaryAccent,
        secondary: primaryAccent,
        surface: surfaceDark,
        error: dangerRed,
        onPrimary: Colors.black,
      ),
    );
  }

  // 🧬 Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: backgroundLight,
      primaryColor: primaryAccent,
      cardColor: surfaceLight,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.bold, color: textBlack),
        headlineMedium: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w600, color: textBlack),
        bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500, color: textBlack),
        bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black54),
      ),
      colorScheme: const ColorScheme.light(
        primary: primaryAccent,
        secondary: primaryAccent,
        surface: surfaceLight,
        error: dangerRed,
        onPrimary: Colors.white,
      ),
    );
  }
}
