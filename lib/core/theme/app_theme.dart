import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/mycolors.dart';

class AppTheme {
  // Modern dark theme with luxury e-commerce tokens
  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: const Color(MyColors.primaryRed),
      scaffoldBackgroundColor: const Color(MyColors.background),
      colorScheme: const ColorScheme.dark(
        primary: Color(MyColors.primaryRed),
        secondary: Color(MyColors.primaryRedLight),
        surface: Color(MyColors.surface),
        error: Color(MyColors.error),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Color(MyColors.textColor),
      ),
      brightness: Brightness.dark,
      useMaterial3: true,

      // Modern translucent/clean AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: Color(MyColors.textColor), size: 22),
        titleTextStyle: TextStyle(
          color: Color(MyColors.textColor),
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        surfaceTintColor: Colors.transparent,
      ),

      // Input decoration theme with subtle borders and deep slate fill
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(MyColors.textfieldBakground),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(MyColors.borderSubtle)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(MyColors.borderSubtle)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(MyColors.primaryRed),
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(MyColors.error), width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(MyColors.error), width: 1.5),
        ),
        hintStyle: const TextStyle(
          color: Color(MyColors.secondaryGrey),
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        labelStyle: const TextStyle(
          color: Color(MyColors.secondaryGrey),
          fontSize: 15,
        ),
        floatingLabelStyle: const TextStyle(
          color: Color(MyColors.primaryRed),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Enhanced button theme with modern styling
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(MyColors.primaryRed),
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 54),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) {
                return Colors.white.withValues(alpha: 0.15);
              }
              if (states.contains(WidgetState.hovered)) {
                return Colors.white.withValues(alpha: 0.08);
              }
              return null;
            },
          ),
        ),
      ),

      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(MyColors.primaryRed),
          minimumSize: const Size(double.infinity, 54),
          side: const BorderSide(color: Color(MyColors.primaryRed), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        ),
      ),

      // Text theme with calibrated weights and spacing
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Color(MyColors.textColor),
          fontSize: 30,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.6,
        ),
        titleLarge: TextStyle(
          color: Color(MyColors.textColor),
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        titleMedium: TextStyle(
          color: Color(MyColors.textColor),
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
        bodyLarge: TextStyle(
          color: Color(MyColors.textColor),
          fontSize: 15,
          fontWeight: FontWeight.w400,
          height: 1.45,
        ),
        bodyMedium: TextStyle(
          color: Color(MyColors.textSecondary),
          fontSize: 13,
          fontWeight: FontWeight.w400,
          height: 1.4,
        ),
        labelLarge: TextStyle(
          color: Color(MyColors.textColor),
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
        labelMedium: TextStyle(
          color: Color(MyColors.textSecondary),
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          color: Color(MyColors.secondaryGrey),
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.3,
        ),
      ),

      // Enhanced card theme with subtle border and zero heavy shadow
      cardTheme: const CardThemeData(
        color: Color(MyColors.cardBackground),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          side: BorderSide(color: Color(MyColors.borderSubtle), width: 1),
        ),
        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        clipBehavior: Clip.antiAlias,
      ),

      // Modern bottom navigation bar theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(MyColors.background),
        selectedItemColor: Color(MyColors.primaryRed),
        unselectedItemColor: Color(MyColors.secondaryGrey),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Icon theme
      iconTheme: const IconThemeData(
        color: Color(MyColors.textColor),
        size: 22,
      ),

      // Divider theme
      dividerTheme: const DividerThemeData(
        color: Color(MyColors.borderSubtle),
        thickness: 1,
        space: 1,
      ),

      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: const Color(MyColors.textfieldBakground),
        selectedColor: const Color(MyColors.primaryRed),
        disabledColor: const Color(MyColors.secondaryGrey),
        labelStyle: const TextStyle(
          color: Color(MyColors.textColor),
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(MyColors.borderSubtle)),
        ),
        elevation: 0,
        pressElevation: 0,
      ),
    );
  }
}
