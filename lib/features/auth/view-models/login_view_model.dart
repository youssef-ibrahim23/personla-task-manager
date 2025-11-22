// view_models/login_view_model.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
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

  Future<void> signIn(LoginData data) async {
    state = const AsyncValue.loading();

    if (data.email.isEmpty) {
      state = AsyncValue.error('Email Is Required', StackTrace.empty);
      return;
    }

    if (data.password.isEmpty) {
      state = AsyncValue.error('Password Is Required', StackTrace.empty);
      return;
    }

    final emailError = Validators.validateEmail(data.email);
    if (emailError != null) {
      state = AsyncValue.error('Please Enter Valid Email', StackTrace.empty);
      return;
    }

    if (!await Helpers.isConnectedToInternet()) {
      state = AsyncValue.error(
        'Connection Error, No Internet',
        StackTrace.empty,
      );
      return;
    }

    try {
      final userCredential = await AuthServices.signIn(data);

      final user = userCredential?.user;
      if (user == null) {
        state = AsyncValue.error("This user not found", StackTrace.current);
        return;
      }

      if (!user.emailVerified) {
        state = AsyncValue.error("Email is not verified", StackTrace.current);
        return;
      }


      state = AsyncValue.data(userCredential);

    } catch (e, st) {
      final errorStr = e.toString();
      String msg;
      if (errorStr.contains("network-request-failed")) {
        msg = "No internet connection, please try again.";
      } else if (errorStr.contains("user-not-found")) {
        msg = "No account found with this email.";
      } else if (errorStr.contains("wrong-password")) {
        msg = "Incorrect password, please try again.";
      } else {
        msg = "Login failed, please try again.";
      }

      state = AsyncValue.error(msg, st);
    }
  }

}
