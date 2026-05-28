// lib/services/alarm_service.dart
/*
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

@pragma('vm:entry-point')
Future<void> alarmCallback() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String name = prefs.getString('alarm_medicine_name') ?? 'Your Medicine';
  final String dose = prefs.getString('alarm_medicine_dose') ?? '';

  // Use method channel to show notification via Android native
  // Store the fired flag so main app knows to show AlarmRingScreen
  await prefs.setBool('alarm_fired', true);
  await prefs.setString('alarm_fired_name', name);
  await prefs.setString('alarm_fired_dose', dose);
}

class AlarmService {
  static final AlarmService _instance = AlarmService._internal();
  factory AlarmService() => _instance;
  AlarmService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();

  static const List<Map<String, String>> sounds = [
    {
      'name': '🔔 Gentle Bell',
      'asset': 'assets/alarm_sounds/gentle_bell.mp3',
      'raw': 'gentle_bell',
    },
    {
      'name': '🎵 Soft Chime',
      'asset': 'assets/alarm_sounds/soft_chime.mp3',
      'raw': 'soft_chime',
    },
    {
      'name': '🚨 Urgent Beep',
      'asset': 'assets/alarm_sounds/urgent_beep.mp3',
      'raw': 'urgent_beep',
    },
  ];

  Future<void> init() async {
    await AndroidAlarmManager.initialize();
  }

  Future<void> scheduleAlarm({
    required int id,
    required String medicineName,
    required String dose,
    required DateTime dateTime,
    required String assetAudioPath,
    bool vibrate = true,
    String emergencyPhone = '',
  }) async {
    DateTime alarmTime = dateTime;
    if (alarmTime.isBefore(DateTime.now())) {
      alarmTime = alarmTime.add(const Duration(days: 1));
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('alarm_name_$id', medicineName);
    await prefs.setString('alarm_dose_$id', dose);
    await prefs.setString('alarm_sound_$id', assetAudioPath);
    await prefs.setBool('alarm_vibrate', vibrate);
    await prefs.setBool('alarm_fired', true);

    await AndroidAlarmManager.periodic(
      const Duration(days: 1),
      id,
      alarmCallback,
      startAt: alarmTime,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );

    debugPrint('Alarm set: $medicineName at $alarmTime');
  }

  Future<void> playSound(String assetPath) async {
    try {
      final String source = assetPath.replaceFirst('assets/', '');
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.play(AssetSource(source));
    } catch (e) {
      debugPrint('Audio error: $e');
    }
  }

  Future<void> stopSound() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      debugPrint('Stop error: $e');
    }
  }

  Future<void> cancelAlarm(int id) async {
    await AndroidAlarmManager.cancel(id);
    debugPrint('Alarm cancelled: $id');
  }

  Future<void> cancelAll() async {
    debugPrint('All alarms cancelled');
  }

  static Future<void> sendSMS({
    required String medicineName,
    required String dose,
    required List<String> phones,
  }) async {
    if (phones.isEmpty) return;
    final String phoneList = phones.join(',');
    final String message =
        'Medicare Reminder: Time to take $medicineName — $dose. Please remind the patient if needed.';
    final Uri uri =
        Uri.parse('sms:$phoneList?body=${Uri.encodeComponent(message)}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
} */
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'notification_service.dart';

@pragma('vm:entry-point')
Future<void> alarmCallback(int id) async {
  // 1. Initialize bindings for background execution
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  // 2. Initialize notification setup for this separate background isolate
  await NotificationService.init();

  final SharedPreferences prefs = await SharedPreferences.getInstance();

  final String name = prefs.getString('alarm_name_$id') ?? 'Medicine';
  final String dose = prefs.getString('alarm_dose_$id') ?? '';
  final String soundPath = prefs.getString('alarm_sound_$id') ??
      'assets/alarm_sounds/gentle_bell.mp3';

  // Mark alarm fired
  await prefs.setBool('alarm_fired_$id', true);

  // 3. Show notification
  await NotificationService.showNotification(
    id: id,
    title: '💊 Medicine Reminder',
    body: '$name - $dose',
  );

  // 4. Play the sound directly in the background isolate
  try {
    final String source = soundPath.replaceFirst('assets/', '');
    final AudioPlayer backgroundAudioPlayer = AudioPlayer();

    await backgroundAudioPlayer.setReleaseMode(ReleaseMode.loop);
    await backgroundAudioPlayer.play(AssetSource(source));

    debugPrint('Background Audio Playing: $source');
  } catch (e) {
    debugPrint('Background Audio Error: $e');
  }

  debugPrint('Alarm Fired successfully for ID: $id - $name');
}

