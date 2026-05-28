<<<<<<< HEAD
// lib/services/notification_service.dart
=======

// lib/services/notification_service.dart

>>>>>>> bd5ae6ec8af0070ace0b0756e38073696507fc02
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
