// lib/features/auth/data/datasources/forgot_password_datasource.dart
import 'package:dio/dio.dart';
import 'package:puskeswan_app/core/error_handling/error_handler.dart';
import 'package:puskeswan_app/features/auth/data/models/otp_response_model.dart';

class ForgotPasswordRemoteDataSource {
  final Dio _dio;

  ForgotPasswordRemoteDataSource(this._dio);

  Future<void> requestReset(String email) async {
    try {
      await _dio.post('/password/forgot', data: {'email': email});
    } catch (e) {
      throw ErrorHandler.handleException(e);
    }
  }

  Future<OtpResponseModel> verifyOtp(String email, String otp) async {
    try {
      final resp = await _dio.post(
        '/password/forgot/verify-otp',
        data: {'email': email, 'otp': otp},
      );
      return OtpResponseModel.fromJson(resp.data);
    } catch (e) {
      throw ErrorHandler.handleException(e);
    }
  }

  Future<void> resetPassword(
      String email, String otp, String newPassword) async {
    try {
      await _dio.post(
        '/password/reset',
        data: {
          'email': email,
          'otp': otp,
          'password': newPassword,
          'password_confirmation': newPassword,
        },
      );
    } catch (e) {
      throw ErrorHandler.handleException(e);
    }
  }
}