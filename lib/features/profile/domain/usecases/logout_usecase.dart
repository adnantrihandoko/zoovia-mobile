// lib/features/profile/domain/usecases/logout_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:puskeswan_app/core/errors/failures.dart';
import 'package:puskeswan_app/features/profile/domain/repositories/profile_repository.dart';

class LogoutUseCase {
  final ProfileRepository repository;

  LogoutUseCase(this.repository);

  Future<Either<Failure, void>> execute() async {
    return await repository.logout();
  }
}