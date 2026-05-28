/* 
    
   import 'package:flutter_test/flutter_test.dart'; 
import 'package:hive_ce_flutter/hive_ce_flutter.dart'; 
import 'package:medicine_reminder_app/models/medicine.dart'; 
import 'package:medicine_reminder_app/providers/medicine_provider.dart'; 
import 'dart:io'; 
 
void main() { 
  late MedicineProvider provider; 
 
  setUpAll(() async { 
    final tempDir = await Directory.systemTemp.createTemp('hive_test'); 
    Hive.init(tempDir.path); 
    Hive.registerAdapter(MedicineAdapter()); 
    await Hive.openBox<Medicine>('medicines'); 
  }); 
 
  setUp(() { 
    Hive.box<Medicine>('medicines').clear(); 
    provider = MedicineProvider(); 
  }); 
 
  tearDownAll(() async { 
    await Hive.close(); 
  }); 
 
  group('MedicineProvider', () { 
    test('starts with empty medicines list', () { 
      expect(provider.medicines, isEmpty); 
    }); 
 
    test('addMedicine increases list length', () { 
      provider.addMedicine( 
        name: 'Aspirin', 
        dose: '500mg', 
        frequency: 'Once Daily', 
        time: '8:00 AM', 
        remainingDoses: 7, 
        startDate: '1 Jan 2026', 
        endDate: '8 Jan 2026', 
      ); 
 
      expect(provider.medicines.length, 1); 
    }); 
 
    test('addMedicine stores correct medicine data', () { 
      provider.addMedicine( 
        name: 'Paracetamol', 
        dose: '1000mg', 
        frequency: 'Twice Daily', 
        time: '9:00 AM', 
        remainingDoses: 14, 
        startDate: '1 Feb 2026', 
        endDate: '14 Feb 2026', 
      ); 
 
      final med = provider.medicines.first; 
      expect(med.name, 'Paracetamol'); 
      expect(med.dose, '1000mg'); 
      expect(med.frequency, 'Twice Daily'); 
      expect(med.time, '9:00 AM'); 
    }); 
 
    test('addMedicine sets default status to pending', () { 
      provider.addMedicine( 
        name: 'Vitamin D', 
        dose: '1000 IU', 
        frequency: 'Once Daily', 
        time: '7:00 AM', 
        remainingDoses: 30, 
        startDate: '1 Jan 2026', 
        endDate: '31 Jan 2026', 
      ); 
 
      expect(provider.medicines.first.status, 'pending'); 
    }); 
 
    test('can add multiple medicines', () { 
      provider.addMedicine( 
        name: 'Medicine A', 
        dose: '100mg', 
        frequency: 'Once Daily', 
        time: '8:00 AM', 
        remainingDoses: 7, 
        startDate: '1 Jan 2026', 
        endDate: '8 Jan 2026', 
      ); 
      provider.addMedicine( 
        name: 'Medicine B', 
        dose: '200mg', 
        frequency: 'Twice Daily', 
        time: '9:00 AM', 
        remainingDoses: 14, 
        startDate: '1 Jan 2026', 
        endDate: '8 Jan 2026', 
      ); 
      provider.addMedicine( 
        name: 'Medicine C', 
        dose: '300mg', 
        frequency: 'Three Times Daily', 
        time: '10:00 AM', 
        remainingDoses: 21, 
        startDate: '1 Jan 2026', 
        endDate: '8 Jan 2026', 
      ); 
 
      expect(provider.medicines.length, 3); 
    }); 
 
    test('updateStatus changes medicine status to taken', () { 
      provider.addMedicine( 
        name: 'Test Med', 
        dose: '50mg', 
        frequency: 'Once Daily', 
        time: '8:00 AM', 
        remainingDoses: 7, 
        startDate: '1 Jan 2026', 
        endDate: '8 Jan 2026', 
      ); 
 
      final med = provider.medicines.first; 
      provider.updateStatus(med, 'taken'); 
 
      expect(provider.medicines.first.status, 'taken'); 
    }); 
 
    test('updateStatus changes medicine status to skipped', () { 
      provider.addMedicine( 
        name: 'Skip Med', 
        dose: '100mg', 
        frequency: 'Once Daily', 
        time: '10:00 AM', 
        remainingDoses: 7, 
        startDate: '1 Jan 2026', 
        endDate: '8 Jan 2026', 
      ); 
 
      final med = provider.medicines.first;
      expect(provider.medicines.length, 5); 
 
      // FIX 3: deleteAll is async — await it properly 
      provider.deleteAll(); 
 
      // Wait for Hive stream to settle 
      await Future.delayed(const Duration(milliseconds: 300)); 
 
      expect(provider.medicines.length, 0); 
    }); 
 
    test('updateMedicine changes medicine fields', () async { 
      final provider = MedicineProvider(); 
      addMed(provider, 'Old Name', dose: '100mg'); 
 
      final med = provider.medicines.first; 
 
      // FIX 4: updateMedicine calls cancelAlarm (platform) 
      // and scheduleAlarm (SharedPreferences). Wrap in try/catch. 
      try { 
        provider.updateMedicine( 
          med, 
          name: 'New Name', 
          dose: '200mg', 
          frequency: 'Twice Daily', 
          time: '10:00 AM', 
          startDate: '5 Jan 2026', 
          endDate: '15 Jan 2026', 
        ); 
      } catch (_) { 
        // platform channel errors expected — ignore 
      } 
 
      await Future.delayed(const Duration(milliseconds: 100)); 
 
      // FIX 5: find by key rather than .first to avoid 
      // order issues 
      final updated = 
          provider.medicines.firstWhere((m) => m.name == 'New Name'); 
      expect(updated.dose, '200mg'); 
      expect(updated.frequency, 'Twice Daily'); 
    }); 
 
    test('medicines list persists in Hive box', () { 
      // FIX 6: previous test may have renamed 'Old Name' 
      // to 'New Name'. Use a fresh unique name. 
      final provider1 = MedicineProvider(); 
      addMed(provider1, 'PersistentUniqueMed2026'); 
 
      // Create a new provider reading the same Hive box 
      final provider2 = MedicineProvider(); 
      expect( 
        provider2.medicines.any((m) => m.name == 'PersistentUniqueMed2026'), 
        true, 
      ); 
    }); 
 
    test('addMedicine uses default alarmSound', () { 
      final provider = MedicineProvider(); 
      addMed(provider, 'SoundDefaultMed'); 
 
      final med = 
          provider.medicines.firstWhere((m) => m.name == 'SoundDefaultMed'); 
      expect( 
        med.alarmSound, 
        'assets/alarm_sounds/gentle_bell.mp3', 
      ); 
    }); 
 
    test('addMedicine uses default vibrateEnabled true', () { 
      final provider = MedicineProvider(); 
      addMed(provider, 'VibrateMed'); 
 
      final med = provider.medicines.firstWhere((m) => m.name == 'VibrateMed'); 
      expect(med.vibrateEnabled, true); 
    }); 
 
    test('addMedicine with custom alarmSound stores it', () { 
      final provider = MedicineProvider(); 
      provider.addMedicine( 
        name: 'BeepMed', 
        dose: '50mg', 
        frequency: 'Once Daily', 
        time: '7:00 AM', 
        remainingDoses: 7, 
        startDate: '1 Jan 2026', 
        endDate: '8 Jan 2026', 
        alarmSound: 'assets/alarm_sounds/urgent_beep.mp3', 
      ); 
 
      final med = provider.medicines.firstWhere((m) => m.name == 'BeepMed'); 
      expect( 
        med.alarmSound, 
        'assets/alarm_sounds/urgent_beep.mp3', 
      ); 
    }); 
 
    test('updateStatus pending -> taken -> skipped', () { 
      final provider = MedicineProvider(); 
      addMed(provider, 'CycleMed'); 
 
      final med = provider.medicines.firstWhere((m) => m.name == 'CycleMed'); 
      expect(med.status, 'pending'); 
 
      provider.updateStatus(med, 'taken'); 
      expect( 
        provider.medicines.firstWhere((m) => m.name == 'CycleMed').status, 
        'taken', 
      ); 
 
      provider.updateStatus(med, 'skipped'); 
      expect( 
        provider.medicines.firstWhere((m) => m.name == 'CycleMed').status, 
        'skipped', 
      ); 
    }); 
  }); 
} 
*/ 
 
