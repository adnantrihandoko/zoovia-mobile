import 'package:puskeswan_app/features/onboarding/app_preferences_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferencesRepositoryImpl implements AppPreferencesRepository {
  final SharedPreferences _prefs;

  AppPreferencesRepositoryImpl(this._prefs);

  @override
  Future<bool> isFirstRun() async => _prefs.getBool('isFirstRun') ?? true;

  @override
  Future<void> setFirstRunCompleted() async => 
      await _prefs.setBool('isFirstRun', false);

  @override
  Future<bool> isLoggedIn() async => _prefs.getBool('isLoggedIn') ?? false;

  @override
  Future<void> setLoggedIn(bool value) async => 
      await _prefs.setBool('isLoggedIn', value);
}