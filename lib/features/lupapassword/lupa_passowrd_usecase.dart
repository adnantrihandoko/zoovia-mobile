// lib/features/auth/domain/usecases/forgot_password_usecase.dart
import 'package:puskeswan_app/core/errors/failures.dart';
import 'package:puskeswan_app/features/lupapassword/lupa_password_datasource.dart';

class RequestPasswordResetUseCase {
  final ForgotPasswordRemoteDataSource _remoteDatasource;

  RequestPasswordResetUseCase(this._remoteDatasource);

  Future<bool> execute(String email) async {
    try {
      // Validasi email sederhana
      if (email.trim().isEmpty) {
        throw BusinessException('Email tidak boleh kosong');
      }

      if (!_isValidEmail(email)) {
        throw BusinessException('Format email tidak valid');
      }

      return await _remoteDatasource.requestPasswordReset(email);
    } catch (e) {
      throw _handleError(e);
    }
  }

  bool _isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    return emailRegExp.hasMatch(email);
  }

  Exception _handleError(dynamic error) {
    if (error is BusinessException || error is ServerFailure || error is NetworkFailure) {
      return error;
    }
    return BusinessException('Terjadi kesalahan: ${error.toString()}');
  }
}

class VerifyResetOtpUseCase {
  final ForgotPasswordRemoteDataSource _remoteDatasource;

  VerifyResetOtpUseCase(this._remoteDatasource);

  Future<bool> execute(String email, String otp) async {
    try {
      // Validasi OTP
      if (otp.trim().isEmpty) {
        throw BusinessException('Kode OTP tidak boleh kosong');
      }

      if (otp.length != 4 || !RegExp(r'^[0-9]+$').hasMatch(otp)) {
        throw BusinessException('Kode OTP harus 4 digit angka');
      }

      return await _remoteDatasource.verifyResetOtp(email, otp);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic error) {
    if (error is BusinessException || error is ServerFailure || error is NetworkFailure) {
      return error;
    }
    return BusinessException('Terjadi kesalahan: ${error.toString()}');
  }
}

class ResetPasswordUseCase {
  final ForgotPasswordRemoteDataSource _remoteDatasource;

  ResetPasswordUseCase(this._remoteDatasource);

  Future<bool> execute(String email, String password, String passwordConfirmation) async {
    try {
      // Validasi password
      if (password.trim().isEmpty) {
        throw BusinessException('Password tidak boleh kosong');
      }

      if (password.length < 6) {
        throw BusinessException('Password minimal 6 karakter');
      }

      if (password != passwordConfirmation) {
        throw BusinessException('Password dan konfirmasi password tidak cocok');
      }

      return await _remoteDatasource.resetPassword(email, password, passwordConfirmation);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic error) {
    if (error is BusinessException || error is ServerFailure || error is NetworkFailure) {
      return error;
    }
    return BusinessException('Terjadi kesalahan: ${error.toString()}');
  }
}