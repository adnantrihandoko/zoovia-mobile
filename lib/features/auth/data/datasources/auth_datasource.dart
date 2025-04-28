// lib\features\auth\data\datasources\auth_remote_datasource.dart

import 'package:dio/dio.dart';
import 'package:puskeswan_app/core/errors/failures.dart';
import '../models/login_response_model.dart';
import '../models/register_response_model.dart';
import '../models/otp_response_model.dart';

class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio);

  Future<LoginResponseModel> login(String email, String password) async {
    final response = await dio.post(
      '/login',
      data: {'email': email, 'password': password},
    );
    return LoginResponseModel.fromJson(response.data);
  }

  Future<RegisterResponseModel> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await dio.post(
        '/register',
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );
      return RegisterResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      // Tambahkan logging detail
      print('Server error: ${e.response?.statusCode} - ${e.response?.data}');
      rethrow;
    }
  }

  Future<OtpResponseModel> verifyOtp(String email, String otp) async {
    final response = await dio.post(
      '/verify-otp',
      data: {'email': email, 'otp': otp},
    );
    return OtpResponseModel.fromJson(response.data);
  }

  Future<OtpResponseModel> resendOtp(String email) async {
    final response = await dio.post(
      '/resend-otp',
      data: {'email': email},
    );
    return OtpResponseModel.fromJson(response.data);
  }

  Future<LoginResponseModel> loginWithGoogle(String googleToken) async {
    try {
      final response = await dio.post(
        '/auth/google',
        data: {'google_token': googleToken},
      );

      // Cek jika format respons sesuai ekspektasi
      if (response.data['success'] == false) {
        throw Exception(response.data['message'] ?? 'Login gagal');
      }

      return LoginResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      ServerFailure(e.toString());
      rethrow;
    }
    
  }

}
