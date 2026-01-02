import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task/core/constants/app_colors.dart';
import 'package:personal_task/core/utils/localization/l10n/app_localizations.dart';
import 'package:personal_task/core/utils/theme/theme_provider.dart';

class ThemeOptionWidget extends ConsumerWidget {
  const ThemeOptionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final localizations = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.surface,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(
          themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
          color: AppColors.primary,
          size: 28,
        ),
        title: Text(
          localizations.change_theme,
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
        subtitle: Text(
          themeMode == ThemeMode.dark
              ? localizations.dark_mode
              : localizations.light_mode,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
        trailing: Switch(
          value: themeMode == ThemeMode.dark,
          onChanged: (value) {
            ref.read(themeProvider.notifier).toggleTheme();
          },
          activeColor: AppColors.primary,
        ),
      ),
    );
  }
}



