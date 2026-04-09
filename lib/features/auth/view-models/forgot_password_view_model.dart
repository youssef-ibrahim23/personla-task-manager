import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:personal_task/core/utils/helpers.dart';

final forgotPasswordViewModel = StateNotifierProvider<ForgotPasswordViewModel , AsyncValue>((ref) => ForgotPasswordViewModel());

class ForgotPasswordViewModel extends StateNotifier<AsyncValue> {
  ForgotPasswordViewModel() : super(const AsyncValue.data(null));

  Future<void> sendResetPasswordEmail(
    String email,
    BuildContext context,
  ) async {
    state = AsyncValue.loading();
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Helpers.displayDialog(
        context: context,
        title: 'Check Your Email',
        message: 'We was sent to your email a reset password link',
        dialogType: DialogType.success,
        openMailOption: true,
      );
      state = AsyncValue.data(null);
    } catch (e) {
      Helpers.displayDialog(
        context: context,
        title: 'Field',
        message: e.toString(),
        dialogType: DialogType.success,
        openMailOption: true,
      );
    }
  }
}
