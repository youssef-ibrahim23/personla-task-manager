import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/shared/image/image_providers.dart';
import '../../../core/utils/DB/models/user.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/utils/validators.dart';
import '../services/profile_services.dart';

final profileViewModelProvider =
    StateNotifierProvider<ProfileViewModel, AsyncValue<User?>>(
      (ref) => ProfileViewModel(),
    );

class ProfileViewModel extends StateNotifier<AsyncValue<User?>> {
  ProfileViewModel() : super(const AsyncValue.loading());

  Future<void> getProfileData() async {
    state = const AsyncValue.loading();
    try {
      final data = await ProfileServices.getProfileData();
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> sendRestPasswordEmail(String email) async {
    state = const AsyncValue.loading();
    try {
      final bool result = await ProfileServices.sendRestPasswordEmail(email);
      state = AsyncValue.data(null);
      return result;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.empty);
      return false;
    }
  }

  Future<void> updateProfile({required User user , required WidgetRef ref}) async {
    state = const AsyncValue.loading();
    final image = ref.read(profilePickedImageProvider.notifier).state == null
        ? ref.read(profileImageProvider.notifier).state
        : await Helpers.imageToBase64(
      File(ref.read(profilePickedImageProvider.notifier).state!.path),
    );
    final nameError = Validators.validateName(user.name);
    final emailError = Validators.validateEmail(user.email);
    final phoneError = Validators.validatePhoneNumber(user.phoneNumber);
    if (nameError != null) {
      state = AsyncValue.error(nameError, StackTrace.current);
      return;
    }
    if (emailError != null) {
      state = AsyncValue.error(emailError, StackTrace.current);
      return;
    }
    if (phoneError != null) {
      state = AsyncValue.error(phoneError, StackTrace.current);
      return;
    }

    try {
      user.image = image;
      await ProfileServices.updateProfile(user: user);
      state = AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.empty);
    }
  }
}
