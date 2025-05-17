// lib/features/profile/data/repositories/profile_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:puskeswan_app/core/errors/failures.dart';
import 'package:puskeswan_app/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:puskeswan_app/features/profile/domain/entities/profile_entity.dart';
import 'package:puskeswan_app/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, ProfileEntity>> getProfile(String id) async {
    try {
      final profileModel = await remoteDataSource.fetchProfile(id);
      print("Profile Model from fetchProfile: $profileModel");

      // Langsung mengonversi model jika tidak ada masalah
      return Right(profileModel.toEntity());
    } on DioException catch (e) {
      print("DioException in getProfile: ${e.message}");
      return Left(ServerFailure(e.message ?? 'Failed to fetch profile'));
    } catch (e) {
      print("Unexpected error in getProfile: $e");
      return Left(ServerFailure('Unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateProfile(
      ProfileEntity profile, String token) async {
    try {
      final updatedProfileModel = await remoteDataSource.updateProfile({
        'id': profile.id,
        'nama': profile.nama,
        'email': profile.email,
        'no_hp': profile.no_hp,
        'photo': profile.photo,
      }, token);
      return Right(updatedProfileModel.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Gagal memperbarui profil'));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfileImage(
      String imagePath, String token) async {
    try {
      await remoteDataSource.uploadProfileImage(imagePath, token);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Gagal mengunggah foto profil'));
    }
  }

  @override
  Future<Either<Failure, bool>> logout(token) async {
    try {
      final result = await remoteDataSource.logout(token);
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Gagal logout'));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      await remoteDataSource.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Gagal mengubah password'));
    }
  }
}
