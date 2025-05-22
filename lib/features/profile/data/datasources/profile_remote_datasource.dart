// lib/features/profile/data/datasources/profile_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:puskeswan_app/features/profile/data/models/profile_model.dart';
import 'package:puskeswan_app/features/profile/domain/entities/profile_entity.dart';
import 'package:puskeswan_app/utils/flutter_secure_storage.dart';

class ProfileRemoteDataSource {
  final Dio dio;
  final AppFlutterSecureStorage _appFlutterSecureStorage;
  ProfileRemoteDataSource(this.dio, this._appFlutterSecureStorage);

  Future<ProfileModel> fetchProfile(String id) async {
    final debugStorage = await _appFlutterSecureStorage.getAllData();
    final storageToken = await _appFlutterSecureStorage.getData('token');
    print("PROFILE/DATA/DATASOURCES/PROFILEREMOTEDATASOURCE: $debugStorage");

    try {
      final response = await dio.post('/user/profile/createOrUpdate',
          data: {
            'id': id,
          },
          options: Options(headers: {
            "Authorization": "Bearer $storageToken",
            "Accept": "application/json",
            "Content-Type": "application/json"
          }));

      print("DATA/PROFILEDATASOURCES: ${response.data}");
      return ProfileModel.fromJson(response.data);
    } catch (e) {
      print("Error fetching profile: $e");
      rethrow;
    }
  }

  /// Create or update profile
  Future<ProfileModel> updateProfile(ProfileEntity entity, String token) async {
    dio.options.headers['Authorization'] = 'Bearer $token';
    final formData = await entity.toFormData();
    final resp = await dio.post(
      '/user/profile/createOrUpdate',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
    if (resp.statusCode != 200) {
      throw Exception('Failed to update profile');
    }
    return ProfileModel.fromJson(resp.data);
  }

  Future<bool> logout(String token) async {
    try {
      final response = await dio.post('/logout',
          options: Options(headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
            "Content-Type": "application/json",
          }));

      print("LOGOUT RESPONSE: ${response.data}");
      return response.data['success'] ?? false;
    } catch (e) {
      print("Error logging out: $e");
      rethrow;
    }
  }

  // New method for changing password
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      await dio.post('/change-password', data: {
        'old_password': oldPassword,
        'new_password': newPassword,
      });
    } catch (e) {
      print("Error changing password: $e");
      rethrow;
    }
  }
}
