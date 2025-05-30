import 'package:flutter/material.dart';
import 'package:puskeswan_app/core/error_handling/error_handler.dart';
import 'package:puskeswan_app/core/errors/failures.dart';
import 'package:puskeswan_app/features/auth/domain/usecases/register_usecase.dart';

enum RegisterStatus {
  initial,
  loading,
  success,
  failure,
}

class RegisterProvider extends ChangeNotifier {
  final RegisterUseCase _registerUseCase;
  RegisterProvider(this._registerUseCase);

  RegisterStatus _status = RegisterStatus.initial;
  AppError? _appError;
  String? registeredEmail;

  bool get isLoading => _status == RegisterStatus.loading;
  bool get isSuccess => _status == RegisterStatus.success;
  AppError? get appError => _appError;
  RegisterStatus get status => _status;

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    _status = RegisterStatus.loading;
    _appError = null;
    notifyListeners();

    final result = await _registerUseCase.execute(
      name: name,
      email: email,
      phone: phone,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );

    result.fold(
      (failure) {
        _appError = ErrorHandler.handleFailure(failure);
        _status = RegisterStatus.failure;
      },
      (email) {
        registeredEmail = email;
        _status = RegisterStatus.success;
      },
    );
    notifyListeners();
  }

  void resetError() {
    _appError = null;
    notifyListeners();
  }

  void resetStatus() {
    _status = RegisterStatus.initial;
    notifyListeners();
  }
}
