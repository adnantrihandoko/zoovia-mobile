import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:puskeswan_app/core/errors/failures.dart';

class SecureStorage {
  final FlutterSecureStorage _flutterSecureStorage;
  SecureStorage(this._flutterSecureStorage);

  Future<void> setToken(String token) {
    _flutterSecureStorage.deleteAll();
    return _flutterSecureStorage.write(key: 'apiToken', value: token);
  }

  Future<String?> getToken() async {
    return await _flutterSecureStorage.read(key: 'apiToken');
  }
}
