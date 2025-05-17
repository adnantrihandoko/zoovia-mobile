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

  // Public method to check app state, useful for manual re-checking from MainScreen
  Future<void> checkAppState() async {
    _state = InisiasiAppState.loading;
    notifyListeners();

    await _initialize();
  }

  Future<void> _initialize() async {
    final isFirstRun = await _repository.isFirstRun();
    final isLoggedIn = await _repository.isLoggedIn();

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
    // First set loading state
    _state = InisiasiAppState.loading;
    notifyListeners();

    // Set logged in
    await _repository.setLoggedIn(true);

    // Small delay to ensure token storage is complete
    await Future.delayed(const Duration(milliseconds: 300));

    // Then transition to home state
    _state = InisiasiAppState.home;
    notifyListeners();
  }

  Future<void> logout() async {
    // First set loading state to trigger UI feedback
    _state = InisiasiAppState.loading;
    notifyListeners();

    // Set logged out
    await _repository.setLoggedIn(false);

    // Small delay to ensure cleanup
    await Future.delayed(const Duration(milliseconds: 200));

    // Transition to login state
    _state = InisiasiAppState.login;
    notifyListeners();
  }
}
