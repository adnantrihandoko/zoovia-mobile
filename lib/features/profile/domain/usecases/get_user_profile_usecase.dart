import 'package:dartz/dartz.dart';
import 'package:puskeswan_app/core/errors/failures.dart';
import 'package:puskeswan_app/features/profile/domain/entities/profile_entity.dart';
import 'package:puskeswan_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:puskeswan_app/utils/flutter_secure_storage.dart';

class GetUserProfileUsecase {
  final ProfileRepository _profileRepository;
  final AppFlutterSecureStorage _appFlutterSecureStorage;

  GetUserProfileUsecase(this._profileRepository, this._appFlutterSecureStorage);

  Future<Either<Failure, ProfileEntity>> execute() async {
    final id = await _appFlutterSecureStorage.getData('id');
    final data = await _profileRepository.getProfile(id);

    return data.fold(
      (failure) {
        print("Error fetching profile: $failure");
        return Left(failure); // Mengembalikan Left saat error
      },
      (profile) {
        print("Data received from getProfile: $profile");
        return Right(profile); // Mengembalikan Right saat berhasil
      },
    );
  }
}
