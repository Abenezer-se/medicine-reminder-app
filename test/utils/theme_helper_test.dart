import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:medicine_reminder_app/utils/theme_helper.dart';

void main() {
  Widget buildWithTheme({
    required Widget child,
    required ThemeMode mode,
  }) {
    return MaterialApp(
      themeMode: mode,
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      home: child,
    );
  }

  group('ThemeHelper - Light Mode', () {
    testWidgets('bg returns light color in light mode', (tester) async {
      late Color result;
      await tester.pumpWidget(buildWithTheme(
        mode: ThemeMode.light,
        child: Builder(builder: (ctx) {
          result = TH.bg(ctx);
          return const SizedBox();
        }),
      ));
      expect(result, const Color(0xFFF0FAFA));
    });

    testWidgets('card returns white in light mode', (tester) async {
      late Color result;
      await tester.pumpWidget(buildWithTheme(
        mode: ThemeMode.light,
        child: Builder(builder: (ctx) {
          result = TH.card(ctx);
          return const SizedBox();
        }),
      ));
      expect(result, Colors.white);
    });

    testWidgets('text returns dark color in light mode', (tester) async {
      late Color result;
      await tester.pumpWidget(buildWithTheme(
        mode: ThemeMode.light,
        child: Builder(builder: (ctx) {
          result = TH.text(ctx);
          return const SizedBox();
        }),
      ));
      expect(result, const Color(0xFF1A2E35));
    });

    testWidgets('isDark returns false in light mode', (tester) async {
      late bool result;
      await tester.pumpWidget(buildWithTheme(
        mode: ThemeMode.light,
        child: Builder(builder: (ctx) {
          result = TH.isDark(ctx);
          return const SizedBox();
        }),
      ));
      expect(result, false);
    });
  });

  group('ThemeHelper - Dark Mode', () {
    testWidgets('bg returns dark color in dark mode', (tester) async {
      late Color result;
      await tester.pumpWidget(buildWithTheme(
        mode: ThemeMode.dark,
        child: Builder(builder: (ctx) {
          result = TH.bg(ctx);
          return const SizedBox();
        }),
      ));
      expect(result, const Color(0xFF0D1117));
    });

    testWidgets('card returns dark card color in dark mode', (tester) async {
      late Color result;
      await tester.pumpWidget(buildWithTheme(
        mode: ThemeMode.dark,
        child: Builder(builder: (ctx) {
          result = TH.card(ctx);
          return const SizedBox();
        }),
      ));
      expect(result, const Color(0xFF161B22));
    });

    testWidgets('text returns white in dark mode', (tester) async {
      late Color result;
      await tester.pumpWidget(buildWithTheme(
        mode: ThemeMode.dark,
        child: Builder(builder: (ctx) {
          result = TH.text(ctx);
          return const SizedBox();
        }),
      ));
      expect(result, Colors.white);
    });

    testWidgets('isDark returns true in dark mode', (tester) async {
      late bool result;
      await tester.pumpWidget(buildWithTheme(
        mode: ThemeMode.dark,
        child: Builder(builder: (ctx) {
          result = TH.isDark(ctx);
          return const SizedBox();
        }),
      ));
      expect(result, true);
    });
  });
}
