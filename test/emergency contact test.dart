import 'package:flutter_test/flutter_test.dart';
import 'package:medicine_reminder_app/models/emergency_contact.dart';

void main() {
  group('EmergencyContact Model', () {
    test('creates contact with all required fields', () {
      final contact = EmergencyContact(
        name: 'Dr. Abebe',
        relation: 'Doctor',
        phone: '+251900034259',
      );

      expect(contact.name, 'Dr. Abebe');
      expect(contact.relation, 'Doctor');
      expect(contact.phone, '+251900034259');
    });

    test('creates contact with family relation', () {
      final contact = EmergencyContact(
        name: 'Kebede',
        relation: 'Brother',
        phone: '+251912345678',
      );

      expect(contact.name, 'Kebede');
      expect(contact.relation, 'Brother');
      expect(contact.phone, '+251912345678');
    });

    test('name can be a single character', () {
      final contact = EmergencyContact(
        name: 'A',
        relation: 'Friend',
        phone: '+251900000000',
      );

      expect(contact.name.length, 1);
      expect(contact.name[0], 'A');
    });

    test('phone stores international format', () {
      final contact = EmergencyContact(
        name: 'Nurse Tigist',
        relation: 'Nurse',
        phone: '+251111234567',
      );

      expect(contact.phone.startsWith('+'), true);
    });

    test('relation field accepts various types', () {
      final relations = [
        'Doctor',
        'Spouse',
        'Parent',
        'Sibling',
        'Friend',
        'Nurse',
        'Caregiver',
      ];

      for (final relation in relations) {
        final contact = EmergencyContact(
          name: 'Test',
          relation: relation,
          phone: '+251900000000',
        );
        expect(contact.relation, relation);
      }
    });

    test('two contacts with same data are independent objects', () {
      final contact1 = EmergencyContact(
        name: 'Dawit',
        relation: 'Father',
        phone: '+251911111111',
      );

      final contact2 = EmergencyContact(
        name: 'Dawit',
        relation: 'Father',
        phone: '+251911111111',
      );

      expect(contact1.name, contact2.name);
      expect(contact1.phone, contact2.phone);
      expect(identical(contact1, contact2), false);
    });
  });
}