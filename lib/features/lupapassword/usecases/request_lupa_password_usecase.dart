// lib/features/auth/domain/usecases/request_forgot_password_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:puskeswan_app/core/errors/failures.dart';
import 'package:puskeswan_app/features/lupapassword/data/lupa_password_repository.dart';

class RequestForgotPasswordUseCase {
  final ForgotPasswordRepository repo;
  RequestForgotPasswordUseCase(this.repo);

  Future<Either<Failure, void>> call(String email) async {
    if (email.isEmpty) {
      return Left(ValidationFailure('Email tidak boleh kosong'));
    }
    // bisa tambah validasi format email
    return repo.requestReset(email);
  }
}
