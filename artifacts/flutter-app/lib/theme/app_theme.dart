import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.tint,
        secondary: AppColors.accent,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      textTheme: _textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.tint),
      ),
    );
  }

  static TextTheme get _textTheme {
    return TextTheme(
      displayLarge: playfairBold(34),
      displayMedium: playfairBold(28),
      displaySmall: playfairBold(24),
      headlineMedium: playfairBold(20),
      headlineSmall: playfairBold(18),
      titleLarge: interSemiBold(18),
      titleMedium: interSemiBold(16),
      titleSmall: interSemiBold(14),
      bodyLarge: interRegular(16),
      bodyMedium: interRegular(15),
      bodySmall: interRegular(14),
      labelLarge: interSemiBold(15),
      labelMedium: interMedium(13),
      labelSmall: interRegular(12),
    );
  }

  static TextStyle playfairBold(double size) {
    return GoogleFonts.playfairDisplay(
      fontSize: size,
      fontWeight: FontWeight.w700,
      color: AppColors.text,
    );
  }

  static TextStyle playfairRegular(double size) {
    return GoogleFonts.playfairDisplay(
      fontSize: size,
      fontWeight: FontWeight.w400,
      color: AppColors.text,
    );
  }

  static TextStyle playfairItalic(double size) {
    return GoogleFonts.playfairDisplay(
      fontSize: size,
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.italic,
      color: AppColors.text,
    );
  }

  static TextStyle interRegular(double size) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: FontWeight.w400,
      color: AppColors.text,
    );
  }

  static TextStyle interMedium(double size) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: FontWeight.w500,
      color: AppColors.text,
    );
  }

  static TextStyle interSemiBold(double size) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: FontWeight.w600,
      color: AppColors.text,
    );
  }

  static TextStyle interBold(double size) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: FontWeight.w700,
      color: AppColors.text,
    );
  }
}
