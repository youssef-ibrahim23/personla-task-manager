import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:personal_task/core/utils/helpers.dart';
import 'package:personal_task/features/home/services/home_services.dart';
import 'package:personal_task/features/tasks/services/tasks_services.dart';
import '../data/home_model.dart';

final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, AsyncValue<HomeModel>>((ref) {
      return HomeViewModel();
    });

class HomeViewModel extends StateNotifier<AsyncValue<HomeModel>> {
  StreamSubscription? _taskListener;
  bool isLoaded = false;

  HomeViewModel() : super(const AsyncValue.loading()) {
    _initialize();
  }

  Future<void> _initialize() async {
    final uid = await Helpers.getUID();
    if (uid == null) {
      print("[HomeViewModel] UID is null → skip listener");
      return;
    }

    print("[HomeViewModel] Listening to Firestore for uid → $uid");

    await _taskListener?.cancel();

    _taskListener = FirebaseFirestore.instance
        .collection('tasks')
        .where('uid', isEqualTo: uid)
        .snapshots()
        .listen((snapshot) {
          print("[HomeViewModel] Firestore change detected → refreshing...");
          getHomeData(true);
        });

    await getHomeData(true);
  }

  Future<void> getHomeData([bool isRefresh = false]) async {
    if (isLoaded && !isRefresh) return;

    state = const AsyncValue.loading();

    try {
      final weather = await HomeServices.getWeather();
      final myTasks = await HomeServices.getMyTasks() ?? [];
      final publicTasks = await HomeServices.getPublicTasks() ?? [];

      final model = HomeModel(
        weather: weather,
        myTasks: myTasks,
        publicTasks: publicTasks,
      );

      state = AsyncValue.data(model);
      isLoaded = true;

      print("[HomeViewModel] Data loaded successfully");
    } catch (e, st) {
      print("[HomeViewModel] getHomeData error: $e");
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteTask(int taskId) async{
    state = AsyncValue.loading();
    try{
      int result = await HomeServices.deleteTask(taskId);
      final weather = await HomeServices.getWeather();
      final myTasks = await HomeServices.getMyTasks() ?? [];
      final publicTasks = await HomeServices.getPublicTasks() ?? [];

      final model = HomeModel(
        weather: weather,
        myTasks: myTasks,
        publicTasks: publicTasks,
      );

      state = AsyncValue.data(model);
    }catch(e){
      print(e);
      state = AsyncValue.error(e, StackTrace.empty);
    }
  }

  @override
  void dispose() {
    _taskListener?.cancel();
    super.dispose();
  }
}
