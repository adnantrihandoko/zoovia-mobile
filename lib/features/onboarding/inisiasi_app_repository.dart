abstract class InisiasiAppRepository {
  Future<bool?> isFirstRun();
  Future<void> setFirstRunCompleted();
  Future<bool> isLoggedIn();
  Future<void> setLoggedIn(bool value);
}