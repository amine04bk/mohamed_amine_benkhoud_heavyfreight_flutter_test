import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get theme => ThemeData(
        primaryColor: AppColors.primaryOrange,
        scaffoldBackgroundColor: AppColors.backgroundWhite,
        textTheme: GoogleFonts.poppinsTextTheme().copyWith(
          headlineLarge: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
          bodyMedium: const TextStyle(
            fontSize: 14,
            color: AppColors.textGrey,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryOrange,
            foregroundColor: AppColors.backgroundWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      );
}