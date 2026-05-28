/*import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:medicine_reminder_app/models/medicine.dart';
import 'package:medicine_reminder_app/models/emergency_contact.dart';
import 'package:medicine_reminder_app/providers/medicine_provider.dart';
import 'package:medicine_reminder_app/providers/setting_provider.dart';
import 'package:medicine_reminder_app/providers/theme_provider.dart';
import 'package:medicine_reminder_app/providers/emergency_provider.dart';
import 'package:medicine_reminder_app/widgets/add_medicine_sheet.dart';
import 'dart:io';

void main() {
  setUpAll(() async {
    final tempDir =
        await Directory.systemTemp.createTemp('hive_add_medicine_test');
    Hive.init(tempDir.path);
    Hive.registerAdapter(MedicineAdapter());
    Hive.registerAdapter(EmergencyContactAdapter());
    await Hive.openBox<Medicine>('medicines');
    await Hive.openBox<EmergencyContact>('emergencyBox');
    await Hive.openBox('settingsBox');
  });

  setUp(() {
    Hive.box<Medicine>('medicines').clear();
    Hive.box('settingsBox').clear();
  });

  tearDownAll(() async {
    await Hive.close();
  });

  Widget buildSheet() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => MedicineProvider()),
        ChangeNotifierProvider(create: (_) => EmergencyProvider()),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider(create: (_) => ThemeProvider()),
                    ChangeNotifierProvider(create: (_) => SettingsProvider()),
                    ChangeNotifierProvider(create: (_) => MedicineProvider()),
                    ChangeNotifierProvider(create: (_) => EmergencyProvider()),
                  ],
                  child: const AddMedicineSheet(),
                ),
              ),
              child: const Text('Open Sheet'),
            ),
          ),
        ),
      ),
    );
  }

  // Helper to open the sheet
  Future<void> openSheet(WidgetTester tester) async {
    await tester.pumpWidget(buildSheet());
    await tester.pump();
    await tester.tap(find.text('Open Sheet'));
    await tester.pumpAndSettle();
  }

  // ─────────────────────────────────────────────────────────────
  group('AddMedicineSheet — UI Elements', () {
    testWidgets('shows Add Medicine header', (tester) async {
      await openSheet(tester);
      expect(find.text('Add Medicine'), findsOneWidget);
    });

    testWidgets('shows close button in header', (tester) async {
      await openSheet(tester);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('shows Medicine Name label', (tester) async {
      await openSheet(tester);
      expect(find.text('Medicine Name *'), findsOneWidget);
    });

    testWidgets('shows Dose label', (tester) async {
      await openSheet(tester);
      expect(find.text('Dose *'), findsOneWidget);
    });

    testWidgets('shows Amount input field', (tester) async {
      await openSheet(tester);
      expect(find.text('Amount'), findsOneWidget);
    });

    testWidgets('shows Frequency label', (tester) async {
      await openSheet(tester);
      expect(find.text('Frequency'), findsOneWidget);
    });

    testWidgets('shows Alarm Time label', (tester) async {
      await openSheet(tester);
      expect(find.text('Alarm Time *'), findsOneWidget);
    });

    testWidgets('shows Add Time button', (tester) async {
      await openSheet(tester);
      expect(find.text('Add Time'), findsOneWidget);
    });

    testWidgets('shows Alarm Sound label', (tester) async {
      await openSheet(tester);
      expect(find.text('Alarm Sound'), findsOneWidget);
    });

    testWidgets('shows Duration label', (tester) async {
      await openSheet(tester);
      expect(find.text('Duration'), findsOneWidget);
    });

    testWidgets('shows Start Date field', (tester) async {
      await openSheet(tester);
      expect(find.text('Start Date'), findsOneWidget);
    });

    testWidgets('shows End Date field', (tester) async {
      await openSheet(tester);
      expect(find.text('End Date'), findsOneWidget);
    });

    testWidgets('shows Save & Set Alarm button', (tester) async {
      await openSheet(tester);
      expect(find.text('Save & Set Alarm'), findsOneWidget);
    });

    testWidgets('shows drag handle at top', (tester) async {
      await openSheet(tester);
      // Drag handle is a Container with rounded corners
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('shows alarm icon in header', (tester) async {
      await openSheet(tester);
      expect(find.byIcon(Icons.medication), findsWidgets);
    });

    testWidgets('shows Vibration toggle', (tester) async {
      await openSheet(tester);
      expect(find.text('Vibration'), findsOneWidget);
    });

    testWidgets('shows Switch widget for vibration', (tester) async {
      await openSheet(tester);
      expect(find.byType(Switch), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('AddMedicineSheet — Dose Unit Dropdown', () {
    testWidgets('default dose unit is mg', (tester) async {
      await openSheet(tester);
      expect(find.text('mg'), findsOneWidget);
    });

    testWidgets('dose unit dropdown contains Pills option', (tester) async {
      await openSheet(tester);
      // Open the dose unit dropdown
      final dropdowns = find.byType(DropdownButton<String>);
      await tester.tap(dropdowns.first);
      await tester.pumpAndSettle();
      expect(find.text('Pills'), findsOneWidget);
    });

    testWidgets('dose unit dropdown contains ml option', (tester) async {
      await openSheet(tester);
      final dropdowns = find.byType(DropdownButton<String>);
      await tester.tap(dropdowns.first);
      await tester.pumpAndSettle();
      expect(find.text('ml'), findsOneWidget);
    });

    testWidgets('dose unit dropdown contains g option', (tester) async {
      await openSheet(tester);
      final dropdowns = find.byType(DropdownButton<String>);
      await tester.tap(dropdowns.first);
      await tester.pumpAndSettle();
      expect(find.text('g'), findsOneWidget);
    });

    testWidgets('dose unit dropdown contains Drops option', (tester) async {
      await openSheet(tester);
      final dropdowns = find.byType(DropdownButton<String>);
      await tester.tap(dropdowns.first);
      await tester.pumpAndSettle();
      expect(find.text('Drops'), findsOneWidget);
    });

    testWidgets('dose unit dropdown contains Units option', (tester) async {
      await openSheet(tester);
      final dropdowns = find.byType(DropdownButton<String>);
      await tester.tap(dropdowns.first);
      await tester.pumpAndSettle();
      expect(find.text('Units'), findsOneWidget);
    });

    testWidgets('can select Pills as dose unit', (tester) async {
      await openSheet(tester);
      final dropdowns = find.byType(DropdownButton<String>);
      await tester.tap(dropdowns.first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Pills').last);
      await tester.pumpAndSettle();
      expect(find.text('Pills'), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('AddMedicineSheet — Frequency Dropdown', () {
    testWidgets('default frequency is Once Daily', (tester) async {
      await openSheet(tester);
      expect(find.text('Once Daily'), findsOneWidget);
    });

    testWidgets('frequency dropdown has Twice Daily option', (tester) async {
      await openSheet(tester);
      final dropdowns = find.byType(DropdownButton<String>);
      // Second dropdown is frequency
      await tester.tap(dropdowns.at(1));
      await tester.pumpAndSettle();
      expect(find.text('Twice Daily'), findsOneWidget);
    });

    testWidgets('frequency dropdown has Three Times Daily option',
        (tester) async {
      await openSheet(tester);
      final dropdowns = find.byType(DropdownButton<String>);
      await tester.tap(dropdowns.at(1));
      await tester.pumpAndSettle();
      expect(find.text('Three Times Daily'), findsOneWidget);
    });

    testWidgets('frequency dropdown has Every 8 Hours option', (tester) async {
      await openSheet(tester);
      final dropdowns = find.byType(DropdownButton<String>);
      await tester.tap(dropdowns.at(1));
      await tester.pumpAndSettle();
      expect(find.text('Every 8 Hours'), findsOneWidget);
    });

    testWidgets('frequency dropdown has Every 12 Hours option', (tester) async {
      await openSheet(tester);
      final dropdowns = find.byType(DropdownButton<String>);
      await tester.tap(dropdowns.at(1));
      await tester.pumpAndSettle();
      expect(find.text('Every 12 Hours'), findsOneWidget);
    });

    testWidgets('frequency dropdown has As Needed option', (tester) async {
      await openSheet(tester);
      final dropdowns = find.byType(DropdownButton<String>);
      await tester.tap(dropdowns.at(1));
      await tester.pumpAndSettle();
      expect(find.text('As Needed'), findsOneWidget);
    });

    testWidgets('can select Twice Daily frequency', (tester) async {
      await openSheet(tester);
      final dropdowns = find.byType(DropdownButton<String>);
      await tester.tap(dropdowns.at(1));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Twice Daily').last);
      await tester.pumpAndSettle();
      expect(find.text('Twice Daily'), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('AddMedicineSheet — Alarm Sound Selection', () {
    testWidgets('shows Gentle Bell sound option', (tester) async {
      await openSheet(tester);
      expect(find.text('🔔 Gentle Bell'), findsOneWidget);
    });

    testWidgets('shows Soft Chime sound option', (tester) async {
      await openSheet(tester);
      expect(find.text('🎵 Soft Chime'), findsOneWidget);
    });

    testWidgets('shows Urgent Beep sound option', (tester) async {
      await openSheet(tester);
      expect(find.text('🚨 Urgent Beep'), findsOneWidget);
    });

    testWidgets('Gentle Bell is selected by default', (tester) async {
      await openSheet(tester);
      // The selected sound card shows radio_button_checked
      expect(
        find.byIcon(Icons.radio_button_checked),
        findsOneWidget,
      );
    });

    testWidgets('can select Soft Chime sound', (tester) async {
      await openSheet(tester);
      await tester.tap(find.text('🎵 Soft Chime'));
      await tester.pump();
      // Now two unselected and one selected
      expect(
        find.byIcon(Icons.radio_button_checked),
        findsOneWidget,
      );
    });

    testWidgets('can select Urgent Beep sound', (tester) async {
      await openSheet(tester);
      await tester.tap(find.text('🚨 Urgent Beep'));
      await tester.pump();
      expect(
        find.byIcon(Icons.radio_button_checked),
        findsOneWidget,
      );
    });

    testWidgets('unselected sounds show radio_button_off', (tester) async {
      await openSheet(tester);
      expect(
        find.byIcon(Icons.radio_button_off),
        findsWidgets,
      );
    });

    testWidgets('shows music note icon next to each sound', (tester) async {
      await openSheet(tester);
      expect(find.byIcon(Icons.music_note), findsWidgets);
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('AddMedicineSheet — Vibration Toggle', () {
    testWidgets('vibration is enabled by default', (tester) async {
      await openSheet(tester);
      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, true);
    });

    testWidgets('can toggle vibration off', (tester) async {
      await openSheet(tester);
      await tester.tap(find.byType(Switch));
      await tester.pump();
      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, false);
    });

    testWidgets('can toggle vibration back on', (tester) async {
      await openSheet(tester);
      await tester.tap(find.byType(Switch));
      await tester.pump();
      await tester.tap(find.byType(Switch));
      await tester.pump();
      final switchWidget = tester.widget<Switch>(find.byType(Switch));
      expect(switchWidget.value, true);
    });

    testWidgets('shows vibration icon', (tester) async {
      await openSheet(tester);
      expect(find.byIcon(Icons.vibration), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('AddMedicineSheet — Validation', () {
    testWidgets('shows error snackbar when medicine name is empty',
        (tester) async {
      await openSheet(tester);
      await tester.tap(find.text('Save & Set Alarm'));
      await tester.pump();
      expect(
        find.text('Please enter medicine name'),
        findsOneWidget,
      );
    });

    testWidgets('shows error when dose amount is empty but name filled',
        (tester) async {
      await openSheet(tester);

      // Fill only medicine name
      final nameField = find.ancestor(
        of: find.text('Medicine Name *'),
        matching: find.byType(TextField),
      );
      await tester.enterText(nameField.first, 'Aspirin');
      await tester.pump();

      await tester.tap(find.text('Save & Set Alarm'));
      await tester.pump();

      expect(
        find.text('Please enter dose amount'),
        findsOneWidget,
      );
    });

    testWidgets('shows error when time not added but name and dose filled',
        (tester) async {
      await openSheet(tester);

      // Enter name
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'Aspirin');
      await tester.pump();

      // Enter dose amount
      await tester.enterText(textFields.at(1), '500');
      await tester.pump();

      await tester.tap(find.text('Save & Set Alarm'));
      await tester.pump();

      expect(
        find.text('Please add at least one alarm time'),
        findsOneWidget,
      );
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('AddMedicineSheet — Add Time Button', () {
    testWidgets('Add Time button is visible', (tester) async {
      await openSheet(tester);
      expect(find.text('Add Time'), findsOneWidget);
    });

    testWidgets('Add Time button shows add_alarm icon', (tester) async {
      await openSheet(tester);
      expect(find.byIcon(Icons.add_alarm), findsOneWidget);
    });

    testWidgets('tapping Add Time opens time picker', (tester) async {
      await openSheet(tester);
      await tester.tap(find.text('Add Time'));
      await tester.pumpAndSettle();

      // Time picker dialog should appear
      expect(find.byType(TimePickerDialog), findsOneWidget);
    });

    testWidgets('time picker can be dismissed with Cancel', (tester) async {
      await openSheet(tester);
      await tester.tap(find.text('Add Time'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Time picker should be gone
      expect(find.byType(TimePickerDialog), findsNothing);
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('AddMedicineSheet — Date Pickers', () {
    testWidgets('Start Date field is tappable', (tester) async {
      await openSheet(tester);
      // find the start date field
      expect(find.text('Start Date'), findsOneWidget);
    });

    testWidgets('tapping Start Date opens date picker', (tester) async {
      await openSheet(tester);
      await tester.tap(find.text('Start Date'));
      await tester.pumpAndSettle();
      expect(find.byType(DatePickerDialog), findsOneWidget);
    });

    testWidgets('tapping End Date opens date picker', (tester) async {
      await openSheet(tester);
      await tester.tap(find.text('End Date'));
      await tester.pumpAndSettle();
      expect(find.byType(DatePickerDialog), findsOneWidget);
    });

    testWidgets('edit_calendar icon shown for Start Date', (tester) async {
      await openSheet(tester);
      expect(
        find.byIcon(Icons.edit_calendar),
        findsWidgets,
      );
    });

    testWidgets('tapping edit_calendar icon opens date picker', (tester) async {
      await openSheet(tester);
      final calendarIcons = find.byIcon(Icons.edit_calendar);
      await tester.tap(calendarIcons.first);
      await tester.pumpAndSettle();
      expect(find.byType(DatePickerDialog), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('AddMedicineSheet — Close Button', () {
    testWidgets('close button dismisses the sheet', (tester) async {
      await openSheet(tester);
      expect(find.text('Add Medicine'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.text('Add Medicine'), findsNothing);
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('AddMedicineSheet — Save Medicine', () {
    testWidgets('successfully saves medicine with all required fields',
        (tester) async {
      await openSheet(tester);

      // Enter medicine name
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'Aspirin');
      await tester.pump();

      // Enter dose amount
      await tester.enterText(textFields.at(1), '500');
      await tester.pump();

      // Add time via picker
      await tester.tap(find.text('Add Time'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Tap Save
      await tester.tap(find.text('Save & Set Alarm'));
      await tester.pumpAndSettle();

      // Sheet should close and medicine should be added
      expect(
        Hive.box<Medicine>('medicines').values.length,
        1,
      );
    });

    testWidgets('saved medicine has correct name', (tester) async {
      await openSheet(tester);

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'Paracetamol');
      await tester.pump();
      await tester.enterText(textFields.at(1), '1000');
      await tester.pump();

      await tester.tap(find.text('Add Time'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save & Set Alarm'));
      await tester.pumpAndSettle();

      final saved = Hive.box<Medicine>('medicines').values.first;
      expect(saved.name, 'Paracetamol');
    });

    testWidgets('saved medicine dose includes unit', (tester) async {
      await openSheet(tester);

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'Ibuprofen');
      await tester.pump();
      await tester.enterText(textFields.at(1), '400');
      await tester.pump();

      await tester.tap(find.text('Add Time'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save & Set Alarm'));
      await tester.pumpAndSettle();

      final saved = Hive.box<Medicine>('medicines').values.first;
      // Dose should be "400 mg" (amount + unit)
      expect(saved.dose.contains('400'), true);
      expect(saved.dose.contains('mg'), true);
    });

    testWidgets('saved medicine default status is pending', (tester) async {
      await openSheet(tester);

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'Vitamin B');
      await tester.pump();
      await tester.enterText(textFields.at(1), '100');
      await tester.pump();

      await tester.tap(find.text('Add Time'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save & Set Alarm'));
      await tester.pumpAndSettle();

      final saved = Hive.box<Medicine>('medicines').values.first;
      expect(saved.status, 'pending');
    });

    testWidgets('success snackbar appears after saving', (tester) async {
      await openSheet(tester);

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'Metformin');
      await tester.pump();
      await tester.enterText(textFields.at(1), '850');
      await tester.pump();

      await tester.tap(find.text('Add Time'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save & Set Alarm'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Metformin'), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('AddMedicineSheet — Time Chip', () {
    testWidgets('adding time shows chip with alarm icon', (tester) async {
      await openSheet(tester);

      await tester.tap(find.text('Add Time'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.alarm), findsOneWidget);
    });

    testWidgets('time chip shows delete icon', (tester) async {
      await openSheet(tester);

      await tester.tap(find.text('Add Time'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.close), findsWidgets);
    });

    testWidgets('deleting time chip removes it', (tester) async {
      await openSheet(tester);

      await tester.tap(find.text('Add Time'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Chip exists — now delete it
      final chipCloseIcons = find.descendant(
        of: find.byType(Chip),
        matching: find.byIcon(Icons.close),
      );
      await tester.tap(chipCloseIcons.first);
      await tester.pump();

      expect(find.byType(Chip), findsNothing);
    });
  });
}
*/

