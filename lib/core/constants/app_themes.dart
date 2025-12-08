import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppThemes {
  final Locale locale;

  AppThemes(this.locale);

  String get _fontFamily {
    if (locale.languageCode == 'ar') {
      return 'Rakkas-Regular';
    } else {
      return 'LuckiestGuy';
    }
  }

  ThemeData get lightTheme {
    return ThemeData(
      fontFamily: _fontFamily,
          appBarTheme: AppBarTheme(
            centerTitle: true,
            backgroundColor: AppColors.primary,
          )
    );
  }

  ThemeData get darkTheme {
    return ThemeData();
  }
}
