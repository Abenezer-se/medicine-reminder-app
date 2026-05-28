

// lib/providers/medicine_provider.dart
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:intl/intl.dart';
import '../models/medicine.dart';
import '../services/alarm_service.dart';

class MedicineProvider extends ChangeNotifier {
  final Box<Medicine> _box = Hive.box<Medicine>('medicines');

  List<Medicine> get medicines => _box.values.toList();

  // FIX: Make this method async so we can capture the exact auto-generated Hive key
  Future<void> addMedicine({
    required String name,
    required String dose,
    required String frequency,
    required String time,
    required int remainingDoses,
    required String startDate,
    required String endDate,
    String alarmSound = 'assets/alarm_sounds/gentle_bell.mp3',
    bool vibrateEnabled = true,
  }) async {
    final medicine = Medicine(
      name: name,
      dose: dose,
      frequency: frequency,
      time: time,
      remainingDoses: remainingDoses,
      startDate: startDate,
      endDate: endDate,
      alarmSound: alarmSound,
      vibrateEnabled: vibrateEnabled,
    );

    // Using await ensures Hive writes the data and populates medicine.key properly
    await _box.add(medicine);
    notifyListeners();
    _scheduleAlarm(medicine);
  }

  void updateStatus(Medicine medicine, String status) {
    medicine.status = status;
    medicine.save();
    notifyListeners();
  }

  void updateMedicine(
    Medicine medicine, {
    required String name,
    required String dose,
    required String frequency,
    required String time,
    required String startDate,
    required String endDate,
  }) {
    // Generate fallback fallback if key is missing safely
    final int alarmId = medicine.key?.hashCode ?? medicine.hashCode;

    AlarmService().cancelAlarm(alarmId);

    medicine.name = name;
    medicine.dose = dose;
    medicine.frequency = frequency;
    medicine.time = time;
    medicine.startDate = startDate;
    medicine.endDate = endDate;
    medicine.save();
    notifyListeners();
    _scheduleAlarm(medicine);
  }

  void deleteMedicine(Medicine medicine) {
    final int alarmId = medicine.key?.hashCode ?? medicine.hashCode;
    AlarmService().cancelAlarm(alarmId);
    medicine.delete();
    notifyListeners();
  }

  // FIX: Collect all active medicine IDs and pass them to cancelAll()
  Future<void> deleteAll() async {
    final List<int> alarmIds = _box.values
        .map((medicine) => medicine.key?.hashCode ?? medicine.hashCode)
        .toList();

    await AlarmService().cancelAll(alarmIds);
    await _box.clear();
    notifyListeners();
  }

  void _scheduleAlarm(Medicine medicine) {
    try {
      final raw = medicine.time.trim();
      DateTime parsed;
      if (raw.contains('AM') || raw.contains('PM')) {
        parsed = DateFormat('h:mm a').parse(raw);
      } else {
        parsed = DateFormat('H:mm').parse(raw);
      }

      final now = DateTime.now();
      final alarmTime = DateTime(
        now.year,
        now.month,
        now.day,
        parsed.hour,
        parsed.minute,
      );

      // FIX: Secure fallback ID mapping strategy if the hive key isn't registered yet
      final int alarmId = medicine.key?.hashCode ?? medicine.hashCode;

      AlarmService().scheduleAlarm(
        id: alarmId,
        medicineName: medicine.name,
        dose: medicine.dose,
        dateTime: alarmTime,
        assetAudioPath: medicine.alarmSound,
        vibrate: medicine.vibrateEnabled,
      );
    } catch (e) {
      debugPrint('Alarm error: $e');
    }
  }
}
