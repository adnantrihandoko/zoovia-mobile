// lib\core\injection\provider_setup.dart

import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:puskeswan_app/features/auth/data/datasources/auth_remote_datasource.dart';
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
import 'package:puskeswan_app/features/onboarding/app_preferences_repo_impl.dart';
import 'package:puskeswan_app/features/onboarding/app_preferences_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  final dio = Dio(BaseOptions(
    baseUrl: 'http://172.16.103.47:7071/api',
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

// Dio client
  getIt.registerSingleton<Dio>(dio);

  // Google sign in
  getIt.registerFactory(() => GoogleLoginUseCase(getIt<AuthRepositoryImpl>()));

  // Auth Feature
  getIt.registerFactory(() => AuthRemoteDataSource(getIt<Dio>()));
  getIt
      .registerFactory(() => AuthRepositoryImpl(getIt<AuthRemoteDataSource>()));
  getIt.registerFactory(() => LoginUseCase(getIt<AuthRepositoryImpl>()));
  getIt.registerFactory(
      () => AuthProvider(getIt<LoginUseCase>(), getIt<GoogleLoginUseCase>()));

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

  // 1. Setup SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // 2. Setup Repository
  getIt.registerSingleton<AppPreferencesRepository>(
    AppPreferencesRepositoryImpl(getIt<SharedPreferences>()),
  );

  // 3. Setup Notifier
  getIt.registerFactory<AppInitialStateNotifier>(
    () => AppInitialStateNotifier(getIt<AppPreferencesRepository>()),
  );
}
