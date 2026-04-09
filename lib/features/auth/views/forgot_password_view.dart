import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task/core/shared/button/button.dart';
import 'package:personal_task/core/shared/text-field/text_field.dart';
import 'package:personal_task/features/auth/view-models/forgot_password_view_model.dart';

import '../../../core/utils/localization/l10n/app_localizations.dart';

class ForgotPasswordView extends ConsumerStatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  ConsumerState<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends ConsumerState<ForgotPasswordView> {
  final TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_outlined)),
        toolbarHeight: height * 0.05,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.23),
              Text(
                'Forgot Password ?',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 55),
              ),
              SizedBox(height: height * 0.1),
              Container(
                width: width,
                height: height * 0.4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    SizedBox(height: height * 0.1),
                    CustomTextField(
                      hintText: AppLocalizations.of(context)!.email,
                      controller: _emailController,
                      obscureText: false,
                      suffixIcon: Icons.mail,
                    ),
                    SizedBox(height: height * 0.05),
                    Button(
                      text: 'Reset Password',
                      onPressed: () {
                        ref
                            .read(forgotPasswordViewModel.notifier)
                            .sendResetPasswordEmail(
                              _emailController.text,
                              context,
                            );
                      },
                      state: ref.watch(forgotPasswordViewModel).isLoading,
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
