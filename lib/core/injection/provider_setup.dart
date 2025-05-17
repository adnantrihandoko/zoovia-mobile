// lib\core\injection\provider_setup.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:puskeswan_app/features/antrian/data/antrian_remote_datasource.dart';
import 'package:puskeswan_app/features/antrian/presentation/controller/antrian_controller.dart';
import 'package:puskeswan_app/features/antrian/usecase/antrian_usecase.dart';
import 'package:puskeswan_app/features/artikel/artikel_controller.dart';
import 'package:puskeswan_app/features/artikel/artikel_remote_datasource.dart';
import 'package:puskeswan_app/features/artikel/artikel_usecase.dart';
import 'package:puskeswan_app/features/auth/data/datasources/auth_datasource.dart';
import 'package:puskeswan_app/features/auth/data/datasources/google_auth_service.dart';
import 'package:puskeswan_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:puskeswan_app/features/auth/domain/usecases/google_login_usecase.dart';
import 'package:puskeswan_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:puskeswan_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:puskeswan_app/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:puskeswan_app/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:puskeswan_app/features/auth/presentation/controllers/login_controller.dart';
import 'package:puskeswan_app/features/auth/presentation/controllers/otp_verification_controller.dart';
import 'package:puskeswan_app/features/auth/presentation/controllers/register_controller.dart';
import 'package:puskeswan_app/features/dokter/dokter_controller.dart';
import 'package:puskeswan_app/features/dokter/dokter_remote_datasource.dart';
import 'package:puskeswan_app/features/dokter/dokter_usecase.dart';
import 'package:puskeswan_app/features/hewanku/data/hewan_remote_datasource.dart';
import 'package:puskeswan_app/features/hewanku/presentation/controller/hewanku_controller.dart';
import 'package:puskeswan_app/features/hewanku/usecase/hewanku_usecase.dart';
import 'package:puskeswan_app/features/layanan/data/layanan_remote_datasource.dart';
import 'package:puskeswan_app/features/layanan/presentation/controllers/layanan_controller.dart';
import 'package:puskeswan_app/features/layanan/usecase/layanan_usecase.dart';
import 'package:puskeswan_app/features/onboarding/inisiasi_app_provider.dart';
import 'package:puskeswan_app/features/onboarding/inisiasi_app_repository_impl.dart';
import 'package:puskeswan_app/features/onboarding/inisiasi_app_repository.dart';
import 'package:puskeswan_app/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:puskeswan_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:puskeswan_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:puskeswan_app/features/profile/domain/usecases/ganti_password_usecase.dart';
import 'package:puskeswan_app/features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:puskeswan_app/features/profile/domain/usecases/logout_usecase.dart';
import 'package:puskeswan_app/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:puskeswan_app/features/profile/presentation/controllers/profile_controller.dart';
import 'package:puskeswan_app/features/rekammedis/rekam_medis_controller.dart';
import 'package:puskeswan_app/features/rekammedis/rekam_medis_datasource.dart';
import 'package:puskeswan_app/features/rekammedis/rekam_medis_usecase.dart';
import 'package:puskeswan_app/utils/flutter_secure_storage.dart';

final getIt = GetIt.instance;
const androidOptions = AndroidOptions(encryptedSharedPreferences: true);
const String imageUrl = "http://192.168.160.220:7071/";