class AlarmService {
  static final AlarmService _instance = AlarmService._internal();
  factory AlarmService() => _instance;
  AlarmService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();

  static const List<Map<String, String>> sounds = [
    {
      'name': '🔔 Gentle Bell',
      'asset': 'assets/alarm_sounds/gentle_bell.mp3',
    },
    {
      'name': '🎵 Soft Chime',
      'asset': 'assets/alarm_sounds/soft_chime.mp3',
    },
    {
      'name': '🚨 Urgent Beep',
      'asset': 'assets/alarm_sounds/urgent_beep.mp3',
    },
  ];

  Future<void> init() async {
    await AndroidAlarmManager.initialize();
  }

  Future<void> scheduleAlarm({
    required int id,
    required String medicineName,
    required String dose,
    required DateTime dateTime,
    required String assetAudioPath,
    bool vibrate = true,
    String emergencyPhone = '',
  }) async {
    DateTime alarmTime = dateTime;

    if (alarmTime.isBefore(DateTime.now())) {
      alarmTime = alarmTime.add(const Duration(days: 1));
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('alarm_name_$id', medicineName);
    await prefs.setString('alarm_dose_$id', dose);
    await prefs.setString('alarm_sound_$id', assetAudioPath);
    await prefs.setBool('alarm_vibrate_$id', vibrate);
    await prefs.setBool('alarm_fired_$id', false);

    if (emergencyPhone.isNotEmpty) {
      await prefs.setString('alarm_phone_$id', emergencyPhone);
    }

    // Schedule exact one-shot alarm
    await AndroidAlarmManager.oneShotAt(
      alarmTime,
      id,
      alarmCallback,
      exact: true,
      wakeup: true, // Forces device screen/CPU to wake up
      rescheduleOnReboot: true,
    );

    debugPrint('Alarm Scheduled: $medicineName at $alarmTime');
  }

  // Used for previewing sounds in the UI application layer
  Future<void> playSound(String assetPath) async {
    try {
      final String source = assetPath.replaceFirst('assets/', '');
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.play(AssetSource(source));
    } catch (e) {
      debugPrint('UI Audio Error: $e');
    }
  }

  Future<void> stopSound() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      debugPrint('Stop Error: $e');
    }
  }

  Future<void> cancelAlarm(int id) async {
    await AndroidAlarmManager.cancel(id);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('alarm_name_$id');
    await prefs.remove('alarm_dose_$id');
    await prefs.remove('alarm_sound_$id');
    await prefs.remove('alarm_vibrate_$id');
    await prefs.remove('alarm_fired_$id');
    await prefs.remove('alarm_phone_$id');

    debugPrint('Alarm Cancelled: $id');
  }

  Future<void> cancelAll(List<int> ids) async {
    for (final id in ids) {
      await cancelAlarm(id);
    }
    debugPrint('All alarms cancelled');
  }

  static Future<void> sendSMS({
    required String medicineName,
    required String dose,
    required List<String> phones,
  }) async {
    if (phones.isEmpty) return;

    final String phoneList = phones.join(',');
    final String message = '💊 Medicare Reminder:\n'
        'Time to take $medicineName ($dose).\n'
        'Please remind the patient if needed.';

    final Uri uri = Uri.parse(
      'sms:$phoneList?body=${Uri.encodeComponent(message)}',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
