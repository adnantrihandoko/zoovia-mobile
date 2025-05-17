import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppFlutterSecureStorage {
  final FlutterSecureStorage _flutterSecureStorage;

  AppFlutterSecureStorage(this._flutterSecureStorage);

  Future<void> storeData(String key, String value) async {
    await _flutterSecureStorage.write(key: key, value: value);
  }

  Future<String> getData(String key) async {
    return await _flutterSecureStorage.read(key: key) ?? '';
  }

  Future<void> deleteData(String key) async {
    return await _flutterSecureStorage.delete(key: key);
  }

  Future<Map<String, String>> getAllData() async {
    return await _flutterSecureStorage.readAll();
  }

  Future<void> clearAllData() async {
    await _flutterSecureStorage.deleteAll();
  }
}
