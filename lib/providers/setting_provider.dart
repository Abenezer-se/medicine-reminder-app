// lib/providers/settings_provider.dart
/*
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

class SettingsProvider extends ChangeNotifier {
  final Box _box = Hive.box('settingsBox');

  static const String defaultSound = 'assets/alarm_sounds/gentle_bell.mp3';


  String get selectedSound =>
      _box.get('alarm_sound', defaultValue: defaultSound) as String;

  bool get soundEnabled =>
      _box.get('sound_enabled', defaultValue: true) as bool;

  bool get vibrateEnabled =>
      _box.get('vibrate_enabled', defaultValue: true) as bool;

  String get reminderLeadTime =>
      _box.get('lead_time', defaultValue: '15 minutes') as String;

  Future<void> setSound(String asset) async {
    await _box.put('alarm_sound', asset);
    notifyListeners();
  }

  Future<void> setSoundEnabled(bool val) async {
    await _box.put('sound_enabled', val);
    notifyListeners();
  }

  Future<void> setVibrateEnabled(bool val) async {
    await _box.put('vibrate_enabled', val);
    notifyListeners();
  }

  Future<void> setLeadTime(String val) async {
    await _box.put('lead_time', val);
    notifyListeners();
  }
}
*/

// lib/providers/settings_provider.dart
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

class SettingsProvider extends ChangeNotifier {
  final Box _box = Hive.box('settingsBox');

  static const String defaultSound = 'assets/alarm_sounds/gentle_bell.mp3';

  String get selectedSound =>
      _box.get('alarm_sound', defaultValue: defaultSound) as String;

  bool get soundEnabled =>
      _box.get('sound_enabled', defaultValue: true) as bool;

  bool get vibrateEnabled =>
      _box.get('vibrate_enabled', defaultValue: true) as bool;

  String get reminderLeadTime =>
      _box.get('lead_time', defaultValue: '15 minutes') as String;

  Future<void> setSound(String asset) async {
    await _box.put('alarm_sound', asset);
    notifyListeners();
  }

  Future<void> setSoundEnabled(bool val) async {
    await _box.put('sound_enabled', val);
    notifyListeners();
  }

  Future<void> setVibrateEnabled(bool val) async {
    await _box.put('vibrate_enabled', val);
    notifyListeners();
  }

  Future<void> setLeadTime(String val) async {
    await _box.put('lead_time', val);
    notifyListeners();
  }
}
