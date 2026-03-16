import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF14C699),
        primary: const Color(0xFF14C699),
        secondary: const Color(0xFFF09E38),
        background: const Color(0xFFF8F9FA),
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        titleLarge: GoogleFonts.inter(fontWeight: FontWeight.bold, color: const Color(0xFF1A1D1E)),
        titleMedium: GoogleFonts.inter(fontWeight: FontWeight.w600, color: const Color(0xFF1A1D1E)),
        bodyLarge: GoogleFonts.inter(color: const Color(0xFF4A4D4E)),
        bodyMedium: GoogleFonts.inter(color: const Color(0xFF6A6D6E)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF1A1D1E)),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1A1D1E),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF14C699),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
