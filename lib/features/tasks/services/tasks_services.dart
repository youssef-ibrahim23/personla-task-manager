import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_task/core/utils/DB/db_services.dart';
import 'package:personal_task/core/utils/DB/firestore_services.dart';
import 'package:personal_task/core/utils/helpers.dart';
import 'package:personal_task/core/utils/localization/l10n/app_localizations.dart';
import 'package:personal_task/core/utils/notifications/FCM_services.dart';
import 'package:personal_task/core/utils/notifications/local_notifcation_services.dart';

import '../../../core/utils/DB/models/task.dart';
import '../views/task_view.dart';

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

      task.id = taskId;

      if (task.reminder != null) {
        LocalNotificationService().scheduleNotification(
          id: task.id ?? 199,
          title: task.title,
          body: task.description,
          scheduledDate: task.reminder!,
        );
      }

      LocalNotificationService().scheduleNotification(
        id: task.id! + 1,
        title: 'Task ${task.title} Ended',
        body: 'the task end date arrived',
        scheduledDate: task.endDate,
      );

      if (await Helpers.isConnectedToInternet()) {
        print(
          "Task added locally with ID: $taskId. Now syncing with Firestore...",
        );
        task.uploadStatus = true;
        await Future.wait([
          FireStoreServices().uploadTask(task: task),
          DBServices.toggleTaskIsUploaded(taskId: taskId, isUploaded: 1),
        ]);

        if (task.isShared == true) {
          FCMServices.sendTopicNotification(
            topic: 'public-tasks',
            title: 'New Public Task ${task.title}',
            body: task.description,
          );
        }
      } else {
        print(
          "Task added locally with ID: $taskId. No internet connection, skipping Firestore sync.",
        );
      }
    } catch (e) {
      print("Error adding task: $e");
    }
  }

  static Future<int> updateTask(Task task) async {
    try {
      if (selectedReminderDate != task.reminder) {
        task.reminder = selectedReminderDate;
        LocalNotificationService().cancelNotification(task.id!);
        LocalNotificationService().scheduleNotification(
          id: task.id ?? 199,
          title: task.title,
          body: task.description,
          scheduledDate: task.reminder!,
        );
      }

      task.isUpdated = true;
      int result = await DBServices.updateTask(task: task);

      final existingAttachments = await DBServices.getAttachmentsByTask(
        task.id!,
      );
      final existingAttachmentIds = existingAttachments
          .map((att) => att.id)
          .where((id) => id != null)
          .cast<int>()
          .toSet();

      final newAttachmentIds =
          task.attachments != null && task.attachments!.isNotEmpty
          ? task.attachments!
                .map((att) => att.id)
                .where((id) => id != null)
                .cast<int>()
                .toSet()
          : <int>{};

      final attachmentsToDelete = existingAttachmentIds.difference(
        newAttachmentIds,
      );
      for (int attachmentId in attachmentsToDelete) {
        try {
          await DBServices.deleteAttachment(attachmentId);
          print('[TasksServices] Deleted attachment from DB: $attachmentId');
        } catch (e) {
          print('[TasksServices] Error deleting attachment $attachmentId: $e');
        }
      }

      if (task.attachments != null && task.attachments!.isNotEmpty) {
        for (int i = 0; i < task.attachments!.length; i++) {
          task.attachments![i].taskId = task.id;
          if (task.attachments![i].id == null) {
            task.attachments![i].id = await DBServices.insertAttachment(
              attachment: task.attachments![i],
            );
            print(
              '[TasksServices] Inserted new attachment: ${task.attachments![i].id}',
            );
          } else {
            await DBServices.insertAttachment(attachment: task.attachments![i]);
            print(
              '[TasksServices] Updated attachment: ${task.attachments![i].id}',
            );
          }
        }
      } else {
        for (int attachmentId in existingAttachmentIds) {
          try {
            await DBServices.deleteAttachment(attachmentId);
            print(
              '[TasksServices] Deleted all attachments for task ${task.id}',
            );
          } catch (e) {
            print(
              '[TasksServices] Error deleting attachment $attachmentId: $e',
            );
          }
        }
      }

      if (await Helpers.isConnectedToInternet()) {
        print(
          "Task updated locally with ID: ${task.id}. Now syncing with Firestore...",
        );
        FireStoreServices().updateTask(task: task);

        if (task.isShared) {
          FCMServices.sendTopicNotification(
            topic: 'public-tasks',
            title: 'Public Task Updated ${task.title}',
            body: task.description,
          );
        }
      } else {
        print(
          "Task updated locally with ID: ${task.id}. No internet connection, skipping Firestore sync.",
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
    final theme = Theme.of(context);

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.primaryColor,
              onPrimary: theme.colorScheme.surface,
              surface: theme.colorScheme.primaryContainer,
              onSurface: theme.colorScheme.surface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return null;

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate ?? DateTime.now()),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.primaryColor,
              onPrimary: theme.colorScheme.surface,
              surface: theme.colorScheme.primaryContainer,
              onSurface: theme.colorScheme.surface,
            ),
          ),
          child: child!,
        );
      },
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

  static List<String> getReminderOptions(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return [
      localizations.before_2_minutes,
      localizations.before_5_minutes,
      localizations.before_10_minutes,
      localizations.before_20_minutes,
    ];
  }

  static List<String> getCategoryOptions(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return [localizations.work, localizations.study, localizations.personal];
  }

  static List<String> getPriorityOptions(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return [localizations.high, localizations.medium, localizations.low];
  }

  static String localizedToDbCategory(String localized, BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    if (localized == localizations.work) return 'Work';
    if (localized == localizations.study) return 'Study';
    if (localized == localizations.personal) return 'Personal';
    return localized;
  }

  static String localizedToDbPriority(String localized, BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    if (localized == localizations.high) return 'High';
    if (localized == localizations.medium) return 'Medium';
    if (localized == localizations.low) return 'Low';
    return localized;
  }

  static String dbToLocalizedCategory(String dbValue, BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    if (dbValue == 'Work') return localizations.work;
    if (dbValue == 'Study') return localizations.study;
    if (dbValue == 'Personal') return localizations.personal;
    return dbValue;
  }

  static String dbToLocalizedPriority(String dbValue, BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    if (dbValue == 'High') return localizations.high;
    if (dbValue == 'Medium') return localizations.medium;
    if (dbValue == 'Low') return localizations.low;
    return dbValue;
  }

  static DateTime? calculateReminderDate(
    BuildContext context, {
    required String? reminderOption,
    required DateTime? endDate,
  }) {
    if (endDate == null || reminderOption == null) {
      return null;
    }

    final localizations = AppLocalizations.of(context)!;
    Duration duration;

    if (reminderOption == localizations.before_2_minutes) {
      duration = const Duration(minutes: 2);
    } else if (reminderOption == localizations.before_5_minutes) {
      duration = const Duration(minutes: 5);
    } else if (reminderOption == localizations.before_10_minutes) {
      duration = const Duration(minutes: 10);
    } else if (reminderOption == localizations.before_20_minutes) {
      duration = const Duration(minutes: 20);
    } else {
      return null;
    }

    return endDate.subtract(duration);
  }

  static String? calculateReminderOptionFromDate(
    BuildContext context, {
    required DateTime? reminderDate,
    required DateTime? endDate,
  }) {
    if (reminderDate == null || endDate == null) {
      return null;
    }

    final localizations = AppLocalizations.of(context)!;
    final difference = endDate.difference(reminderDate);
    final totalMinutes = difference.inMinutes;

    if (totalMinutes >= 1 && totalMinutes <= 3) {
      return localizations.before_2_minutes;
    } else if (totalMinutes >= 4 && totalMinutes <= 6) {
      return localizations.before_5_minutes;
    } else if (totalMinutes >= 9 && totalMinutes <= 11) {
      return localizations.before_10_minutes;
    } else if (totalMinutes >= 19 && totalMinutes <= 21) {
      return localizations.before_20_minutes;
    } else {
      return null;
    }
  }
}
