// lib/features/auth/presentation/controllers/otp_verification_controller.dart

import 'package:flutter/material.dart';
import 'package:puskeswan_app/core/errors/failures.dart';
import 'package:puskeswan_app/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:puskeswan_app/features/auth/domain/usecases/verify_otp_usecase.dart';

enum OtpVerificationStatus {
  initial,
  loading,
  success,
  failure,
  resending,
  resendSuccess,
  resendFailure,
}

class OtpVerificationProvider with ChangeNotifier {
  final VerifyOtpUseCase verifyOtpUseCase;
  final ResendOtpUseCase resendOtpUseCase;

  OtpVerificationProvider({
    required this.verifyOtpUseCase,
    required this.resendOtpUseCase,
  });

  OtpVerificationStatus _status = OtpVerificationStatus.initial;
  Failure? _error;

  bool get isLoading => _status == OtpVerificationStatus.loading;
  bool get isResending => _status == OtpVerificationStatus.resending;
  bool get isSuccess => _status == OtpVerificationStatus.success;
  Failure? get error => _error;
  OtpVerificationStatus get status => _status;

  Future<void> verifyOtp(String email, String otp) async {
    _status = OtpVerificationStatus.loading;
    notifyListeners();

    final result = await verifyOtpUseCase.execute(email, otp);

    result.fold(
      (failure) {
        _error = failure;
        _status = OtpVerificationStatus.failure;
        notifyListeners();
      },
      (_) {
        _error = null;
        _status = OtpVerificationStatus.success;
        notifyListeners();
      },
    );
  }

  Future<void> resendOtp(String email) async {
    _status = OtpVerificationStatus.resending;
    notifyListeners();

    final result = await resendOtpUseCase.execute(email);

    result.fold(
      (failure) {
        _error = failure;
        _status = OtpVerificationStatus.resendFailure;
        notifyListeners();
      },
      (_) {
        _error = null;
        _status = OtpVerificationStatus.resendSuccess;
        notifyListeners();
      },
    );
  }
  
  void resetStatus() {
    _status = OtpVerificationStatus.initial;
    notifyListeners();
  }
}