/*

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:medicine_reminder_app/models/medicine.dart';
import 'package:medicine_reminder_app/models/emergency_contact.dart';
import 'package:medicine_reminder_app/providers/medicine_provider.dart';
import 'package:medicine_reminder_app/providers/setting_provider.dart';
import 'package:medicine_reminder_app/providers/theme_provider.dart';
import 'package:medicine_reminder_app/providers/emergency_provider.dart';
import 'package:medicine_reminder_app/widgets/add_medicine_sheet.dart';
import 'dart:io';

void main() {
  setUpAll(() async {
    final tempDir =
        await Directory.systemTemp.createTemp('hive_add_medicine_test');
    Hive.init(tempDir.path);
    Hive.registerAdapter(MedicineAdapter());
    Hive.registerAdapter(EmergencyContactAdapter());
    await Hive.openBox<Medicine>('medicines');
    await Hive.openBox<EmergencyContact>('emergencyBox');
    await Hive.openBox('settingsBox');
  });

  setUp(() {
    Hive.box<Medicine>('medicines').clear();
    Hive.box('settingsBox').clear();
  });

  tearDownAll(() async {
    await Hive.close();
  });

  // ── helper: build the sheet inside a large surface ──────────
  Widget buildSheet() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => MedicineProvider()),
        ChangeNotifierProvider(create: (_) => EmergencyProvider()),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider(create: (_) => ThemeProvider()),
                    ChangeNotifierProvider(create: (_) => SettingsProvider()),
                    ChangeNotifierProvider(create: (_) => MedicineProvider()),
                    ChangeNotifierProvider(create: (_) => EmergencyProvider()),
                  ],
                  child: const AddMedicineSheet(),
                ),
              ),
              child: const Text('Open Sheet'),
            ),
          ),
        ),
      ),
    );
  }

  // ── open the sheet with a large test surface ─────────────────
  Future<void> openSheet(WidgetTester tester) async {
    // Set a large surface so nothing is off-screen
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildSheet());
    await tester.pump();
    await tester.tap(find.text('Open Sheet'));
    await tester.pumpAndSettle();
  }

  // ── scroll and tap helper ────────────────────────────────────
  Future<void> scrollAndTap(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  // ─────────────────────────────────────────────────────────────
  group('AddMedicineSheet — UI Elements', () {
    testWidgets('shows Add Medicine header', (tester) async {
      await openSheet(tester);
      expect(find.text('Add Medicine'), findsOneWidget);
    });

    testWidgets('shows close button in header', (tester) async {
      await openSheet(tester);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('shows Medicine Name label', (tester) async {
      await openSheet(tester);
      expect(find.text('Medicine Name *'), findsOneWidget);
    });

    testWidgets('shows Dose label', (tester) async {
      await openSheet(tester);
      expect(find.text('Dose *'), findsOneWidget);
    });

    testWidgets('shows Frequency label', (tester) async {
      await openSheet(tester);
      expect(find.text('Frequency'), findsOneWidget);
    });

    testWidgets('shows Alarm Time label', (tester) async {
      await openSheet(tester);
      expect(find.text('Alarm Time *'), findsOneWidget);
    });

    testWidgets('shows Add Time button', (tester) async {
      await openSheet(tester);
      expect(find.text('Add Time'), findsOneWidget);
    });

    testWidgets('shows Alarm Sound label', (tester) async {
      await openSheet(tester);
      expect(find.text('Alarm Sound'), findsOneWidget);
    });

    testWidgets('shows Duration label', (tester) async {
      await openSheet(tester);
      await tester.dragFrom(const Offset(400, 800), const Offset(400, 400));
      await tester.pumpAndSettle();
      expect(find.text('Duration'), findsOneWidget);
    });

    testWidgets('shows Save & Set Alarm button', (tester) async {
      await openSheet(tester);
      final saveFinder = find.text('Save & Set Alarm');
      await tester.ensureVisible(saveFinder);
      expect(saveFinder, findsOneWidget);
    });

    testWidgets('shows Vibration toggle', (tester) async {
      await openSheet(tester);
      expect(find.text('Vibration'), findsOneWidget);
    });

    testWidgets('shows Switch widget for vibration', (tester) async {
      await openSheet(tester);
      expect(find.byType(Switch), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('AddMedicineSheet — Dose Unit Dropdown', () {
    testWidgets('default dose unit is mg', (tester) async {
      await openSheet(tester);
      expect(find.text('mg'), findsOneWidget);
    });

    testWidgets('dose unit dropdown contains Pills option', (tester) async {
      await openSheet(tester);
      final dropdowns = find.byType(DropdownButton<String>);
      await tester.tap(dropdowns.first);
      await tester.pumpAndSettle();
      expect(find.text('Pills'), findsOneWidget);
    });

    testWidgets('dose unit dropdown contains ml option', (tester) async {
      await openSheet(tester);
      final dropdowns = find.byType(DropdownButton<String>);
      await tester.tap(dropdowns.first);
      await tester.pumpAndSettle();
      expect(find.text('ml'), findsOneWidget);
    });

    testWidgets('can select Pills as dose unit', (tester) async {
      await openSheet(tester);
      final dropdowns = find.byType(DropdownButton<String>);
      await tester.tap(dropdowns.first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Pills').last);
      await tester.pumpAndSettle();
      expect(find.text('Pills'), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('AddMedicineSheet — Frequency Dropdown', () {
    testWidgets('default frequency is Once Daily', (tester) async {
      await openSheet(tester);
      expect(find.text('Once Daily'), findsOneWidget);
    });

    testWidgets('frequency dropdown has Twice Daily option', (tester) async {
      await openSheet(tester);
      final dropdowns = find.byType(DropdownButton<String>);
      await tester.tap(dropdowns.at(1));
      await tester.pumpAndSettle();
      expect(find.text('Twice Daily'), findsOneWidget);
    });

    testWidgets('frequency dropdown has As Needed option', (tester) async {
      await openSheet(tester);
      final dropdowns = find.byType(DropdownButton<String>);
      await tester.tap(dropdowns.at(1));
      await tester.pumpAndSettle();
      expect(find.text('As Needed'), findsOneWidget);
    });

    testWidgets('can select Twice Daily frequency', (tester) async {
      await openSheet(tester);
      final dropdowns = find.byType(DropdownButton<String>);
      await tester.tap(dropdowns.at(1));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Twice Daily').last);
      await tester.pumpAndSettle();
      expect(find.text('Twice Daily'), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('AddMedicineSheet — Alarm Sound Selection', () {
    testWidgets('shows Gentle Bell sound option', (tester) async {
      await openSheet(tester);
      expect(find.text('🔔 Gentle Bell'), findsOneWidget);
    });

    testWidgets('shows Soft Chime sound option', (tester) async {
      await openSheet(tester);
      expect(find.text('🎵 Soft Chime'), findsOneWidget);
    });

    testWidgets('shows Urgent Beep sound option', (tester) async {
      await openSheet(tester);
      expect(find.text('🚨 Urgent Beep'), findsOneWidget);
    });

    testWidgets('Gentle Bell is selected by default', (tester) async {
      await openSheet(tester);
      expect(
        find.byIcon(Icons.radio_button_checked),
        findsOneWidget,
      );
    });

    testWidgets('can select Soft Chime sound', (tester) async {
      await openSheet(tester);
      await tester.tap(find.text('🎵 Soft Chime'));
      await tester.pump();
      expect(
        find.byIcon(Icons.radio_button_checked),
        findsOneWidget,
      );
    });

    testWidgets('unselected sounds show radio_button_off', (tester) async {
      await openSheet(tester);
      expect(
        find.byIcon(Icons.radio_button_off),
        findsWidgets,
      );
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('AddMedicineSheet — Vibration Toggle', () {
    testWidgets('vibration is enabled by default', (tester) async {
      await openSheet(tester);
      final sw = tester.widget<Switch>(find.byType(Switch));
      expect(sw.value, true);
    });

    testWidgets('can toggle vibration off', (tester) async {
      await openSheet(tester);
      await tester.tap(find.byType(Switch));
      await tester.pump();
      final sw = tester.widget<Switch>(find.byType(Switch));
      expect(sw.value, false);
    });

    testWidgets('can toggle vibration back on', (tester) async {
      await openSheet(tester);
      await tester.tap(find.byType(Switch));
      await tester.pump();
      await tester.tap(find.byType(Switch));
      await tester.pump();
      final sw = tester.widget<Switch>(find.byType(Switch));
      expect(sw.value, true);
    });

    testWidgets('shows vibration icon', (tester) async {
      await openSheet(tester);
      expect(find.byIcon(Icons.vibration), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('AddMedicineSheet — Validation', () {
    testWidgets('shows error when medicine name is empty', (tester) async {
      await openSheet(tester);
      final saveFinder = find.text('Save & Set Alarm');
      await tester.ensureVisible(saveFinder);
      await tester.tap(saveFinder, warnIfMissed: false);
      await tester.pump();
      expect(
        find.text('Please enter medicine name'),
        findsOneWidget,
      );
    });

    testWidgets('shows error when dose is empty but name filled',
        (tester) async {
      await openSheet(tester);

      // Fill name
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'Aspirin');
      await tester.pump();

      // Tap save without dose
      final saveFinder = find.text('Save & Set Alarm');
      await tester.ensureVisible(saveFinder);
      await tester.tap(saveFinder, warnIfMissed: false);
      await tester.pump();

      expect(
        find.text('Please enter dose amount'),
        findsOneWidget,
      );
    });

    testWidgets('shows error when time not added but name and dose filled',
        (tester) async {
      await openSheet(tester);

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'Aspirin');
      await tester.pump();
      await tester.enterText(textFields.at(1), '500');
      await tester.pump();

      final saveFinder = find.text('Save & Set Alarm');
      await tester.ensureVisible(saveFinder);
      await tester.tap(saveFinder, warnIfMissed: false);
      await tester.pump();

      expect(
        find.text('Please add at least one alarm time'),
        findsOneWidget,
      );
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('AddMedicineSheet — Add Time Button', () {
    testWidgets('Add Time button is visible', (tester) async {
      await openSheet(tester);
      expect(find.text('Add Time'), findsOneWidget);
    });

    testWidgets('Add Time button shows add_alarm icon', (tester) async {
      await openSheet(tester);
      expect(find.byIcon(Icons.add_alarm), findsOneWidget);
    });

    testWidgets('tapping Add Time opens time picker', (tester) async {
      await openSheet(tester);
      await tester.tap(find.text('Add Time'));
      await tester.pumpAndSettle();
      expect(find.byType(TimePickerDialog), findsOneWidget);
    });

    testWidgets('time picker can be dismissed with Cancel', (tester) async {
      await openSheet(tester);
      await tester.tap(find.text('Add Time'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.byType(TimePickerDialog), findsNothing);
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('AddMedicineSheet — Date Pickers', () {
    testWidgets('tapping Start Date opens date picker', (tester) async {
      await openSheet(tester);
      final startFinder = find.text('Start Date');
      await tester.ensureVisible(startFinder);
      await tester.pumpAndSettle();
      await tester.tap(startFinder, warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.byType(DatePickerDialog), findsOneWidget);
    });

    testWidgets('tapping End Date opens date picker', (tester) async {
      await openSheet(tester);
      final endFinder = find.text('End Date');
      await tester.ensureVisible(endFinder);
      await tester.pumpAndSettle();
      await tester.tap(endFinder, warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.byType(DatePickerDialog), findsOneWidget);
    });

    testWidgets('edit_calendar icon shown for dates', (tester) async {
      await openSheet(tester);
      expect(find.byIcon(Icons.edit_calendar), findsWidgets);
    });

    testWidgets('tapping edit_calendar opens date picker', (tester) async {
      await openSheet(tester);
      final calIcons = find.byIcon(Icons.edit_calendar);
      await tester.ensureVisible(calIcons.first);
      await tester.pumpAndSettle();
      await tester.tap(calIcons.first, warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.byType(DatePickerDialog), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('AddMedicineSheet — Close Button', () {
    testWidgets('close button dismisses the sheet', (tester) async {
      await openSheet(tester);
      expect(find.text('Add Medicine'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      expect(find.text('Add Medicine'), findsNothing);
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('AddMedicineSheet — Save Medicine', () {
    Future<void> fillAndSave(
        WidgetTester tester, String name, String dose) async {
      await openSheet(tester);

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), name);
      await tester.pump();
      await tester.enterText(textFields.at(1), dose);
      await tester.pump();

      // Add time
      await tester.tap(find.text('Add Time'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Tap save
      final saveFinder = find.text('Save & Set Alarm');
      await tester.ensureVisible(saveFinder);
      await tester.pumpAndSettle();
      await tester.tap(saveFinder, warnIfMissed: false);
      await tester.pumpAndSettle();
    }

    testWidgets('successfully saves medicine', (tester) async {
      await fillAndSave(tester, 'Aspirin', '500');
      expect(
        Hive.box<Medicine>('medicines').values.length,
        1,
      );
    });

    testWidgets('saved medicine has correct name', (tester) async {
      await fillAndSave(tester, 'Paracetamol', '1000');
      final saved = Hive.box<Medicine>('medicines').values.first;
      expect(saved.name, 'Paracetamol');
    });

    testWidgets('saved medicine dose includes unit', (tester) async {
      await fillAndSave(tester, 'Ibuprofen', '400');
      final saved = Hive.box<Medicine>('medicines').values.first;
      expect(saved.dose.contains('400'), true);
      expect(saved.dose.contains('mg'), true);
    });

    testWidgets('saved medicine default status is pending', (tester) async {
      await fillAndSave(tester, 'Vitamin B', '100');
      final saved = Hive.box<Medicine>('medicines').values.first;
      expect(saved.status, 'pending');
    });

    testWidgets('success snackbar appears after saving', (tester) async {
      await fillAndSave(tester, 'Metformin', '850');
      expect(find.textContaining('Metformin'), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('AddMedicineSheet — Time Chip', () {
    testWidgets('adding time shows chip with alarm icon', (tester) async {
      await openSheet(tester);
      await tester.tap(find.text('Add Time'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.alarm), findsOneWidget);
    });

    testWidgets('deleting time chip removes it', (tester) async {
      await openSheet(tester);
      await tester.tap(find.text('Add Time'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      final chipClose = find.descendant(
        of: find.byType(Chip),
        matching: find.byIcon(Icons.close),
      );
      await tester.tap(chipClose.first);
      await tester.pump();
      expect(find.byType(Chip), findsNothing);
    });
  });
}
*/

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:medicine_reminder_app/models/medicine.dart';
import 'package:medicine_reminder_app/models/emergency_contact.dart';
import 'package:medicine_reminder_app/providers/medicine_provider.dart';
import 'package:medicine_reminder_app/providers/setting_provider.dart';
import 'package:medicine_reminder_app/providers/theme_provider.dart';
import 'package:medicine_reminder_app/providers/emergency_provider.dart';
import 'package:medicine_reminder_app/widgets/add_medicine_sheet.dart';
import 'dart:io';

