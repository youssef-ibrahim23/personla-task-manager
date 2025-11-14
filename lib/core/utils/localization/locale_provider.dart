import 'dart:ui';

import 'package:flutter_riverpod/legacy.dart';

import 'locale_notifier.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});