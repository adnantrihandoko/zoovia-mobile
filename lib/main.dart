import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:puskeswan_app/core/injection/provider_setup.dart';
import 'package:puskeswan_app/features/antrian/presentation/controller/antrian_controller.dart';
import 'package:puskeswan_app/features/auth/presentation/controllers/login_controller.dart';
import 'package:puskeswan_app/features/auth/presentation/controllers/otp_verification_controller.dart';
import 'package:puskeswan_app/features/auth/presentation/controllers/register_controller.dart';
import 'package:puskeswan_app/features/hewanku/presentation/controller/hewanku_controller.dart';
import 'package:puskeswan_app/features/layanan/presentation/controllers/layanan_controller.dart';
import 'package:puskeswan_app/main_screen.dart';
import 'package:puskeswan_app/features/onboarding/inisiasi_app_provider.dart';
import 'package:puskeswan_app/features/profile/presentation/controllers/profile_controller.dart';

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
        ChangeNotifierProvider(create: (_) => getIt<InisiasiAppProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<RegisterProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<OtpVerificationProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<ProfileProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<HewanProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<AntrianProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<LayananProvider>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Montserrat'),
      home: const MainScreen(),
    );
  }
}
