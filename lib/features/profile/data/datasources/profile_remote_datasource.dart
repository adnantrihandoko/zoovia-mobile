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
    
    try {
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
      return ProfileModel.fromJson(response.data);
    } catch (e) {
      print("Error fetching profile: $e");
      rethrow;
    }
  }

  Future<ProfileModel> updateProfile(
      Map<String, dynamic> profileData, String token) async {
    // Jangan sertakan field 'photo' jika itu adalah URL (string)
    if (profileData.containsKey('photo') && 
        (profileData['photo'] is String) && 
        (profileData['photo'] as String).startsWith('http')) {
      profileData.remove('photo');
    }
    
    print("REQUEST[POST] => PATH: /user/profile/create");
    print("Request data: $profileData");
    
    try {
      final response = await dio.post('/user/profile/create',
          data: profileData,
          options: Options(headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
            "Content-Type": "application/json"
          }));
      
      print("UPDATE PROFILE RESPONSE: ${response.data}");
      return ProfileModel.fromJson(response.data);
    } catch (e) {
      print("Error updating profile: $e");
      rethrow;
    }
  }

  Future<String> uploadProfileImage(String filePath, String token) async {
    print("REQUEST[POST] => PATH: /profile/image");
    print("Uploading image from: $filePath");
    
    try {
      final formData = FormData.fromMap({
        'profile_image': await MultipartFile.fromFile(filePath),
      });
      
      final response = await dio.post('/profile/image',
          data: formData,
          options: Options(headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          }));
      
      // Mengembalikan URL foto yang baru diupload
      print("UPLOAD IMAGE RESPONSE: ${response.data}");
      if (response.data['status'] == 'success' && response.data['data'] != null) {
        String photoUrl = response.data['data']['photo'] ?? '';
        // Pastikan URL foto lengkap
        return photoUrl;
      }
      
      throw Exception('Failed to upload image: Invalid response');
    } catch (e) {
      print("Error uploading profile image: $e");
      rethrow;
    }
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