// lib/features/auth/presentation/providers/forgot_password_provider.dart

import 'package:flutter/foundation.dart';
import 'package:puskeswan_app/core/error_handling/error_handler.dart';
import 'package:puskeswan_app/core/errors/failures.dart';
import 'package:puskeswan_app/features/auth/data/models/otp_response_model.dart';
import 'package:puskeswan_app/features/lupapassword/usecases/ganti_password_usecase.dart';
import 'package:puskeswan_app/features/lupapassword/usecases/request_lupa_password_usecase.dart';
import 'package:puskeswan_app/features/lupapassword/usecases/verifikasi_otp_lupa_password_usecase.dart';

class ForgotPasswordProvider with ChangeNotifier {
  final RequestForgotPasswordUseCase requestUseCase;
  final VerifyOtpForgotPasswordUseCase verifyUseCase;
  final ResetPasswordUseCase resetUseCase;

  ForgotPasswordProvider({
    required this.requestUseCase,
    required this.verifyUseCase,
    required this.resetUseCase,
  });

  bool _isLoading = false;
  AppError? _appError;
  OtpResponseModel? _otpData;
  bool _isOtpVerified = false;
  bool _isResetSuccess = false;

  bool get isLoading => _isLoading;
  AppError? get appError => _appError;
  OtpResponseModel? get otpData => _otpData;
  bool get isOtpVerified => _isOtpVerified;
  bool get isResetSuccess => _isResetSuccess;

  Future<bool> requestReset(String email) async {
    _setLoading(true);
    final result = await requestUseCase.call(email);
    return result.fold(
      (f) {
        _handleFailure(f);
        _setLoading(false);
        return false;
      },
      (_) {
        _appError = null;
        _setLoading(false);
        return true;
      },
    );
  }

  Future<bool> verifyOtp(String email, String otp) async {
    _setLoading(true);
    final result = await verifyUseCase.call(email, otp);
    return result.fold(
      (f) {
        _handleFailure(f);
        _setLoading(false);
        return false;
      },
      (data) {
        _otpData = data;
        _isOtpVerified = true;
        _appError = null;
        _setLoading(false);
        return true;
      },
    );
  }

  Future<bool> resetPassword(
      String email, String otp, String newPassword) async {
    _setLoading(true);
    final result = await resetUseCase.call(email, otp, newPassword);
    return result.fold(
      (f) {
        _handleFailure(f);
        _setLoading(false);
        return false;
      },
      (_) {
        _isResetSuccess = true;
        _appError = null;
        _setLoading(false);
        return true;
      },
    );
  }

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  void _handleFailure(Failure f) {
    _appError = ErrorHandler.handleFailure(f);
    notifyListeners();
  }
}
