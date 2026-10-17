import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Color Palette extracted from Figma
  static const Color primaryBlue = Color(0xFF0070F0);
  static const Color secondaryBlue = Color(0xFF0077FF);
  static const Color lightBlueBg = Color(0xFFF2F8FF);
  static const Color lightBlueBorder = Color(0xFFBFDDFF);

  static const Color darkText = Color(0xFF090A0A);
  static const Color bodyText = Color(0xFF303437);
  static const Color mutedText = Color(0xFF72777A);
  static const Color lightText = Color(0xFF979C9E);

  static const Color bgWhite = Color(0xFFFFFFFF);
  static const Color bgOffWhite = Color(0xFFF8F9FA);
  static const Color cardGray = Color(0xFFF3F4F6);
  static const Color borderLight = Color(0xFFE5E7EB);

  // Metric Colors
  static const Color ringSleep = Color(0xFF52BAFF);
  static const Color ringCalories = Color(0xFFFF6E79);
  static const Color ringSteps = Color(0xFFFFC85C);
  static const Color successGreen = Color(0xFF00C12B);
  static const Color starYellow = Color(0xFFFFB800);
  static const Color navBarDark = Color(0xFF191D21);

  static ThemeData get lightTheme {
    final fontFamily = GoogleFonts.dmSans().fontFamily;

    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: bgWhite,
      primaryColor: primaryBlue,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        primary: primaryBlue,
        surface: bgWhite,
        onSurface: darkText,
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          color: darkText,
          fontWeight: FontWeight.w700,
          fontSize: 28,
          fontFamily: fontFamily,
        ),
        headlineMedium: TextStyle(
          color: darkText,
          fontWeight: FontWeight.w700,
          fontSize: 22,
          fontFamily: fontFamily,
        ),
        titleLarge: TextStyle(
          color: darkText,
          fontWeight: FontWeight.w700,
          fontSize: 18,
          fontFamily: fontFamily,
        ),
        titleMedium: TextStyle(
          color: darkText,
          fontWeight: FontWeight.w600,
          fontSize: 16,
          fontFamily: fontFamily,
        ),
        bodyLarge: TextStyle(
          color: bodyText,
          fontWeight: FontWeight.w400,
          fontSize: 15,
          fontFamily: fontFamily,
        ),
        bodyMedium: TextStyle(
          color: mutedText,
          fontWeight: FontWeight.w400,
          fontSize: 13,
          fontFamily: fontFamily,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgWhite,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: darkText),
      ),
    );
  }
}
