import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppFlutterSecureStorage {

  final FlutterSecureStorage flutterSecureStorage;

  AppFlutterSecureStorage(this.flutterSecureStorage);

  Future<void> storeData(String key, String value) async {
    await flutterSecureStorage.write(key: key, value: value);
  }
  
}
