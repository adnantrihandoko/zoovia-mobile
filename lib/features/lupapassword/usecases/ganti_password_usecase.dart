// lib/features/auth/domain/usecases/reset_password_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:puskeswan_app/core/errors/failures.dart';
import 'package:puskeswan_app/features/lupapassword/data/lupa_password_repository.dart';

class ResetPasswordUseCase {
  final ForgotPasswordRepository repo;
  ResetPasswordUseCase(this.repo);

  Future<Either<Failure, void>> call(
      String email, String otp, String newPassword) async {
    if (newPassword.length < 8) {
      return Left(ValidationFailure(
          'Password minimal 8 karakter'));
    }
    return repo.resetPassword(email, otp, newPassword);
  }
}
