import 'package:flutter_test/flutter_test.dart'; 
import 'package:flutter/material.dart'; 
import 'package:hive_ce_flutter/hive_ce_flutter.dart'; 
import 'package:medicine_reminder_app/providers/theme_provider.dart'; 
import 'dart:io'; 
 
void main() { 
  setUpAll(() async { 
    final tempDir = await Directory.systemTemp.createTemp('hive_theme_test'); 
    Hive.init(tempDir.path); 
    await Hive.openBox('settingsBox'); 
  }); 
 
  setUp(() { 
    Hive.box('settingsBox').clear(); 
  }); 
 
  tearDownAll(() async { 
    await Hive.close(); 
  }); 
 
  group('ThemeProvider', () { 
    test('default isDark is false', () { 
      final provider = ThemeProvider(); 
      expect(provider.isDark, false); 
    }); 
 
    test('default themeMode is light', () { 
      final provider = ThemeProvider(); 
      expect(provider.themeMode, ThemeMode.light); 
    }); 
 
    test('toggleTheme sets isDark to true', () { 
      final provider = ThemeProvider(); 
      provider.toggleTheme(true); 
      expect(provider.isDark, true); 
    }); 
 
    test('toggleTheme sets themeMode to dark', () { 
      final provider = ThemeProvider(); 
      provider.toggleTheme(true); 
      expect(provider.themeMode, ThemeMode.dark); 
    }); 
 
    test('toggleTheme false sets isDark to false', () { 
      final provider = ThemeProvider(); 
      provider.toggleTheme(true); 
      provider.toggleTheme(false); 
      expect(provider.isDark, false); 
    }); 
 
    test('dark mode persists in Hive', () { 
      final provider1 = ThemeProvider(); 
      provider1.toggleTheme(true); 
 
      final provider2 = ThemeProvider(); 
      expect(provider2.isDark, true); 
    }); 
 
    test('light mode persists in Hive', () { 
      final provider1 = ThemeProvider(); 
      provider1.toggleTheme(true); 
      provider1.toggleTheme(false); 
 
      final provider2 = ThemeProvider(); 
      expect(provider2.isDark, false); 
    }); 
  }); 
}