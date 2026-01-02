import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:personal_task/core/utils/helpers.dart';
import 'package:personal_task/features/home/services/home_services.dart';
import '../data/home_model.dart';

final homeViewModelProvider =
StateNotifierProvider<HomeViewModel, AsyncValue<HomeModel>>((ref) {
  return HomeViewModel();
});

class HomeViewModel extends StateNotifier<AsyncValue<HomeModel>> {

  HomeModel homeModel = HomeModel();

  HomeViewModel() : super(const AsyncValue.loading()) {
    _initialize();
  }

  Future<void> _initialize() async {
    final uid = await Helpers.getUID();
    if (uid == null) {
      print("[HomeViewModel] UID is null → skip listener");
      return;
    }
    await getHomeData();
  }

  Future<void> getHomeData() async {

    state = const AsyncValue.loading();

    try {
      homeModel.weather = await HomeServices.getWeather();
      homeModel.myTasks = await HomeServices.getMyTasks() ?? [];
      homeModel.publicTasks = await HomeServices.getPublicTasks();
      homeModel.pendingTasks =
          await HomeServices.getPendingTasks() ?? [];

      state = AsyncValue.data(homeModel);

      print("[HomeViewModel] Data loaded successfully");
    } catch (e, st) {
      print("[HomeViewModel] getHomeData error: $e");
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteTask(int taskId) async {
    state = AsyncValue.loading();
    try {
      await HomeServices.deleteTask(taskId);
      final weather = await HomeServices.getWeather();
      final myTasks = await HomeServices.getMyTasks() ?? [];
      final publicTasks = await HomeServices.getPublicTasks() ?? [];
      final pendingTasks = await HomeServices.getPendingTasks() ?? [];

      final model = HomeModel(
        weather: weather,
        myTasks: myTasks,
        publicTasks: publicTasks,
        pendingTasks: pendingTasks,
      );

      state = AsyncValue.data(model);
    } catch (e) {
      print(e);
      state = AsyncValue.error(e, StackTrace.empty);
    }
  }
}
