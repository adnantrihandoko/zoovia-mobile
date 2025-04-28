// lib/features/profile/domain/usecases/change_password_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:puskeswan_app/core/errors/failures.dart';
import 'package:puskeswan_app/features/profile/domain/repositories/profile_repository.dart';

class ChangePasswordUseCase {
  final ProfileRepository repository;

  ChangePasswordUseCase(this.repository);

  Future<Either<Failure, void>> execute({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    // Validate input
    if (newPassword != confirmPassword) {
      return Left(ServerFailure('Password konfirmasi tidak cocok'));
    }

    // Call repository method
    return await repository.changePassword(
      oldPassword: oldPassword,
      newPassword: newPassword,
    );
  }
}