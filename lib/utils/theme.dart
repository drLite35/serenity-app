import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors
  static const Color primaryMint = Color(0xFF9BCFB8);
  static const Color secondaryMint = Color(0xFFBEDCD0);
  
  // Background Colors
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF2C3E50);
  
  // Text Colors
  static const Color textDark = Color(0xFF000000);
  static const Color textLight = Color(0xFF666666);
  
  // Accent Colors
  static const Color accentGray = Color(0xFFF2F6F4);
  static const Color emergencyRed = Color(0xFFFF6B6B);
  
  // Exercise Colors
  static const Color softSky = Color(0xFFD4E6E1);
  static const Color softPeach = Color(0xFFE8D6CF);
  static const Color softMint = Color(0xFFB8E0D2);
  static const Color softSage = Color(0xFFCAD7B2);
  static const Color softLavender = Color(0xFFE2DDE7);
  static const Color softCoral = Color(0xFFE8D0CB);

  static ThemeData get theme => ThemeData(
        primaryColor: primaryMint,
        scaffoldBackgroundColor: backgroundLight,
        colorScheme: ColorScheme.light(
          primary: primaryMint,
          secondary: secondaryMint,
          surface: backgroundLight,
          background: backgroundLight,
          error: emergencyRed,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            color: textDark,
            fontSize: 28,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.2,
          ),
          headlineMedium: TextStyle(
            color: textDark,
            fontSize: 24,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.1,
          ),
          titleLarge: TextStyle(
            color: textDark,
            fontSize: 20,
            fontWeight: FontWeight.w500,
            letterSpacing: 0,
          ),
          titleMedium: TextStyle(
            color: textDark,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0,
          ),
          bodyLarge: TextStyle(
            color: textLight,
            fontSize: 16,
            letterSpacing: 0,
            height: 1.5,
          ),
          bodyMedium: TextStyle(
            color: textLight,
            fontSize: 14,
            letterSpacing: 0,
            height: 1.4,
          ),
          bodySmall: TextStyle(
            color: textLight,
            fontSize: 12,
            letterSpacing: 0,
            height: 1.3,
          ),
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadowColor: Colors.black.withOpacity(0.05),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: primaryMint,
          unselectedItemColor: textLight,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryMint,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primaryMint,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: textDark,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            letterSpacing: 0,
          ),
          iconTheme: IconThemeData(
            color: textDark,
          ),
        ),
      );
} 