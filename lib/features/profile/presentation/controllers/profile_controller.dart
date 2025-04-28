// lib/features/profile/presentation/controllers/profile_controller.dart
import 'package:flutter/material.dart';
import 'package:puskeswan_app/core/errors/failures.dart';
import 'package:puskeswan_app/features/profile/domain/entities/profile_entity.dart';
import 'package:puskeswan_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:puskeswan_app/features/profile/domain/usecases/ganti_password_usecase.dart';
import 'package:puskeswan_app/features/profile/domain/usecases/logout_usecase.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileRepository _repository;
  final LogoutUseCase? logoutUseCase;
  final ChangePasswordUseCase? changePasswordUseCase;

  ProfileProvider(
    this._repository, {
    this.logoutUseCase,
    this.changePasswordUseCase,
  });

  ProfileEntity? _profile;
  Failure? _error;
  bool _isLoading = false;

  ProfileEntity? get profile => _profile;
  Failure? get error => _error;
  bool get isLoading => _isLoading;

  Future<void> fetchProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _repository.getProfile();

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
  }

  Future<void> updateProfile(ProfileEntity updatedProfile) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _repository.updateProfile(updatedProfile);

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
  }

  Future<void> updateProfileImage(String imagePath) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _repository.updateProfileImage(imagePath);

    result.fold(
      (failure) {
        _error = failure;
        _isLoading = false;
        notifyListeners();
      },
      (_) {
        // Refresh profile to get updated image
        fetchProfile();
      },
    );
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
    if (logoutUseCase == null) {
      _error = ServerFailure('Logout not supported');
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

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
        notifyListeners();
      },
    );
  }
}