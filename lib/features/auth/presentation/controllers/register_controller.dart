// lib\features\auth\presentation\controllers\register_controller.dart

import 'package:flutter/material.dart';
import 'package:puskeswan_app/features/auth/domain/usecases/register_usecase.dart';

// register_controller.dart
class RegisterProvider extends ChangeNotifier {
  final RegisterUseCase _registerUseCase;
  RegisterProvider(this._registerUseCase);

  bool _isLoading = false;
  String? _error;
  String? registeredEmail;
  bool get isLoading => _isLoading;
  String? get error => _error;


  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    _isLoading = true;
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
        _isLoading = false;
      },
      (email) {
        print('Registration succeeded with email: $email');
        registeredEmail = email;
        _isLoading = false;
      },
    );
    
     print('After registration, registeredEmail is: $registeredEmail');
    notifyListeners();
  }

  void resetError() {
    _error = null;
    notifyListeners();
  }
}