Future<void> setupDependencies() async {
  final dio = Dio(BaseOptions(
    baseUrl: 'http://192.168.160.220:7071/api',
    headers: {"Accept": "application/json", "Content-Type": "application/json"},
    connectTimeout: const Duration(seconds: 10),
  ));

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      print('REQUEST[${options.method}] => PATH: ${options.path}');
      print('Request data: ${options.data}');
      return handler.next(options);
    },
    onResponse: (response, handler) {
      print(
          'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
      print('Response data: ${response.data}');
      return handler.next(response);
    },
    onError: (DioException e, handler) {
      print(
          'ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
      print('Error data: ${e.response?.data}');
      return handler.next(e);
    },
  ));
  getIt.registerSingleton<FlutterSecureStorage>(
      const FlutterSecureStorage(aOptions: androidOptions));

  getIt.registerSingleton<Dio>(dio);

  getIt.registerSingleton<PusherChannelsFlutter>(PusherChannelsFlutter());

  getIt.registerFactory(
      () => AppFlutterSecureStorage(getIt<FlutterSecureStorage>()));

  // Dio client

  // Profile Feature
  getIt.registerFactory(() =>
      ProfileRemoteDataSource(getIt<Dio>(), getIt<AppFlutterSecureStorage>()));
  getIt.registerFactory<ProfileRepository>(
    () => ProfileRepositoryImpl(getIt<ProfileRemoteDataSource>()),
  );

  // Profile Use Cases
  getIt.registerFactory(() => LogoutUseCase(
      getIt<ProfileRepository>(), getIt<AppFlutterSecureStorage>()));
  getIt
      .registerFactory(() => ChangePasswordUseCase(getIt<ProfileRepository>()));
  getIt.registerFactory(() => GetUserProfileUsecase(
      getIt<ProfileRepository>(), getIt<AppFlutterSecureStorage>()));
  getIt.registerFactory(() => UpdateProfileUsecase(
      getIt<ProfileRepository>(), getIt<AppFlutterSecureStorage>()));

  // Profile Provider
  getIt.registerFactory(
    () => ProfileProvider(
      getIt<GetUserProfileUsecase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
      changePasswordUseCase: getIt<ChangePasswordUseCase>(),
      getIt<UpdateProfileUsecase>(),
    ),
  );

  // Google sign in
  getIt.registerFactory(() => GoogleLoginUseCase(
      getIt<AuthRepositoryImpl>(), getIt<GoogleAuthService>()));

  getIt.registerSingleton(() => GoogleAuthService());

  // Auth Feature
  getIt.registerFactory(() => AuthRemoteDataSource(getIt<Dio>()));
  getIt.registerFactory(() => AuthRepositoryImpl(
      getIt<AuthRemoteDataSource>(), getIt<AppFlutterSecureStorage>()));
  getIt.registerFactory(() => LoginUseCase(getIt<AuthRepositoryImpl>()));
  getIt.registerFactory(() => AuthProvider(
      getIt<LoginUseCase>(),
      getIt<GoogleLoginUseCase>(),
      getIt<GoogleAuthService>(),
      getIt<AppFlutterSecureStorage>()));

  // Register
  getIt.registerFactory(() => RegisterUseCase(getIt<AuthRepositoryImpl>()));
  getIt.registerFactory(() => RegisterProvider(getIt<RegisterUseCase>()));

  // OTP Verification
  getIt.registerFactory(() => VerifyOtpUseCase(getIt<AuthRepositoryImpl>()));
  getIt.registerFactory(() => ResendOtpUseCase(getIt<AuthRepositoryImpl>()));
  getIt.registerFactory(() => OtpVerificationProvider(
        verifyOtpUseCase: getIt<VerifyOtpUseCase>(),
        resendOtpUseCase: getIt<ResendOtpUseCase>(),
      ));

  // Setup Inisiasi Notifier
  getIt.registerSingleton(InisiasiAppRepository);
  getIt.registerFactory<InisiasiAppRepositoryImpl>(
      () => InisiasiAppRepositoryImpl(getIt<AppFlutterSecureStorage>()));
  getIt.registerFactory<InisiasiAppProvider>(
    () => InisiasiAppProvider(getIt<InisiasiAppRepositoryImpl>()),
  );

  getIt.registerSingleton(GoogleAuthService());

  //Setup dependensi yang berkatian dengan fitur hewanku
  getIt.registerFactory(() => HewanRemoteDatasource(getIt<Dio>()));
  getIt.registerFactory(() => HewanUseCase(getIt<HewanRemoteDatasource>()));
  getIt.registerFactory(() =>
      HewanProvider(getIt<HewanUseCase>(), getIt<AppFlutterSecureStorage>()));

  //setup dependensi antrian
  getIt.registerFactory(() => AntrianRemoteDatasource(getIt<Dio>()));
  getIt.registerFactory(() => AntrianUseCase(getIt<AntrianRemoteDatasource>()));
  getIt.registerFactory(() => AntrianProvider(getIt<AntrianUseCase>(),
      getIt<AppFlutterSecureStorage>(), getIt<PusherChannelsFlutter>()));

  //SETUP DEPENDENSI LAYANAN
  getIt.registerFactory(() => LayananRemoteDatasource(getIt<Dio>()));
  getIt.registerFactory(() => LayananUseCase(getIt<LayananRemoteDatasource>()));
  getIt.registerFactory(() => LayananProvider(
      getIt<LayananUseCase>(), getIt<AppFlutterSecureStorage>()));

  // Setup dependensi dokter
  getIt.registerFactory(() => DokterRemoteDatasource(getIt<Dio>()));
  getIt.registerFactory(() => DokterUseCase(getIt<DokterRemoteDatasource>()));
  getIt.registerFactory(() =>
      DokterProvider(getIt<DokterUseCase>(), getIt<AppFlutterSecureStorage>()));

  //setup dependensi artikel
  getIt.registerFactory(() => ArtikelRemoteDatasource(getIt<Dio>()));
  getIt.registerFactory(() => ArtikelUsecase(getIt<ArtikelRemoteDatasource>()));
  getIt.registerFactory(() => ArtikelProvider(
      getIt<ArtikelUsecase>(), getIt<AppFlutterSecureStorage>()));

  //setup dependensi rekam medis
  getIt.registerFactory(() => RekamMedisRemoteDatasource(getIt<Dio>()));
  getIt.registerFactory(
      () => RekamMedisUseCase(getIt<RekamMedisRemoteDatasource>()));
  getIt.registerFactory(() => RekamMedisProvider(
      getIt<RekamMedisUseCase>(), getIt<AppFlutterSecureStorage>()));
}
