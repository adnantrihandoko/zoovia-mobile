// lib/features/auth/data/datasources/auth_remote_datasource.dart
import 'package:dio/dio.dart';
import 'package:puskeswan_app/core/error_handling/error_handler.dart';
import 'package:puskeswan_app/features/rekammedis/rekam_medis_usecase.dart';
import '../models/login_response_model.dart';
import '../models/register_response_model.dart';
import '../models/otp_response_model.dart';

class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio);

  Future<LoginResponseModel> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/login',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'email': email,
          'password': password,
        },
      );
      return LoginResponseModel.fromJson(response.data);
    } catch (e) {
      throw ErrorHandler.handleException(e);
    }
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
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );
      return RegisterResponseModel.fromJson(response.data);
    } catch (e) {
      throw ErrorHandler.handleException(e);
    }
  }

  Future<OtpResponseModel> verifyOtp(String email, String otp) async {
    try {
      final response = await dio.post(
        '/otp/verify',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'email': email,
          'otp': otp,
        },
      );
      return OtpResponseModel.fromJson(response.data);
    } catch (e) {
      throw ErrorHandler.handleException(e);
    }
  }

  Future<OtpResponseModel> resendOtp(String email) async {
    try {
      final response = await dio.post(
        '/otp/resend',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'email': email,
        },
      );
      return OtpResponseModel.fromJson(response.data);
    } catch (e) {
      throw ErrorHandler.handleException(e);
    }
  }

  Future<LoginResponseModel> loginWithGoogle(String googleToken) async {
    try {
      final response = await dio.post(
        '/auth/google',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
        data: {
          'google_token': googleToken,
        },
      );

      // Jika server mengembalikan success=false
      if (response.data['success'] == false) {
        throw BusinessException(response.data['message'] ?? 'Login gagal');
      }

      return LoginResponseModel.fromJson(response.data);
    } catch (e) {
      throw ErrorHandler.handleException(e);
    }
  }

  Future<void> logout(String token) async {
    try {
      await dio.get(
        '/logout',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
    } catch (e) {
      throw ErrorHandler.handleException(e);
    }
  }
}
