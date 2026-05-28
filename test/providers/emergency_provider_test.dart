import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:medicine_reminder_app/models/emergency_contact.dart';
import 'package:medicine_reminder_app/providers/emergency_provider.dart';
import 'dart:io';

void main() {
  late EmergencyProvider provider;

  setUpAll(() async {
    final tempDir =
        await Directory.systemTemp.createTemp('hive_emergency_test');
    Hive.init(tempDir.path);
    Hive.registerAdapter(EmergencyContactAdapter());
    await Hive.openBox<EmergencyContact>('emergencyBox');
  });

  setUp(() {
    Hive.box<EmergencyContact>('emergencyBox').clear();
    provider = EmergencyProvider();
  });

  tearDownAll(() async {
    await Hive.close();
  });

  group('EmergencyProvider', () {
    test('starts with no contacts', () {
      expect(provider.contacts, isEmpty);
    });

    test('addContact increases contacts length', () {
      provider.addContact(EmergencyContact(
        name: 'Dr. Abebe',
        relation: 'Doctor',
        phone: '+251900034259',
      ));

      expect(provider.contacts.length, 1);
    });

    test('addContact stores correct contact data', () {
      provider.addContact(EmergencyContact(
        name: 'Kebede',
        relation: 'Friend',
        phone: '+251912345678',
      ));

      final contact = provider.contacts.first;
      expect(contact.name, 'Kebede');
      expect(contact.relation, 'Friend');
      expect(contact.phone, '+251912345678');
    });

    test('can add multiple contacts', () {
      provider.addContact(EmergencyContact(
        name: 'Contact 1',
        relation: 'Doctor',
        phone: '+251911111111',
      ));
      provider.addContact(EmergencyContact(
        name: 'Contact 2',
        relation: 'Nurse',
        phone: '+251922222222',
      ));
      provider.addContact(EmergencyContact(
        name: 'Contact 3',
        relation: 'Family',
        phone: '+251933333333',
      ));

      expect(provider.contacts.length, 3);
    });

    test('removeContact decreases contacts length', () {
      provider.addContact(EmergencyContact(
        name: 'Removable',
        relation: 'Test',
        phone: '+251900000000',
      ));

      expect(provider.contacts.length, 1);
      final contact = provider.contacts.first;
      provider.removeContact(contact);

      expect(provider.contacts.length, 0);
    });

    test('clearAll removes all contacts', () {
      for (int i = 0; i < 4; i++) {
        provider.addContact(EmergencyContact(
          name: 'Contact $i',
          relation: 'Test',
          phone: '+25190000000$i',
        ));
      }

      expect(provider.contacts.length, 4);
      provider.clearAll();
      expect(provider.contacts.length, 0);
    });

    test('contacts persist across provider instances', () {
      provider.addContact(EmergencyContact(
        name: 'Persistent',
        relation: 'Doctor',
        phone: '+251900099999',
      ));

      final provider2 = EmergencyProvider();
      expect(provider2.contacts.isNotEmpty, true);
      expect(provider2.contacts.first.name, 'Persistent');
    });
  });
}
