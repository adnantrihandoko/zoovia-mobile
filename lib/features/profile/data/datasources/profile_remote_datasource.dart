// lib/features/profile/data/datasources/profile_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:puskeswan_app/features/profile/data/models/profile_model.dart';
import 'package:puskeswan_app/utils/flutter_secure_storage.dart';

class ProfileRemoteDataSource {
  final Dio dio;
  final AppFlutterSecureStorage _appFlutterSecureStorage;

  ProfileRemoteDataSource(this.dio, this._appFlutterSecureStorage);

  Future<ProfileModel> fetchProfile(String id) async {
    final debugStorage = await _appFlutterSecureStorage.getAllData();
    final storageToken = await _appFlutterSecureStorage.getData('token');
    print("PROFILE/DATA/DATASOURCES/PROFILEREMOTEDATASOURCE: $debugStorage");
    print("PROFILE/DATA/DATASOURCES/PROFILEREMOTEDATASOURCE: $storageToken");
    final response = await dio.post('/user/profile/create',
        data: {
          'id': id,
        },
        options: Options(headers: {
          "Authorization": "Bearer $storageToken",
          "Accept": "application/json",
          "Content-Type": "application/json"
        }));
    print("DATA/PROFILEDATASOURCES: ${response.data}");
    print("Response Status: ${response.statusCode}");
    print("Response Headers: ${response.headers}");
    return ProfileModel.fromJson(response.data);
  }

  Future<ProfileModel> updateProfile(
      Map<String, dynamic> profileData, String token) async {
    final response = await dio.post('/user/profile/create',
        data: profileData,
        options: Options(headers: {"Authorization": "Bearer $token"}));
    return ProfileModel.fromJson(response.data);
  }

  Future<void> uploadProfileImage(String filePath, String token) async {
    final formData = FormData.fromMap({
      'profile_image': await MultipartFile.fromFile(filePath),
    });
    await dio.post('/profile/image',
        data: formData,
        options: Options(headers: {"Authorization": "Bearer $token"}));
  }

  Future<bool> logout(String token) async {
    final response = await dio.post('/logout',
        options: Options(headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json",
        }));
    print("DATA/DATASOURCES: ${response.data['success']}");
    return response.data['success'];
  }

  // New method for changing password
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    await dio.post('/change-password', data: {
      'old_password': oldPassword,
      'new_password': newPassword,
    });
  }
}
