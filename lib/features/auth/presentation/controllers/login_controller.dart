// lib\features\auth\presentation\controllers\login_controller.dart

import 'package:flutter/foundation.dart';
import 'package:puskeswan_app/core/errors/failures.dart';
import 'package:puskeswan_app/features/auth/data/datasources/google_auth_service.dart';
import 'package:puskeswan_app/features/auth/domain/entities/auth_entity.dart';
import 'package:puskeswan_app/features/auth/domain/usecases/google_login_usecase.dart';
import 'package:puskeswan_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:puskeswan_app/utils/flutter_secure_storage.dart';

class AuthProvider with ChangeNotifier {
  final LoginUseCase loginUseCase;
  final GoogleLoginUseCase? googleLoginUseCase;
  final GoogleAuthService googleAuthService;
  final AppFlutterSecureStorage _appFlutterSecureStorage;

  AuthProvider(
    this.loginUseCase,
    this.googleLoginUseCase,
    this.googleAuthService,
    this._appFlutterSecureStorage,
  );

  bool _isLoading = false;
  Failure? _error;
  AuthEntity? _user;

  bool get isLoading => _isLoading;
  Failure? get error => _error;
  AuthEntity? get user => _user;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await loginUseCase.execute(email, password);

      return result.fold(
        (failure) {
          _error = failure;
          _isLoading = false;
          notifyListeners();
          return false;
        },
        (user) async {
          _user = user;
          print(
              "AUTH/PRESENTATION/CONTROLLERS/LOGINCONTROLLERS: ${user.token}");

          await loginUseCase.simpanData("token", user.token);
          await loginUseCase.simpanData("id", user.id);
          final tokenSave = await _appFlutterSecureStorage.getData('token');
          print("AUTH/PRESENTATION/CONTROLLERS/LOGINCONTROLLERS: $tokenSave");

          _error = null;
          _isLoading = false;
          notifyListeners();
          return true;
        },
      );
    } catch (e) {
      print(e.toString());
      _error = ServerFailure(e.toString());
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // google sign in
  Future<void> loginWithGoogle() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await googleLoginUseCase!.execute();

      result.fold(
        (failure) {
          _error = failure;
          _isLoading = false;
          notifyListeners();
        },
        (user) async {
          _user = user;

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
}
