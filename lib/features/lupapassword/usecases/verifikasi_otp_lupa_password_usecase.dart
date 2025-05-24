// lib/features/auth/domain/usecases/verify_otp_forgot_password_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:puskeswan_app/core/errors/failures.dart';
import 'package:puskeswan_app/features/auth/data/models/otp_response_model.dart';
import 'package:puskeswan_app/features/lupapassword/data/lupa_password_repository.dart';

class VerifyOtpForgotPasswordUseCase {
  final ForgotPasswordRepository repo;
  VerifyOtpForgotPasswordUseCase(this.repo);

  Future<Either<Failure, OtpResponseModel>> call(
      String email, String otp) async {
    if (otp.length != 6) {
      return Left(ValidationFailure('OTP harus 6 digit'));
    }
    return repo.verifyOtp(email, otp);
  }
}
