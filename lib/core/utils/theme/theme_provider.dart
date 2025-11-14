import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:personal_task/core/utils/theme/theme_notifier.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier , ThemeMode>((ref){
  return ThemeNotifier();
});