import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task/bottom_navigations.dart';
import 'package:personal_task/core/constants/app_colors.dart';
import 'package:personal_task/core/constants/app_strings.dart';
import 'package:personal_task/core/utils/localization/l10n/app_localizations.dart';
import 'package:personal_task/features/auth/views/register_view.dart';
import 'package:personal_task/features/auth/views/widgets/another_option.dart';
import 'package:personal_task/core/shared/button/button.dart';
import 'package:personal_task/features/auth/data/login_data.dart';
import 'package:personal_task/features/auth/view-models/login_view_model.dart';
import 'package:personal_task/core/shared/text-field/text_field.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/utils/localization/locale_provider.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final Map<String, TextEditingController> _controllers = {
    'email': TextEditingController(),
    'password': TextEditingController(),
  };

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final loginState = ref.watch(loginViewModelProvider);

    ref.listen(loginViewModelProvider, (previous, next) {
      next.when(
        data: (user) {
          if (user != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => BottomNavigations()),
            );
          }
        },
        error: (error, _) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Helpers.displayDialog(
              context: context,
              title: AppLocalizations.of(context)!.login_failed,
              message: error.toString(),
              dialogType: DialogType.error,
              openMailOption: false,
            );
          });
        },
        loading: () {},
      );
    });

    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height:  ref.watch(localeProvider).languageCode == 'ar' ? screenHeight * 0.14 : screenHeight * 0.22),
              Text(
                AppLocalizations.of(context)!.app_title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: ref.watch(localeProvider).languageCode == 'ar' ? AppStrings.primaryArabicFont: AppStrings.primaryFont,
                  fontSize: ref.watch(localeProvider).languageCode == 'ar' ? 100 : 70,
                ),
              ).animate().shimmer(
                color: AppColors.primary,
                duration: 1.seconds,
              ),
              SizedBox(height: screenHeight * 0.07),
              Container(
                width: screenWidth,
                height: screenHeight * 0.5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.04),
                    Text(
                      AppLocalizations.of(context)!.login,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 50,
                        fontFamily: ref.watch(localeProvider).languageCode == 'ar' ? AppStrings.primaryArabicFont: AppStrings.primaryFont,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomTextField(
                      hintText: AppLocalizations.of(context)!.email,
                      controller: _controllers['email'],
                      obscureText: false,
                      fontFamily: ref.watch(localeProvider).languageCode == 'ar' ? AppStrings.primaryArabicFont: AppStrings.primaryFont,
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    CustomTextField(
                      hintText: AppLocalizations.of(context)!.password,
                      controller: _controllers['password'],
                      obscureText: true,
                      isHaveSuffixIcon: true,
                      fontFamily: ref.watch(localeProvider).languageCode == 'ar' ? AppStrings.primaryArabicFont: AppStrings.primaryFont,
                    ),
                    SizedBox(height: screenHeight * 0.035),
                    Button(
                      text: loginState.isLoading
                          ? AppLocalizations.of(context)!.logging
                          : AppLocalizations.of(context)!.login,
                      onPressed: loginState.isLoading ? () {} : () async {
                        await ref.read(loginViewModelProvider.notifier).signIn(
                          LoginData(
                            email: _controllers['email']!.text,
                            password: _controllers['password']!.text,
                          ),
                        );
                      },
                      state: loginState.isLoading,
                      fontFamily: ref.watch(localeProvider).languageCode == 'ar' ? AppStrings.primaryArabicFont: AppStrings.primaryFont,
                    ).animate().moveX(begin: 500, duration: 500.ms),
                    SizedBox(height: screenHeight * 0.01),
                    AnotherOption(
                      isLogin: false,
                      page: const RegisterView(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
