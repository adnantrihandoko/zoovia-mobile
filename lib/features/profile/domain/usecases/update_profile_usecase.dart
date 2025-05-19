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

  Future<Either<Failure, ProfileEntity>> execute(ProfileEntity profile) async {
    try {
      final token = await _secureStorage.getData('token');
      
      if (token.isEmpty) {
        return Left(ServerFailure('Token tidak ditemukan'));
      }

      // Konversi entity ke map untuk dikirim ke repository
      final profileData = {
        'id': profile.id,
        'nama': profile.nama,
        'email': profile.email,
        'no_hp': profile.no_hp,
      };
      
      // Sertakan photo hanya jika bukan string kosong
      if (profile.photo.isNotEmpty) {
        profileData['photo'] = profile.photo;
      }

      return _repository.updateProfile(profileData, token);
    } catch (e) {
      print('UpdateProfileUsecase error: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, String>> updateProfileImage(String imagePath) async {
    try {
      final token = await _secureStorage.getData('token');
      
      if (token.isEmpty) {
        return Left(ServerFailure('Token tidak ditemukan'));
      }

      return _repository.updateProfileImage(imagePath, token);
    } catch (e) {
      print('UpdateProfileImageUsecase error: $e');
      return Left(ServerFailure(e.toString()));
    }
  }
}