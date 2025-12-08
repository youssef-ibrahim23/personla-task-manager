// core/utils/localization/locale_notifier.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/app_strings.dart';
import 'l10n/app_localizations.dart';

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale(AppStrings.defaultLocale)) {
    _loadLocale();
  }

  bool _isLoading = false;

  Future<void> _loadLocale() async {
    _isLoading = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(AppStrings.prefLanguage);
      if (languageCode != null) {
        final locale = Locale(languageCode.toLowerCase());
        if (AppLocalizations.supportedLocales.contains(locale)) {
          state = locale;
        }
      }
    } catch (e) {
      print('Error loading locale: $e');
    } finally {
      _isLoading = false;
    }
  }

  Future<void> _saveLocale(String languageCode) async {
    if (_isLoading) return; // Don't save during initial load
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppStrings.prefLanguage, languageCode);
    } catch (e) {
      print('Error saving locale: $e');
    }
  }

  void setLocale(Locale locale) {
    if (!AppLocalizations.supportedLocales.contains(locale)) return;
    state = locale;
    _saveLocale(locale.languageCode);
  }

  void setLocaleFromString(String languageCode) {
    final locale = Locale(languageCode.toLowerCase());
    if (!AppLocalizations.supportedLocales.contains(locale)) return;
    state = locale;
    _saveLocale(languageCode.toLowerCase());
  }

  void resetLocale() {
    state = const Locale(AppStrings.defaultLocale);
    _saveLocale(AppStrings.defaultLocale);
  }

  String getLocale() {
    return state.languageCode;
  }

  String getCurrentLanguageString() {
    return state.languageCode == 'ar' ? 'Arabic' : 'English';
  }
}
