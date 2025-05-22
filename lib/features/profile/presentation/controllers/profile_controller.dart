// lib/features/profile/presentation/controllers/profile_controller.dart
import 'package:flutter/material.dart';
import 'package:puskeswan_app/core/errors/failures.dart';
import 'package:puskeswan_app/features/profile/domain/entities/profile_entity.dart';
import 'package:puskeswan_app/features/profile/domain/usecases/ganti_password_usecase.dart';
import 'package:puskeswan_app/features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:puskeswan_app/features/profile/domain/usecases/logout_usecase.dart';
import 'package:puskeswan_app/features/profile/domain/usecases/update_profile_usecase.dart';

class ProfileProvider with ChangeNotifier {
  final GetUserProfileUsecase _getUserProfileUseCase;
  final UpdateProfileUsecase _updateProfileUsecase;
  final LogoutUseCase? logoutUseCase;
  final ChangePasswordUseCase? changePasswordUseCase;

  bool _fetchingProfile = false; // Flag untuk mencegah double fetch

  ProfileProvider(
    this._getUserProfileUseCase,
    this._updateProfileUsecase, {
    this.logoutUseCase,
    this.changePasswordUseCase,
  });

  ProfileEntity? _profile;
  Failure? _error;
  bool _isLoading = false;

  ProfileEntity? get profile => _profile;
  Failure? get error => _error;
  bool get isLoading => _isLoading;

  // Method untuk mengatur ulang state (reset provider)
  void resetState() {
    _error = null;
    _isLoading = false;
    _fetchingProfile = false;
    notifyListeners();
  }

  Future<void> fetchProfile() async {
    // Jika sudah sedang mengambil profile, jangan ambil lagi
    if (_fetchingProfile) return;

    print("Mulai fetch profile...");
    _fetchingProfile = true;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _getUserProfileUseCase.execute();

      result.fold(
        (failure) {
          print("Fetch profile error: ${failure.message}");
          _error = failure;
          _isLoading = false;
          _fetchingProfile = false;
          notifyListeners();
        },
        (profile) {
          print("Fetch profile success! Nama: ${profile.nama}");
          _profile = profile;
          _error = null;
          _isLoading = false;
          _fetchingProfile = false;
          notifyListeners();
        },
      );
    } catch (e) {
      print("Exception saat fetch profile: $e");
      _error = ServerFailure(e.toString());
      _isLoading = false;
      _fetchingProfile = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile(ProfileEntity updatedProfile) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _updateProfileUsecase.execute(updatedProfile);
      debugPrint(updatedProfile.photoFile!.path);
      result.fold(
        (failure) {
          _error = failure;
          _isLoading = false;
          notifyListeners();
        },
        (profile) {
          _profile = profile;
          _error = null;
          _isLoading = false;
          notifyListeners();
        },
      );
    } catch (e) {
      _error = ServerFailure(e.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (changePasswordUseCase == null) {
      _error = ServerFailure('Change password not supported');
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await changePasswordUseCase!.execute(
      oldPassword: oldPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    return result.fold(
      (failure) {
        _error = failure;
        _isLoading = false;
        notifyListeners();
        return false;
      },
      (_) {
        _error = null;
        _isLoading = false;
        notifyListeners();
        return true;
      },
    );
  }

  Future<void> logout() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await logoutUseCase!.execute();

      result.fold(
        (failure) {
          _error = failure;
          _isLoading = false;
          notifyListeners();
        },
        (_) {
          _profile = null;
          _error = null;
          _isLoading = false;
          _fetchingProfile = false; // Reset flag saat logout
          notifyListeners();
        },
      );
    } catch (e) {
      _error = ServerFailure(e.toString());
      _isLoading = false;
      notifyListeners();
    }
  }
}
