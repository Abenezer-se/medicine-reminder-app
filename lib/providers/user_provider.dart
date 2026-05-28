
// lib/providers/user_provider.dart
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

class UserProvider extends ChangeNotifier {
  final Box _userBox = Hive.box('userBox');

  String get userName => _userBox.get('user_name', defaultValue: '') as String;
  String get userEmail =>
      _userBox.get('user_email', defaultValue: '') as String;


  UserProvider() {
    // Box is already opened in main.dart
  }
  

  Future<void> updateUser({required String name, required String email}) async {
    await _userBox.put('user_name', name.trim());
    await _userBox.put('user_email', email.trim());
    notifyListeners();
  }
}
