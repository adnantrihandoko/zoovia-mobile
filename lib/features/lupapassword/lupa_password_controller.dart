// lib/features/auth/presentation/controllers/forgot_password_controller.dart
import 'package:flutter/material.dart';
import 'package:puskeswan_app/features/lupapassword/lupa_passowrd_usecase.dart';

enum ForgotPasswordStatus {
  initial,
  loading,
  success,
  failure,
  verifyLoading,
  verifySuccess,
  verifyFailure,
  resetLoading,
  resetSuccess,
  resetFailure,
}

class ForgotPasswordProvider extends ChangeNotifier {
  final RequestPasswordResetUseCase _requestPasswordResetUseCase;
  final VerifyResetOtpUseCase _verifyResetOtpUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;

  ForgotPasswordStatus _status = ForgotPasswordStatus.initial;
  String? _errorMessage;
  bool _isLoading = false;

  // Getters
  ForgotPasswordStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  
  ForgotPasswordProvider(
    this._requestPasswordResetUseCase,
    this._verifyResetOtpUseCase,
    this._resetPasswordUseCase,
  );

  // Reset status
  void resetStatus() {
    _status = ForgotPasswordStatus.initial;
    _errorMessage = null;
    notifyListeners();
  }

  // Request password reset
  Future<bool> requestPasswordReset(String email) async {
    _status = ForgotPasswordStatus.loading;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _requestPasswordResetUseCase.execute(email);
      _status = ForgotPasswordStatus.success;
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _status = ForgotPasswordStatus.failure;
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Verify OTP
  Future<bool> verifyOtp(String email, String otp) async {
    _status = ForgotPasswordStatus.verifyLoading;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _verifyResetOtpUseCase.execute(email, otp);
      _status = ForgotPasswordStatus.verifySuccess;
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _status = ForgotPasswordStatus.verifyFailure;
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Reset password
  Future<bool> resetPassword(String email, String password, String passwordConfirmation) async {
    _status = ForgotPasswordStatus.resetLoading;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _resetPasswordUseCase.execute(email, password, passwordConfirmation);
      _status = ForgotPasswordStatus.resetSuccess;
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _status = ForgotPasswordStatus.resetFailure;
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}