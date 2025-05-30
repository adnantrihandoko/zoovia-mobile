import 'package:flutter/foundation.dart';
import 'package:puskeswan_app/core/error_handling/error_handler.dart';
import 'package:puskeswan_app/core/errors/failures.dart';
import 'package:puskeswan_app/features/auth/data/datasources/google_auth_service.dart';
import 'package:puskeswan_app/features/auth/domain/entities/auth_entity.dart';
import 'package:puskeswan_app/features/auth/domain/usecases/google_login_usecase.dart';
import 'package:puskeswan_app/features/auth/domain/usecases/login_usecase.dart';

class AuthProvider with ChangeNotifier {
  final LoginUseCase loginUseCase;
  final GoogleLoginUseCase? googleLoginUseCase;
  final GoogleAuthService googleAuthService;

  AuthProvider(
    this.loginUseCase,
    this.googleLoginUseCase,
    this.googleAuthService,
  );

  bool _isLoading = false;
  AppError? _appError;
  AuthEntity? _user;

  bool get isLoading => _isLoading;
  AppError? get appError => _appError;
  AuthEntity? get user => _user;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _appError = null;
    notifyListeners();

    try {
      final result = await loginUseCase.execute(email, password);
      return result.fold(
        (failure) {
          _appError = ErrorHandler.handleFailure(failure);
          _isLoading = false;
          notifyListeners();
          return false;
        },
        (user) async {
          _user = user;

          await loginUseCase.simpanData("token", user.token);
          await loginUseCase.simpanData("id", user.id);

          _appError = null;
          _isLoading = false;
          notifyListeners();
          return true;
        },
      );
    } catch (e) {
      _appError = ErrorHandler.handleFailure(ErrorHandler.handleException(e));
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> loginWithGoogle() async {
    _isLoading = true;
    _appError = null;
    notifyListeners();

    try {
      final result = await googleLoginUseCase!.execute();
      return result.fold(
        (failure) {
          _appError = ErrorHandler.handleFailure(failure);
          _isLoading = false;
          notifyListeners();
          return false;
        },
        (user) async {
          await loginUseCase.simpanData("token", user.token);
          await loginUseCase.simpanData("id", user.id);
          await loginUseCase.simpanData("name", user.name);
          await loginUseCase.simpanData("email", user.email);

          _user = user;
          _appError = null;
          _isLoading = false;
          notifyListeners();
          return true;
        },
      );
    } catch (e) {
      _appError = ErrorHandler.handleFailure(ErrorHandler.handleException(e));
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> registerWithGoogle() async {
    _isLoading = true;
    _appError = null;
    notifyListeners();

    try {
      final result = await googleLoginUseCase!.execute();
      return result.fold(
        (failure) {
          _appError = ErrorHandler.handleFailure(failure);
          _isLoading = false;
          notifyListeners();
          return false;
        },
        (user) async {
          await loginUseCase.simpanData("token", user.token);
          await loginUseCase.simpanData("id", user.id);
          await loginUseCase.simpanData("name", user.name);
          await loginUseCase.simpanData("email", user.email);

          _user = user;
          _appError = null;
          _isLoading = false;
          notifyListeners();
          return true;
        },
      );
    } catch (e) {
      _appError = ErrorHandler.handleFailure(ErrorHandler.handleException(e));
      debugPrint(e.toString());
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
