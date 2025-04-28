// lib/features/profile/domain/repositories/profile_repository.dart
import 'package:dartz/dartz.dart';
import 'package:puskeswan_app/core/errors/failures.dart';
import 'package:puskeswan_app/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getProfile();
  Future<Either<Failure, ProfileEntity>> updateProfile(ProfileEntity profile);
  Future<Either<Failure, void>> updateProfileImage(String imagePath);
  Future<Either<Failure, void>> logout();
  
  // New method for changing password
  Future<Either<Failure, void>> changePassword({
    required String oldPassword,
    required String newPassword,
  });
}