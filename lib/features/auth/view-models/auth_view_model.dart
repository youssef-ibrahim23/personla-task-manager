// view_models/login_view_model.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart' show StateNotifierProvider, StateNotifier;
import '../data/login_data.dart';
import '../services/auth_services.dart';
import '../../../core/utils/DB/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;

final authViewModelProvider = StateNotifierProvider<authViewModel, AsyncValue<UserCredential?>>(
      (ref) => authViewModel(),
);

class authViewModel extends StateNotifier<AsyncValue<UserCredential?>> {
  authViewModel() : super(const AsyncValue.data(null));

  final AuthServices _authServices = AuthServices();

  Future<void> signIn(LoginData data) async {
    state = const AsyncValue.loading();
    try {
      final userCredential = await _authServices.signIn(data);
      state = AsyncValue.data(userCredential);
    } catch (e) {
      state = AsyncValue.error(e , StackTrace.current);
    }
  }

  Future<void> register(User user) async{
    state = const AsyncValue.loading();
    try{
      final UserCredential? userCredential = await _authServices.register(user);
      state = AsyncValue.data(userCredential);
    }catch(e){
      print(e);
      state = AsyncValue.error(e , StackTrace.current);
    }
  }
}
