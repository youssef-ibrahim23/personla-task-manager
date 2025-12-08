import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task/core/constants/app_colors.dart';
import 'package:personal_task/core/constants/app_strings.dart';
import 'package:personal_task/core/utils/localization/l10n/app_localizations.dart';
import 'package:personal_task/features/more/view/widgets/language_option_widget.dart';
import 'package:personal_task/features/more/view/widgets/logout_option_widget.dart';
import 'package:personal_task/features/more/view/widgets/theme_option_widget.dart';

class MoreView extends ConsumerWidget {
  const MoreView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: screenHeight * 0.25,
              padding: const EdgeInsets.only(top: 50),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
              ),
              child: Text(
                localizations.more,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontFamily: AppStrings.primaryFont,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            const ThemeOptionWidget(),
            const LanguageOptionWidget(),
            const LogoutOptionWidget(),
            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
    );
  }
}
