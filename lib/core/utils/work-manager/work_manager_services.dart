import 'package:firebase_core/firebase_core.dart';
import 'package:personal_task/core/utils/DB/firestore_services.dart';
import 'package:personal_task/core/utils/helpers.dart';
import 'package:personal_task/core/utils/notifications/FCM_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:personal_task/core/utils/DB/db_services.dart';

import '../../../firebase_options.dart';

class WorkManagerServices {
  static Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );
    print("WorkManager initialized");
  }

  static Future<void> registerPeriodicSync({
    required String uniqueName,
    required String taskName,
    Duration? frequency,
    Constraints? constraints,
    Map<String , dynamic>? inputData,
  }) async {
    try {
      await Workmanager().registerPeriodicTask(
        uniqueName,
        taskName,
        frequency: frequency,
        constraints: constraints,
        existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
        inputData: inputData
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

    // Initialize DB
    try {
      await DBServices().initDB();
    } catch (e) {
      print('[Workmanager] Failed to init DB: $e');
    }

    // Initialize Firebase
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e) {
      print('[Workmanager] Failed to init Firebase: $e');
    }

    // Get UID
    String? uid;
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

    // Load Service Account JSON from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final serviceAccountJson = prefs.getString('service_account_json');
    print(serviceAccountJson);
    if (serviceAccountJson == null) {
      print("[Workmanager] Service account JSON not found, skipping FCM.");
    }

    try {
      // Sync Offline Tasks
      if (taskName == 'syncOfflineTasks') {
        final offlineTasks = await DBServices.getUnUploadedTasks(uid);

        if (offlineTasks.isNotEmpty) {
          for (final task in offlineTasks) {
            try {
              task.uploadStatus = true;
              await FireStoreServices().uploadTask(task: task);
              await DBServices.toggleTaskIsUploaded(
                taskId: task.id!,
                isUploaded: 1,
              );

              if (task.isShared == true && serviceAccountJson != null) {
                try {
                  await FCMServices.sendTopicNotificationFromJson(
                    jsonString: serviceAccountJson,
                    topic: 'public-tasks',
                    title: "New Public Task : ${task.title}",
                    body: task.description,
                  );
                } catch (e) {
                  print("[Workmanager] Failed sending FCM for task ${task.id}: $e");
                }
              }
            } catch (e) {
              print('[Workmanager] Failed syncing offline task ${task.id}: $e');
            }
          }
        } else {
          print("[Workmanager] No offline tasks to sync");
        }
      }

      // Sync Updated Tasks
      if (taskName == 'syncUpdatedTasks') {
        final updatedTasks = await DBServices.getUpdatedTasks(uid);

        if (updatedTasks != null && updatedTasks.isNotEmpty) {
          for (final task in updatedTasks) {
            try {
              task.isUpdated = false;
              await FireStoreServices().updateTask(task: task);
              await DBServices.toggleIsUpdatedStatus(
                taskId: task.id!,
                isUpdated: 0,
              );

              if (task.isShared == true && serviceAccountJson != null) {
                try {
                  await FCMServices.sendTopicNotificationFromJson(
                    jsonString: serviceAccountJson,
                    topic: 'public-tasks',
                    title: "Updated Public Task : ${task.title}",
                    body: task.description,
                  );
                } catch (e) {
                  print("[Workmanager] Failed sending FCM for updated task ${task.id}: $e");
                }
              }
            } catch (e) {
              print('[Workmanager] Failed syncing updated task ${task.id}: $e');
            }
          }
        } else {
          print("[Workmanager] No updated tasks to sync");
        }
      }

      if(taskName == "syncDeleteTasks"){

          final deletedTasks = await DBServices.getDeletedTasks(uid);

          if (deletedTasks != null && deletedTasks.isNotEmpty) {
            for (final task in deletedTasks) {
              try {
                await FireStoreServices().deleteTask(taskId: task.id.toString());
                await DBServices.deleteTask(task.id!);
              } catch (e) {
                print('[Workmanager] Failed syncing deleted task ${task.id}: $e');
              }
            }
          } else {
            print("[Workmanager] No deleted tasks to sync");
          }
        }

      print("[Workmanager] Background task $taskName finished successfully");
      return true;
    } catch (e, st) {
      print("[Workmanager] Error in background task: $e\n$st");
      return false;
    }
  });
}
