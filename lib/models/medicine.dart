// lib/models/medicine.dart
import 'package:hive_ce/hive.dart';

part 'medicine.g.dart';

@HiveType(typeId: 0)
class Medicine extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late String dose;

  @HiveField(2)
  late String frequency;

  @HiveField(3)
  late String time;

  @HiveField(4)
  late int remainingDoses;

  @HiveField(5)
  late String startDate;

  @HiveField(6)
  late String endDate;

  @HiveField(7)
  late String status;

  @HiveField(8)
  late String alarmSound;

  @HiveField(9)
  late bool vibrateEnabled;

  Medicine({
    required this.name,
    required this.dose,
    required this.frequency,
    required this.time,
    required this.remainingDoses,
    required this.startDate,
    required this.endDate,
    this.status = "pending",
    this.alarmSound = 'assets/alarm_sounds/gentle_bell.mp3',
    this.vibrateEnabled = true,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      name: json['name'] ?? '',
      dose: json['dose'] ?? '',
      frequency: json['frequency'] ?? '',
      time: json['time'] ?? '',
      remainingDoses: json['remainingDoses'] ?? 7,
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      status: json['status'] ?? "pending",
    );
  }
}
