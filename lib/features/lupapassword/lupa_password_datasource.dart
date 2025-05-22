// lib/features/auth/data/datasources/forgot_password_datasource.dart
import 'package:dio/dio.dart';
import 'package:puskeswan_app/core/errors/failures.dart';

class ForgotPasswordRemoteDataSource {
  final Dio _dio;

  ForgotPasswordRemoteDataSource(this._dio);

  // Request OTP for password reset
  Future<bool> requestPasswordReset(String email) async {
    try {
      final response = await _dio.post(
        '/password/forgot',
        data: {'email': email},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'success') {
          return true;
        } else {
          throw ServerFailure(data['message'] ?? 'Gagal mengirim kode reset password');
        }
      } else {
        throw ServerFailure('Gagal mengirim permintaan: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        // Validation errors
        final errors = e.response?.data['errors'];
        final messages = errors is Map ? errors.values.join(', ') : 'Validasi email gagal';
        throw ServerFailure(messages);
      }
      throw NetworkFailure('Terjadi kesalahan jaringan: ${e.message}');
    } catch (e) {
      if (e is ServerFailure || e is NetworkFailure) {
        rethrow;
      }
      throw ServerFailure('Terjadi kesalahan: $e');
    }
  }

  // Verify OTP for password reset
  Future<bool> verifyResetOtp(String email, String otp) async {
    try {
      final response = await _dio.post(
        '/password/verify-otp',
        data: {
          'email': email,
          'otp': otp,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'success') {
          return true;
        } else {
          throw ServerFailure(data['message'] ?? 'Verifikasi OTP gagal');
        }
      } else {
        throw ServerFailure('Verifikasi gagal: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 400 || e.response?.statusCode == 422) {
        final message = e.response?.data['message'] ?? 'Kode OTP tidak valid';
        throw ServerFailure(message);
      }
      throw NetworkFailure('Terjadi kesalahan jaringan: ${e.message}');
    } catch (e) {
      if (e is ServerFailure || e is NetworkFailure) {
        rethrow;
      }
      throw ServerFailure('Terjadi kesalahan: $e');
    }
  }

  // Reset password
  Future<bool> resetPassword(String email, String password, String passwordConfirmation) async {
    try {
      final response = await _dio.post(
        '/password/reset',
        data: {
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == 'success') {
          return true;
        } else {
          throw ServerFailure(data['message'] ?? 'Gagal mengatur ulang password');
        }
      } else {
        throw ServerFailure('Gagal mengatur ulang password: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        // Validation errors
        final errors = e.response?.data['errors'];
        final messages = errors is Map ? errors.values.join(', ') : 'Validasi password gagal';
        throw ServerFailure(messages);
      }
      throw NetworkFailure('Terjadi kesalahan jaringan: ${e.message}');
    } catch (e) {
      if (e is ServerFailure || e is NetworkFailure) {
        rethrow;
      }
      throw ServerFailure('Terjadi kesalahan: $e');
    }
  }
}