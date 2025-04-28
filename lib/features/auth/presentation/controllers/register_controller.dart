// lib/features/auth/presentation/controllers/register_controller.dart

import 'package:flutter/material.dart';
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
  String? _error;
  String? registeredEmail;

  bool get isLoading => _status == RegisterStatus.loading;
  bool get isSuccess => _status == RegisterStatus.success;
  String? get error => _error;
  RegisterStatus get status => _status;

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    _status = RegisterStatus.loading;
    _error = null;
    notifyListeners();

    print('Starting registration with email: $email');

    final result = await _registerUseCase.execute(
      name: name,
      email: email,
      phone: phone,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );

    result.fold(
      (failure) {
        print('Registration failed: ${failure.message}');
        _error = failure.message;
        _status = RegisterStatus.failure;
      },
      (email) {
        print('Registration succeeded with email: $email');
        registeredEmail = email;
        _status = RegisterStatus.success;
      },
    );
    print('After registration, registeredEmail is: $registeredEmail');
    notifyListeners();
  }

  void resetError() {
    _error = null;
    notifyListeners();
  }

  void resetStatus() {
    _status = RegisterStatus.initial;
    notifyListeners();
  }
}
