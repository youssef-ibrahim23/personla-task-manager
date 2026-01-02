import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:personal_task/features/auth/services/auth_services.dart';

class MoreViewModel extends StateNotifier<AsyncValue<void>> {
  MoreViewModel() : super(const AsyncValue.data(null));

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      final success = await AuthServices.signOut();
      if (success) {
        state = const AsyncValue.data(null);
      } else {
        state = AsyncValue.error('Failed to logout', StackTrace.current);
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final moreViewModelProvider =
    StateNotifierProvider<MoreViewModel, AsyncValue<void>>((ref) {
  return MoreViewModel();
});

