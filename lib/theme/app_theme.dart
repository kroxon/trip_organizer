import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData createTheme(ColorScheme colorScheme) {
    return ThemeData().copyWith(
      scaffoldBackgroundColor: colorScheme.surface,
      colorScheme: colorScheme,
      textTheme: GoogleFonts.ubuntuCondensedTextTheme().copyWith(
        titleSmall: GoogleFonts.ubuntuCondensed(
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
        titleMedium: GoogleFonts.ubuntuCondensed(
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
        titleLarge: GoogleFonts.ubuntuCondensed(
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
      ),
      cardTheme: CardTheme(
        color: colorScheme.surfaceContainerHigh,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}