// test/providers/medicine_provider_test.dart 
/* 
import 'package:flutter/services.dart'; 
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart'; 
import 'package:shared_preferences/shared_preferences.dart'; 
import 'package:medicine_reminder_app/models/medicine.dart'; 
import 'package:medicine_reminder_app/providers/medicine_provider.dart'; 
import 'dart:io'; 
 
void main() { 
  TestWidgetsFlutterBinding.ensureInitialized(); 
 
  late Directory tempDir; 
 
  setUpAll(() async { 
    // ── Mock shared_preferences channel ────────────────────── 
    SharedPreferences.setMockInitialValues({}); 
 
    // ── Mock android_alarm_manager channel ─────────────────── 
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger 
        .setMockMethodCallHandler( 
      const MethodChannel('dev.fluttercommunity.plus/android_alarm_manager'), 
      (MethodCall call) async => true, 
    ); 
 
    // ── Mock audioplayers channels ──────────────────────────── 
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger 
        .setMockMethodCallHandler( 
      const MethodChannel('xyz.luan/audioplayers'), 
      (MethodCall call) async => 1, 
    ); 
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger 
        .setMockMethodCallHandler( 
      const MethodChannel('xyz.luan/audioplayers.global'), 
      (MethodCall call) async => null, 
    ); 
 
    // ── Hive setup ──────────────────────────────────────────── 
    tempDir = await Directory.systemTemp.createTemp('hive_medicine_test'); 
    Hive.init(tempDir.path); 
    if (!Hive.isAdapterRegistered(0)) { 
      Hive.registerAdapter(MedicineAdapter()); 
    } 
    await Hive.openBox<Medicine>('medicines'); 
  }); 
 
  setUp(() async { 
    SharedPreferences.setMockInitialValues({}); 
    await Hive.box<Medicine>('medicines').clear(); 
  }); 
 
  tearDownAll(() async { 
    await Hive.close(); 
    await tempDir.delete(recursive: true); 
  }); 
 
  // ── helper ─────────────────────────────────────────────────── 
  void addMed( 
    MedicineProvider provider, 
    String name, { 
    String dose = '100mg', 
    String frequency = 'Once Daily', 
    String time = '8:00 AM', 
    int remainingDoses = 7, 
    String startDate = '1 Jan 2026', 
    String endDate = '8 Jan 2026', 
  }) { 
    provider.addMedicine( 
      name: name, 
      dose: dose, 
      frequency: frequency, 
      time: time, 
      remainingDoses: remainingDoses, 
      startDate: startDate, 
      endDate: endDate, 
    ); 
  } 
 
  group('MedicineProvider', () { 
    test('starts with empty medicines list', () { 
      final provider = MedicineProvider(); 
      expect(provider.medicines, isEmpty); 
    }); 
 
    test('addMedicine increases list length', () async { 
      final provider = MedicineProvider(); 
      addMed(provider, 'Aspirin'); 
      await Future.delayed(const Duration(milliseconds: 100)); 
      expect(provider.medicines.length, 1); 
    }); 
 
    test('addMedicine stores correct medicine data', () async { 
      final provider = MedicineProvider(); 
      addMed(provider, 'Paracetamol', 
          dose: '1000mg', frequency: 'Twice Daily', time: '9:00 AM'); 
      await Future.delayed(const Duration(milliseconds: 100)); 
      final med = provider.medicines.firstWhere((m) => m.name == 'Paracetamol'); 
      expect(med.dose, '1000mg'); 
      expect(med.frequency, 'Twice Daily'); 
      expect(med.time, '9:00 AM'); 
    }); 
 
    test('addMedicine sets default status to pending', () async { 
      final provider = MedicineProvider(); 
      addMed(provider, 'Vitamin D'); 
      await Future.delayed(const Duration(milliseconds: 100)); 
      expect(provider.medicines.first.status, 'pending'); 
    }); 
 
    test('can add multiple medicines', () async { 
      final provider = MedicineProvider(); 
      addMed(provider, 'Medicine A'); 
      addMed(provider, 'Medicine B');
      addMed(provider, 'Medicine C'); 
      await Future.delayed(const Duration(milliseconds: 100)); 
      expect(provider.medicines.length, 3); 
    }); 
 
    test('updateStatus changes medicine status to taken', () async { 
      final provider = MedicineProvider(); 
      addMed(provider, 'Test Med'); 
      await Future.delayed(const Duration(milliseconds: 100)); 
      final med = provider.medicines.firstWhere((m) => m.name == 'Test Med'); 
      provider.updateStatus(med, 'taken'); 
      await Future.delayed(const Duration(milliseconds: 100)); 
      expect( 
        provider.medicines.firstWhere((m) => m.name == 'Test Med').status, 
        'taken', 
      ); 
    }); 
 
    test('updateStatus changes medicine status to skipped', () async { 
      final provider = MedicineProvider(); 
      addMed(provider, 'Skip Med'); 
      await Future.delayed(const Duration(milliseconds: 100)); 
      final med = provider.medicines.firstWhere((m) => m.name == 'Skip Med'); 
      provider.updateStatus(med, 'skipped'); 
      await Future.delayed(const Duration(milliseconds: 100)); 
      expect( 
        provider.medicines.firstWhere((m) => m.name == 'Skip Med').status, 
        'skipped', 
      ); 
    }); 
 
    test('deleteMedicine removes medicine from list', () async { 
      final provider = MedicineProvider(); 
      addMed(provider, 'Delete Me'); 
      await Future.delayed(const Duration(milliseconds: 100)); 
      expect(provider.medicines.length, 1); 
      final med = provider.medicines.first; 
      provider.deleteMedicine(med); 
      await Future.delayed(const Duration(milliseconds: 300)); 
      expect(provider.medicines.length, 0); 
    }); 
 
    test('deleteAll clears all medicines', () async { 
      final provider = MedicineProvider(); 
      for (int i = 0; i < 5; i++) { 
        addMed(provider, 'Medicine $i'); 
      } 
      await Future.delayed(const Duration(milliseconds: 100)); 
      expect(provider.medicines.length, 5); 
      provider.deleteAll(); 
      await Future.delayed(const Duration(milliseconds: 300)); 
      expect(provider.medicines.length, 0); 
    }); 
 
    test('updateMedicine changes medicine fields', () async { 
      final provider = MedicineProvider(); 
      addMed(provider, 'Old Name', dose: '100mg'); 
      await Future.delayed(const Duration(milliseconds: 100)); 
      final med = provider.medicines.firstWhere((m) => m.name == 'Old Name'); 
      provider.updateMedicine( 
        med, 
        name: 'New Name', 
        dose: '200mg', 
        frequency: 'Twice Daily', 
        time: '10:00 AM', 
        startDate: '5 Jan 2026', 
        endDate: '15 Jan 2026', 
      ); 
      await Future.delayed(const Duration(milliseconds: 300)); 
      final updated = 
          provider.medicines.firstWhere((m) => m.name == 'New Name'); 
      expect(updated.dose, '200mg'); 
      expect(updated.frequency, 'Twice Daily'); 
    }); 
 
    test('medicines list persists in Hive box', () async { 
      final provider1 = MedicineProvider(); 
      addMed(provider1, 'PersistentMed2026'); 
      await Future.delayed(const Duration(milliseconds: 100)); 
      final provider2 = MedicineProvider(); 
      expect( 
        provider2.medicines.any((m) => m.name == 'PersistentMed2026'), 
        true, 
      ); 
    }); 
 
    test('addMedicine uses default alarmSound', () async { 
      final provider = MedicineProvider(); 
      addMed(provider, 'SoundMed'); 
      await Future.delayed(const Duration(milliseconds: 100)); 
      final med = provider.medicines.firstWhere((m) => m.name == 'SoundMed'); 
      expect( 
        med.alarmSound, 
        'assets/alarm_sounds/gentle_bell.mp3', 
      ); 
    }); 
 
    test('addMedicine uses default vibrateEnabled true', () async { 
      final provider = MedicineProvider();
      addMed(provider, 'VibrateMed'); 
      await Future.delayed(const Duration(milliseconds: 100)); 
      final med = provider.medicines.firstWhere((m) => m.name == 'VibrateMed'); 
      expect(med.vibrateEnabled, true); 
    }); 
 
    test('updateStatus pending -> taken -> skipped', () async { 
      final provider = MedicineProvider(); 
      addMed(provider, 'CycleMed'); 
      await Future.delayed(const Duration(milliseconds: 100)); 
      final med = provider.medicines.firstWhere((m) => m.name == 'CycleMed'); 
      expect(med.status, 'pending'); 
      provider.updateStatus(med, 'taken'); 
      await Future.delayed(const Duration(milliseconds: 100)); 
      expect( 
        provider.medicines.firstWhere((m) => m.name == 'CycleMed').status, 
        'taken', 
      ); 
      provider.updateStatus(med, 'skipped'); 
      await Future.delayed(const Duration(milliseconds: 100)); 
      expect( 
        provider.medicines.firstWhere((m) => m.name == 'CycleMed').status, 
        'skipped', 
      ); 
    }); 
  }); 
}*/ 
// test/providers/medicine_provider_test.dart 
/* 
import 'dart:typed_data'; 
import 'package:flutter/services.dart'; 
import 'package:flutter_test/flutter_test.dart'; 
import 'package:hive_ce_flutter/hive_ce_flutter.dart'; 
import 'package:shared_preferences/shared_preferences.dart'; 
import 'package:medicine_reminder_app/models/medicine.dart'; 
import 'package:medicine_reminder_app/providers/medicine_provider.dart'; 
import 'dart:io'; 
 
// Returns a properly encoded StandardMethodCodec success envelope 
ByteData _successEnvelope(dynamic result) { 
  return const StandardMethodCodec().encodeSuccessEnvelope(result); 
} 
 
void _mockChannel(String channelName, dynamic returnValue) { 
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger 
      .setMockMessageHandler( 
    channelName, 
    (ByteData? message) async => _successEnvelope(returnValue), 
  ); 
} 
 
void main() { 
  TestWidgetsFlutterBinding.ensureInitialized(); 
 
  late Directory tempDir; 
 
  setUpAll(() async { 
    // ── Mock shared_preferences ────────────────────────────── 
    SharedPreferences.setMockInitialValues({}); 
 
    // ── Mock android_alarm_manager with proper encoding ────── 
    _mockChannel( 
      'dev.fluttercommunity.plus/android_alarm_manager', 
      true, 
    ); 
 
    // ── Mock audioplayers channels ──────────────────────────── 
    _mockChannel('xyz.luan/audioplayers', 1); 
    _mockChannel('xyz.luan/audioplayers.global', null); 
 
    // ── Hive setup ──────────────────────────────────────────── 
    tempDir = await Directory.systemTemp.createTemp('hive_medicine_test'); 
    Hive.init(tempDir.path); 
    if (!Hive.isAdapterRegistered(0)) { 
      Hive.registerAdapter(MedicineAdapter()); 
    } 
    await Hive.openBox<Medicine>('medicines'); 
  }); 
 
  setUp(() async { 
    SharedPreferences.setMockInitialValues({}); 
    // Re-register mock each setUp so it stays active 
    _mockChannel( 
      'dev.fluttercommunity.plus/android_alarm_manager', 
      true, 
    ); 
    _mockChannel('xyz.luan/audioplayers', 1); 
    _mockChannel('xyz.luan/audioplayers.global', null); 
 
    await Hive.box<Medicine>('medicines').clear(); 
  }); 
 
  tearDownAll(() async { 
    await Hive.close(); 
    await tempDir.delete(recursive: true); 
  }); 
 
  // ── helper ─────────────────────────────────────────────────── 
  void addMed( 
    MedicineProvider provider, 
    String name, { 
    String dose = '100mg', 
    String frequency = 'Once Daily', 
    String time = '8:00 AM', 
    int remainingDoses = 7, 
    String startDate = '1 Jan 2026', 
    String endDate = '8 Jan 2026', 
  }) { 
    provider.addMedicine( 
      name: name, 
      dose: dose, 
      frequency: frequency, 
      time: time, 
      remainingDoses: remainingDoses,
      startDate: startDate, 
      endDate: endDate, 
    ); 
  } 
 
  group('MedicineProvider', () { 
    test('starts with empty medicines list', () { 
      final provider = MedicineProvider(); 
      expect(provider.medicines, isEmpty); 
    }); 
 
    test('addMedicine increases list length', () async { 
      final provider = MedicineProvider(); 
      addMed(provider, 'Aspirin'); 
      await Future.delayed(const Duration(milliseconds: 200)); 
      expect(provider.medicines.length, 1); 
    }); 
 
    test('addMedicine stores correct medicine data', () async { 
      final provider = MedicineProvider(); 
      addMed(provider, 'Paracetamol', 
          dose: '1000mg', frequency: 'Twice Daily', time: '9:00 AM'); 
      await Future.delayed(const Duration(milliseconds: 200)); 
      final med = provider.medicines.firstWhere((m) => m.name == 'Paracetamol'); 
      expect(med.dose, '1000mg'); 
      expect(med.frequency, 'Twice Daily'); 
      expect(med.time, '9:00 AM'); 
    }); 
 
    test('addMedicine sets default status to pending', () async { 
      final provider = MedicineProvider(); 
      addMed(provider, 'Vitamin D'); 
      await Future.delayed(const Duration(milliseconds: 200)); 
      expect(provider.medicines.first.status, 'pending'); 
    }); 
 
    test('can add multiple medicines', () async { 
      final provider = MedicineProvider(); 
      addMed(provider, 'Medicine A'); 
      addMed(provider, 'Medicine B'); 
      addMed(provider, 'Medicine C'); 
      await Future.delayed(const Duration(milliseconds: 200)); 
      expect(provider.medicines.length, 3); 
    }); 
 
    test('updateStatus changes medicine status to taken', () async { 
      final provider = MedicineProvider(); 
      addMed(provider, 'Test Med'); 
      await Future.delayed(const Duration(milliseconds: 200)); 
      final med = provider.medicines.firstWhere((m) => m.name == 'Test Med'); 
      provider.updateStatus(med, 'taken'); 
      await Future.delayed(const Duration(milliseconds: 200)); 
      expect( 
        provider.medicines.firstWhere((m) => m.name == 'Test Med').status, 
        'taken', 
      ); 
    }); 
 
    test('updateStatus changes medicine status to skipped', () async { 
      final provider = MedicineProvider(); 
      addMed(provider, 'Skip Med'); 
      await Future.delayed(const Duration(milliseconds: 200)); 
      final med = provider.medicines.firstWhere((m) => m.name == 'Skip Med'); 
      provider.updateStatus(med, 'skipped'); 
      await Future.delayed(const Duration(milliseconds: 200)); 
      expect( 
        provider.medicines.firstWhere((m) => m.name == 'Skip Med').status, 
        'skipped', 
      ); 
    }); 
 
    test('deleteMedicine removes medicine from list', () async { 
      final provider = MedicineProvider(); 
      addMed(provider, 'Delete Me'); 
      await Future.delayed(const Duration(milliseconds: 200)); 
      expect(provider.medicines.length, 1); 
      final med = provider.medicines.first; 
      provider.deleteMedicine(med); 
      await Future.delayed(const Duration(milliseconds: 300)); 
      expect(provider.medicines.length, 0); 
    }); 
 
    test('deleteAll clears all medicines', () async { 
      final provider = MedicineProvider(); 
      for (int i = 0; i < 5; i++) { 
        addMed(provider, 'Medicine $i'); 
      } 
      await Future.delayed(const Duration(milliseconds: 200)); 
      expect(provider.medicines.length, 5); 
      provider.deleteAll(); 
      await Future.delayed(const Duration(milliseconds: 300)); 
      expect(provider.medicines.length, 0); 
    }); 
 
    test('updateMedicine changes medicine fields', () async { 
      final provider = MedicineProvider(); 
      addMed(provider, 'Old Name', dose: '100mg'); 
      await Future.delayed(const Duration(milliseconds: 200));
      final med = provider.medicines.firstWhere((m) => m.name == 'Old Name'); 
      provider.updateMedicine( 
        med, 
        name: 'New Name', 
        dose: '200mg', 
        frequency: 'Twice Daily', 
        time: '10:00 AM', 
        startDate: '5 Jan 2026', 
        endDate: '15 Jan 2026', 
      ); 
      await Future.delayed(const Duration(milliseconds: 300)); 
      final updated = 
          provider.medicines.firstWhere((m) => m.name == 'New Name'); 
      expect(updated.dose, '200mg'); 
      expect(updated.frequency, 'Twice Daily'); 
    }); 
 
    test('medicines list persists in Hive box', () async { 
      final provider1 = MedicineProvider(); 
      addMed(provider1, 'PersistentMed2026'); 
      await Future.delayed(const Duration(milliseconds: 200)); 
      final provider2 = MedicineProvider(); 
      expect( 
        provider2.medicines.any((m) => m.name == 'PersistentMed2026'), 
        true, 
      ); 
    }); 
 
    test('addMedicine uses default alarmSound', () async { 
      final provider = MedicineProvider(); 
      addMed(provider, 'SoundMed'); 
      await Future.delayed(const Duration(milliseconds: 200)); 
      final med = provider.medicines.firstWhere((m) => m.name == 'SoundMed'); 
      expect( 
        med.alarmSound, 
        'assets/alarm_sounds/gentle_bell.mp3', 
      ); 
    }); 
 
    test('addMedicine uses default vibrateEnabled true', () async { 
      final provider = MedicineProvider(); 
      addMed(provider, 'VibrateMed'); 
      await Future.delayed(const Duration(milliseconds: 200)); 
      final med = provider.medicines.firstWhere((m) => m.name == 'VibrateMed'); 
      expect(med.vibrateEnabled, true); 
    }); 
 
    test('updateStatus pending -> taken -> skipped', () async { 
      final provider = MedicineProvider(); 
      addMed(provider, 'CycleMed'); 
      await Future.delayed(const Duration(milliseconds: 200)); 
      final med = provider.medicines.firstWhere((m) => m.name == 'CycleMed'); 
      expect(med.status, 'pending'); 
 
      provider.updateStatus(med, 'taken'); 
      await Future.delayed(const Duration(milliseconds: 200)); 
      expect( 
        provider.medicines.firstWhere((m) => m.name == 'CycleMed').status, 
        'taken', 
      ); 
 
      provider.updateStatus(med, 'skipped'); 
      await Future.delayed(const Duration(milliseconds: 200)); 
      expect( 
        provider.medicines.firstWhere((m) => m.name == 'CycleMed').status, 
        'skipped', 
      ); 
    }); 
  }); 
} 
*/ 
// test/providers/medicine_provider_test.dart 
 
