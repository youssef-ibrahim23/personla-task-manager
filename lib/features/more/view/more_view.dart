import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:personal_task/core/utils/localization/l10n/app_localizations.dart';
import 'package:personal_task/features/auth/services/auth_services.dart';
import 'package:personal_task/features/more/view/widgets/language_option_widget.dart';
import 'package:personal_task/features/more/view/widgets/logout_option_widget.dart';
import 'package:personal_task/features/more/view/widgets/theme_option_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/theme/theme_provider.dart';

class MoreView extends ConsumerStatefulWidget {
  const MoreView({super.key});

  @override
  ConsumerState<MoreView> createState() => _MoreViewState();
}

class _MoreViewState extends ConsumerState<MoreView> {

  bool biometricStatus = false;

  @override
  void initState() {
    super.initState();
    _loadBiometricStatus();
  }

  _loadBiometricStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      biometricStatus = prefs.getBool('isBiometricEnabled') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                // sign in Selection Section
                _buildSectionHeader(
                  context,
                  'Enable Biometric Login',
                  Icons.fingerprint,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
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
                      ref.watch(themeProvider) == ThemeMode.dark
                          ? Icons.dark_mode
                          : Icons.light_mode,
                      color: Theme.of(context).primaryColor,
                      size: 28,
                    ),
                    title: Text(
                      "Biometric Login",
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                    subtitle: Text(
                      'Enable Biometric Login',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                    trailing: Switch(
                      value: biometricStatus,
                      onChanged: (value) async {
                        if (value) {
                          final canUse = await AuthServices.canUseBiometric();

                          if (!canUse) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Biometric authentication not available'),
                              ),
                            );
                            return;
                          }

                          final authenticated = await LocalAuthentication().authenticate(
                            localizedReason: 'Please authenticate to enable it',
                            biometricOnly: true,
                          );

                          if (!authenticated) return;
                        }

                        await AuthServices.toggleBiometricAvailability(value);

                        setState(() {
                          biometricStatus = value;
                        });
                      },
                      activeColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
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

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: theme.primaryColor, size: 24),
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
