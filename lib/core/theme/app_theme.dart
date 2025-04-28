import 'package:flutter/material.dart';
import '../constants/mycolors.dart';

class AppTheme {
  // Light theme
  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: const Color(MyColors.primaryRed),
      scaffoldBackgroundColor: const Color(MyColors.background),
      brightness: Brightness.dark,
      // AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(MyColors.primaryRed),
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(MyColors.textColor)),
      ),
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(MyColors.textfieldBakground),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: Color(MyColors.primaryRed),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(MyColors.error)),
        ),
        hintStyle: const TextStyle(
          color: Color(MyColors.secondaryGrey),
          fontFamily: 'Metropolis',
        ),
      ),
      // Button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(MyColors.primaryRed),
          foregroundColor: const Color(MyColors.textColor),
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Metropolis',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      // Text theme
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontFamily: 'Metropolis',
          color: Color(MyColors.textColor),
          fontSize: 34,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Metropolis',
          color: Color(MyColors.textColor),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Metropolis',
          color: Color(MyColors.textColor),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Metropolis',
          color: Color(MyColors.textColor),
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Metropolis',
          color: Color(MyColors.textColor),
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        labelLarge: TextStyle(
          fontFamily: 'Metropolis',
          color: Color(MyColors.textColor),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: TextStyle(
          fontFamily: 'Metropolis',
          color: Color(MyColors.textColor),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          fontFamily: 'Metropolis',
          color: Color(MyColors.textColor),
          fontSize: 11,
          fontWeight: FontWeight.normal,
        ),
      ),
      // Card theme
      cardTheme: CardTheme(
        color: const Color(MyColors.textfieldBakground),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      // Bottom navigation bar theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(MyColors.background),
        selectedItemColor: Color(MyColors.primaryRed),
        unselectedItemColor: Color(MyColors.textSecondary),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
