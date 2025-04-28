import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:puskeswan_app/core/injection/provider_setup.dart';
import 'package:puskeswan_app/features/auth/presentation/controllers/login_controller.dart';
import 'package:puskeswan_app/features/auth/presentation/controllers/otp_verification_controller.dart';
import 'package:puskeswan_app/features/auth/presentation/controllers/register_controller.dart';
import 'package:puskeswan_app/features/onboarding/app_initial_state_notifier.dart';
import 'package:puskeswan_app/features/profile/presentation/controllers/profile_controller.dart';
import 'package:puskeswan_app/features/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Tambahkan ini
  await setupDependencies(); // Tambahkan await
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<AuthProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<AppInitialStateNotifier>()),
        ChangeNotifierProvider(create: (_) => getIt<RegisterProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<OtpVerificationProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<ProfileProvider>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(),
    );
  }
}
