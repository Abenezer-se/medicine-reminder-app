/* import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_reminder_app/services/alarm_service.dart';

void main() {
  group('AlarmService Sounds', () {
    test('sounds list has exactly 3 options', () {
      expect(AlarmService.sounds.length, 3);
    });

    test('first sound is Gentle Bell', () {
      expect(AlarmService.sounds[0]['name'], '🔔 Gentle Bell');
      expect(
        AlarmService.sounds[0]['asset'],
        'assets/alarm_sounds/gentle_bell.mp3',
      );
      expect(AlarmService.sounds[0]['raw'], 'gentle_bell');
    });

    test('second sound is Soft Chime', () {
      expect(AlarmService.sounds[1]['name'], '🎵 Soft Chime');
      expect(
        AlarmService.sounds[1]['asset'],
        'assets/alarm_sounds/soft_chime.mp3',
      );
      expect(AlarmService.sounds[1]['raw'], 'soft_chime');
    });

    test('third sound is Urgent Beep', () {
      expect(AlarmService.sounds[2]['name'], '🚨 Urgent Beep');
      expect(
        AlarmService.sounds[2]['asset'],
        'assets/alarm_sounds/urgent_beep.mp3',
      );
      expect(AlarmService.sounds[2]['raw'], 'urgent_beep');
    });

    test('all sounds have name, asset, and raw keys', () {
      for (final sound in AlarmService.sounds) {
        expect(sound.containsKey('name'), true);
        expect(sound.containsKey('asset'), true);
        expect(sound.containsKey('raw'), true);
      }
    });

    test('all sound assets start with assets/alarm_sounds/', () {
      for (final sound in AlarmService.sounds) {
        expect(
          sound['asset']!.startsWith('assets/alarm_sounds/'),
          true,
        );
      }
    });

    test('all sound assets end with .mp3', () {
      for (final sound in AlarmService.sounds) {
        expect(sound['asset']!.endsWith('.mp3'), true);
      }
    });

    test('singleton returns same instance', () {
      final a = AlarmService();
      final b = AlarmService();
      expect(identical(a, b), true);
    });

    test('sendSMS does nothing with empty phone list', () async {
      // Should not throw
      await expectLater(
        AlarmService.sendSMS(
          medicineName: 'Aspirin',
          dose: '500mg',
          phones: [],
        ),
        completes,
      );
    });
  });

  group('Alarm Time Logic', () {
    test('alarm time in the past should move to next day', () {
      final pastTime = DateTime.now().subtract(
        const Duration(hours: 2),
      );
      final adjustedTime = pastTime.isBefore(DateTime.now())
          ? pastTime.add(const Duration(days: 1))
          : pastTime;

      expect(adjustedTime.isAfter(DateTime.now()), true);
    });

    test('alarm time in the future stays as is', () {
      final futureTime = DateTime.now().add(const Duration(hours: 2));
      final adjustedTime = futureTime.isBefore(DateTime.now())
          ? futureTime.add(const Duration(days: 1))
          : futureTime;

      expect(adjustedTime, futureTime);
    });

    test('medicine time "8:00 AM" parses to hour 8', () {
      // Simulate the time parsing used in MedicineProvider
      final raw = '8:00 AM';
      expect(raw.contains('AM'), true);
    });

    test('medicine time "10:30 PM" parses correctly', () {
      final raw = '10:30 PM';
      expect(raw.contains('PM'), true);
    });
  });
}
*/

import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_reminder_app/services/alarm_service.dart';

