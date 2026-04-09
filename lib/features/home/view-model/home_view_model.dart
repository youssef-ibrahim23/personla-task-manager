// dart
// File: lib/features/home/view-model/home_view_model.dart

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:personal_task/core/utils/helpers.dart';
import 'package:personal_task/features/home/services/home_services.dart';
import '../../../core/utils/DB/models/task.dart';
import '../data/home_model.dart';

final homeViewModelProvider =
StateNotifierProvider<HomeViewModel, AsyncValue<HomeModel>>((ref) {
  return HomeViewModel(ref);
});

class HomeViewModel extends StateNotifier<AsyncValue<HomeModel>> {
  final Ref ref;
  HomeModel homeModel = HomeModel();
  Timer? _retryTimer;
  int _retryCount = 0;
  StreamSubscription<User?>? _authSub;

  HomeViewModel(this.ref) : super(const AsyncValue.loading()) {
    _initialize();
    // Listen to auth state so we react if UID arrives later.
    _authSub = FirebaseAuth.instance.idTokenChanges().listen((user) {
      final uid = user?.uid;
      if (uid != null) {
        print('[HomeViewModel] auth listener: uid available -> $uid');
        // cancel retry timer if any and fetch data
        _retryTimer?.cancel();
        _retryTimer = null;
        _retryCount = 0;
        getHomeData();
      }
    });
  }

  Future<void> _initialize() async {
    final uid = await Helpers.getUID();
    if (uid == null) {
      print("[HomeViewModel] UID is null → scheduling retry");
      _scheduleUIDRetry();
      return;
    }
    _retryTimer?.cancel();
    _retryCount = 0;
    await getHomeData();
  }

  void _scheduleUIDRetry() {
    if (_retryTimer != null || _retryCount >= 5) return;
    _retryTimer = Timer.periodic(const Duration(seconds: 2), (t) async {
      _retryCount++;
      final uid = await Helpers.getUID();
      if (uid != null) {
        print("[HomeViewModel] UID obtained on retry: $uid");
        t.cancel();
        _retryTimer = null;
        _retryCount = 0;
        await getHomeData();
      } else if (_retryCount >= 5) {
        print("[HomeViewModel] UID still null after retries");
        t.cancel();
        _retryTimer = null;
      }
    });
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    _authSub?.cancel();
    super.dispose();
  }

  Future<void> getHomeData() async {
    state = const AsyncValue.loading();

    try {
      homeModel.weather = await HomeServices.getWeather();
      homeModel.myTasks = await HomeServices.getMyTasks() ?? [];
      homeModel.publicTasks = await HomeServices.getPublicTasks() ?? [];
      homeModel.pendingTasks = await HomeServices.getPendingTasks() ?? [];

      state = AsyncValue.data(homeModel);

      print("[HomeViewModel] Data loaded successfully");
    } catch (e, st) {
      print("[HomeViewModel] getHomeData error: $e");
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteTask(Task task) async {
    state = const AsyncValue.loading();
    try {
      await HomeServices.deleteTask(task.id!);

      homeModel.myTasks.remove(task);

      if (task.isShared) {
        homeModel.publicTasks?.remove(task);
      }

      if (!task.uploadStatus) {
        homeModel.pendingTasks.remove(task);
      }

      state = AsyncValue.data(homeModel);
    } catch (e) {
      print(e);
      state = AsyncValue.error(e, StackTrace.empty);
    }
  }
}
