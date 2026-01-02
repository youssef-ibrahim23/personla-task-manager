import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:personal_task/core/utils/helpers.dart';
import 'package:personal_task/core/utils/localization/l10n/app_localizations.dart';
import 'package:personal_task/core/utils/validators.dart';
import 'package:personal_task/features/tasks/services/tasks_services.dart';

import '../../../core/utils/DB/models/task.dart';

final taskViewModelProvider =
StateNotifierProvider<TaskViewModel, AsyncValue<void>>((ref) {
  return TaskViewModel();
});
class TaskViewModel extends StateNotifier<AsyncValue<void>> {
  TaskViewModel() : super(const AsyncValue.data(null));

  Future<void> addTask(Task task , BuildContext context) async {
    state = const AsyncValue.loading();
    String? titleError = Validators.validateNotNull(task.title , AppLocalizations.of(context)!.enter_task_title);
    String? descriptionError = Validators.validateNotNull(task.description , AppLocalizations.of(context)!.enter_task_description);
    String? categoryError = Validators.validateNotNull(task.category , AppLocalizations.of(context)!.select_task_category);
    String? priorityError = Validators.validateNotNull(task.priority , AppLocalizations.of(context)!.select_task_priority);
    String? startDateError = Validators.validateNotNull(task.startDate.toString() , AppLocalizations.of(context)!.select_start_date_time);
    String? endDateError = Validators.validateNotNull(task.endDate.toString() , AppLocalizations.of(context)!.select_end_date_time);
    String? dateError = Validators.validateStartDateIsBeforeEndDate(task.startDate, task.endDate);

    if(titleError != null){
      state = AsyncValue.error(titleError , StackTrace.current);
      return;
    }

    if(descriptionError != null){
      state = AsyncValue.error(descriptionError , StackTrace.current);
      return;
    }

    if(categoryError != null){
      state = AsyncValue.error(categoryError ,StackTrace.current);
      return;
    }

    if(priorityError != null){
      state = AsyncValue.error(priorityError , StackTrace.current);
      return;
    }

    if(startDateError != null){
      state = AsyncValue.error(startDateError , StackTrace.current);
      return;
    }

    if(endDateError != null){
      state = AsyncValue.error(endDateError , StackTrace.current);
      return;
    }

    if(dateError != null){
      state = AsyncValue.error(dateError , StackTrace.current);
      return;
    }

    try {
      final uid = await Helpers.getUID();
      task.ownerId = uid!;
      await TasksServices.addTask(task);
      state = const AsyncValue.data(null);
      Navigator.pop(context, true);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateTask(Task task , BuildContext context) async{
    state = const AsyncValue.loading();
    try {
      await TasksServices.updateTask(task);
      state = const AsyncValue.data(null);
          } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
  }

