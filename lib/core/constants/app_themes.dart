import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppThemes {
  final Locale locale;

  AppThemes(this.locale);

  String get _fontFamily {
    if (locale.languageCode == 'ar') {
      return 'Rakkas-Regular';
    } else {
      return 'Luckiest Guy';
    }
  }

  ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.primary,
      fontFamily: _fontFamily,
      appBarTheme: AppBarTheme(
        surfaceTintColor: AppColors.primary,
        foregroundColor: AppColors.light,
        centerTitle: true,
        backgroundColor: AppColors.primary,
        titleTextStyle: TextStyle(fontFamily: _fontFamily),
      ),
      colorScheme: ColorScheme.fromSeed(
        primary: AppColors.primary,
        primaryContainer: AppColors.light,
        seedColor: AppColors.light,
        surface: AppColors.dark,
        background: AppColors.primary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(letterSpacing: 1 , color: AppColors.dark , fontSize: 15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(width: 2, color: AppColors.dark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(width: 2, color: AppColors.dark),
        ),
        suffixIconColor: AppColors.dark,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.primary,
        unselectedLabelColor: Colors.grey,
        indicator: UnderlineTabIndicator(
        borderSide: BorderSide(width: 5.0, color: AppColors.primary),
      ),
        labelStyle: TextStyle(fontSize: 20, fontFamily: _fontFamily),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: AppColors.light,
        headerBackgroundColor: AppColors.primary,
        headerForegroundColor: AppColors.light,
        dayStyle: TextStyle(
          color: AppColors.dark,
          fontFamily: _fontFamily,
          fontWeight: FontWeight.w500,
        ),
        weekdayStyle: TextStyle(
          color: AppColors.dark,
          fontFamily: _fontFamily,
          fontWeight: FontWeight.w600,
        ),
        yearStyle: TextStyle(
          color: AppColors.dark,
          fontFamily: _fontFamily,
        ),
        rangeSelectionBackgroundColor: AppColors.primary.withOpacity(0.2),
        rangeSelectionOverlayColor: MaterialStateProperty.all(
          AppColors.primary.withOpacity(0.1),
        ),
        todayBorder: BorderSide(
          color: AppColors.primary,
          width: 2,
        ),
        todayBackgroundColor: WidgetStateProperty.all(Colors.white),
        dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.primary;
          }
          return Colors.transparent;
        }),
        todayForegroundColor: MaterialStateProperty.all(AppColors.primary),
        dayForegroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.light;
          }
          if (states.contains(MaterialState.disabled)) {
            return Colors.grey.shade400;
          }
          return AppColors.dark;
        }),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        headerHeadlineStyle: TextStyle(
          color: AppColors.light,
          fontFamily: _fontFamily,
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
        headerHelpStyle: TextStyle(
          color: AppColors.light.withOpacity(0.9),
          fontFamily: _fontFamily,
          fontSize: 14,
        ),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: AppColors.light,
        hourMinuteColor: AppColors.primary.withOpacity(0.1),
        hourMinuteTextColor: AppColors.primary,
        dayPeriodColor: AppColors.primary.withOpacity(0.1),
        dayPeriodTextColor: AppColors.primary,
        dialHandColor: AppColors.primary,
        dialBackgroundColor: AppColors.primary.withOpacity(0.05),
        dialTextColor: AppColors.dark,
        entryModeIconColor: AppColors.primary,
        helpTextStyle: TextStyle(
          color: AppColors.dark,
          fontFamily: _fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        hourMinuteTextStyle: TextStyle(
          color: AppColors.primary,
          fontFamily: _fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        dayPeriodTextStyle: TextStyle(
          color: AppColors.primary,
          fontFamily: _fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  ThemeData get darkTheme {
    return  ThemeData(
      primaryColor: AppColors.primaryDark,
      scaffoldBackgroundColor: AppColors.primaryDark,
      fontFamily: _fontFamily,
        colorScheme: ColorScheme.fromSeed(
          primary: AppColors.primary,
          primaryContainer: AppColors.dark,
          seedColor: AppColors.dark,
          surface: AppColors.light,
          background: AppColors.primaryDark,
        ),
      appBarTheme: AppBarTheme(
        surfaceTintColor: AppColors.primaryDark,
        foregroundColor: AppColors.light,
        centerTitle: true,
        backgroundColor: AppColors.primaryDark,
        titleTextStyle: TextStyle(fontFamily: _fontFamily),
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(letterSpacing: 1 , color: AppColors.light , fontSize: 15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(width: 2, color: AppColors.light),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(width: 2, color: AppColors.light),
        ),
        suffixIconColor: AppColors.light,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: AppColors.light,
        unselectedLabelColor: Colors.grey,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(width: 5.0, color: AppColors.primaryDark),
        ),
        labelStyle: TextStyle(fontSize: 20, fontFamily: _fontFamily),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: AppColors.dark,
        headerBackgroundColor: AppColors.primaryDark,
        headerForegroundColor: AppColors.light,
        dayStyle: TextStyle(
          color: AppColors.light,
          fontFamily: _fontFamily,
          fontWeight: FontWeight.w500,
        ),
        weekdayStyle: TextStyle(
          color: AppColors.light,
          fontFamily: _fontFamily,
          fontWeight: FontWeight.w600,
        ),
        yearStyle: TextStyle(
          color: AppColors.light,
          fontFamily: _fontFamily,
        ),
        rangeSelectionBackgroundColor: AppColors.primary.withOpacity(0.3),
        rangeSelectionOverlayColor: MaterialStateProperty.all(
          AppColors.primary.withOpacity(0.15),
        ),
        todayBorder: BorderSide(
          color: AppColors.primary,
          width: 2,
        ),
        dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.primary;
          }
          return Colors.transparent;
        }),
        todayForegroundColor: MaterialStateProperty.all(AppColors.primary),
        dayForegroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.light;
          }
          if (states.contains(MaterialState.disabled)) {
            return Colors.grey.shade600;
          }
          return AppColors.light;
        }),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        headerHeadlineStyle: TextStyle(
          color: AppColors.light,
          fontFamily: _fontFamily,
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
        headerHelpStyle: TextStyle(
          color: AppColors.light.withOpacity(0.9),
          fontFamily: _fontFamily,
          fontSize: 14,
        ),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: AppColors.dark,
        hourMinuteColor: AppColors.primary.withOpacity(0.2),
        hourMinuteTextColor: AppColors.primary,
        dayPeriodColor: AppColors.primary.withOpacity(0.2),
        dayPeriodTextColor: AppColors.primary,
        dialHandColor: AppColors.primary,
        dialBackgroundColor: AppColors.primary.withOpacity(0.1),
        dialTextColor: AppColors.light,
        entryModeIconColor: AppColors.primary,
        helpTextStyle: TextStyle(
          color: AppColors.light,
          fontFamily: _fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        hourMinuteTextStyle: TextStyle(
          color: AppColors.primary,
          fontFamily: _fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        dayPeriodTextStyle: TextStyle(
          color: AppColors.primary,
          fontFamily: _fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
