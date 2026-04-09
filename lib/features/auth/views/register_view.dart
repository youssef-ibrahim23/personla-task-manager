import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task/core/shared/image/image_providers.dart';
import 'package:personal_task/core/utils/helpers.dart';
import 'package:personal_task/core/utils/DB/models/user.dart';
import 'package:personal_task/features/auth/view-models/register_view_model.dart';
import 'package:personal_task/features/auth/views/login_view.dart';
import 'package:personal_task/features/auth/views/widgets/another_option.dart';
import 'package:personal_task/core/shared/button/button.dart';
import 'package:personal_task/core/shared/image/image_widget.dart';
import 'package:personal_task/core/shared/text-field/text_field.dart';

import '../../../core/utils/localization/l10n/app_localizations.dart';
import '../../../core/utils/localization/locale_provider.dart';

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
    'confirmPassword': TextEditingController(),
  };

  bool get _passwordsMatch {
    return _controllers['password']!.text ==
        _controllers['confirmPassword']!.text;
  }

  @override
  void dispose() {
    _controllers['name']!.dispose();
    _controllers['email']!.dispose();
    _controllers['phoneNumber']!.dispose();
    _controllers['password']!.dispose();
    _controllers['confirmPassword']!.dispose();
    super.dispose();
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
              title: AppLocalizations.of(context)!.login_failed,
              message: AppLocalizations.of(context)!.something_went_wrong,
              dialogType: DialogType.error,
              openMailOption: false,
            );
            return;
          } else {
            Helpers.displayDialog(
              context: context,
              title: AppLocalizations.of(context)!.register_success,
              message:
                  AppLocalizations.of(context)!.email_verification_sent,
              dialogType: DialogType.success,
              openMailOption: true,
              email: userCredential.user!.email,
            );
          }
        },
        error: (error, _) {
          Helpers.displayDialog(
            context: context,
            title: AppLocalizations.of(context)!.register_failed,
            message: error.toString(),
            dialogType: DialogType.error,
            openMailOption: false,
          );
          return;
        },
        loading: () {},
      );
    });

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.09),
              Text(
                AppLocalizations.of(context)!.create_your_account,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 30,
                  fontWeight: FontWeight.w300,
                ),
              ).animate().shimmer(
                color: Theme.of(context).primaryColor,
                duration: 1.seconds,
              ),
              SizedBox(height: screenHeight * 0.03),
              Container(
                width: screenWidth,
                height: screenHeight * 0.87,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: screenHeight * 0.03,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ImageWidget(
                          pickedImageProvider: registerPickedImageProvider,
                          cloudImage: null,
                          state: false,
                        ).animate().moveX(begin: ref.watch(localeProvider).languageCode == 'ar' ? 300 : -300, duration: 500.ms),
                        SizedBox(width: screenWidth * 0.1),
                        IconButton(
                          onPressed: () {
                            ref
                                    .read(
                                      registerPickedImageProvider.notifier,
                                    )
                                    .state =
                                null;
                          },
                          icon: Icon(Icons.delete),
                          color: Colors.red,
                        ).animate().moveX(begin: ref.watch(localeProvider).languageCode == 'ar' ? -300 : 300, duration: 500.ms),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.04),
                    CustomTextField(
                      hintText: AppLocalizations.of(context)!.name,
                      controller: _controllers['name'],
                      obscureText: false,
                      suffixIcon: Icons.short_text,
                    ).animate().fadeIn(duration: 1.seconds),
                    SizedBox(height: screenHeight * 0.04),
                    CustomTextField(
                      hintText: AppLocalizations.of(context)!.email,
                      controller: _controllers['email'],
                      obscureText: false,
                      suffixIcon: Icons.mail,
                    ).animate().fadeIn(duration: 1.seconds),
                    SizedBox(height: screenHeight * 0.04),
                    CustomTextField(
                      hintText: AppLocalizations.of(context)!.phone_number,
                      controller: _controllers['phoneNumber'],
                      obscureText: false,
                      suffixIcon: Icons.phone,
                    ).animate().fadeIn(duration: 1.seconds),
                    SizedBox(height: screenHeight * 0.04),
                    CustomTextField(
                      hintText: AppLocalizations.of(context)!.password,
                      controller: _controllers['password'],
                      obscureText: true,
                      isPassword: true,
                      onChanged: (_) {
                        setState(() {});
                      },
                    ).animate().fadeIn(duration: 1.seconds),
                    SizedBox(height: screenHeight * 0.04),
                    CustomTextField(
                      hintText: AppLocalizations.of(context,)!.confirm_password,
                      controller: _controllers['confirmPassword'],
                      obscureText: true,
                      isPassword: true,
                      onChanged: (_) {
                        setState(() {});
                      },
                    ).animate().fadeIn(duration: 1.seconds),
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: screenWidth * 0.08),
                        Icon(
                          _passwordsMatch ? Icons.check_circle : Icons.cancel,
                          color: _passwordsMatch ? Colors.green : Colors.red,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          _passwordsMatch
                              ? AppLocalizations.of(context)!.passwords_match
                              : AppLocalizations.of(context)!.password_not_match,
                          style: TextStyle(
                            color: _passwordsMatch
                                ? Colors.green
                                : Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Button(
                      text: registerStatus.isLoading
                          ? AppLocalizations.of(context)!.registering
                          : AppLocalizations.of(context)!.register,
                      onPressed: () async {
                        if (!_passwordsMatch) {
                          Helpers.displayDialog(
                            context: context,
                            title: AppLocalizations.of(context)!.register_failed,
                            message: AppLocalizations.of(context)!.password_not_match,
                            dialogType: DialogType.error,
                            openMailOption: false,
                          );
                        } else {
                          await ref
                              .read(registerViewModelProvider.notifier)
                              .register(
                                User(
                                  name: _controllers['name']!.text,
                                  email: _controllers['email']!.text,
                                  phoneNumber:
                                      _controllers['phoneNumber']!.text,
                                  password: _controllers['password']!.text,
                                  image: ref
                                      .watch(registerPickedImageProvider)
                                      ?.path,
                                ),
                            context
                              );
                        }
                      },
                      state: registerStatus.isLoading,
                    ).animate().fadeIn(duration: 700.ms),
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
