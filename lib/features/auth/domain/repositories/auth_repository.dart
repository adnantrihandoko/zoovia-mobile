// lib\features\auth\domain\repositories\auth_repository.dart

import 'package:dartz/dartz.dart';
import 'package:puskeswan_app/core/errors/failures.dart';
import 'package:puskeswan_app/features/auth/domain/entities/auth_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthEntity>> login(String email, String password);

  Future<Either<Failure, String>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  });

  Future<Either<Failure, void>> verifyOtp(String email, String otp);

  Future<Either<Failure, void>> resendOtp(String email);

  Future<Either<Failure, AuthEntity>> loginWithGoogle(String googleToken);

  Future<Either<Failure, void>> simpanToken(String key, String value);

  Future<String?> ambilToken(String key);

  Future<void> logout(String token);
}
