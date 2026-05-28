import 'package:flutter/material.dart'; 
import 'package:flutter_test/flutter_test.dart'; 
import 'package:provider/provider.dart'; 
import 'package:hive_ce_flutter/hive_ce_flutter.dart'; 
import 'package:medicine_reminder_app/models/medicine.dart'; 
import 'package:medicine_reminder_app/models/emergency_contact.dart'; 
import 'package:medicine_reminder_app/providers/medicine_provider.dart'; 
import 'package:medicine_reminder_app/providers/user_provider.dart'; 
import 'package:medicine_reminder_app/providers/theme_provider.dart'; 
import 'package:medicine_reminder_app/providers/setting_provider.dart'; 
import 'package:medicine_reminder_app/providers/emergency_provider.dart'; 
import 'package:medicine_reminder_app/screen/home_screen.dart'; 
import 'dart:io'; 
 
void main() { 
  setUpAll(() async { 
    final tempDir = await Directory.systemTemp.createTemp('hive_home_test'); 
    Hive.init(tempDir.path); 
    Hive.registerAdapter(MedicineAdapter()); 
    Hive.registerAdapter(EmergencyContactAdapter()); 
    await Hive.openBox<Medicine>('medicines'); 
    await Hive.openBox<EmergencyContact>('emergencyBox'); 
    await Hive.openBox('userBox'); 
    await Hive.openBox('settingsBox'); 
  }); 
 
  setUp(() { 
    Hive.box<Medicine>('medicines').clear(); 
    Hive.box('userBox').clear(); 
    Hive.box('settingsBox').clear(); 
  }); 
 
  tearDownAll(() async { 
    await Hive.close(); 
  }); 
 
  Widget buildHomeScreen() { 
    return MultiProvider( 
      providers: [ 
        ChangeNotifierProvider(create: (_) => ThemeProvider()), 
        ChangeNotifierProvider(create: (_) => SettingsProvider()), 
        ChangeNotifierProvider(create: (_) => MedicineProvider()), 
        ChangeNotifierProvider(create: (_) => UserProvider()), 
        ChangeNotifierProvider(create: (_) => EmergencyProvider()), 
      ], 
      child: const MaterialApp( 
        home: HomeScreen(), 
      ), 
    ); 
  } 
 
  group('HomeScreen', () { 
    testWidgets('shows MediCare in app bar', (tester) async { 
      await tester.pumpWidget(buildHomeScreen()); 
      await tester.pump(); 
 
      expect(find.text('MediCare'), findsOneWidget); 
    }); 
 
    testWidgets('shows empty state message when no medicines', (tester) async { 
      await tester.pumpWidget(buildHomeScreen()); 
      await tester.pump(); 
 
      expect( 
        find.text('No medicines added yet'), 
        findsOneWidget, 
      ); 
    }); 
 
    testWidgets('shows stat cards', (tester) async { 
      await tester.pumpWidget(buildHomeScreen()); 
      await tester.pump(); 
 
      expect(find.text('Total'), findsOneWidget); 
      expect(find.text('Taken'), findsOneWidget); 
      expect(find.text('Pending'), findsOneWidget); 
      expect(find.text('Skipped'), findsOneWidget); 
    }); 
 
    testWidgets('shows Today\'s Schedule heading', (tester) async { 
      await tester.pumpWidget(buildHomeScreen()); 
      await tester.pump(); 
 
      expect(find.text("Today's Schedule"), findsOneWidget); 
    }); 
 
    testWidgets('shows Add Medicine FAB button', (tester) async { 
      await tester.pumpWidget(buildHomeScreen()); 
      await tester.pump(); 
 
      expect(find.text('Add Medicine'), findsWidgets); 
    }); 
 
    testWidgets('shows greeting text', (tester) async { 
      await tester.pumpWidget(buildHomeScreen()); 
      await tester.pump(); 
 
      // Should show Good Morning, Good Afternoon, or Good Evening 
      final greetingFinder = find.textContaining('Good'); 
      expect(greetingFinder, findsOneWidget); 
    }); 
 
    testWidgets('notification bell icon is present', (tester) async { 
      await tester.pumpWidget(buildHomeScreen()); 
      await tester.pump(); 
 
      expect(find.byIcon(Icons.notifications), findsOneWidget); 
    }); 
  }); 
}