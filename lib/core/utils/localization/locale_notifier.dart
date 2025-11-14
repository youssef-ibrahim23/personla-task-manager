import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../constants/app_strings.dart';
import 'l10n/app_localizations.dart';

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale(AppStrings.defaultLocale));

  void setLocale(Locale locale) {
    if (!AppLocalizations.supportedLocales.contains(locale)) return;
    state = locale;
  }

  void resetLocale() {
    state = const Locale(AppStrings.defaultLocale);
  }
}
