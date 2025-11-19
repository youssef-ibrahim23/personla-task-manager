import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task/core/constants/app_colors.dart';
import 'package:personal_task/core/constants/app_strings.dart';
import 'package:personal_task/core/utils/localization/l10n/app_localizations.dart';
import 'package:personal_task/core/utils/validators.dart';
import 'package:personal_task/features/auth/views/register_view.dart';
import 'package:personal_task/features/auth/views/widgets/another_option.dart';
import 'package:personal_task/features/auth/views/widgets/button.dart';
import 'package:personal_task/features/auth/data/login_data.dart';
import 'package:personal_task/features/auth/view-models/login_view_model.dart';
import 'package:personal_task/features/auth/views/widgets/text_field.dart';
import 'package:personal_task/features/profile/view/profile_view.dart';

import '../../../core/utils/helpers.dart';

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

  void _login() {
    final emailError = Validators.validateEmail(_controllers['email']!.text);

    if (emailError != null) {
      Helpers.displayDialog(
        context: context,
        title: 'Invalid Email',
        message: emailError,
        dialogType: DialogType.error,
        isRegister: false
      );
      return;
    }
    ref
        .read(loginViewModelProvider.notifier)
        .signIn(
          LoginData(
            email: _controllers['email']!.text,
            password: _controllers['password']!.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {

    final double screenWidth = MediaQuery.of(context).size.width;

    final double screenHeight = MediaQuery.of(context).size.height;

    final loginState = ref.watch(loginViewModelProvider);

    ref.listen(loginViewModelProvider, (previous, next) {
      next.when(
        data: (user) {
          if (user != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => ProfileView()),
            );
          }
        },
        error: (error, _) {
          final msg = error.toString().contains("not verified")
              ? "Your email is not verified. Please check your inbox."
              : "Login failed, please try again.";

          Helpers.displayDialog(
            context: context,
            title: "Login Failed",
            message: msg,
            dialogType:  DialogType.error,
            isRegister: false,
          );
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
              SizedBox(height: screenHeight * 0.2),
              Text(
                AppLocalizations.of(context)!.app_title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: AppStrings.primaryFont,
                  fontSize: 70,
                ),
              ).animate().shimmer(
                color: AppColors.primary,
                duration: 1.seconds
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
                        fontFamily: AppStrings.primaryFont,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomTextField(
                      hintText: AppLocalizations.of(context)!.email,
                      controller: _controllers['email'],
                      obscureText: false,
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    CustomTextField(
                      hintText: AppLocalizations.of(context)!.password,
                      controller: _controllers['password'],
                      obscureText: true,
                      isHaveSuffixIcon: true,
                    ),
                    SizedBox(height: screenHeight * 0.035),
                    Button(
                      text: loginState.isLoading ? AppLocalizations.of(context)!.logging : AppLocalizations.of(context)!.login,
                      onPressed: loginState.isLoading ? (){} : _login,
                      state: loginState.isLoading,
                    ).animate().moveX(begin: 500 , duration: 500.ms),
                    SizedBox(height: screenHeight * 0.01),
                    AnotherOption(isLogin: false, page: RegisterView()),
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
