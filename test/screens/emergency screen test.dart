import 'package:flutter/material.dart'; 
import 'package:flutter_test/flutter_test.dart'; 
import 'package:provider/provider.dart'; 
import 'package:hive_ce_flutter/hive_ce_flutter.dart'; 
import 'package:medicine_reminder_app/models/emergency_contact.dart'; 
import 'package:medicine_reminder_app/models/medicine.dart'; 
import 'package:medicine_reminder_app/providers/emergency_provider.dart'; 
import 'package:medicine_reminder_app/providers/medicine_provider.dart'; 
import 'package:medicine_reminder_app/providers/theme_provider.dart'; 
import 'package:medicine_reminder_app/providers/setting_provider.dart'; 
import 'package:medicine_reminder_app/screen/emergency_screen.dart'; 
import 'dart:io'; 
 
void main() { 
  setUpAll(() async { 
    final tempDir = 
        await Directory.systemTemp.createTemp('hive_emergency_screen_test'); 
    Hive.init(tempDir.path); 
    Hive.registerAdapter(MedicineAdapter()); 
    Hive.registerAdapter(EmergencyContactAdapter()); 
    await Hive.openBox<Medicine>('medicines'); 
    await Hive.openBox<EmergencyContact>('emergencyBox'); 
    await Hive.openBox('settingsBox'); 
  }); 
 
  setUp(() { 
    Hive.box<EmergencyContact>('emergencyBox').clear(); 
    Hive.box('settingsBox').clear(); 
  }); 
 
  tearDownAll(() async { 
    await Hive.close(); 
  }); 
 
  Widget buildEmergencyScreen() { 
    return MultiProvider( 
      providers: [ 
        ChangeNotifierProvider(create: (_) => ThemeProvider()), 
        ChangeNotifierProvider(create: (_) => SettingsProvider()), 
        ChangeNotifierProvider(create: (_) => MedicineProvider()), 
        ChangeNotifierProvider(create: (_) => EmergencyProvider()), 
      ], 
      child: const MaterialApp(home: EmergencyScreen()), 
    ); 
  } 
 
  group('EmergencyScreen', () { 
    testWidgets('shows Emergency in app bar', (tester) async { 
      await tester.pumpWidget(buildEmergencyScreen()); 
      await tester.pump(); 
 
      expect(find.text('Emergency'), findsOneWidget); 
    }); 
 
    testWidgets('shows Emergency Alert button', (tester) async { 
      await tester.pumpWidget(buildEmergencyScreen()); 
      await tester.pump(); 
 
      expect(find.text('Emergency Alert'), findsOneWidget); 
    }); 
 
    testWidgets('shows Send Emergency Alert button', (tester) async { 
      await tester.pumpWidget(buildEmergencyScreen()); 
      await tester.pump(); 
 
      expect(find.text('Send Emergency Alert'), findsOneWidget); 
    }); 
 
    testWidgets('shows Emergency Contacts heading', (tester) async { 
      await tester.pumpWidget(buildEmergencyScreen()); 
      await tester.pump(); 
 
      expect(find.text('Emergency Contacts'), findsOneWidget); 
    }); 
 
    testWidgets('shows no contacts message when empty', (tester) async { 
      await tester.pumpWidget(buildEmergencyScreen()); 
      await tester.pump(); 
 
      expect( 
        find.text('No emergency contacts yet'), 
        findsOneWidget, 
      ); 
    }); 
 
    testWidgets('shows Add button', (tester) async { 
      await tester.pumpWidget(buildEmergencyScreen()); 
      await tester.pump(); 
 
      expect(find.text('Add'), findsOneWidget); 
    }); 
 
    testWidgets('tapping Add opens dialog', (tester) async { 
      await tester.pumpWidget(buildEmergencyScreen()); 
      await tester.pump(); 
 
      await tester.tap(find.text('Add')); 
      await tester.pump(); 
 
      expect(find.text('Add Contact'), findsOneWidget); 
    }); 
 
    testWidgets('Add Contact dialog has name field', (tester) async { 
      await tester.pumpWidget(buildEmergencyScreen()); 
      await tester.pump(); 
 
      await tester.tap(find.text('Add')); 
      await tester.pump(); 
 
      expect(find.text('Full Name'), findsOneWidget); 
    }); 
 
    testWidgets('Add Contact dialog has phone field', (tester) async {
      await tester.pumpWidget(buildEmergencyScreen()); 
      await tester.pump(); 
 
      await tester.tap(find.text('Add')); 
      await tester.pump(); 
 
      expect(find.text('Phone Number'), findsOneWidget); 
    }); 
 
    testWidgets('shows Ambulance quick action', (tester) async { 
      await tester.pumpWidget(buildEmergencyScreen()); 
      await tester.pump(); 
 
      expect(find.text('Ambulance'), findsOneWidget); 
    }); 
 
    testWidgets('shows Health Hotline quick action', (tester) async { 
      await tester.pumpWidget(buildEmergencyScreen()); 
      await tester.pump(); 
 
      expect(find.text('Health Hotline'), findsOneWidget); 
    }); 
  }); 
}