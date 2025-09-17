import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/mycolors.dart';

class AppTheme {
  // Modern dark theme with enhanced design tokens
  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: const Color(MyColors.primaryRed),
      scaffoldBackgroundColor: const Color(MyColors.background),
      brightness: Brightness.dark,
      useMaterial3: true,

      // AppBar theme with modern styling
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(MyColors.primaryRed),
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Color(MyColors.textColor)),
        titleTextStyle: const TextStyle(
          fontFamily: 'Metropolis',
          color: Color(MyColors.textColor),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
        shadowColor: Colors.black26,
        surfaceTintColor: Colors.transparent,
      ),
      // Input decoration theme with modern styling
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(MyColors.textfieldBakground),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(MyColors.primaryRed),
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(MyColors.error), width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(MyColors.error), width: 2),
        ),
        hintStyle: const TextStyle(
          color: Color(MyColors.secondaryGrey),
          fontFamily: 'Metropolis',
          fontSize: 16,
        ),
        labelStyle: const TextStyle(
          color: Color(MyColors.secondaryGrey),
          fontFamily: 'Metropolis',
          fontSize: 16,
        ),
        floatingLabelStyle: const TextStyle(
          color: Color(MyColors.primaryRed),
          fontFamily: 'Metropolis',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      // Enhanced button theme with modern styling
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(MyColors.primaryRed),
          foregroundColor: const Color(MyColors.textColor),
          minimumSize: const Size(double.infinity, 56),
          elevation: 4,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Metropolis',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) {
                return Colors.white.withOpacity(0.1);
              }
              if (states.contains(WidgetState.hovered)) {
                return Colors.white.withOpacity(0.05);
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
          minimumSize: const Size(double.infinity, 56),
          side: const BorderSide(color: Color(MyColors.primaryRed), width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Metropolis',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
      // Enhanced card theme with modern styling
      cardTheme: const CardThemeData(
        color: Color(MyColors.textfieldBakground),
        elevation: 8,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        clipBehavior: Clip.antiAlias,
      ),

      // Modern bottom navigation bar theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(MyColors.background),
        selectedItemColor: Color(MyColors.primaryRed),
        unselectedItemColor: Color(MyColors.textSecondary),
        type: BottomNavigationBarType.fixed,
        elevation: 16,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Metropolis',
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Metropolis',
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Icon theme
      iconTheme: const IconThemeData(
        color: Color(MyColors.textColor),
        size: 24,
      ),

      // Divider theme
      dividerTheme: const DividerThemeData(
        color: Color(MyColors.textSecondary),
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
          fontFamily: 'Metropolis',
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 2,
        pressElevation: 4,
      ),
    );
  }
}
