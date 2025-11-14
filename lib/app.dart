import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task/features/splash/view/splash_view.dart';

import 'core/constants/app_themes.dart';
import 'core/utils/localization/l10n/app_localizations.dart';
import 'core/utils/localization/locale_provider.dart';
import 'core/utils/theme/theme_provider.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final theme = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Task',
      themeMode: theme,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const SplashView(),
    );
  }
}
