// lib\core\injection\provider_setup.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:puskeswan_app/features/auth/data/datasources/auth_datasource.dart';
import 'package:puskeswan_app/features/auth/data/datasources/google_auth_service.dart';
import 'package:puskeswan_app/features/auth/data/datasources/secure_storage.dart';
import 'package:puskeswan_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:puskeswan_app/features/auth/domain/usecases/google_login_usecase.dart';
import 'package:puskeswan_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:puskeswan_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:puskeswan_app/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:puskeswan_app/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:puskeswan_app/features/auth/presentation/controllers/login_controller.dart';
import 'package:puskeswan_app/features/auth/presentation/controllers/otp_verification_controller.dart';
import 'package:puskeswan_app/features/auth/presentation/controllers/register_controller.dart';
import 'package:puskeswan_app/features/onboarding/app_initial_state_notifier.dart';
import 'package:puskeswan_app/features/onboarding/app_preferences_repository.dart';
import 'package:puskeswan_app/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:puskeswan_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:puskeswan_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:puskeswan_app/features/profile/domain/usecases/ganti_password_usecase.dart';
import 'package:puskeswan_app/features/profile/domain/usecases/logout_usecase.dart';
import 'package:puskeswan_app/features/profile/presentation/controllers/profile_controller.dart';
import 'package:puskeswan_app/utils/flutter_secure_storage.dart';

final getIt = GetIt.instance;
const androidOptions = AndroidOptions(encryptedSharedPreferences: true);


Future<void> setupDependencies() async {
  final dio = Dio(BaseOptions(
    baseUrl: 'http://192.168.161.220:7071/api',
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
  getIt.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage(aOptions: androidOptions));

  getIt.registerFactory(
      () => SecureStorage(getIt<FlutterSecureStorage>()));

  // Dio client
  getIt.registerSingleton<Dio>(dio);

  // Profile Feature
  getIt.registerFactory(() => ProfileRemoteDataSource(getIt<Dio>()));
  getIt.registerFactory<ProfileRepository>(
    () => ProfileRepositoryImpl(getIt<ProfileRemoteDataSource>()),
  );

  // Profile Use Cases
  getIt.registerFactory(() => LogoutUseCase(getIt<ProfileRepository>()));
  getIt
      .registerFactory(() => ChangePasswordUseCase(getIt<ProfileRepository>()));

  // Profile Provider
  getIt.registerFactory(
    () => ProfileProvider(
      getIt<ProfileRepository>(),
      logoutUseCase: getIt<LogoutUseCase>(),
      changePasswordUseCase: getIt<ChangePasswordUseCase>(),
    ),
  );

  // Google sign in
  getIt.registerFactory(() => GoogleLoginUseCase(
      getIt<AuthRepositoryImpl>(), getIt<GoogleAuthService>()));

  getIt.registerSingleton(() => GoogleAuthService());

  // Auth Feature
  getIt.registerFactory(() => AuthRemoteDataSource(getIt<Dio>()));
  getIt
      .registerFactory(() => AuthRepositoryImpl(getIt<AuthRemoteDataSource>(), getIt<SecureStorage>()));
  getIt.registerFactory(() => LoginUseCase(getIt<AuthRepositoryImpl>()));
  getIt.registerFactory(() => AuthProvider(getIt<LoginUseCase>(),
      getIt<GoogleLoginUseCase>(), getIt<GoogleAuthService>()));

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

  // 3. Setup Notifier
  getIt.registerFactory<AppInitialStateNotifier>(
    () => AppInitialStateNotifier(getIt<AppPreferencesRepository>()),
  );
}
