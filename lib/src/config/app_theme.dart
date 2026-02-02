import 'package:flutter/material.dart';
import 'color_scheme.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: false,

    // Core colors
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.background,
      surfaceTint: Colors.transparent,
      error: AppColors.error,
    ),

    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(
        color: AppColors.primary,
      ),
      titleTextStyle: TextStyle(
        color: AppColors.primary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),

    // Text
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
    ),

    // Divider
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 1,
    ),

    // Icons
    iconTheme: const IconThemeData(
      color: AppColors.primary,
      size: 22,
    ),

    // Buttons (Text / Icon buttons)
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    // Floating Action Button
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 2,
    ),

    // Checkbox / Switch / etc.
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.all(AppColors.primary),
      checkColor: WidgetStateProperty.all(Colors.white),
    ),

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.all(AppColors.primary),
      trackColor: WidgetStateProperty.all(AppColors.primaryLight),
    ),

    // Input fields (forms)
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      labelStyle: const TextStyle(
        color: AppColors.textSecondary,
      ),
    ),

    //card
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );

  const AppTheme._();
}