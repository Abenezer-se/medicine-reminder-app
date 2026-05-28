

// lib/models/emergency_contact.dart
import 'package:hive_ce/hive.dart';

part 'emergency_contact.g.dart';

@HiveType(typeId: 1)
class EmergencyContact extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late String relation;

  @HiveField(2)
  late String phone;

  EmergencyContact({
    required this.name,
    required this.relation,
    required this.phone,
  });
}
