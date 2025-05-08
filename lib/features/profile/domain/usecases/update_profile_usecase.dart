import 'package:dartz/dartz.dart';
import 'package:puskeswan_app/core/errors/failures.dart';
import 'package:puskeswan_app/features/profile/domain/entities/profile_entity.dart';
import 'package:puskeswan_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:puskeswan_app/utils/flutter_secure_storage.dart';

class UpdateProfileUsecase {
  final ProfileRepository _profileRepository;
  final AppFlutterSecureStorage _appFlutterSecureStorage;

  UpdateProfileUsecase(this._profileRepository, this._appFlutterSecureStorage);

  Future<Either<Failure, ProfileEntity>> execute(ProfileEntity data) async {
    final token = await _appFlutterSecureStorage.getData('token');
    return await _profileRepository.updateProfile(data, token);
  }

  Future<Either<Failure, void>> updateProfileImage(String imagePath) async {
    final token = await _appFlutterSecureStorage.getData('token');
    return await _profileRepository.updateProfileImage(imagePath, token);
  }
}
