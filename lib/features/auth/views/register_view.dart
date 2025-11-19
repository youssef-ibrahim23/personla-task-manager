import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task/core/utils/helpers.dart';
import 'package:personal_task/core/utils/DB/models/user.dart';
import 'package:personal_task/features/auth/view-models/register_view_model.dart';
import 'package:personal_task/features/auth/views/login_view.dart';
import 'package:personal_task/features/auth/views/widgets/another_option.dart';
import 'package:personal_task/features/auth/views/widgets/button.dart';
import 'package:personal_task/features/auth/views/widgets/image_widget.dart';
import 'package:personal_task/features/auth/views/widgets/register_header.dart';
import 'package:personal_task/features/auth/views/widgets/text_field.dart';

import '../../../core/utils/localization/l10n/app_localizations.dart';
import '../../../core/utils/validators.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState<RegisterView> createState() => _RegisterStateView();
}

class _RegisterStateView extends ConsumerState<RegisterView> {
  final Map<String, TextEditingController> _controllers = {
    'name': TextEditingController(),
    'email': TextEditingController(),
    'phoneNumber': TextEditingController(),
    'password': TextEditingController(),
  };

  void _register() {
    final nameError = Validators.validateName(_controllers['name']!.text);

    final emailError = Validators.validateEmail(_controllers['email']!.text);

    final phoneNumberError = Validators.validatePhoneNumber(
      _controllers['phoneNumber']!.text,
    );

    final passwordError = Validators.validatePassword(
      _controllers['password']!.text,
    );

    if (emailError != null) {
      Helpers.displayDialog(
        context: context,
        title: 'Invalid Email',
        message: emailError,
        dialogType: DialogType.error,
        isRegister: false,
      );
      return;
    } else if (passwordError != null) {
      Helpers.displayDialog(
        context: context,
        title: 'Weak Password',
        message: passwordError,
        dialogType: DialogType.error,
        isRegister: false,
      );
      return;
    } else if (nameError != null) {
      Helpers.displayDialog(
        context: context,
        title: 'Invalid Name',
        message: nameError,
        dialogType: DialogType.error,
        isRegister: false,
      );
      return;
    } else if (phoneNumberError != null) {
      Helpers.displayDialog(
        context: context,
        title: 'Invalid Phone Number',
        message: phoneNumberError,
        dialogType: DialogType.error,
        isRegister: false,
      );
      return;
    } else {
      ref
          .read(registerViewModelProvider.notifier)
          .register(
            User(
              name: _controllers['name']!.text,
              email: _controllers['email']!.text,
              phoneNumber: _controllers['phoneNumber']!.text,
              password: _controllers['password']!.text,
              image: ref.watch(pickedImageProvider),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    final double screenHeight = MediaQuery.of(context).size.height;

    final registerStatus = ref.watch(registerViewModelProvider);

    ref.listen(registerViewModelProvider, (previous, next) {
      next.when(
        data: (userCredential) async {
          if (userCredential == null) {
            Helpers.displayDialog(
              context: context,
              title: 'Field To Register',
              message: 'Something went wrong please , try again',
              dialogType: DialogType.error,
              isRegister: false,
            );
            return;
          } else {
            Helpers.displayDialog(
              context: context,
              title: 'Register Success',
              message:
                  'We were sent a email verification to your email, check your email',
              dialogType: DialogType.success,
              isRegister: true,
              email: userCredential.user!.email,
            );
          }
        },
        error: (error, _) {
          Helpers.displayDialog(
            context: context,
            title: 'Field To Register',
            message: error.toString(),
            dialogType: DialogType.error,
            isRegister: false,
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
              SizedBox(height: screenHeight * 0.12),
              RegisterHeader(),
              SizedBox(height: screenHeight * 0.05),
              Container(
                width: screenWidth,
                height: screenHeight * 0.75,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.025),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ImageWidget().animate().moveX(
                          begin: -300,
                          duration: 500.ms,
                        ),
                        SizedBox(width: screenWidth * 0.1),
                        IconButton(
                          onPressed: () {
                            ref.read(pickedImageProvider.notifier).state = null;
                          },
                          icon: Icon(Icons.delete),
                          color: Colors.red,
                        ).animate().moveX(begin: 300, duration: 500.ms),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    CustomTextField(
                      hintText: AppLocalizations.of(context)!.name,
                      controller: _controllers['name'],
                      obscureText: false,
                    ).animate().fadeIn(duration: 1.seconds),
                    SizedBox(height: screenHeight * 0.05),
                    CustomTextField(
                      hintText: AppLocalizations.of(context)!.email,
                      controller: _controllers['email'],
                      obscureText: false,
                    ).animate().fadeIn(duration: 1.seconds),
                    SizedBox(height: screenHeight * 0.05),
                    CustomTextField(
                      hintText: AppLocalizations.of(context)!.phone_number,
                      controller: _controllers['phoneNumber'],
                      obscureText: false,
                    ).animate().fadeIn(duration: 1.seconds),
                    SizedBox(height: screenHeight * 0.05),
                    CustomTextField(
                      hintText: AppLocalizations.of(context)!.password,
                      controller: _controllers['password'],
                      obscureText: true,
                      isHaveSuffixIcon: true,
                    ).animate().fadeIn(duration: 1.seconds),
                    SizedBox(height: screenHeight * 0.03),

                    Button(
                      text: registerStatus!.isLoading
                          ? AppLocalizations.of(context)!.registering
                          : AppLocalizations.of(context)!.register,
                      onPressed: registerStatus!.isLoading ? () {} : _register,
                      state: registerStatus!.isLoading,
                    ).animate().moveX(begin: 500, duration: 500.ms),
                    SizedBox(height: screenHeight * 0.01),
                    AnotherOption(isLogin: true, page: LoginView()),
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