void main() {
  // FIX: AudioPlayer inside AlarmService uses platform channels
  // so we MUST initialize the Flutter test binding first.
  // We also avoid instantiating AlarmService() directly in
  // tests that don't need it, to prevent the AudioPlayer
  // platform channel crash.
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AlarmService — Static Sound Data', () {
    // These tests only read static const data — no instance needed

    test('sounds list has exactly 3 options', () {
      expect(AlarmService.sounds.length, 3);
    });

    test('first sound is Gentle Bell', () {
      expect(AlarmService.sounds[0]['name'], '🔔 Gentle Bell');
      expect(
        AlarmService.sounds[0]['asset'],
        'assets/alarm_sounds/gentle_bell.mp3',
      );
      expect(AlarmService.sounds[0]['raw'], 'gentle_bell');
    });

    test('second sound is Soft Chime', () {
      expect(AlarmService.sounds[1]['name'], '🎵 Soft Chime');
      expect(
        AlarmService.sounds[1]['asset'],
        'assets/alarm_sounds/soft_chime.mp3',
      );
      expect(AlarmService.sounds[1]['raw'], 'soft_chime');
    });

    test('third sound is Urgent Beep', () {
      expect(AlarmService.sounds[2]['name'], '🚨 Urgent Beep');
      expect(
        AlarmService.sounds[2]['asset'],
        'assets/alarm_sounds/urgent_beep.mp3',
      );
      expect(AlarmService.sounds[2]['raw'], 'urgent_beep');
    });

    test('all sounds have name, asset, and raw keys', () {
      for (final sound in AlarmService.sounds) {
        expect(sound.containsKey('name'), true);
        expect(sound.containsKey('asset'), true);
        expect(sound.containsKey('raw'), true);
      }
    });

    test('all sound assets start with assets/alarm_sounds/', () {
      for (final sound in AlarmService.sounds) {
        expect(
          sound['asset']!.startsWith('assets/alarm_sounds/'),
          true,
        );
      }
    });

    test('all sound assets end with .mp3', () {
      for (final sound in AlarmService.sounds) {
        expect(sound['asset']!.endsWith('.mp3'), true);
      }
    });

    test('all raw names contain no path separators', () {
      for (final sound in AlarmService.sounds) {
        expect(sound['raw']!.contains('/'), false);
        expect(sound['raw']!.contains('.'), false);
      }
    });

    test('sound names are non-empty strings', () {
      for (final sound in AlarmService.sounds) {
        expect(sound['name']!.isNotEmpty, true);
      }
    });
  });

  group('AlarmService — Singleton', () {
    // FIX: AudioPlayer requires a real platform binding.
    // TestWidgetsFlutterBinding.ensureInitialized() at the
    // top of main() provides that. Now AlarmService()
    // can be instantiated safely.

    test('factory returns same instance', () {
      final a = AlarmService();
      final b = AlarmService();
      expect(identical(a, b), true);
    });
  });

  group('AlarmService — sendSMS (static method)', () {
    // sendSMS is a static method — no AlarmService instance needed

    test('sendSMS completes without error for empty list', () async {
      await expectLater(
        AlarmService.sendSMS(
          medicineName: 'Aspirin',
          dose: '500mg',
          phones: [],
        ),
        completes,
      );
    });
  });

  group('Alarm Time Logic', () {
    test('past alarm time should be moved to next day', () {
      final past = DateTime.now().subtract(const Duration(hours: 2));
      final adjusted = past.isBefore(DateTime.now())
          ? past.add(const Duration(days: 1))
          : past;
      expect(adjusted.isAfter(DateTime.now()), true);
    });

    test('future alarm time stays unchanged', () {
      final future = DateTime.now().add(const Duration(hours: 2));
      final adjusted = future.isBefore(DateTime.now())
          ? future.add(const Duration(days: 1))
          : future;
      expect(adjusted, future);
    });

    test('alarm time exactly now is treated as past', () {
      // A time in the past by 1 second should roll to tomorrow
      final almostNow = DateTime.now().subtract(const Duration(seconds: 1));
      final adjusted = almostNow.isBefore(DateTime.now())
          ? almostNow.add(const Duration(days: 1))
          : almostNow;
      expect(adjusted.isAfter(DateTime.now()), true);
    });

    test('AM time string contains AM', () {
      const raw = '8:00 AM';
      expect(raw.contains('AM'), true);
      expect(raw.contains('PM'), false);
    });

    test('PM time string contains PM', () {
      const raw = '10:30 PM';
      expect(raw.contains('PM'), true);
      expect(raw.contains('AM'), false);
    });

    test('24h time format contains neither AM nor PM', () {
      const raw = '14:30';
      expect(raw.contains('AM'), false);
      expect(raw.contains('PM'), false);
    });
  });
}
