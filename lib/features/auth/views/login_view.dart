import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task/core/constants/app_strings.dart';
import 'package:personal_task/core/utils/validators.dart';
import 'package:personal_task/features/auth/views/register_view.dart';
import 'package:personal_task/features/auth/views/widgets/another_option.dart';
import 'package:personal_task/features/auth/views/widgets/button.dart';
import 'package:personal_task/features/home/view/home_view.dart';
import 'package:personal_task/features/auth/data/login_data.dart';
import 'package:personal_task/features/auth/view-models/auth_view_model.dart';
import 'package:personal_task/features/auth/views/widgets/text_field.dart';

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
        context,
        'Invalid Email',
        emailError,
        DialogType.error,
      );
      return;
    }
    ref
        .read(authViewModelProvider.notifier)
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

    final loginState = ref.watch(authViewModelProvider);

    ref.listen(authViewModelProvider, (previous, next) {
      next.when(
        data: (user) async {
          if (user == null) {
            Helpers.displayDialog(
              context,
              'Field To Login',
              'This User Not Found , Please Register First',
              DialogType.error,
            );
            return;
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeView()),
            );
          }
        },
        error: (error, _) {
          Helpers.displayDialog(
            context,
            'Field To Login',
            'Something went wrong please , try again',
            DialogType.error,
          );
          return;
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
              SizedBox(height: screenHeight * 0.33),
              Text(
                "Personal Tasks",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: AppStrings.primaryFont,
                  fontSize: 40,
                ),
              ),
              SizedBox(height: screenHeight * 0.09),
              Container(
                width: screenWidth,
                height: screenHeight * 0.52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.04),
                    Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 50,
                        fontFamily: AppStrings.primaryFont,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    CustomTextField(
                      hintText: "Email",
                      controller: _controllers['email'],
                      obscureText: false,
                    ),
                    SizedBox(height: screenHeight * 0.05),
                    CustomTextField(
                      hintText: "Password",
                      controller: _controllers['password'],
                      obscureText: true,
                      isHaveSuffixIcon: true,
                    ),
                    SizedBox(height: screenHeight * 0.035),
                    Button(
                      text: loginState.isLoading ? "Logging" : "Login",
                      onPressed: _login,
                      state: loginState.isLoading,
                    ),
                    SizedBox(height: screenHeight * 0.015),
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
