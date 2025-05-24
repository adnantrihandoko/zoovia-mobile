// lib/features/auth/domain/usecases/login_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:puskeswan_app/core/errors/failures.dart';
import 'package:puskeswan_app/features/auth/domain/entities/auth_entity.dart';
import 'package:puskeswan_app/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  /// Melakukan login dengan validasi input dan propagasi Failure
  Future<Either<Failure, AuthEntity>> execute(
      String email, String password) async {
    // Validasi input
    if (email.isEmpty || password.isEmpty) {
      return Left(ValidationFailure('Email dan password tidak boleh kosong.'));
    }
    // Validasi format email sederhana
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      return Left(ValidationFailure('Format email tidak valid.'));
    }

    // Panggil repository
    return await repository.login(email, password);
  }

  /// Menyimpan data (misal token) dengan error handling
  Future<Either<Failure, void>> simpanData(String key, String value) async {
    if (key.isEmpty || value.isEmpty) {
      return Left(ValidationFailure('Key dan value harus diisi.'));
    }
    return await repository.simpanToken(key, value);
  }
}
