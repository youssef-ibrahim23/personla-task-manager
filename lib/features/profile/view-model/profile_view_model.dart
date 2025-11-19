import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../../core/utils/DB/models/user.dart';
import '../services/profile_services.dart';

final profileViewModelProvider =
StateNotifierProvider<ProfileViewModel, AsyncValue<User?>>(
      (ref) => ProfileViewModel(),
);

class ProfileViewModel extends StateNotifier<AsyncValue<User?>> {
  ProfileViewModel() : super(const AsyncValue.data(null));

  Future<void> getProfileData() async {
    state = const AsyncValue.loading();
    try {
      final data = await ProfileServices.getProfileData();
      print(data);
      state = AsyncValue.data(data);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.empty);
    }
  }
}
