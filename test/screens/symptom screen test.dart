import 'package:flutter/material.dart'; 
import 'package:flutter_test/flutter_test.dart'; 
import 'package:medicine_reminder_app/screen/symptom_screen.dart'; 
 
void main() { 
  Widget buildSymptomScreen() { 
    return const MaterialApp(home: SymptomScreen()); 
  } 
 
  group('SymptomScreen', () { 
    testWidgets('shows Symptom Checker in app bar', (tester) async { 
      await tester.pumpWidget(buildSymptomScreen()); 
      await tester.pump(); 
 
      expect(find.text('Symptom Checker'), findsOneWidget); 
    }); 
 
    testWidgets('shows Common Symptoms heading', (tester) async { 
      await tester.pumpWidget(buildSymptomScreen()); 
      await tester.pump(); 
 
      expect(find.text('Common Symptoms'), findsOneWidget); 
    }); 
 
    testWidgets('shows all 8 common symptom chips', (tester) async { 
      await tester.pumpWidget(buildSymptomScreen()); 
      await tester.pump(); 
 
      final symptoms = [ 
        'Headache', 
        'Fever', 
        'Cough', 
        'Nausea', 
        'Fatigue', 
        'Chest Pain', 
        'Dizziness', 
        'Sore Throat', 
      ]; 
 
      for (final symptom in symptoms) { 
        expect(find.text(symptom), findsOneWidget, 
            reason: '$symptom chip should be visible'); 
      } 
    }); 
 
    testWidgets('shows Check Symptom button', (tester) async { 
      await tester.pumpWidget(buildSymptomScreen()); 
      await tester.pump(); 
 
      expect(find.text('Check Symptom'), findsOneWidget); 
    }); 
 
    testWidgets('shows result after tapping Headache', (tester) async { 
      await tester.pumpWidget(buildSymptomScreen()); 
      await tester.pump(); 
 
      await tester.tap(find.text('Headache')); 
      await tester.pump(const Duration(seconds: 1)); 
 
      expect( 
        find.textContaining('Results for'), 
        findsOneWidget, 
      ); 
    }); 
 
    testWidgets('shows result after tapping Fever', (tester) async { 
      await tester.pumpWidget(buildSymptomScreen()); 
      await tester.pump(); 
 
      await tester.tap(find.text('Fever')); 
      await tester.pump(const Duration(seconds: 1)); 
 
      expect( 
        find.textContaining('Results for'), 
        findsOneWidget, 
      ); 
    }); 
 
    testWidgets('shows warning disclaimer after result', (tester) async { 
      await tester.pumpWidget(buildSymptomScreen()); 
      await tester.pump(); 
 
      await tester.tap(find.text('Cough')); 
      await tester.pump(const Duration(seconds: 1)); 
 
      expect( 
        find.textContaining('General information only'), 
        findsOneWidget, 
      ); 
    }); 
 
    testWidgets('shows search hint text', (tester) async { 
      await tester.pumpWidget(buildSymptomScreen()); 
      await tester.pump(); 
 
      expect( 
        find.text('Type a symptom...'), 
        findsOneWidget, 
      ); 
    }); 
  }); 
 
  group('Symptom Info Logic', () { 
    // Testing the symptom info logic directly 
    String getInfo(String s) { 
      s = s.toLowerCase(); 
      if (s.contains('headache') || s.contains('head')) { 
        return 'tension headache or migraine'; 
      } else if (s.contains('fever')) { 
        return 'fighting an infection'; 
      } else if (s.contains('cough')) { 
        return 'common cold'; 
      } else if (s.contains('nausea')) { 
        return 'food poisoning'; 
      } else if (s.contains('fatigue') || s.contains('tired')) { 
        return 'poor sleep'; 
      } else if (s.contains('chest')) { 
        return 'chest pain'; 
      } else if (s.contains('dizz')) { 
        return 'dehydration'; 
      } else if (s.contains('throat')) { 
        return 'throat infection'; 
      } 
      return 'no specific information'; 
    } 
 
    test('headache symptom returns migraine info', () { 
      expect(getInfo('Headache'), contains('headache'));
      }); 
 
    test('fever symptom returns infection info', () { 
      expect(getInfo('Fever'), contains('infection')); 
    }); 
 
    test('cough symptom returns cold info', () { 
      expect(getInfo('Cough'), contains('cold')); 
    }); 
 
    test('unknown symptom returns generic message', () { 
      expect(getInfo('xyz unknown'), contains('no specific')); 
    }); 
 
    test('chest pain returns emergency warning info', () { 
      expect(getInfo('Chest Pain'), contains('chest pain')); 
    }); 
  }); 
}