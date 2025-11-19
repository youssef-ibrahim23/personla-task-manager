import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/utils/DB/models/user.dart';
import '../services/auth_services.dart';

final pickedImageProvider = StateProvider<XFile?>((ref)=> null);

final registerViewModelProvider =
StateNotifierProvider<RegisterViewModel, AsyncValue<UserCredential?>>(
      (ref) => RegisterViewModel(),
);

class RegisterViewModel extends StateNotifier<AsyncValue<UserCredential?>> {
  RegisterViewModel() : super(const AsyncValue.data(null));

  Future<void> register(User user) async {
    state = const AsyncValue.loading();
    try {
      final userCredential = await AuthServices.register(user);
      state = AsyncValue.data(userCredential);
    } catch (e, st) {
      if(e.toString() == 'network-request-failed'){
        state = AsyncValue.error('Network Error', st);
      } else if (e.toString() == 'email-already-used'){
      state = AsyncValue.error('Email Already Used', st);
    }
    else{
    state = AsyncValue.error('Something went wrong please , try again', st);
    }
    }
  }

}
