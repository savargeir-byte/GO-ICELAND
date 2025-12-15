import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_iceland/theme/app_theme.dart';

void main() {
  group('AppTheme', () {
    test('dark theme has correct aurora colors', () {
      final theme = AppTheme.dark;

      expect(theme.brightness, equals(Brightness.dark));
      expect(theme.colorScheme.primary, equals(const Color(0xFF00E5FF)));
      expect(theme.colorScheme.secondary, equals(const Color(0xFF6A5CFF)));
      expect(theme.scaffoldBackgroundColor, equals(const Color(0xFF050B14)));
    });

    test('light theme is configured', () {
      final theme = AppTheme.light;

      expect(theme.brightness, equals(Brightness.light));
      expect(theme.scaffoldBackgroundColor, equals(const Color(0xFFF7FFF7)));
    });
  });

  group('AppTheme color constants', () {
    test('has Aurora cyan', () {
      expect(AppTheme.cyanAccent, equals(const Color(0xFF00E5FF)));
    });

    test('has purple glow', () {
      expect(AppTheme.purpleAccent, equals(const Color(0xFF6A5CFF)));
    });

    test('has dark background', () {
      expect(AppTheme.darkBackground, equals(const Color(0xFF050B14)));
    });
  });
}
