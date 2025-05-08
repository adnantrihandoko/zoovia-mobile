// features/onboarding/presentation/notifiers/app_initial_state_notifier.dart
import 'package:flutter/material.dart';
import 'package:puskeswan_app/features/onboarding/inisiasi_app_repository.dart';

enum InisiasiAppState { loading, onboarding, login, home }

class InisiasiAppProvider with ChangeNotifier {
  final InisiasiAppRepository _repository;
  InisiasiAppState _state = InisiasiAppState.loading;

  InisiasiAppState get state => _state;

  InisiasiAppProvider(this._repository) {
    _initialize();
  }

  Future<void> _initialize() async {
    final isFirstRun = await _repository.isFirstRun();
    final isLoggedIn = await _repository.isLoggedIn();
    print("ONBOARDING/INISIASI_APP_PROVIDER: $isLoggedIn");
    print("ONBOARDING/INISIASI_APP_PROVIDER: $isFirstRun");

    _state = isFirstRun!
        ? InisiasiAppState.onboarding
        : isLoggedIn
            ? InisiasiAppState.home
            : InisiasiAppState.login;

    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    await _repository.setFirstRunCompleted();
    _state = InisiasiAppState.login;
    notifyListeners();
  }

  Future<void> login() async {
    await _repository.setLoggedIn(true);
    _state = InisiasiAppState.home;
    notifyListeners();
  }

  Future<void> logout() async {
    await _repository.setLoggedIn(false);
    _state = InisiasiAppState.login;
    notifyListeners();
  }
}
