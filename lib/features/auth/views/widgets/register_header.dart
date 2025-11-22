import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/localization/l10n/app_localizations.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.app_title,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontFamily: AppStrings.primaryFont,
            fontSize: 40,
          ),
        ).animate().shimmer(
          color: AppColors.primary,
          duration: 1.seconds,
        ),
        Text(
          AppLocalizations.of(context)!.create_your_account,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 18,
            fontFamily: AppStrings.primaryFont,
            fontWeight: FontWeight.w300,
          ),
        ).animate().shimmer(
          color: AppColors.primary,
          duration: 1.seconds,
        ),
      ],
    );
  }
}
