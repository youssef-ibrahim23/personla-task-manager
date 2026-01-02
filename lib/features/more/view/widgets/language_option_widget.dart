import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task/core/constants/app_colors.dart';
import 'package:personal_task/core/constants/app_strings.dart';
import 'package:personal_task/core/utils/localization/l10n/app_localizations.dart';
import 'package:personal_task/core/utils/localization/locale_provider.dart';

class LanguageOptionWidget extends ConsumerWidget {
  const LanguageOptionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final localizations = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      children: [
        Expanded(
          child: _buildLanguageCard(
            context: context,
            locale: locale,
            languageCode: 'en',
            languageName: localizations.english,
            flag: '🇺🇸',
            countryName: 'United States',
            isSelected: locale.languageCode == 'en',
            onTap: () {
              ref.read(localeProvider.notifier).setLocaleFromString('en');
            },
          ),
        ),
        SizedBox(width: screenWidth * 0.04),
        Expanded(
          child: _buildLanguageCard(
            context: context,
            locale: locale,
            languageCode: 'ar',
            languageName: localizations.arabic,
            flag: '🇸🇦',
            countryName: 'السعودية',
            isSelected: locale.languageCode == 'ar',
            onTap: () {
              ref.read(localeProvider.notifier).setLocaleFromString('ar');
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageCard({
    required BuildContext context,
    required Locale locale,
    required String languageCode,
    required String languageName,
    required String flag,
    required String countryName,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    theme.primaryColor,
                    theme.primaryColor.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected ? null : theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? theme.primaryColor
                : theme.colorScheme.primary.withOpacity(0.2),
            width: isSelected ? 2.5 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? theme.primaryColor.withOpacity(0.3)
                  : Colors.black.withOpacity(0.05),
              blurRadius: isSelected ? 12 : 8,
              offset: Offset(0, isSelected ? 6 : 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Flag
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.2)
                    : theme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Text(flag, style: const TextStyle(fontSize: 32)),
            ),
            const SizedBox(height: 12),
            // Language Name
            Text(
              languageName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : theme.colorScheme.surface,
                fontFamily: 'Rakkas-Regular',
              ),
            ),
            const SizedBox(height: 6),
            // Country Name
            Text(
              countryName,
              style: TextStyle(
                fontFamily: AppStrings.primaryArabicFont,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? Colors.white.withOpacity(0.9)
                    : theme.colorScheme.surface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 12),
            // Selection Indicator
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.white : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? Colors.white
                      : theme.colorScheme.primary.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: AppColors.primary, size: 16)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