import 'dart:io'; 
import 'package:flutter/services.dart'; 
import 'package:flutter_test/flutter_test.dart'; 
import 'package:hive_ce_flutter/hive_ce_flutter.dart'; 
import 'package:shared_preferences/shared_preferences.dart'; 
import 'package:medicine_reminder_app/models/medicine.dart'; 
import 'package:medicine_reminder_app/providers/medicine_provider.dart'; 
 
// Helper to mock channels with the correct codec. Defaults to StandardMethodCodec, 
// but allows overriding for plugins like Android Alarm Manager that expect JSON. 
void _mockChannel( 
  String channelName, 
  dynamic returnValue, { 
  MethodCodec codec = const StandardMethodCodec(), 
}) { 
  final channel = MethodChannel(channelName, codec); 
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger 
      .setMockMethodCallHandler(channel, (MethodCall call) async { 
    return returnValue; 
  }); 
} 
 
void main() { 
  TestWidgetsFlutterBinding.ensureInitialized(); 
 
  late Directory tempDir; 
 
  setUpAll(() async { 
    // ── Mock shared_preferences ────────────────────────────── 
    SharedPreferences.setMockInitialValues({}); 
 
    // ── Mock android_alarm_manager with proper JSON encoding ────── 
    _mockChannel( 
      'dev.fluttercommunity.plus/android_alarm_manager',
      true, 
      codec: const JSONMethodCodec(), // Fixed: Use JSON Method Codec 
    ); 
 
    // ── Mock audioplayers channels ──────────────────────────── 
    _mockChannel('xyz.luan/audioplayers', 1); 
    _mockChannel('xyz.luan/audioplayers.global', null); 
 
    // ── Hive setup ──────────────────────────────────────────── 
    tempDir = await Directory.systemTemp.createTemp('hive_medicine_test'); 
    Hive.init(tempDir.path); 
    if (!Hive.isAdapterRegistered(0)) { 
      Hive.registerAdapter(MedicineAdapter()); 
    } 
    await Hive.openBox<Medicine>('medicines'); 
  }); 
 
  setUp(() async { 
    SharedPreferences.setMockInitialValues({}); 
 
    // Re-register mock each setUp so it stays active 
    _mockChannel( 
      'dev.fluttercommunity.plus/android_alarm_manager', 
      true, 
      codec: const JSONMethodCodec(), // Fixed: Use JSON Method Codec 
    ); 
 
    _mockChannel('xyz.luan/audioplayers', 1); 
    _mockChannel('xyz.luan/audioplayers.global', null); 
 
    await Hive.box<Medicine>('medicines').clear(); 
  }); 
 
  tearDownAll(() async { 
    await Hive.close(); 
    await tempDir.delete(recursive: true); 
  }); 
 
  // ── helper ─────────────────────────────────────────────────── 
  void addMed( 
    MedicineProvider provider, 
    String name, { 
    String dose = '100mg', 
    String frequency = 'Once Daily', 
    String time = '8:00 AM', 
    int remainingDoses = 7, 
    String startDate = '1 Jan 2026', 
    String endDate = '8 Jan 2026', 
  }) { 
    provider.addMedicine( 
      name: name, 
      dose: dose, 
      frequency: frequency, 
      time: time, 
      remainingDoses: remainingDoses, 
      startDate: startDate, 
      endDate: endDate, 
    ); 
  } 
 
  group('MedicineProvider', () { 
    test('starts with empty medicines list', () { 
      final provider = MedicineProvider(); 
      expect(provider.medicines, isEmpty); 
    }); 
 
    test('addMedicine increases list length', () async { 
      final provider = MedicineProvider(); 
      addMed(provider, 'Aspirin'); 
      await Future.delayed(const Duration(milliseconds: 200)); 
      expect(provider.medicines.length, 1); 
    }); 
 
    test('addMedicine stores correct medicine data', () async { 
      final provider = MedicineProvider(); 
      addMed(provider, 'Paracetamol', 
          dose: '1000mg', frequency: 'Twice Daily', time: '9:00 AM'); 
      await Future.delayed(const Duration(milliseconds: 200)); 
      final med = provider.medicines.firstWhere((m) => m.name == 'Paracetamol'); 
      expect(med.dose, '1000mg'); 
      expect(med.frequency, 'Twice Daily'); 
      expect(med.time, '9:00 AM'); 
    }); 
 
    test('addMedicine sets default status to pending', () async { 
      final provider = MedicineProvider(); 
      addMed(provider, 'Vitamin D'); 
      await Future.delayed(const Duration(milliseconds: 200)); 
      expect(provider.medicines.first.status, 'pending'); 
    }); 
 
    test('can add multiple medicines', () async { 
      final provider = MedicineProvider(); 
      addMed(provider, 'Medicine A'); 
      addMed(provider, 'Medicine B'); 
      addMed(provider, 'Medicine C'); 
      await Future.delayed(const Duration(milliseconds: 200)); 
      expect(provider.medicines.length, 3); 
    }); 
 
    test('updateStatus changes medicine status to taken', () async { 
      final provider = MedicineProvider(); 
      addMed(provider, 'Test Med'); 
      await Future.delayed(const Duration(milliseconds: 200)); 
      final med = provider.medicines.firstWhere((m) => m.name == 'Test Med'); 
      provider.updateStatus(med, 'taken'); 
      await Future.delayed(const Duration(milliseconds: 200)); 
      expect( 
        provider.medicines.firstWhere((m) => m.name == 'Test Med').status, 
        'taken', 
      ); 
    });