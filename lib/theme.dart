import 'package:flutter/material.dart';

final appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF2EC4B6),
    background: const Color(0xFFF7FFF7),
  ),
  textTheme: const TextTheme(
    headlineMedium: TextStyle(fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(fontSize: 15),
  ),
);
