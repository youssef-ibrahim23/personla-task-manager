import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task/core/utils/localization/l10n/app_localizations.dart';
import 'package:personal_task/features/more/view/widgets/language_option_widget.dart';
import 'package:personal_task/features/more/view/widgets/logout_option_widget.dart';
import 'package:personal_task/features/more/view/widgets/theme_option_widget.dart';

class MoreView extends ConsumerWidget {
  const MoreView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.colorScheme.primaryContainer,
      body: CustomScrollView(
        slivers: [
          // Enhanced Header
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              height: screenHeight * 0.35,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.primaryColor,
                    theme.primaryColor.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.primaryColor.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.settings_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        localizations.more,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          fontFamily: 'Rakkas-Regular',
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        localizations.settings_and_preferences,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Content Section
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenHeight * 0.03,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Language Selection Section
                _buildSectionHeader(
                  context,
                  localizations.change_language,
                  Icons.language_rounded,
                ),
                const SizedBox(height: 16),
                const LanguageOptionWidget(),
                SizedBox(height: screenHeight * 0.03),
                // Theme Selection Section
                _buildSectionHeader(
                  context,
                  localizations.change_theme,
                  Icons.palette_rounded,
                ),
                const SizedBox(height: 16),
                const ThemeOptionWidget(),
                SizedBox(height: screenHeight * 0.03),
                // Logout Section
                _buildSectionHeader(
                  context,
                  localizations.account,
                  Icons.account_circle_rounded,
                ),
                const SizedBox(height: 16),
                const LogoutOptionWidget(),
                SizedBox(height: screenHeight * 0.04),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: theme.primaryColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.surface,
            fontFamily: 'Rakkas-Regular',
          ),
        ),
      ],
    );
  }
}
