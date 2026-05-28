/*import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:medicine_reminder_app/providers/user_provider.dart';
import 'dart:io';

void main() {
  setUpAll(() async {
    final tempDir = await Directory.systemTemp.createTemp('hive_user_test');
    Hive.init(tempDir.path);
    await Hive.openBox('userBox');
  });

  setUp(() {
    Hive.box('userBox').clear();
  });

  tearDownAll(() async {
    await Hive.close();
  });

  group('UserProvider', () {
    test('default userName is empty string', () {
      final provider = UserProvider();
      expect(provider.userName, '');
    });

    test('default userEmail is empty string', () {
      final provider = UserProvider();
      expect(provider.userEmail, '');
    });

    test('updateUser saves name and email', () async {
      final provider = UserProvider();
      await provider.updateUser(
        name: 'Dawit Bekele',
        email: 'dawit@email.com',
      );

      expect(provider.userName, 'Dawit Bekele');
      expect(provider.userEmail, 'dawit@email.com');
    });

    test('updateUser trims whitespace from name', () async {
      final provider = UserProvider();
      await provider.updateUser(
        name: '  Tigist  ',
        email: 'tigist@email.com',
      );

      expect(provider.userName, 'Tigist');
    });

    test('updateUser trims whitespace from email', () async {
      final provider = UserProvider();
      await provider.updateUser(
        name: 'Yohannes',
        email: '  yohannes@email.com  ',
      );

      expect(provider.userEmail, 'yohannes@email.com');
    });

    test('user data persists across instances', () async {
      final provider1 = UserProvider();
      await provider1.updateUser(
        name: 'Mekdes',
        email: 'mekdes@test.com',
      );

      final provider2 = UserProvider();
      expect(provider2.userName, 'Mekdes');
      expect(provider2.userEmail, 'mekdes@test.com');
    });

    test('updateUser can overwrite existing data', () async {
      final provider = UserProvider();
      await provider.updateUser(name: 'First Name', email: 'first@email.com');
      await provider.updateUser(name: 'Second Name', email: 'second@email.com');

      expect(provider.userName, 'Second Name');
      expect(provider.userEmail, 'second@email.com');
    });
  });
}*/

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:medicine_reminder_app/providers/user_provider.dart';
import 'dart:io';

void main() {
  // FIX: updateUser is async — every test must await it
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('hive_user_test');
    Hive.init(tempDir.path);
    await Hive.openBox('userBox');
  });

  setUp(() async {
    // FIX: await the clear so box is empty before each test
    await Hive.box('userBox').clear();
  });

  tearDownAll(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  group('UserProvider', () {
    test('default userName is empty string', () {
      final provider = UserProvider();
      expect(provider.userName, '');
    });

    test('default userEmail is empty string', () {
      final provider = UserProvider();
      expect(provider.userEmail, '');
    });

    test('updateUser saves name and email', () async {
      final provider = UserProvider();
      // FIX: await the async updateUser call
      await provider.updateUser(
        name: 'Dawit Bekele',
        email: 'dawit@email.com',
      );
      expect(provider.userName, 'Dawit Bekele');
      expect(provider.userEmail, 'dawit@email.com');
    });

    test('updateUser trims whitespace from name', () async {
      final provider = UserProvider();
      await provider.updateUser(
        name: '  Tigist  ',
        email: 'tigist@email.com',
      );
      expect(provider.userName, 'Tigist');
    });

    test('updateUser trims whitespace from email', () async {
      final provider = UserProvider();
      await provider.updateUser(
        name: 'Yohannes',
        email: '  yohannes@email.com  ',
      );
      expect(provider.userEmail, 'yohannes@email.com');
    });

    test('user data persists across provider instances', () async {
      final provider1 = UserProvider();
      // FIX: await before creating second instance
      await provider1.updateUser(
        name: 'Mekdes',
        email: 'mekdes@test.com',
      );

      final provider2 = UserProvider();
      expect(provider2.userName, 'Mekdes');
      expect(provider2.userEmail, 'mekdes@test.com');
    });

    test('updateUser can overwrite existing data', () async {
      final provider = UserProvider();
      await provider.updateUser(name: 'First Name', email: 'first@email.com');
      await provider.updateUser(name: 'Second Name', email: 'second@email.com');
      expect(provider.userName, 'Second Name');
      expect(provider.userEmail, 'second@email.com');
    });

    test('empty name is stored as empty string', () async {
      final provider = UserProvider();
      await provider.updateUser(name: '', email: 'test@test.com');
      expect(provider.userName, '');
    });

    test('empty email is stored as empty string', () async {
      final provider = UserProvider();
      await provider.updateUser(name: 'Test', email: '');
      expect(provider.userEmail, '');
    });

    test('name with only spaces is trimmed to empty', () async {
      final provider = UserProvider();
      await provider.updateUser(name: '   ', email: 'test@test.com');
      expect(provider.userName, '');
    });
  });
}
