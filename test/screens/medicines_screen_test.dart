// FIX: the file had no top-level main() function which
// caused the "Undefined name 'main'" compile error.
// Every test file MUST have void main() { ... }

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:medicine_reminder_app/models/medicine.dart';
import 'package:medicine_reminder_app/models/emergency_contact.dart';
import 'package:medicine_reminder_app/providers/medicine_provider.dart';
import 'package:medicine_reminder_app/providers/theme_provider.dart';
import 'package:medicine_reminder_app/providers/setting_provider.dart';
import 'package:medicine_reminder_app/providers/emergency_provider.dart';
import 'package:medicine_reminder_app/screen/medicines.dart';
import 'dart:io';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUpAll(() async {
    tempDir =
        await Directory.systemTemp.createTemp('hive_medicines_screen_test');
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(MedicineAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(EmergencyContactAdapter());
    }
    await Hive.openBox<Medicine>('medicines');
    await Hive.openBox<EmergencyContact>('emergencyBox');
    await Hive.openBox('settingsBox');
  });

  setUp(() async {
    await Hive.box<Medicine>('medicines').clear();
    await Hive.box('settingsBox').clear();
  });

  tearDownAll(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  Widget buildMedicinesScreen() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => MedicineProvider()),
        ChangeNotifierProvider(create: (_) => EmergencyProvider()),
      ],
      child: const MaterialApp(home: MedicinesScreen()),
    );
  }

  group('MedicinesScreen', () {
    testWidgets('shows Medicines in app bar', (tester) async {
      await tester.pumpWidget(buildMedicinesScreen());
      await tester.pump();
      expect(find.text('Medicines'), findsOneWidget);
    });

    testWidgets('shows empty state when no medicines', (tester) async {
      await tester.pumpWidget(buildMedicinesScreen());
      await tester.pump();
      expect(find.text('No medicines yet'), findsOneWidget);
    });

    testWidgets('shows Add Medicine FAB', (tester) async {
      await tester.pumpWidget(buildMedicinesScreen());
      await tester.pump();
      expect(find.text('Add Medicine'), findsOneWidget);
    });

    testWidgets('shows summary pills in header', (tester) async {
      await tester.pumpWidget(buildMedicinesScreen());
      await tester.pump();
      expect(find.text('Total'), findsOneWidget);
      expect(find.text('Taken'), findsOneWidget);
      expect(find.text('Pending'), findsOneWidget);
    });

    testWidgets('shows notification bell icon', (tester) async {
      await tester.pumpWidget(buildMedicinesScreen());
      await tester.pump();
      expect(find.byIcon(Icons.notifications), findsOneWidget);
    });

    testWidgets('FAB add icon is visible', (tester) async {
      await tester.pumpWidget(buildMedicinesScreen());
      await tester.pump();
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('tapping FAB opens AddMedicineSheet', (tester) async {
      await tester.pumpWidget(buildMedicinesScreen());
      await tester.pump();
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(find.text('Add Medicine'), findsOneWidget);
    });

    testWidgets('shows encourage message in empty state', (tester) async {
      await tester.pumpWidget(buildMedicinesScreen());
      await tester.pump();
      expect(
        find.text('Tap + to add your first medicine'),
        findsOneWidget,
      );
    });
  });
}