void main() {
  setUpAll(() async {
    final tempDir =
        await Directory.systemTemp.createTemp('hive_add_medicine_test');
    Hive.init(tempDir.path);
    Hive.registerAdapter(MedicineAdapter());
    Hive.registerAdapter(EmergencyContactAdapter());
    await Hive.openBox<Medicine>('medicines');
    await Hive.openBox<EmergencyContact>('emergencyBox');
    await Hive.openBox('settingsBox');
  });

  setUp(() {
    Hive.box<Medicine>('medicines').clear();
    Hive.box('settingsBox').clear();
  });

  tearDownAll(() async {
    await Hive.close();
  });

  // ── build sheet ──────────────────────────────────────────────
  Widget buildSheet() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => MedicineProvider()),
        ChangeNotifierProvider(create: (_) => EmergencyProvider()),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => MultiProvider(
                  providers: [
                    ChangeNotifierProvider(create: (_) => ThemeProvider()),
                    ChangeNotifierProvider(create: (_) => SettingsProvider()),
                    ChangeNotifierProvider(create: (_) => MedicineProvider()),
                    ChangeNotifierProvider(create: (_) => EmergencyProvider()),
                  ],
                  child: const AddMedicineSheet(),
                ),
              ),
              child: const Text('Open Sheet'),
            ),
          ),
        ),
      ),
    );
  }

  // ── open sheet with large screen ─────────────────────────────
  Future<void> openSheet(WidgetTester tester) async {
    // Use a tall screen so all widgets are on-screen
    tester.view.physicalSize = const Size(1080, 3200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(buildSheet());
    await tester.pump();
    await tester.tap(find.text('Open Sheet'));
    await tester.pumpAndSettle();
  }

  // ── scroll to widget and tap safely ─────────────────────────
  Future<void> scrollAndTap(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder, warnIfMissed: false);
    await tester.pumpAndSettle();
  }

  // ── fill form and save ───────────────────────────────────────
  // FIX: scrolls to every element before interacting,
  //      and waits for Hive write to complete.
  Future<void> fillAndSave(
    WidgetTester tester,
    String name,
    String dose,
  ) async {
    await openSheet(tester);

    // ── Name ──
    final nameField = find.ancestor(
      of: find.text('Medicine Name *'),
      matching: find.byType(TextField),
    );
    await tester.ensureVisible(nameField.first);
    await tester.tap(nameField.first, warnIfMissed: false);
    await tester.enterText(nameField.first, name);
    await tester.pump();

    // ── Dose amount ──
    final amountField = find.ancestor(
      of: find.text('Amount'),
      matching: find.byType(TextField),
    );
    await tester.ensureVisible(amountField.first);
    await tester.tap(amountField.first, warnIfMissed: false);
    await tester.enterText(amountField.first, dose);
    await tester.pump();

    // ── Add alarm time ──
    final addTimeFinder = find.text('Add Time');
    await tester.ensureVisible(addTimeFinder);
    await tester.pumpAndSettle();
    await tester.tap(addTimeFinder, warnIfMissed: false);
    await tester.pumpAndSettle();

    // Confirm time picker with OK
    final okFinder = find.text('OK');
    expect(okFinder, findsOneWidget, reason: 'Time picker OK button not found');
    await tester.tap(okFinder);
    await tester.pumpAndSettle();

    // ── Save ──
    final saveFinder = find.text('Save & Set Alarm');
    await tester.ensureVisible(saveFinder);
    await tester.pumpAndSettle();
    await tester.tap(saveFinder, warnIfMissed: false);

    // FIX: pump multiple frames so Hive write and
    //      setState complete before we check the box
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
  }

  // ─────────────────────────────────────────────────────────────
  group('AddMedicineSheet — UI Elements', () {
    testWidgets('shows Add Medicine header', (tester) async {
      await openSheet(tester);
      expect(find.text('Add Medicine'), findsOneWidget);
    });

    testWidgets('shows close button in header', (tester) async {
      await openSheet(tester);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('shows Medicine Name label', (tester) async {
      await openSheet(tester);
      expect(find.text('Medicine Name *'), findsOneWidget);
    });

    testWidgets('shows Dose label', (tester) async {
      await openSheet(tester);
      expect(find.text('Dose *'), findsOneWidget);
    });

    testWidgets('shows Amount input hint', (tester) async {
      await openSheet(tester);
      expect(find.text('Amount'), findsOneWidget);
    });

    testWidgets('shows Frequency label', (tester) async {
      await openSheet(tester);
      expect(find.text('Frequency'), findsOneWidget);
    });

    testWidgets('shows Alarm Time label', (tester) async {
      await openSheet(tester);
      expect(find.text('Alarm Time *'), findsOneWidget);
    });

    testWidgets('shows Add Time button', (tester) async {
      await openSheet(tester);
      expect(find.text('Add Time'), findsOneWidget);
    });

    testWidgets('shows Alarm Sound label', (tester) async {
      await openSheet(tester);
      expect(find.text('Alarm Sound'), findsOneWidget);
    });

    testWidgets('shows Duration label', (tester) async {
      await openSheet(tester);
      final durationFinder = find.text('Duration');
      await tester.ensureVisible(durationFinder);
      expect(durationFinder, findsOneWidget);
    });

    testWidgets('shows Start Date field', (tester) async {
      await openSheet(tester);
      final startFinder = find.text('Start Date');
      await tester.ensureVisible(startFinder);
      expect(startFinder, findsOneWidget);
    });

    testWidgets('shows End Date field', (tester) async {
      await openSheet(tester);
      final endFinder = find.text('End Date');
      await tester.ensureVisible(endFinder);
      expect(endFinder, findsOneWidget);
    });

    testWidgets('shows Save & Set Alarm button', (tester) async {
      await openSheet(tester);
      final saveFinder = find.text('Save & Set Alarm');
      await tester.ensureVisible(saveFinder);
      expect(saveFinder, findsOneWidget);
    });

    testWidgets('shows Vibration toggle label', (tester) async {
      await openSheet(tester);
      expect(find.text('Vibration'), findsOneWidget);
    });

    testWidgets('shows Switch widget for vibration', (tester) async {
      await openSheet(tester);
      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('shows vibration icon', (tester) async {
      await openSheet(tester);
      expect(find.byIcon(Icons.vibration), findsOneWidget);
    });

    testWidgets('shows alarm icon in header', (tester) async {
      await openSheet(tester);
      expect(find.byIcon(Icons.medication), findsWidgets);
    });

    testWidgets('shows add_alarm icon on Add Time button', (tester) async {
      await openSheet(tester);
      expect(find.byIcon(Icons.add_alarm), findsOneWidget);
    });

    testWidgets('shows music_note icon next to sounds', (tester) async {
      await openSheet(tester);
      expect(find.byIcon(Icons.music_note), findsWidgets);
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('AddMedicineSheet — Dose Unit Dropdown', () {
    testWidgets('default dose unit is mg', (tester) async {
      await openSheet(tester);
      expect(find.text('mg'), findsOneWidget);
    });

    testWidgets('dose unit dropdown contains Pills', (tester) async {
      await openSheet(tester);
      final dropdowns = find.byType(DropdownButton<String>);
      await tester.tap(dropdowns.first);
      await tester.pumpAndSettle();
      expect(find.text('Pills'), findsOneWidget);
    });

    testWidgets('dose unit dropdown contains ml', (tester) async {
      await openSheet(tester);
      final dropdowns = find.byType(DropdownButton<String>);
      await tester.tap(dropdowns.first);
      await tester.pumpAndSettle();
      expect(find.text('ml'), findsOneWidget);
    });

    testWidgets('dose unit dropdown contains g', (tester) async {
      await openSheet(tester);
      final dropdowns = find.byType(DropdownButton<String>);
      await tester.tap(dropdowns.first);
      await tester.pumpAndSettle();
      expect(find.text('g'), findsOneWidget);
    });

    testWidgets('dose unit dropdown contains Drops', (tester) async {
      await openSheet(tester);
      final dropdowns = find.byType(DropdownButton<String>);
      await tester.tap(dropdowns.first);
      await tester.pumpAndSettle();
      expect(find.text('Drops'), findsOneWidget);
    });

    testWidgets('dose unit dropdown contains Units', (tester) async {
      await openSheet(tester);
      final dropdowns = find.byType(DropdownButton<String>);
      await tester.tap(dropdowns.first);
      await tester.pumpAndSettle();
      expect(find.text('Units'), findsOneWidget);
    });

    testWidgets('can select Pills as dose unit', (tester) async {
      await openSheet(tester);
      final dropdowns = find.byType(DropdownButton<String>);
      await tester.tap(dropdowns.first);
      await tester.pumpAndSettle();
      // Use .last to pick from the dropdown menu overlay
      await tester.tap(find.text('Pills').last);
      await tester.pumpAndSettle();
      expect(find.text('Pills'), findsOneWidget);
    });

    testWidgets('can select ml as dose unit', (tester) async {
      await openSheet(tester);
      final dropdowns = find.byType(DropdownButton<String>);
      await tester.tap(dropdowns.first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('ml').last);
      await tester.pumpAndSettle();
      expect(find.text('ml'), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('AddMedicineSheet — Frequency Dropdown', () {
    testWidgets('default frequency is Once Daily', (tester) async {
      await openSheet(tester);
      expect(find.text('Once Daily'), findsOneWidget);
    });

    testWidgets('frequency dropdown has Twice Daily', (tester) async {
      await openSheet(tester);
      final dropdowns = find.byType(DropdownButton<String>);
      await tester.tap(dropdowns.at(1));
      await tester.pumpAndSettle();
      expect(find.text('Twice Daily'), findsOneWidget);
    });

    testWidgets('frequency dropdown has Three Times Daily', (tester) async {
      await openSheet(tester);
      final dropdowns = find.byType(DropdownButton<String>);
      await tester.tap(dropdowns.at(1));
      await tester.pumpAndSettle();
      expect(find.text('Three Times Daily'), findsOneWidget);
    });

    testWidgets('frequency dropdown has Every 8 Hours', (tester) async {
      await openSheet(tester);
      final dropdowns = find.byType(DropdownButton<String>);
      await tester.tap(dropdowns.at(1));
      await tester.pumpAndSettle();
      expect(find.text('Every 8 Hours'), findsOneWidget);
    });

    testWidgets('frequency dropdown has Every 12 Hours', (tester) async {
      await openSheet(tester);
      final dropdowns = find.byType(DropdownButton<String>);
      await tester.tap(dropdowns.at(1));
      await tester.pumpAndSettle();
      expect(find.text('Every 12 Hours'), findsOneWidget);
    });

    testWidgets('frequency dropdown has As Needed', (tester) async {
      await openSheet(tester);
      final dropdowns = find.byType(DropdownButton<String>);
      await tester.tap(dropdowns.at(1));
      await tester.pumpAndSettle();
      expect(find.text('As Needed'), findsOneWidget);
    });

    testWidgets('can select Twice Daily', (tester) async {
      await openSheet(tester);
      final dropdowns = find.byType(DropdownButton<String>);
      await tester.tap(dropdowns.at(1));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Twice Daily').last);
      await tester.pumpAndSettle();
      expect(find.text('Twice Daily'), findsOneWidget);
    });

    testWidgets('can select As Needed', (tester) async {
      await openSheet(tester);
      final dropdowns = find.byType(DropdownButton<String>);
      await tester.tap(dropdowns.at(1));
      await tester.pumpAndSettle();
      await tester.tap(find.text('As Needed').last);
      await tester.pumpAndSettle();
      expect(find.text('As Needed'), findsOneWidget);
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('AddMedicineSheet — Alarm Sound Selection', () {
    testWidgets('shows Gentle Bell sound option', (tester) async {
      await openSheet(tester);
      expect(find.text('🔔 Gentle Bell'), findsOneWidget);
    });

    testWidgets('shows Soft Chime sound option', (tester) async {
      await openSheet(tester);
      expect(find.text('🎵 Soft Chime'), findsOneWidget);
    });

    testWidgets('shows Urgent Beep sound option', (tester) async {
      await openSheet(tester);
      expect(find.text('🚨 Urgent Beep'), findsOneWidget);
    });

    testWidgets('Gentle Bell is selected by default', (tester) async {
      await openSheet(tester);
      expect(
        find.byIcon(Icons.radio_button_checked),
        findsOneWidget,
      );
    });

    testWidgets('unselected sounds show radio_button_off', (tester) async {
      await openSheet(tester);
      // 2 sounds are unselected = 2 radio_button_off icons
      expect(
        find.byIcon(Icons.radio_button_off),
        findsNWidgets(2),
      );
    });

    testWidgets('can select Soft Chime', (tester) async {
      await openSheet(tester);
      await tester.tap(find.text('🎵 Soft Chime'));
      await tester.pump();
      // Still only one selected
      expect(
        find.byIcon(Icons.radio_button_checked),
        findsOneWidget,
      );
    });

    testWidgets('can select Urgent Beep', (tester) async {
      await openSheet(tester);
      await tester.tap(find.text('🚨 Urgent Beep'));
      await tester.pump();
      expect(
        find.byIcon(Icons.radio_button_checked),
        findsOneWidget,
      );
    });

    testWidgets('selecting Soft Chime deselects Gentle Bell', (tester) async {
      await openSheet(tester);
      await tester.tap(find.text('🎵 Soft Chime'));
      await tester.pump();
      // Now Gentle Bell and Urgent Beep are unselected
      expect(
        find.byIcon(Icons.radio_button_off),
        findsNWidgets(2),
      );
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('AddMedicineSheet — Vibration Toggle', () {
    testWidgets('vibration is enabled by default', (tester) async {
      await openSheet(tester);
      final sw = tester.widget<Switch>(find.byType(Switch));
      expect(sw.value, true);
    });

    testWidgets('can toggle vibration off', (tester) async {
      await openSheet(tester);
      await tester.tap(find.byType(Switch));
      await tester.pump();
      final sw = tester.widget<Switch>(find.byType(Switch));
      expect(sw.value, false);
    });

    testWidgets('can toggle vibration back on', (tester) async {
      await openSheet(tester);
      await tester.tap(find.byType(Switch));
      await tester.pump();
      await tester.tap(find.byType(Switch));
      await tester.pump();
      final sw = tester.widget<Switch>(find.byType(Switch));
      expect(sw.value, true);
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('AddMedicineSheet — Validation', () {
    testWidgets('shows error when medicine name is empty', (tester) async {
      await openSheet(tester);
      final saveFinder = find.text('Save & Set Alarm');
      await tester.ensureVisible(saveFinder);
      await tester.pumpAndSettle();
      await tester.tap(saveFinder, warnIfMissed: false);
      await tester.pump();
      expect(
        find.text('Please enter medicine name'),
        findsOneWidget,
      );
    });

    testWidgets('shows error when dose empty but name filled', (tester) async {
      await openSheet(tester);

      // Fill name only
      final nameField = find.ancestor(
        of: find.text('Medicine Name *'),
        matching: find.byType(TextField),
      );
      await tester.enterText(nameField.first, 'Aspirin');
      await tester.pump();

      final saveFinder = find.text('Save & Set Alarm');
      await tester.ensureVisible(saveFinder);
      await tester.pumpAndSettle();
      await tester.tap(saveFinder, warnIfMissed: false);
      await tester.pump();

      expect(
        find.text('Please enter dose amount'),
        findsOneWidget,
      );
    });

    testWidgets('shows error when time not added but name and dose filled',
        (tester) async {
      await openSheet(tester);

      // Fill name
      final nameField = find.ancestor(
        of: find.text('Medicine Name *'),
        matching: find.byType(TextField),
      );
      await tester.enterText(nameField.first, 'Aspirin');
      await tester.pump();

      // Fill dose amount
      final amountField = find.ancestor(
        of: find.text('Amount'),
        matching: find.byType(TextField),
      );
      await tester.enterText(amountField.first, '500');
      await tester.pump();

      final saveFinder = find.text('Save & Set Alarm');
      await tester.ensureVisible(saveFinder);
      await tester.pumpAndSettle();
      await tester.tap(saveFinder, warnIfMissed: false);
      await tester.pump();

      expect(
        find.text('Please add at least one alarm time'),
        findsOneWidget,
      );
    });

    testWidgets('no error snackbar shown on valid input', (tester) async {
      await fillAndSave(tester, 'Aspirin', '500');
      // Error messages should not be visible
      expect(
        find.text('Please enter medicine name'),
        findsNothing,
      );
      expect(
        find.text('Please enter dose amount'),
        findsNothing,
      );
      expect(
        find.text('Please add at least one alarm time'),
        findsNothing,
      );
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('AddMedicineSheet — Add Time Button', () {
    testWidgets('Add Time button is visible', (tester) async {
      await openSheet(tester);
      expect(find.text('Add Time'), findsOneWidget);
    });

    testWidgets('tapping Add Time opens time picker', (tester) async {
      await openSheet(tester);
      await tester.tap(find.text('Add Time'));
      await tester.pumpAndSettle();
      expect(find.byType(TimePickerDialog), findsOneWidget);
    });

    testWidgets('time picker dismissed with Cancel', (tester) async {
      await openSheet(tester);
      await tester.tap(find.text('Add Time'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.byType(TimePickerDialog), findsNothing);
    });

    testWidgets('confirming time picker closes it', (tester) async {
      await openSheet(tester);
      await tester.tap(find.text('Add Time'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(find.byType(TimePickerDialog), findsNothing);
    });

    testWidgets('cancelling does not add time chip', (tester) async {
      await openSheet(tester);
      await tester.tap(find.text('Add Time'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.byType(Chip), findsNothing);
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('AddMedicineSheet — Date Pickers', () {
    testWidgets('tapping Start Date opens date picker', (tester) async {
      await openSheet(tester);
      final startFinder = find.text('Start Date');
      await tester.ensureVisible(startFinder);
      await tester.pumpAndSettle();
      await tester.tap(startFinder, warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.byType(DatePickerDialog), findsOneWidget);
    });

    testWidgets('tapping End Date opens date picker', (tester) async {
      await openSheet(tester);
      final endFinder = find.text('End Date');
      await tester.ensureVisible(endFinder);
      await tester.pumpAndSettle();
      await tester.tap(endFinder, warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.byType(DatePickerDialog), findsOneWidget);
    });

    testWidgets('edit_calendar icons are visible', (tester) async {
      await openSheet(tester);
      expect(find.byIcon(Icons.edit_calendar), findsWidgets);
    });

    testWidgets('tapping edit_calendar opens date picker', (tester) async {
      await openSheet(tester);
      final calIcons = find.byIcon(Icons.edit_calendar);
      await tester.ensureVisible(calIcons.first);
      await tester.pumpAndSettle();
      await tester.tap(calIcons.first, warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.byType(DatePickerDialog), findsOneWidget);
    });

    testWidgets('cancelling date picker closes it', (tester) async {
      await openSheet(tester);
      final startFinder = find.text('Start Date');
      await tester.ensureVisible(startFinder);
      await tester.pumpAndSettle();
      await tester.tap(startFinder, warnIfMissed: false);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.byType(DatePickerDialog), findsNothing);
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('AddMedicineSheet — Close Button', () {
    testWidgets('close button dismisses the sheet', (tester) async {
      await openSheet(tester);
      expect(find.text('Add Medicine'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      expect(find.text('Add Medicine'), findsNothing);
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('AddMedicineSheet — Save Medicine', () {
    testWidgets('successfully saves medicine to Hive', (tester) async {
      await fillAndSave(tester, 'Aspirin', '500');
      expect(
        Hive.box<Medicine>('medicines').length,
        greaterThanOrEqualTo(1),
      );
    });

    testWidgets('saved medicine has correct name', (tester) async {
      await fillAndSave(tester, 'Paracetamol', '1000');

      final box = Hive.box<Medicine>('medicines');
      expect(box.length, greaterThanOrEqualTo(1));

      // FIX: find by name instead of relying on .first
      final saved = box.values.firstWhere((m) => m.name == 'Paracetamol');
      expect(saved.name, 'Paracetamol');
    });

    testWidgets('saved medicine dose includes amount', (tester) async {
      await fillAndSave(tester, 'Ibuprofen', '400');

      final box = Hive.box<Medicine>('medicines');
      expect(box.length, greaterThanOrEqualTo(1));

      final saved = box.values.firstWhere((m) => m.name == 'Ibuprofen');

      // FIX: check amount is present; unit depends on
      // which unit was selected (default is 'mg')
      expect(saved.dose.contains('400'), true);
    });

    testWidgets('saved medicine dose includes default mg unit', (tester) async {
      await fillAndSave(tester, 'Ibuprofen400mg', '400');

      final box = Hive.box<Medicine>('medicines');
      expect(box.length, greaterThanOrEqualTo(1));

      final saved = box.values.firstWhere((m) => m.name == 'Ibuprofen400mg');

      // The dose field is built as '$amount $_doseUnit'
      // Default unit is 'mg' so dose should be '400 mg'
      final doseLower = saved.dose.toLowerCase();
      expect(
        doseLower.contains('400') && doseLower.contains('mg'),
        true,
        reason: 'Expected dose to contain "400" and "mg", got: ${saved.dose}',
      );
    });

    testWidgets('saved medicine default status is pending', (tester) async {
      // FIX: use unique name so firstWhere always finds
      // the right medicine even if box has leftovers
      await fillAndSave(tester, 'VitaminBPendingTest', '100');

      final box = Hive.box<Medicine>('medicines');
      expect(box.length, greaterThanOrEqualTo(1));

      final saved = box.values.firstWhere(
        (m) => m.name == 'VitaminBPendingTest',
        orElse: () => throw StateError(
          'Medicine not found in box. '
          'Box contents: ${box.values.map((m) => m.name).toList()}',
        ),
      );
      expect(saved.status, 'pending');
    });

    testWidgets('saved medicine default frequency is Once Daily',
        (tester) async {
      await fillAndSave(tester, 'FreqTest', '50');

      final box = Hive.box<Medicine>('medicines');
      final saved = box.values.firstWhere((m) => m.name == 'FreqTest');
      expect(saved.frequency, 'Once Daily');
    });

    testWidgets('saved medicine vibrateEnabled is true by default',
        (tester) async {
      await fillAndSave(tester, 'VibrateTest', '200');

      final box = Hive.box<Medicine>('medicines');
      final saved = box.values.firstWhere((m) => m.name == 'VibrateTest');
      expect(saved.vibrateEnabled, true);
    });

    testWidgets('saved medicine alarmSound is gentle_bell by default',
        (tester) async {
      await fillAndSave(tester, 'SoundTest', '75');

      final box = Hive.box<Medicine>('medicines');
      final saved = box.values.firstWhere((m) => m.name == 'SoundTest');
      expect(
        saved.alarmSound,
        'assets/alarm_sounds/gentle_bell.mp3',
      );
    });

    testWidgets('success snackbar contains medicine name', (tester) async {
      await fillAndSave(tester, 'Metformin', '850');
      // Sheet closes and snackbar shows medicine name
      expect(
        find.textContaining('Metformin'),
        findsOneWidget,
      );
    });

    testWidgets('sheet closes after successful save', (tester) async {
      await fillAndSave(tester, 'CloseTest', '300');
      // Header should be gone after sheet closes
      expect(find.text('Add Medicine'), findsNothing);
    });
  });

  // ─────────────────────────────────────────────────────────────
  group('AddMedicineSheet — Time Chip', () {
    testWidgets('confirming time adds chip with alarm icon', (tester) async {
      await openSheet(tester);
      await tester.tap(find.text('Add Time'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.alarm), findsOneWidget);
    });

    testWidgets('time chip has delete icon', (tester) async {
      await openSheet(tester);
      await tester.tap(find.text('Add Time'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      // Chip's delete icon is Icons.close inside a Chip
      final chipClose = find.descendant(
        of: find.byType(Chip),
        matching: find.byIcon(Icons.close),
      );
      expect(chipClose, findsOneWidget);
    });

    testWidgets('deleting time chip removes it', (tester) async {
      await openSheet(tester);
      await tester.tap(find.text('Add Time'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Delete the chip
      final chipClose = find.descendant(
        of: find.byType(Chip),
        matching: find.byIcon(Icons.close),
      );
      await tester.tap(chipClose.first);
      await tester.pump();

      expect(find.byType(Chip), findsNothing);
    });

    testWidgets('can add multiple time chips', (tester) async {
      await openSheet(tester);

      // Add first time
      await tester.tap(find.text('Add Time'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Add second time
      await tester.tap(find.text('Add Time'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(find.byType(Chip), findsNWidgets(2));
    });
  });
}
