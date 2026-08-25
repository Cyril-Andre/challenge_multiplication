import 'package:challengemultiplication/common/services/storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('StorageService', () {
    test('saves and reads a value', () async {
      final storage = StorageService();

      expect(StorageService.instance, same(storage));

      await storage.saveData('token', 'abc');

      expect(await storage.readData('token'), 'abc');
    });

    test('removes a stored value', () async {
      final storage = StorageService();

      await storage.saveData('token', 'abc');
      await storage.removeData('token');

      expect(await storage.readData('token'), isNull);
    });

    test('clears all stored values', () async {
      final storage = StorageService();

      await storage.saveData('first', '1');
      await storage.saveData('second', '2');
      await storage.clearAll();

      expect(await storage.readData('first'), isNull);
      expect(await storage.readData('second'), isNull);
    });
  });
}
