// lib\features\auth\presentation\controllers\login_controller.dart

import 'package:flutter/foundation.dart';
import 'package:puskeswan_app/core/errors/failures.dart';
import 'package:puskeswan_app/features/auth/domain/entities/auth_entity.dart';
import 'package:puskeswan_app/features/auth/domain/usecases/google_login_usecase.dart';
import 'package:puskeswan_app/features/auth/domain/usecases/login_usecase.dart';

class AuthProvider with ChangeNotifier {
  final LoginUseCase loginUseCase;
  final GoogleLoginUseCase? googleLoginUseCase;

  AuthProvider(this.loginUseCase, this.googleLoginUseCase);

  bool _isLoading = false;
  Failure? _error;
  AuthEntity? _user;

  bool get isLoading => _isLoading;
  Failure? get error => _error;
  AuthEntity? get user => _user;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final result = await loginUseCase.execute(email, password);

    result.fold(
      (failure) {
        _error = failure;
        _isLoading = false;
        notifyListeners();
      },
      (user) {
        _user = user;
        _error = null;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // google sign in
  Future<void> loginWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    final result = await googleLoginUseCase!.execute();

    result.fold(
      (failure) {
        _error = failure;
        _isLoading = false;
        notifyListeners();
      },
      (user) {
        _user = user;
        _error = null;
        _isLoading = false;
        notifyListeners();
        // Navigasi setelah login sukses
      },
    );
  }
}