// lib/features/profile/domain/usecases/logout_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:puskeswan_app/core/errors/failures.dart';
import 'package:puskeswan_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:puskeswan_app/utils/flutter_secure_storage.dart';

class LogoutUseCase {
  final ProfileRepository repository;
  final AppFlutterSecureStorage _appFlutterSecureStorage;

  LogoutUseCase(this.repository, this._appFlutterSecureStorage);

  Future<Either<Failure, bool>> execute() async {
    final token = await _appFlutterSecureStorage.getData('token');
    final result = await repository.logout(token);
    return result.fold((failure) {
      return Left(ServerFailure("Terjadi Kesalahan"));
    }, (logout) {
      return result;
    });
  }
}
