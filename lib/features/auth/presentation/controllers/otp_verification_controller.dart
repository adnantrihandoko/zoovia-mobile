// lib\features\auth\presentation\controllers\otp_verification_controller.dart

import 'package:flutter/material.dart';
import 'package:puskeswan_app/core/errors/failures.dart';
import 'package:puskeswan_app/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:puskeswan_app/features/auth/domain/usecases/verify_otp_usecase.dart';

class OtpVerificationProvider with ChangeNotifier {
  final VerifyOtpUseCase verifyOtpUseCase;
  final ResendOtpUseCase resendOtpUseCase;

  OtpVerificationProvider({
    required this.verifyOtpUseCase,
    required this.resendOtpUseCase,
  });

  bool _isLoading = false;
  bool _isResending = false;
  Failure? _error;

  bool get isLoading => _isLoading;
  bool get isResending => _isResending;
  Failure? get error => _error;

  Future<void> verifyOtp(String email, String otp) async {
    _isLoading = true;
    notifyListeners();

    final result = await verifyOtpUseCase.execute(email, otp);

    result.fold(
      (failure) {
        _error = failure;
        _isLoading = false;
        notifyListeners();
      },
      (_) {
        _error = null;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> resendOtp(String email) async {
    _isResending = true;
    notifyListeners();

    final result = await resendOtpUseCase.execute(email);

    result.fold(
      (failure) {
        _error = failure;
        _isResending = false;
        notifyListeners();
      },
      (_) {
        _error = null;
        _isResending = false;
        notifyListeners();
      },
    );
  }
}