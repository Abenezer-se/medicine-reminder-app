import 'package:flutter/material.dart'; 
import 'package:flutter_test/flutter_test.dart'; 
import 'package:provider/provider.dart'; 
import 'package:hive_ce_flutter/hive_ce_flutter.dart'; 
import 'package:medicine_reminder_app/models/medicine.dart'; 
import 'package:medicine_reminder_app/providers/medicine_provider.dart'; 
import 'package:medicine_reminder_app/widgets/notification_button.dart'; 
import 'dart:io'; 
 
void main() { 
  setUpAll(() async { 
    final tempDir = await Directory.systemTemp.createTemp('hive_notif_test'); 
    Hive.init(tempDir.path); 
    Hive.registerAdapter(MedicineAdapter()); 
    await Hive.openBox<Medicine>('medicines'); 
  }); 
 
  setUp(() { 
    Hive.box<Medicine>('medicines').clear(); 
  }); 
 
  tearDownAll(() async { 
    await Hive.close(); 
  }); 
 
  Widget buildWithNotificationButton() { 
    return MultiProvider( 
      providers: [ 
        ChangeNotifierProvider(create: (_) => MedicineProvider()), 
      ], 
      child: const MaterialApp( 
        home: Scaffold( 
          appBar: null, 
          body: Center(child: NotificationButton()), 
        ), 
      ), 
    ); 
  } 
 
  group('NotificationButton', () { 
    testWidgets('renders notification icon', (tester) async { 
      await tester.pumpWidget(buildWithNotificationButton()); 
      await tester.pump(); 
 
      expect(find.byIcon(Icons.notifications), findsOneWidget); 
    }); 
 
    testWidgets('tapping shows bottom sheet', (tester) async { 
      await tester.pumpWidget(buildWithNotificationButton()); 
      await tester.pump(); 
 
      await tester.tap(find.byIcon(Icons.notifications)); 
      await tester.pump(); 
 
      expect(find.text('Reminders'), findsOneWidget); 
    }); 
 
    testWidgets('shows no reminders message when empty', (tester) async { 
      await tester.pumpWidget(buildWithNotificationButton()); 
      await tester.pump(); 
 
      await tester.tap(find.byIcon(Icons.notifications)); 
      await tester.pump(); 
 
      expect(find.text('No reminders yet'), findsOneWidget); 
    }); 
 
    testWidgets('shows add medicines message when no medicines added', 
        (tester) async { 
      await tester.pumpWidget(buildWithNotificationButton()); 
      await tester.pump(); 
 
      await tester.tap(find.byIcon(Icons.notifications)); 
      await tester.pump(); 
 
      expect( 
        find.text('Add medicines to see upcoming reminders'), 
        findsOneWidget, 
      ); 
    }); 
  }); 
}