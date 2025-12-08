import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_task/core/utils/DB/db_services.dart';
import 'package:personal_task/core/utils/DB/firestore_services.dart';
import 'package:personal_task/core/utils/helpers.dart';
import 'package:personal_task/core/utils/notifications/FCM_services.dart';
import 'package:personal_task/core/utils/notifications/local_notification_services.dart';
import 'package:personal_task/features/tasks/views/task_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/DB/models/task.dart';

class TasksServices {
  static Future<void> addTask(Task task) async {
    try {
      int taskId = await DBServices.insertTask(task: task);

      if (task.attachments != null && task.attachments!.isNotEmpty) {
        for (int i = 0; i < task.attachments!.length; i++) {
          task.attachments![i].taskId = taskId;
          task.attachments![i].id = await DBServices.insertAttachment(
            attachment: task.attachments![i],
          );
        }
      }

      if (await Helpers.isConnectedToInternet()) {
        print(
          "Task added locally with ID: $taskId. Now syncing with Firestore...",
        );
        task.id = taskId;
        task.uploadStatus = true;
        await Future.wait([
          FireStoreServices().uploadTask(task: task),
          DBServices.toggleTaskIsUploaded(taskId: taskId, isUploaded: 1),
        ]);

        if (task.isShared == true) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          final accessToken = preferences.getString('fcm_access_token') ?? '';
          final projectId = preferences.getString('project_id') ?? '';
          FCMServices.sendTopicNotification(
            topic: 'public-tasks',
            title: 'New Public Task ${task.title}',
            body: task.description,
            accessToken: accessToken,
              projectId: projectId
          );
        }
      } else {
        print(
          "Task added locally with ID: $taskId. No internet connection, skipping Firestore sync.",
        );
      }

      // if (task.reminder != null) {
      //   LocalNotificationServices().scheduleNotification(
      //     id: task.id ?? 1,
      //     title: task.title,
      //     body: task.description,
      //     scheduledDate: task.reminder!,
      //   );
      // }

      // LocalNotificationServices().showBasicNotification(
      //   id: 1,
      //   title: 'New Task Added Success: ${task.title}',
      //   body: task.description,
      // );
    } catch (e) {
      print("Error adding task: $e");
    }
  }

  static Future<int> updateTask(Task task) async {
    try {
      bool updateNotification = false;
      bool sendPublicNotification = false;
      if(task.reminder != selectedReminderDate){
        task.reminder = selectedReminderDate;
        updateNotification = true;
      }

      if(task.isShared != isPublic){
        task.isShared = isPublic;
        sendPublicNotification = isPublic ? isPublic : false;
      }
      task.isUpdated = true;
      int result = await DBServices.updateTask(task: task);

      if (task.attachments != null && task.attachments!.isNotEmpty) {
        for (int i = 0; i < task.attachments!.length; i++) {
          task.attachments![i].taskId = task.id;
          task.attachments![i].id = await DBServices.insertAttachment(
            attachment: task.attachments![i],
          );
        }
      }
      if (await Helpers.isConnectedToInternet()) {
        print(
          "Task updated locally with ID: ${task.id}. Now syncing with Firestore...",
        );
        FireStoreServices().updateTask(task: task);

        if (sendPublicNotification) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          final accessToken = preferences.getString('fcm_access_token') ?? '';
          final projectId = preferences.getString('project_id') ?? '';
          FCMServices.sendTopicNotification(
            topic: 'public-tasks',
            title: 'New Public Task ${task.title}',
            body: task.description,
              accessToken: accessToken,
              projectId: projectId,
          );
        }
      } else {
        print(
          "Task updated locally with ID: ${task.id}. No internet connection, skipping Firestore sync.",
        );
      }
      if (updateNotification) {
        LocalNotificationServices().updateScheduledNotification(
          id: task.id!,
          title: task.title,
          body: task.description,
          newScheduledDate: task.reminder!,
        );
      }

      return result;
    } catch (e) {
      print("Error updating task: $e");
      return 0;
    }
  }

  static Future<DateTime?> pickEndDateTime(
    BuildContext context, {
    DateTime? initialDate,
  }) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return null;

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate ?? DateTime.now()),
    );

    if (pickedTime == null) return null;

    return DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
  }

  static String? formatEndDate(DateTime? dateTime) {
    if (dateTime == null) return null;
    return DateFormat('yyyy-MM-dd – HH:mm').format(dateTime);
  }
}
