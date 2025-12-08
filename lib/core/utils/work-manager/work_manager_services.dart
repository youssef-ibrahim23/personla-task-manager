import 'package:firebase_core/firebase_core.dart';
import 'package:personal_task/core/utils/DB/firestore_services.dart';
import 'package:personal_task/core/utils/helpers.dart';
import 'package:personal_task/core/utils/notifications/FCM_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:personal_task/core/utils/DB/db_services.dart';
import 'package:personal_task/core/utils/DB/models/task.dart';

import '../../../firebase_options.dart';

class WorkManagerServices {
  static Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
    print("WorkManager initialized");
  }

  static Future<void> registerPeriodicSync({
    required String uniqueName,
    required String taskName,
    Duration? frequency,
    Constraints? constraints,
  }) async {
    try {
      await Workmanager().registerPeriodicTask(
        uniqueName,
        taskName,
        frequency: frequency,
        constraints: constraints,
        existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
      );
      print("Periodic sync task registered: $taskName");
    } catch (e) {
      print('[WorkManager] Failed to register periodic task $taskName: $e');
    }
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    print("[Workmanager] Background task running: $taskName");

    try {
      await DBServices().initDB();
    } catch (e) {
      print('[Workmanager] Failed to init DB: $e');
    }

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e) {
      print('[Workmanager] Failed to init Firebase: $e');
    }

    String? uid;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final accessToken = preferences.getString('fcm_access_token') ?? '';
    print("The Acces Token is : $accessToken}");
    final projectId = preferences.getString('project_id') ?? '';
    print("The Project Id is : $projectId}");
    try {
      uid = await Helpers.getUID();
      if (uid == null) {
        print("[Workmanager] UID not found — stopping sync.");
        return false;
      }
    } catch (e) {
      print("[Workmanager] Failed getting UID: $e");
      return false;
    }

    try {
      if (taskName == 'syncOfflineTasks') {
        final List<Task> offlineTasks = await DBServices.getUnUploadedTasks(
          uid,
        );

        if (offlineTasks.isNotEmpty) {
          for (final task in offlineTasks) {
            try {
              task.uploadStatus = true;
              await FireStoreServices().uploadTask(task: task);
              await DBServices.toggleTaskIsUploaded(
                taskId: task.id!,
                isUploaded: 1,
              );
              if (task.isShared == true) {
                FCMServices.sendTopicNotification(
                  topic: 'public-tasks',
                  title: "New Public Task : ${task.title}",
                  body: task.description,
                  accessToken: accessToken,
                  projectId: projectId,
                );
              }
              print("[Workmanager] Offline tasks synced: ${offlineTasks.length}");
              return true;
            } catch (e) {
              print('[Workmanager] Failed syncing offline task ${task.id}: $e');
              return false;
            }
          }
        }
        print("No Tasks To Sync It");
        return true;
      }

      if (taskName == 'syncUpdatedTasks') {
        final List<Task>? updatedTasks = await DBServices.getUpdatedTasks(uid);

        if (updatedTasks != null && updatedTasks.isNotEmpty) {
          for (final task in updatedTasks) {
            try {
              task.isUpdated = false;
              await FireStoreServices().updateTask(task: task);
              await DBServices.toggleIsUpdatedStatus(
                taskId: task.id!,
                isUpdated: 0,
              );
              if (task.isShared == true) {
                FCMServices.sendTopicNotification(
                  topic: 'public-tasks',
                  title: "New Public Task : ${task.title}",
                  body: task.description,
                  accessToken: accessToken,
                  projectId: projectId,
                );
              }
            } catch (e) {
              print('[Workmanager] Failed syncing updated task ${task.id}: $e');
            }
          }
        }

        print(
          "[Workmanager] Updated tasks synced: ${updatedTasks?.length ?? 0}",
        );
        return true;
      }

      return true;
    } catch (e, st) {
      print("[Workmanager] Error: $e\n$st");
      return false;
    }
  });
}
