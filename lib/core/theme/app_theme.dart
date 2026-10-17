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
  static const Color starYellow = Color(0xFFFFB800);
  static const Color navBarDark = Color(0xFF191D21);

  // Status Colors (Success, Error, Warning, Info)
  static const Color successGreen = Color(0xFF00C12B);
  static const Color successLightBg = Color(0xFFEFFDF4);
  static const Color successLightBg2 = Color(0xFFF0FDF4);
  static const Color successBorder = Color(0xFFBBF7D0);
  static const Color successDarkText = Color(0xFF166534);

  static const Color errorRed = Color(0xFFDC2626);
  static const Color errorRedDot = Color(0xFFEF4444);
  static const Color errorLightBg = Color(0xFFFEF2F2);
  static const Color errorLightBg2 = Color(0xFFFEE2E2);
  static const Color errorBorder = Color(0xFFFCA5A5);
  static const Color errorDarkText = Color(0xFFB91C1C);

  static const Color warningAmber = Color(0xFFFFB800);
  static const Color warningLightBg = Color(0xFFFFFBEB);
  static const Color warningDarkText = Color(0xFFB45309);

  // Interactive & Selection Tints
  static const Color chipSelectedBg = Color(0xFFEFF6FF);
  static const Color facilityCardBg = Color(0xFFEFF6FF);
  static const Color facilityCardBorder = Color(0xFFD6E8FE);
  static const Color facilityCardBorderSoft = Color(0xFFD3E7FF);

  // Vector Illustration Colors
  static const Color illustrationTreadmillBelt = Color(0xFFD4E6FC);
  static const Color illustrationTreadmillBase = Color(0xFFE4F0FD);
  static const Color illustrationJersey = Color(0xFFFF6E79);
  static const Color illustrationShorts = Color(0xFF68B1FF);
  static const Color illustrationShoe1 = Color(0xFFFF6456);
  static const Color illustrationShoe2 = Color(0xFFFF8275);
  static const Color illustrationSkin = Color(0xFFFFCCBD);

  // Design Radii
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 24.0;
  static const double radiusXLarge = 28.0;
  static const double radiusPill = 999.0;

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
