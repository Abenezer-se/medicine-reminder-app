
// lib/providers/emergency_provider.dart
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import '../models/emergency_contact.dart';

class EmergencyProvider extends ChangeNotifier {
  final Box<EmergencyContact> _box = Hive.box<EmergencyContact>('emergencyBox');

  List<EmergencyContact> get contacts => _box.values.toList();

  EmergencyProvider() {
    // Box is opened in main.dart
  }

  void addContact(EmergencyContact contact) {
    _box.add(contact);
    notifyListeners();
  }

  void removeContact(EmergencyContact contact) {
    final key = _box.keys.firstWhere((k) => _box.get(k) == contact);
    _box.delete(key);
    notifyListeners();
  }

  void clearAll() async {
    await _box.clear();
    notifyListeners();
  }
}
