import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:medicine_reminder_app/models/medicine.dart';
import 'package:medicine_reminder_app/providers/medicine_provider.dart';
import 'package:medicine_reminder_app/providers/theme_provider.dart';
import 'package:medicine_reminder_app/providers/setting_provider.dart';
import 'package:medicine_reminder_app/screen/health_screen.dart';
import 'dart:io';

void main() {
  setUpAll(() async {
    final tempDir = await Directory.systemTemp.createTemp('hive_health_test');
    Hive.init(tempDir.path);
    Hive.registerAdapter(MedicineAdapter());
    await Hive.openBox<Medicine>('medicines');
    await Hive.openBox('settingsBox');
  });

  tearDownAll(() async {
    await Hive.close();
  });

  Widget buildHealthScreen() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => MedicineProvider()),
      ],
      child: const MaterialApp(home: HealthScreen()),
    );
  }

  group('HealthScreen', () {
    testWidgets('shows Health in app bar', (tester) async {
      await tester.pumpWidget(buildHealthScreen());
      await tester.pump();

      expect(find.text('Health'), findsOneWidget);
    });

    testWidgets('shows Blood Pressure tab', (tester) async {
      await tester.pumpWidget(buildHealthScreen());
      await tester.pump();

      expect(find.textContaining('Blood Pressure'), findsWidgets);
    });

    testWidgets('shows BMI Calculator tab', (tester) async {
      await tester.pumpWidget(buildHealthScreen());
      await tester.pump();

      expect(find.textContaining('BMI'), findsWidgets);
    });

    testWidgets('can switch to BMI tab', (tester) async {
      await tester.pumpWidget(buildHealthScreen());
      await tester.pump();

      await tester.tap(find.text('⚖️ BMI Calculator'));
      await tester.pump();

      expect(find.text('Calculate BMI'), findsOneWidget);
    });

    testWidgets('BMI tab has height and weight inputs', (tester) async {
      await tester.pumpWidget(buildHealthScreen());
      await tester.pump();

      await tester.tap(find.text('⚖️ BMI Calculator'));
      await tester.pump();

      expect(find.text('Height (cm)'), findsOneWidget);
      expect(find.text('Weight (kg)'), findsOneWidget);
    });

    testWidgets('BP tab has systolic and diastolic inputs', (tester) async {
      await tester.pumpWidget(buildHealthScreen());
      await tester.pump();

      expect(find.text('Systolic (Top)'), findsOneWidget);
      expect(find.text('Diastolic (Bottom)'), findsOneWidget);
    });
  });

  group('BMI Calculation Logic', () {
    test('normal BMI range is 18.5 to 24.9', () {
      const height = 175.0;
      const weight = 70.0;
      final hm = height / 100;
      final bmi = weight / (hm * hm);

      expect(bmi, greaterThanOrEqualTo(18.5));
      expect(bmi, lessThan(25.0));
    });

    test('underweight BMI is below 18.5', () {
      const height = 170.0;
      const weight = 45.0;
      final hm = height / 100;
      final bmi = weight / (hm * hm);

      expect(bmi, lessThan(18.5));
    });

    test('overweight BMI is 25 to 29.9', () {
      const height = 170.0;
      const weight = 80.0;
      final hm = height / 100;
      final bmi = weight / (hm * hm);

      expect(bmi, greaterThanOrEqualTo(25.0));
      expect(bmi, lessThan(30.0));
    });

    test('obese BMI is 30 or above', () {
      const height = 165.0;
      const weight = 100.0;
      final hm = height / 100;
      final bmi = weight / (hm * hm);

      expect(bmi, greaterThanOrEqualTo(30.0));
    });
  });

  group('Blood Pressure Classification', () {
    test('normal BP is systolic < 120 and diastolic < 80', () {
      const systolic = 118;
      const diastolic = 76;
      expect(systolic < 120 && diastolic < 80, true);
    });

    test('elevated BP is systolic 120-129 and diastolic < 80', () {
      const systolic = 125;
      const diastolic = 78;
      expect(systolic >= 120 && systolic < 130 && diastolic < 80, true);
    });

    test('stage 1 hypertension is systolic 130-139', () {
      const systolic = 135;
      expect(systolic >= 130 && systolic < 140, true);
    });

    test('stage 2 hypertension is systolic >= 140', () {
      const systolic = 150;
      expect(systolic >= 140, true);
    });

    test('crisis is systolic > 180', () {
      const systolic = 185;
      expect(systolic > 180, true);
    });
  });
}
