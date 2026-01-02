import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:personal_task/core/utils/localization/l10n/app_localizations.dart';

import '../../../core/utils/DB/models/user.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/utils/validators.dart';
import '../services/auth_services.dart';

final registerViewModelProvider =
    StateNotifierProvider<RegisterViewModel, AsyncValue<UserCredential?>>(
      (ref) => RegisterViewModel(),
    );

class RegisterViewModel extends StateNotifier<AsyncValue<UserCredential?>> {
  RegisterViewModel() : super(const AsyncValue.data(null));

  Future<void> register(User user , BuildContext context) async {
    state = const AsyncValue.loading();
    final nameError = Validators.validateName(user.name);
    final emailError = Validators.validateEmail(user.email);
    final phoneError = Validators.validatePhoneNumber(user.phoneNumber);
    final passError = Validators.validatePassword(user.password ?? '');

    if (nameError != null) {
      state = AsyncValue.error(AppLocalizations.of(context)!.name_required, StackTrace.current);
      return;
    }
    if (emailError != null) {
      state = AsyncValue.error(AppLocalizations.of(context)!.email_required, StackTrace.current);
      return;
    }
    if (phoneError != null) {
      state = AsyncValue.error(AppLocalizations.of(context)!.phone_number_required, StackTrace.current);
      return;
    }
    if (passError != null) {
      state = AsyncValue.error(AppLocalizations.of(context)!.week_password, StackTrace.current);
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
      final credential = await AuthServices.register(user);
      state = AsyncValue.data(credential);
    } catch (e, st) {
      final error = e.toString();
      if (error.contains('network-request-failed')) {
        state = AsyncValue.error('Network Error', st);
      } else if (error.contains('email-already-in-use')) {
        state = AsyncValue.error('Email Already Used', st);
      } else {
        state = AsyncValue.error('Something went wrong, please try again', st);
      }
    }
  }
}
