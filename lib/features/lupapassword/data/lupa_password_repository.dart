// lib/features/auth/data/repositories/forgot_password_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:puskeswan_app/core/errors/failures.dart';
import 'package:puskeswan_app/features/auth/data/models/otp_response_model.dart';
import 'package:puskeswan_app/features/lupapassword/data/lupa_password_datasource.dart';

class ForgotPasswordRepository{
  final ForgotPasswordRemoteDataSource remote;
  ForgotPasswordRepository(this.remote);

  Future<Either<Failure, void>> requestReset(String email) async {
    try {
      await remote.requestReset(email);
      return const Right(null);
    } on Failure catch (f) {
      return Left(f);
    }
  }

  Future<Either<Failure, OtpResponseModel>> verifyOtp(
      String email, String otp) async {
    try {
      final model = await remote.verifyOtp(email, otp);
      return Right(model);
    } on Failure catch (f) {
      return Left(f);
    }
  }

  Future<Either<Failure, void>> resetPassword(
      String email, String otp, String newPassword) async {
    try {
      await remote.resetPassword(email, otp, newPassword);
      return const Right(null);
    } on Failure catch (f) {
      return Left(f);
    }
  }
}
