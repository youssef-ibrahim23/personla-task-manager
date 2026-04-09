import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_task/app.dart';
import 'package:personal_task/core/utils/notifications/FCM_services.dart';
import 'package:personal_task/core/utils/notifications/local_notifcation_services.dart';
import 'package:personal_task/core/utils/work-manager/work_manager_services.dart';
import 'package:personal_task/firebase_options.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:workmanager/workmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  LocalNotificationService().initialize();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FCMServices.initializeServiceAccount();

  await WorkManagerServices.initialize();

  await WorkManagerServices.registerPeriodicSync(
    uniqueName: 'syncOfflineTasks',
    taskName: 'syncOfflineTasks',
    frequency: const Duration(minutes: 15),
    constraints: Constraints(networkType: NetworkType.connected),
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const App();
  }
}