// lib/features/profile/data/datasources/profile_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:puskeswan_app/features/profile/data/models/profile_model.dart';

class ProfileRemoteDataSource {
  final Dio dio;

  ProfileRemoteDataSource(this.dio);

  Future<ProfileModel> fetchProfile() async {
    final response = await dio.get('/profile');
    return ProfileModel.fromJson(response.data);
  }

  Future<ProfileModel> updateProfile(Map<String, dynamic> profileData) async {
    final response = await dio.put('/profile', data: profileData);
    return ProfileModel.fromJson(response.data);
  }

  Future<void> uploadProfileImage(String filePath) async {
    final formData = FormData.fromMap({
      'profile_image': await MultipartFile.fromFile(filePath),
    });
    await dio.post('/profile/image', data: formData);
  }

  Future<void> logout() async {
    await dio.post('/logout');
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