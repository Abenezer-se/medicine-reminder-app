// lib/services/notification_service.dart
/*import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        print("Notification tapped: ${response.payload}");
        // You can navigate to HomeScreen or show "Taken" dialog here later
      },
    );

    // High-priority channel for medicine reminders (uses device's alarm/notification sound)
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'medicine_reminder_channel',
      'Medicine Reminders',
      description: 'Reminders to take your medication on time',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      enableLights: true,
    );

    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Schedule a reliable medicine reminder with alarm-like behavior
  Future<void> scheduleMedicineReminder({
    required int id,
    required String medicineName,
    required String time,
    required DateTime reminderDateTime,
  }) async {
    final tz.TZDateTime scheduledTime =
        tz.TZDateTime.from(reminderDateTime, tz.local);

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'medicine_reminder_channel',
      'Medicine Reminders',
      channelDescription: 'Critical reminders for taking medication',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true, // Uses device's default notification/alarm sound
      enableVibration: true,
      fullScreenIntent: true, // Shows on top of lock screen (high priority)
      category: AndroidNotificationCategory.alarm,
      audioAttributesUsage:
          AudioAttributesUsage.alarm, // Helps play at full volume
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await notificationsPlugin.zonedSchedule(
      id,
      '🔔 Time to take your medicine!',
      '$medicineName — $time',
      scheduledTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode
          .exactAllowWhileIdle, // Most reliable for exact time
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: medicineName,
      matchDateTimeComponents:
          DateTimeComponents.time, // Repeat daily at same time
    );

    print("✅ Reminder scheduled: $medicineName at $time");
  }

  Future<void> cancelNotification(int id) async {
    await notificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await notificationsPlugin.cancelAll();
  }
}*/

// lib/services/notification_service.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await notificationsPlugin.initialize(initSettings);
  }

  Future<void> scheduleMedicineReminder({
    required int id,
    required String medicineName,
    required String time,
    required DateTime reminderDateTime,
  }) async {
    final tz.TZDateTime scheduledTime =
        tz.TZDateTime.from(reminderDateTime, tz.local);

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'medicine_reminder_channel',
      'Medicine Reminders',
      channelDescription: 'Reminders to take your medication',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      enableVibration: true,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
      sound:
          null, // Use default system sound (loudest possible without custom file)
      actions: [
        AndroidNotificationAction(
          'taken',
          'Taken',
          showsUserInterface: true,
        ),
        AndroidNotificationAction(
          'snooze',
          'Snooze 10 min',
          showsUserInterface: true,
        ),
      ],
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await notificationsPlugin.zonedSchedule(
      id,
      '🔔 Time to take your medicine!',
      '$medicineName - $time',
      scheduledTime,
      notificationDetails,
      androidScheduleMode:
          AndroidScheduleMode.inexactAllowWhileIdle, // More reliable
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // Repeat daily
    );
  }

  Future<void> cancelNotification(int id) async {
    await notificationsPlugin.cancel(id);
  }
}
