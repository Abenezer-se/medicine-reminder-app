

// lib/providers/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

class ThemeProvider extends ChangeNotifier {
  final Box _box = Hive.box('settingsBox');

  bool get isDark => _box.get('isDark', defaultValue: false) as bool;

  ThemeMode get themeMode => isDark ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme(bool value) {
    _box.put('isDark', value);
    notifyListeners();
  }
}
