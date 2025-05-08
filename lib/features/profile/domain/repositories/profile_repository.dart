// lib/features/profile/domain/repositories/profile_repository.dart
import 'package:dartz/dartz.dart';
import 'package:puskeswan_app/core/errors/failures.dart';
import 'package:puskeswan_app/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getProfile(String id);
  Future<Either<Failure, ProfileEntity>> updateProfile(ProfileEntity profile, String token);
  Future<Either<Failure, void>> updateProfileImage(String imagePath, String token);
  Future<Either<Failure, bool>> logout(String token);
  Future<Either<Failure, void>> changePassword({
    required String oldPassword,
    required String newPassword,
  });
}