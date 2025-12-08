import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:personal_task/core/utils/helpers.dart';
import 'package:personal_task/features/tasks/services/tasks_services.dart';

import '../../../core/utils/DB/models/task.dart';

final taskViewModelProvider =
StateNotifierProvider<TaskViewModel, AsyncValue<void>>((ref) {
  return TaskViewModel();
});
class TaskViewModel extends StateNotifier<AsyncValue<void>> {
  TaskViewModel() : super(const AsyncValue.data(null));

  Future<void> addTask(Task task) async {
    state = const AsyncValue.loading();
    try {
      final uid = await Helpers.getUID();
      task.ownerId = uid!;
      await TasksServices.addTask(task);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateTask(Task task) async{
    state = const AsyncValue.loading();
    try {
      await TasksServices.updateTask(task);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  }

