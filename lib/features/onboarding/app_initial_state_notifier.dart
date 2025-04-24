// features/onboarding/presentation/notifiers/app_initial_state_notifier.dart
import 'package:flutter/material.dart';
import 'package:puskeswan_app/features/onboarding/app_preferences_repository.dart';

enum AppInitialState { loading, onboarding, login, home }

class AppInitialStateNotifier with ChangeNotifier {
  final AppPreferencesRepository _repository;
  AppInitialState _state = AppInitialState.loading;
  
  AppInitialState get state => _state;

  AppInitialStateNotifier(this._repository) {
    _initialize();
  }

  Future<void> _initialize() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate loading
    
    final isFirstRun = await _repository.isFirstRun();
    final isLoggedIn = await _repository.isLoggedIn();

    _state = isFirstRun 
        ? AppInitialState.onboarding
        : isLoggedIn 
            ? AppInitialState.home 
            : AppInitialState.login;
    
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    await _repository.setFirstRunCompleted();
    _state = AppInitialState.login;
    notifyListeners();
  }

  Future<void> login() async {
    await _repository.setLoggedIn(true);
    _state = AppInitialState.home;
    notifyListeners();
  }

  Future<void> logout() async {
    await _repository.setLoggedIn(false);
    _state = AppInitialState.login;
    notifyListeners();
  }
}