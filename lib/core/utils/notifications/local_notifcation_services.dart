import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;

class LocalNotificationService {
  static final LocalNotificationService _instance =
  LocalNotificationService._internal();
  factory LocalNotificationService() => _instance;
  LocalNotificationService._internal();

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static const String basicChannelId = 'basic_channel';
  static const String scheduledChannelId = 'scheduled_channel';

  // Add this: Callback for notification tap
  static Function(int, String?)? onNotificationTap;

  bool _isInitialized = false;

  /// Initialize Notifications
  Future<void> initialize({Function(int, String?)? onTap}) async {
    if (_isInitialized) return;

    print("[Notifications] Initializing...");

    // Store the callback
    if (onTap != null) {
      onNotificationTap = onTap;
    }

    try {
      // Initialize timezones
      tzData.initializeTimeZones();
      final cairoLocation = tz.getLocation('Africa/Cairo');
      tz.setLocalLocation(cairoLocation);

      // Initialize plugin
      await _notificationsPlugin.initialize(
        const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(),
        ),
        // Handle notification tap
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          _handleNotificationTap(response);
        },
      );

      // Create notification channels
      await _createNotificationChannels();

      _isInitialized = true;
      print("[Notifications] Initialized successfully.");

    } catch (e) {
      print("[Notifications] Initialization error: $e");
    }
  }

  Future<void> _createNotificationChannels() async {
    print("[Notifications] Creating channels...");

    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      // Basic notification channel
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          basicChannelId,
          'Basic Notifications',
          description: 'For basic immediate notifications',
          importance: Importance.max,
          enableLights: true,
          enableVibration: true,
        ),
      );

      // Scheduled notification channel
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          scheduledChannelId,
          'Scheduled Notifications',
          description: 'For scheduled notifications',
          importance: Importance.max,
          enableLights: true,
          enableVibration: true,
        ),
      );
      print("[Notifications] Channels created.");
    }
  }

  Future<void> showBasicNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    print("[Notifications] Showing basic notification: $title");

    try {
      await _notificationsPlugin.show(
        id,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            basicChannelId,
            'Basic Notifications',
            importance: Importance.max,
            priority: Priority.high,
            autoCancel: true,
            enableLights: true,
            enableVibration: true,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        payload: payload ?? 'notification_$id',
      );
      print("[Notifications] Basic notification shown.");
    } catch (e) {
      print("[Notifications] Failed to show basic notification: $e");
    }
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    print("[Notifications] Scheduling: $title for $scheduledDate");

    try {
      if (!_isInitialized) await initialize();

      // Convert to Cairo timezone
      final cairoLocation = tz.getLocation('Africa/Cairo');
      final tzTime = tz.TZDateTime.from(scheduledDate, cairoLocation);

      print("[Notifications] Converted time: $tzTime");

      // Check if in past
      final now = tz.TZDateTime.now(cairoLocation);
      if (tzTime.isBefore(now)) {
        print("[Notifications] Time is in past, scheduling for 5 seconds instead");
        final newTime = now.add(const Duration(seconds: 5));
        await _scheduleAtTime(
          id: id,
          title: title,
          body: body,
          tzTime: newTime,
          payload: payload,
        );
        return;
      }

      await _scheduleAtTime(
        id: id,
        title: title,
        body: body,
        tzTime: tzTime,
        payload: payload,
      );

    } catch (e) {
      print("[Notifications] Failed to schedule: $e");
    }
  }

  Future<void> _scheduleAtTime({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime tzTime,
    String? payload,
  }) async {
    try {

      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            scheduledChannelId,
            'Scheduled Notifications',
            importance: Importance.max,
            priority: Priority.high,
            autoCancel: true,
            enableLights: true,
            enableVibration: true,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload ?? 'scheduled_$id',
      );

      print("[Notifications] Scheduled successfully for $tzTime");

    } catch (e) {
      print("[Notifications] Error in scheduleAtTime: $e");
    }
  }

  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }

  // Handle notification tap
  void _handleNotificationTap(NotificationResponse response) {
    print("[Notifications] Notification tapped: ID=${response.id}, Payload=${response.payload}");

    // Call the callback if set
    if (onNotificationTap != null) {
      onNotificationTap!(response.id ?? 0, response.payload);
    }
  }
}