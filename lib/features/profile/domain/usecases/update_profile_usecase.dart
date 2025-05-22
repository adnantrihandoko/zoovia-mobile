// lib/features/profile/domain/usecases/update_profile_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:puskeswan_app/core/errors/failures.dart';
import 'package:puskeswan_app/features/profile/domain/entities/profile_entity.dart';
import 'package:puskeswan_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:puskeswan_app/utils/flutter_secure_storage.dart';

class UpdateProfileUsecase {
  final ProfileRepository _repository;
  final AppFlutterSecureStorage _secureStorage;

  UpdateProfileUsecase(this._repository, this._secureStorage);

  /// Executes the profile update flow.
  ///
  /// Returns [ProfileEntity] on success or [Failure] on error.
  Future<Either<Failure, ProfileEntity>> execute(ProfileEntity profile) async {
    try {
      // Retrieve token from secure storage
      final token = await _secureStorage.getData('token');

      if (token.isEmpty) {
        return Left(ServerFailure('Token tidak ditemukan'));
      }

      // Delegate to repository, passing the full entity (including photoFile)
      return await _repository.updateProfile(profile, token);

    } catch (e, stack) {
      // Log error if needed
      print('UpdateProfileUsecase error: $e');
      print(stack);
      return Left(ServerFailure(e.toString()));
    }
  }
}