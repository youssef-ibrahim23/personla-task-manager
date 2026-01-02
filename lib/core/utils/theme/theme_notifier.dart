// core/utils/theme/theme_notifier.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/app_strings.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeString = prefs.getString(AppStrings.prefThemeMode);
      if (themeString != null) {
        if (themeString.toLowerCase() == 'dark') {
          state = ThemeMode.dark;
        } else {
          state = ThemeMode.light;
        }
      }
    } catch (e) {
      print('Error loading theme: $e');
    }
  }

  Future<void> _saveTheme(ThemeMode mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeString = mode == ThemeMode.dark ? 'dark' : 'light';
      await prefs.setString(AppStrings.prefThemeMode, themeString);
    } catch (e) {
      print('Error saving theme: $e');
    }
  }

  void toggleTheme() {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    state = newMode;
    _saveTheme(newMode);
  }

  void setThemeFromString(String themeString) {
    if (themeString.toLowerCase() == 'dark') {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.light;
    }
    _saveTheme(state);
  }
}