import 'package:driver_app/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData _base = ThemeData(
    useMaterial3: true,
    appBarTheme: const AppBarTheme(
      centerTitle: false,
      elevation: 0,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
    ),
  );

  static ThemeData get lightTheme {
    return _base.copyWith(
      colorScheme: const ColorScheme(
        brightness: Brightness.light,

        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        surfaceContainer: AppColors.background,
        error: AppColors.error,
        errorContainer: AppColors.warning,
        tertiary: AppColors.success,

        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
        onSurfaceVariant: AppColors.textSecondary,
        onError: Colors.white,
        onErrorContainer: Colors.white,
        onTertiary: Colors.white
      ),
      scaffoldBackgroundColor: AppColors.background,
    );
  }

  static ThemeData get darkTheme {
    return _base.copyWith(
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,

        primary: AppColors.darkPrimary,
        secondary: AppColors.secondary,
        surface: AppColors.darkSurface,
        surfaceContainer: AppColors.darkBackground,
        error: AppColors.error,
        errorContainer: AppColors.warning,
        tertiary: AppColors.success,

        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.darkTextPrimary,
        onSurfaceVariant: AppColors.darkTextSecondary,
        onError: Colors.white,
        onErrorContainer: Colors.white,
        onTertiary: Colors.white
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
    );
  }
}