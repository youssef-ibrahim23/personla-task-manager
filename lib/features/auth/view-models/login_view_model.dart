// view_models/login_view_model.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/utils/helpers.dart';
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

    try {
      final userCredential = await AuthServices.signIn(data);

      if (userCredential!.user != null && userCredential!.user!.emailVerified == true) {
        Helpers.toggleLoginState();
        Helpers.saveUID(userCredential!.user!.uid);
        state = AsyncValue.data(userCredential);
      } else {
        state = AsyncValue.error(
          "Email is not verified",
          StackTrace.current,
        );
      }

    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
