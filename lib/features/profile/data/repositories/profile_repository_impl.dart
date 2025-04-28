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
  Future<Either<Failure, ProfileEntity>> getProfile() async {
    try {
      final profileModel = await remoteDataSource.fetchProfile();
      return Right(profileModel.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Gagal mengambil profil'));
    }
  }

  @override
  Future<Either<Failure, ProfileEntity>> updateProfile(ProfileEntity profile) async {
    try {
      final updatedProfileModel = await remoteDataSource.updateProfile({
        'name': profile.name,
        'email': profile.email,
        'phone': profile.phoneNumber,
      });
      return Right(updatedProfileModel.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Gagal memperbarui profil'));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfileImage(String imagePath) async {
    try {
      await remoteDataSource.uploadProfileImage(imagePath);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Gagal mengunggah foto profil'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
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