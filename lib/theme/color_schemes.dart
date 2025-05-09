import 'package:flutter/material.dart';

final darkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color(0xFF6B4EFF),
  primary: const Color(0xFF9D86FF), // Jaśniejszy odcień fioletu dla lepszej widoczności w trybie ciemnym
  secondary: const Color(0xFF4DFFD4), // Jaśniejszy odcień turkusu
  tertiary: const Color(0xFFFF8F8F), // Jaśniejszy odcień czerwieni
  surface: const Color(0xFF1A1A2E),
  onSurfaceVariant: const Color(0xFF1A1A2E),
  error: const Color(0xFFFF4B4B),
  onPrimary: Colors.white,
  onSecondary: Colors.black,
  onSurface: Colors.white,
  onError: Colors.white,
).copyWith(
  surfaceContainerHigh: const Color(0xFF2A2A3E),
  onSurfaceVariant: const Color(0xFFE1E1E3),
);

final lightColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: const Color(0xFF6B4EFF),
  primary: const Color(0xFF5838E7), // Ciemniejszy odcień fioletu dla trybu jasnego
  secondary: const Color(0xFF00B396), // Ciemniejszy odcień turkusu
  tertiary: const Color(0xFFE64646), // Ciemniejszy odcień czerwieni
  surface: Colors.white,
  onSurfaceVariant: Colors.white,
  error: const Color(0xFFFF4B4B),
  onPrimary: Colors.white,
  onSecondary: Colors.black,
  onSurface: const Color(0xFF1A1A2E),
  onError: Colors.white,
).copyWith(
  surfaceContainerHigh: const Color(0xFFF5F5F5),
  onSurfaceVariant: Colors.black87,
);