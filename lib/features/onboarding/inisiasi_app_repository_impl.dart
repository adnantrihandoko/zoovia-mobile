import 'package:puskeswan_app/features/onboarding/inisiasi_app_repository.dart';
import 'package:puskeswan_app/utils/flutter_secure_storage.dart';

class InisiasiAppRepositoryImpl implements InisiasiAppRepository {
  final AppFlutterSecureStorage _appFlutterSecureStorage;

  InisiasiAppRepositoryImpl(this._appFlutterSecureStorage);

  @override
  Future<bool> isFirstRun() async {
    final state = await _appFlutterSecureStorage.getData("isFirstRun");
    print('ONBOARDING/INISIASI_REPO_IMPL: $state');
    if (state.toLowerCase().toString() == 'true' ||
        state.toLowerCase().toString() == '') {
      return true;
    }

    return false;
  }

  @override
  Future<void> setFirstRunCompleted() async {
    await _appFlutterSecureStorage.storeData('isFirstRun', 'false');
    final state = await _appFlutterSecureStorage.getData("isFirstRun");
    print('ONBOARDING/INISIASI_REPO_IMPL: $state');
  }

  @override
  Future<bool> isLoggedIn() async {
    final state = await _appFlutterSecureStorage.getData('isLoggedIn');
    print("ONBOARDING/INISIASI_APP_REPO_IMPL: ${state.toString()}");
    if (state.toString() == 'true') {
      return true;
    }
    return state.toString() == 'true';
  }

  @override
  Future<void> setLoggedIn(bool value) async => await _appFlutterSecureStorage
      .storeData('isLoggedIn', value.toString().toLowerCase());
}
