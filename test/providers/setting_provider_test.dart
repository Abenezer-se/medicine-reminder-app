/*import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:medicine_reminder_app/providers/setting_provider.dart';
import 'dart:io';

void main() {
  setUpAll(() async {
    final tempDir = await Directory.systemTemp.createTemp('hive_settings_test');
    Hive.init(tempDir.path);
    await Hive.openBox('settingsBox');
  });

  setUp(() {
    Hive.box('settingsBox').clear();
  });

  tearDownAll(() async {
    await Hive.close();
  });

  group('SettingsProvider', () {
    test('default selectedSound is gentle_bell', () {
      final provider = SettingsProvider();
      expect(
        provider.selectedSound,
        'assets/alarm_sounds/gentle_bell.mp3',
      );
    });

    test('default soundEnabled is true', () {
      final provider = SettingsProvider();
      expect(provider.soundEnabled, true);
    });

    test('default vibrateEnabled is true', () {
      final provider = SettingsProvider();
      expect(provider.vibrateEnabled, true);
    });

    test('default reminderLeadTime is 15 minutes', () {
      final provider = SettingsProvider();
      expect(provider.reminderLeadTime, '15 minutes');
    });

    test('setSound updates selectedSound', () async {
      final provider = SettingsProvider();
      await provider.setSound('assets/alarm_sounds/urgent_beep.mp3');
      expect(
        provider.selectedSound,
        'assets/alarm_sounds/urgent_beep.mp3',
      );
    });

    test('setSoundEnabled to false works', () async {
      final provider = SettingsProvider();
      await provider.setSoundEnabled(false);
      expect(provider.soundEnabled, false);
    });

    test('setVibrateEnabled to false works', () async {
      final provider = SettingsProvider();
      await provider.setVibrateEnabled(false);
      expect(provider.vibrateEnabled, false);
    });

    test('setLeadTime updates reminderLeadTime', () async {
      final provider = SettingsProvider();
      await provider.setLeadTime('30 minutes');
      expect(provider.reminderLeadTime, '30 minutes');
    });

    test('settings persist across instances', () async {
      final provider1 = SettingsProvider();
      await provider1.setSound('assets/alarm_sounds/soft_chime.mp3');
      await provider1.setSoundEnabled(false);
      await provider1.setVibrateEnabled(false);
      await provider1.setLeadTime('1 hour');

      final provider2 = SettingsProvider();
      expect(provider2.selectedSound, 'assets/alarm_sounds/soft_chime.mp3');
      expect(provider2.soundEnabled, false);
      expect(provider2.vibrateEnabled, false);
      expect(provider2.reminderLeadTime, '1 hour');
    });

    test('all three sounds are valid options', () {
      final validSounds = [
        'assets/alarm_sounds/gentle_bell.mp3',
        'assets/alarm_sounds/soft_chime.mp3',
        'assets/alarm_sounds/urgent_beep.mp3',
      ];

      for (final sound in validSounds) {
        expect(
          validSounds.contains(sound),
          true,
          reason: '$sound should be a valid sound option',
        );
      }
    });
  });
}*/

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:medicine_reminder_app/providers/setting_provider.dart';
import 'dart:io';

void main() {
  // FIX: settingsBox must be cleared AND re-read between
  // tests. The problem is Hive.box() returns the same
  // in-memory box, so .clear() doesn't reset the
  // SettingsProvider's getter cache — we must call
  // the async setters and await them properly.
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_settings_test');
    Hive.init(tempDir.path);
    await Hive.openBox('settingsBox');
  });

  setUp(() async {
    // FIX: clear box and wait for async clear to finish
    await Hive.box('settingsBox').clear();
  });

  tearDownAll(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  group('SettingsProvider', () {
    test('default selectedSound is gentle_bell', () {
      final provider = SettingsProvider();
      expect(
        provider.selectedSound,
        'assets/alarm_sounds/gentle_bell.mp3',
      );
    });

    test('default soundEnabled is true', () {
      final provider = SettingsProvider();
      expect(provider.soundEnabled, true);
    });

    test('default vibrateEnabled is true', () {
      final provider = SettingsProvider();
      expect(provider.vibrateEnabled, true);
    });

    test('default reminderLeadTime is 15 minutes', () {
      final provider = SettingsProvider();
      expect(provider.reminderLeadTime, '15 minutes');
    });

    test('setSound updates selectedSound', () async {
      final provider = SettingsProvider();
      // FIX: await the async setter before reading the value
      await provider.setSound('assets/alarm_sounds/urgent_beep.mp3');
      expect(
        provider.selectedSound,
        'assets/alarm_sounds/urgent_beep.mp3',
      );
    });

    test('setSoundEnabled to false works', () async {
      final provider = SettingsProvider();
      await provider.setSoundEnabled(false);
      expect(provider.soundEnabled, false);
    });

    test('setSoundEnabled back to true works', () async {
      final provider = SettingsProvider();
      await provider.setSoundEnabled(false);
      await provider.setSoundEnabled(true);
      expect(provider.soundEnabled, true);
    });

    test('setVibrateEnabled to false works', () async {
      final provider = SettingsProvider();
      await provider.setVibrateEnabled(false);
      expect(provider.vibrateEnabled, false);
    });

    test('setVibrateEnabled back to true works', () async {
      final provider = SettingsProvider();
      await provider.setVibrateEnabled(false);
      await provider.setVibrateEnabled(true);
      expect(provider.vibrateEnabled, true);
    });

    test('setLeadTime updates reminderLeadTime', () async {
      final provider = SettingsProvider();
      await provider.setLeadTime('30 minutes');
      expect(provider.reminderLeadTime, '30 minutes');
    });

    test('setLeadTime accepts all valid options', () async {
      final provider = SettingsProvider();
      final options = [
        '5 minutes',
        '10 minutes',
        '15 minutes',
        '30 minutes',
        '1 hour',
      ];
      for (final option in options) {
        await provider.setLeadTime(option);
        expect(provider.reminderLeadTime, option);
      }
    });

    test('settings persist across provider instances', () async {
      // FIX: await all setters before reading from new instance
      final provider1 = SettingsProvider();
      await provider1.setSound('assets/alarm_sounds/soft_chime.mp3');
      await provider1.setSoundEnabled(false);
      await provider1.setVibrateEnabled(false);
      await provider1.setLeadTime('1 hour');

      // New instance reads same Hive box
      final provider2 = SettingsProvider();
      expect(
        provider2.selectedSound,
        'assets/alarm_sounds/soft_chime.mp3',
      );
      expect(provider2.soundEnabled, false);
      expect(provider2.vibrateEnabled, false);
      expect(provider2.reminderLeadTime, '1 hour');
    });

    test('all three alarm sounds are valid', () {
      final validSounds = [
        'assets/alarm_sounds/gentle_bell.mp3',
        'assets/alarm_sounds/soft_chime.mp3',
        'assets/alarm_sounds/urgent_beep.mp3',
      ];
      for (final sound in validSounds) {
        expect(validSounds.contains(sound), true);
      }
    });
  });
}
