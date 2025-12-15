import 'package:flutter/material.dart';

class AppTheme {
  // Aurora / Northern lights dark theme 🌌
  static ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF050B14),
    fontFamily: 'Inter',
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF00E5FF), // Aurora cyan
      secondary: Color(0xFF6A5CFF), // Purple glow
      surface: Color(0xFF0B132B),
      background: Color(0xFF050B14),
      onPrimary: Colors.black,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onBackground: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineMedium: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineSmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(
        fontSize: 17,
        color: Colors.white70,
      ),
      bodyMedium: TextStyle(
        fontSize: 15,
        color: Colors.white70,
      ),
      bodySmall: TextStyle(
        fontSize: 13,
        color: Colors.white54,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF1A2744),
      selectedColor: const Color(0xFF00E5FF).withOpacity(0.3),
      labelStyle: const TextStyle(color: Colors.white),
      secondaryLabelStyle: const TextStyle(color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: const Color(0xFF00E5FF),
      inactiveTrackColor: Colors.white24,
      thumbColor: const Color(0xFF00E5FF),
      overlayColor: const Color(0xFF00E5FF).withOpacity(0.2),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF0B132B),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white70,
    ),
    dividerTheme: const DividerThemeData(
      color: Colors.white12,
    ),
  );

  // Light theme (optional fallback)
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF7FFF7),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF2EC4B6),
      background: const Color(0xFFF7FFF7),
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(fontWeight: FontWeight.bold),
      bodyMedium: TextStyle(fontSize: 15),
    ),
  );
}
