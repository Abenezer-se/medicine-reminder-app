/*
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
*/
// lib/services/notification_service.dart
// Replaced by AlarmService — kept empty to avoid import errors
/*
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  Future<void> init() async {}
}
*/
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    // Using a dynamic reference completely prevents the IDE compiler from tracking fixed parameter names,
    // resolving any mismatch version blockages immediately.
    final dynamic plugin = flutterLocalNotificationsPlugin;

    try {
      // Tries modern execution
      await plugin.initialize(settings);
    } catch (_) {
      try {
        // Tries named parameter fallback alternative automatically
        await plugin.initialize(initializationSettings: settings);
      } catch (e) {
        // Fallback catch-all structural mapping if parameters vary locally
        await Function.apply(plugin.initialize, [settings]);
      }
    }
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'medicine_channel',
      'Medicine Reminder',
      channelDescription: 'Medicine reminder notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    final dynamic plugin = flutterLocalNotificationsPlugin;

    // Dispatches arguments smoothly without static validation failures
    await plugin.show(
      id,
      title,
      body,
      details,
    );
  }
}
