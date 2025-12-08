import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationServices {

  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    try {
      const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings iosSettings =
      DarwinInitializationSettings();

      const InitializationSettings settings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await flutterLocalNotificationsPlugin.initialize(settings);
      print('Initialize Notification Success');
    }catch(e){
      print('Initialize Notification Error : ${e.toString()}');
    }
  }

  Future<void> showBasicNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    print('Showing basic notification: id=$id, title=$title, body=$body');

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'basic_channel',
      'Basic Notifications',
      channelDescription: 'General local notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformDetails,
    );

    print('Basic notification shown successfully');
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    print('Scheduling notification: id=$id, title=$title, body=$body, scheduledDate=$scheduledDate');

    final tzTime = tz.TZDateTime.from(scheduledDate, tz.local);

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'scheduled_channel',
      'Scheduled Notifications',
      channelDescription: 'Notifications scheduled for later',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzTime,
      platformDetails,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: null,
    );

    print('Notification scheduled successfully for $tzTime');
  }

  Future<void> updateScheduledNotification({
    required int id,
    required String title,
    required String body,
    required DateTime newScheduledDate,
  }) async {
    print('Updating notification: id=$id, title=$title, body=$body, newScheduledDate=$newScheduledDate');

    await flutterLocalNotificationsPlugin.cancel(id);
    print('Cancelled existing notification with id=$id');

    final tzTime = tz.TZDateTime.from(newScheduledDate, tz.local);

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'scheduled_channel',
      'Scheduled Notifications',
      channelDescription: 'Notifications scheduled for later',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tzTime,
      platformDetails,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: null,
    );

    print('Notification updated and scheduled successfully for $tzTime');
  }

}
