// view_models/login_view_model.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:personal_task/core/utils/localization/l10n/app_localizations.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/utils/validators.dart';
import '../data/login_data.dart';
import '../services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';

final loginViewModelProvider =
    StateNotifierProvider<LoginViewModel, AsyncValue<UserCredential?>>(
      (ref) => LoginViewModel(),
    );

class LoginViewModel extends StateNotifier<AsyncValue<UserCredential?>> {
  LoginViewModel() : super(const AsyncValue.data(null));

  Future<void> signIn(LoginData data , BuildContext context) async {
    state = const AsyncValue.loading();

    if (data.email.isEmpty) {
      state = AsyncValue.error(AppLocalizations.of(context)!.email_required, StackTrace.empty);
      return;
    }

    if (data.password.isEmpty) {
      state = AsyncValue.error(AppLocalizations.of(context)!.password_required, StackTrace.empty);
      return;
    }

    final emailError = Validators.validateEmail(data.email);
    if (emailError != null) {
      state = AsyncValue.error(AppLocalizations.of(context)!.please_enter_valid_email, StackTrace.empty);
      return;
    }

    if (!await Helpers.isConnectedToInternet()) {
      state = AsyncValue.error(
        AppLocalizations.of(context)!.connection_Error_no_internet,
        StackTrace.empty,
      );
      return;
    }

    try {
      final userCredential = await AuthServices.signIn(data);

      final user = userCredential?.user;

      if (user == null) {
        state = AsyncValue.error(AppLocalizations.of(context)!.this_user_not_found, StackTrace.current);
        return;
      }

      if (!user.emailVerified) {
        state = AsyncValue.error(AppLocalizations.of(context)!.email_is_not_verified, StackTrace.current);
        return;
      }


      state = AsyncValue.data(userCredential);

    } on FirebaseAuthException catch (e, st) {
      final errorStr = e.toString();
      String msg;
      if (errorStr.contains("network-request-failed")) {
        msg = AppLocalizations.of(context)!.connection_Error_no_internet;
      } else if (errorStr.contains("user-not-found")) {
        msg = AppLocalizations.of(context)!.this_user_not_found;
      } else if (errorStr.contains("wrong-password")) {
        msg = "Incorrect password, please try again.";
      } else {
        msg = AppLocalizations.of(context)!.login_failed;
      }

      state = AsyncValue.error(msg, st);
    } catch(e,st){
      print("$e $st");
    }
  }

}
