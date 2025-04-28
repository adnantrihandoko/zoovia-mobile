// lib\features\auth\data\repositories\auth_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:puskeswan_app/core/errors/failures.dart';
import 'package:puskeswan_app/features/auth/data/datasources/auth_datasource.dart';
import 'package:puskeswan_app/features/auth/data/datasources/secure_storage.dart';
import 'package:puskeswan_app/features/auth/domain/entities/auth_entity.dart';
import 'package:puskeswan_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SecureStorage storage;

  AuthRepositoryImpl(this.remoteDataSource, this.storage);

  @override
  Future<Either<Failure, AuthEntity>> login(
      String email, String password) async {
    try {
      final response = await remoteDataSource.login(email, password);
      return Right(response.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server error occurred'));
    }
  }

  @override
  Future<Either<Failure, String>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await remoteDataSource.register(
        name: name,
        email: email,
        phone: phone,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      return Right(response.email);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Registration failed'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> verifyOtp(String email, String otp) async {
    try {
      await remoteDataSource.verifyOtp(email, otp);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'OTP verification failed'));
    }
  }

  @override
  Future<Either<Failure, void>> resendOtp(String email) async {
    try {
      await remoteDataSource.resendOtp(email);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to resend OTP'));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> loginWithGoogle(
      String googleToken) async {
    try {
      if (googleToken.isEmpty) {
        return Left(ServerFailure('Google token tidak valid'));
      }

      final response = await remoteDataSource.loginWithGoogle(googleToken);
      return Right(response.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Google login gagal'));
    } catch (e) {
      return Left(ServerFailure('Error login dengan Google'));
    }
  }

  @override
  Future<Either<Failure, void>> simpanToken(String apiToken) async {
    try {
      return Right(storage.setToken(apiToken));
    } catch (e) {
      return Left(ServerFailure("Gagal Menyimpan Token"));
    }
  }

  @override
  Future<String?> ambilToken() async {
    return await storage.getToken();
  }
}
