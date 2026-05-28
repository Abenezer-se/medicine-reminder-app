// lib/main.dart
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers/theme_provider.dart';
import 'providers/medicine_provider.dart';
import 'providers/emergency_provider.dart';
import 'providers/user_provider.dart';
import 'providers/setting_provider.dart';
import 'services/alarm_service.dart';
import 'screen/splash_screen.dart';
import 'screen/alarm_ring_screen.dart';
import 'models/medicine.dart';
import 'models/emergency_contact.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(MedicineAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(EmergencyContactAdapter());
    }
    if (!Hive.isBoxOpen('medicines')) {
      await Hive.openBox<Medicine>('medicines');
    }
    if (!Hive.isBoxOpen('emergencyBox')) {
      await Hive.openBox<EmergencyContact>('emergencyBox');
    }
    if (!Hive.isBoxOpen('userBox')) {
      await Hive.openBox('userBox');
    }
    if (!Hive.isBoxOpen('settingsBox')) {
      await Hive.openBox('settingsBox');
    }
  } catch (e) {
    debugPrint('Hive init error: $e');
  }

  try {
    await AlarmService().init();
  } catch (e) {
    debugPrint('Alarm init error: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => MedicineProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => EmergencyProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Check every 3 seconds if alarm fired
    _startAlarmChecker();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _startAlarmChecker() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 3));
      await _checkAlarmFired();
      return true; // keep looping
    });
  }

  Future<void> _checkAlarmFired() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final bool fired = prefs.getBool('alarm_fired') ?? false;

      if (fired) {
        // Clear the flag immediately
        await prefs.setBool('alarm_fired', false);

        final String name =
            prefs.getString('alarm_fired_name') ?? 'Your Medicine';
        final String dose = prefs.getString('alarm_fired_dose') ?? '';
        final String sound = prefs.getString('alarm_sound') ??
            'assets/alarm_sounds/gentle_bell.mp3';

        // Find matching medicine from Hive
        final medicines = Hive.box<Medicine>('medicines').values.toList();
        Medicine? matchedMedicine;
        for (final m in medicines) {
          if (m.name == name) {
            matchedMedicine = m;
            break;
          }
        }

        // Navigate to AlarmRingScreen
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => AlarmRingScreen(
              medicineName: name,
              dose: dose,
              time: matchedMedicine?.time ?? '',
              alarmSound: sound,
              medicine: matchedMedicine,
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Alarm check error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2EC4B6),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF0FAFA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2EC4B6),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        cardColor: Colors.white,
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2EC4B6),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0D1117),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF161B22),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        cardColor: const Color(0xFF161B22),
        cardTheme: CardThemeData(
          color: const Color(0xFF161B22),
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: const Color(0xFF161B22),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: Color(0xFF161B22),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Color(0xFF161B22),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF21262D),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF30363D)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF30363D)),
          ),
          labelStyle: const TextStyle(color: Colors.white70),
          hintStyle: const TextStyle(color: Colors.white38),
        ),
        listTileTheme: const ListTileThemeData(
          textColor: Colors.white,
          iconColor: Colors.white70,
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const Color(0xFF2EC4B6);
            }
            return Colors.grey;
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const Color(0xFF2EC4B6).withOpacity(0.4);
            }
            return Colors.grey.withOpacity(0.3);
          }),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
          titleLarge: TextStyle(color: Colors.white),
          titleMedium: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white70),
        dividerColor: Colors.white12,
      ),
      home: const SplashScreen(),
    );
  }
}
