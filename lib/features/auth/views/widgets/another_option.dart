import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task/core/utils/localization/l10n/app_localizations.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/localization/locale_provider.dart';

class AnotherOption extends ConsumerWidget {
  final bool isLogin;
  final Widget page;

  const AnotherOption({super.key, required this.isLogin, required this.page});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isLogin
              ? AppLocalizations.of(context)!.already_have_account
              : AppLocalizations.of(context)!.not_have_account,
          style:  TextStyle(color: Theme.of(context).colorScheme.surface , fontFamily: ref.watch(localeProvider).languageCode == 'ar' ? AppStrings.primaryArabicFont: AppStrings.primaryFont,),
        ).animate().move(begin: const Offset(0, 100), duration: 500.ms),
        TextButton(
          child: Text(
            isLogin
                ? AppLocalizations.of(context)!.login
                : AppLocalizations.of(context)!.register,
            style: TextStyle(color: Theme.of(context).colorScheme.background , fontFamily: ref.watch(localeProvider).languageCode == 'ar' ? AppStrings.primaryArabicFont: AppStrings.primaryFont),
          ).animate().move(begin: const Offset(0, 100), duration: 500.ms),
          onPressed: () {
            if (isLogin) {
              Navigator.pop(context);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => page),
              );
            }
          },
        ),
      ],
    );
  }
}
