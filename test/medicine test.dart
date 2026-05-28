import 'package:flutter_test/flutter_test.dart'; 
import 'package:medicine_reminder_app/models/medicine.dart'; 
 
void main() { 
  group('Medicine Model', () { 
    test('creates Medicine with required fields', () { 
      final med = Medicine( 
        name: 'Aspirin', 
        dose: '500mg', 
        frequency: 'Once Daily', 
        time: '8:00 AM', 
        remainingDoses: 7, 
        startDate: '1 Jan 2026', 
        endDate: '30 Jan 2026', 
      ); 
 
      expect(med.name, 'Aspirin'); 
      expect(med.dose, '500mg'); 
      expect(med.frequency, 'Once Daily'); 
      expect(med.time, '8:00 AM'); 
      expect(med.remainingDoses, 7); 
      expect(med.startDate, '1 Jan 2026'); 
      expect(med.endDate, '30 Jan 2026'); 
    }); 
 
    test('default status is pending', () { 
      final med = Medicine( 
        name: 'Paracetamol', 
        dose: '1000mg', 
        frequency: 'Twice Daily', 
        time: '9:00 AM', 
        remainingDoses: 14, 
        startDate: '1 Jan 2026', 
        endDate: '15 Jan 2026', 
      ); 
 
      expect(med.status, 'pending'); 
    }); 
 
    test('default alarmSound is gentle_bell', () { 
      final med = Medicine( 
        name: 'Ibuprofen', 
        dose: '400mg', 
        frequency: 'Once Daily', 
        time: '10:00 AM', 
        remainingDoses: 10, 
        startDate: '1 Jan 2026', 
        endDate: '10 Jan 2026', 
      ); 
 
      expect( 
        med.alarmSound, 
        'assets/alarm_sounds/gentle_bell.mp3', 
      ); 
    }); 
 
    test('default vibrateEnabled is true', () { 
      final med = Medicine( 
        name: 'Vitamin C', 
        dose: '500mg', 
        frequency: 'Once Daily', 
        time: '7:00 AM', 
        remainingDoses: 30, 
        startDate: '1 Jan 2026', 
        endDate: '31 Jan 2026', 
      ); 
 
      expect(med.vibrateEnabled, true); 
    }); 
 
    test('custom status can be set', () { 
      final med = Medicine( 
        name: 'Metformin', 
        dose: '850mg', 
        frequency: 'Twice Daily', 
        time: '8:00 AM', 
        remainingDoses: 60, 
        startDate: '1 Jan 2026', 
        endDate: '28 Feb 2026', 
        status: 'taken', 
      ); 
 
      expect(med.status, 'taken'); 
    }); 
 
    test('custom alarmSound can be set', () { 
      final med = Medicine( 
        name: 'Omeprazole', 
        dose: '20mg', 
        frequency: 'Once Daily', 
        time: '7:30 AM', 
        remainingDoses: 28, 
        startDate: '1 Jan 2026', 
        endDate: '28 Jan 2026', 
        alarmSound: 'assets/alarm_sounds/urgent_beep.mp3', 
      ); 
 
      expect( 
        med.alarmSound, 
        'assets/alarm_sounds/urgent_beep.mp3', 
      ); 
    }); 
 
    test('fromJson creates Medicine correctly', () { 
      final json = { 
        'name': 'Amoxicillin', 
        'dose': '250mg', 
        'frequency': 'Three Times Daily', 
        'time': '9:00 AM', 
        'remainingDoses': 21, 
        'startDate': '1 Jan 2026', 
        'endDate': '7 Jan 2026', 
        'status': 'pending', 
      }; 
 
      final med = Medicine.fromJson(json); 
 
      expect(med.name, 'Amoxicillin'); 
      expect(med.dose, '250mg'); 
      expect(med.frequency, 'Three Times Daily'); 
      expect(med.time, '9:00 AM'); 
      expect(med.remainingDoses, 21); 
    }); 
 
    test('fromJson uses defaults for missing fields', () { 
      final json = { 
        'name': 'Test Medicine', 
        'dose': '100mg', 
        'frequency': 'Once Daily', 
        'time': '8:00 AM', 
      }; 
 
      final med = Medicine.fromJson(json); 
 
      expect(med.remainingDoses, 7); 
      expect(med.startDate, ''); 
      expect(med.endDate, ''); 
      expect(med.status, 'pending'); 
    }); 
 
    test('vibrateEnabled can be disabled', () { 
      final med = Medicine( 
        name: 'Sleeping Aid',
        dose: '10mg', 
        frequency: 'Once Daily', 
        time: '10:00 PM', 
        remainingDoses: 30, 
        startDate: '1 Jan 2026', 
        endDate: '31 Jan 2026', 
        vibrateEnabled: false, 
      ); 
 
      expect(med.vibrateEnabled, false); 
    }); 
  }); 
}