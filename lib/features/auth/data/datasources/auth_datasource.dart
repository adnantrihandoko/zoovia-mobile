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
      options: Options(headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      }),
      data: {'email': email, 'password': password},
    );
    print("AUTH/DATA/DATASOURCES/AUTHDATASOURCES: ${response.data}");
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
        options: Options(headers: {
          "Accept": "application/json",
          "Content-Type": "application/json"
        }),
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );
      print("AUTHDATASOURCE/REGISTER: ${response.data}");
      return RegisterResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      // Tambahkan logging detail
      print('Server error: ${e.response?.statusCode} - ${e.response?.data}');
      rethrow;
    }
  }

  Future<OtpResponseModel> verifyOtp(String email, String otp) async {
    final response = await dio.post(
      '/otp/verify',
      data: {'email': email, 'otp': otp},
    );
    return OtpResponseModel.fromJson(response.data);
  }

  Future<OtpResponseModel> resendOtp(String email) async {
    final response = await dio.post(
      '/otp/resend',
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

  Future<void> logout(String token) async {
    try {
      final response = await dio.get('/logout',
          options: Options(headers: {
            "Accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "Bearer <$token>"
          }));
      return response.data;
    } catch (e) {
      print(e.toString());
    }
  }
}
