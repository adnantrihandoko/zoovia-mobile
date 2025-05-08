import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puskeswan_app/components/app_button.dart';
import 'package:puskeswan_app/components/app_colors.dart';
import 'package:puskeswan_app/features/auth/presentation/screens/login_screen.dart';
import 'package:puskeswan_app/features/auth/presentation/screens/register_screen.dart';
import 'package:puskeswan_app/features/onboarding/inisiasi_app_provider.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<InisiasiAppProvider>(context);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary500,
                  AppColors.primary200
                ], // Warna gradient
              ),
            ),
          ),

          // Image Overlay
          Positioned.fill(
            child: Opacity(
              opacity: 0.8, // Mengatur transparansi overlay
              child: Image.asset(
                'assets/onboarding/background.png', // Ganti dengan gambar Anda
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Content Layer (Text)
          Align(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 60.0, horizontal: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "Selamat datang di Zoovia",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(height: 20),
                  Flexible(
                    child: AspectRatio(
                      aspectRatio: 1, // Menjaga rasio gambar tetap proporsional
                      child: Image.asset(
                        'assets/onboarding/onboardingpet.png',
                        fit: BoxFit
                            .contain, // Memastikan gambar tidak terdistorsi
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              //rounded rectangle putih bawah
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
              height: 395,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(32), bottom: Radius.zero),
              ),
              child: Column(
                //content yang ada di dalam rounded rectangle
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    //garis tiga
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(3, (index) {
                      return Expanded(
                          child: Container(
                        margin: const EdgeInsets.only(right: 22.0),
                        height: 6,
                        decoration: const BoxDecoration(
                            color: AppColors.neutral800,
                            borderRadius:
                                BorderRadius.all(Radius.circular(99))),
                      ));
                    }),
                  ),
                  const SizedBox(
                    height: 32.0,
                  ),
                  const Column(
                    spacing: 10.0,
                    children: [
                      Text(
                        "Mulai peduli pada hewan kesayanganmu !",
                        style: TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.w600),
                      ),
                      Text(
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w500),
                          "Aplikasi yang memudahkan Anda merawat hewan peliharaan dengan layanan kesehatan, informasi terpercaya, dan antrian online."),
                    ],
                  ),
                  const SizedBox(
                    height: 36.0,
                  ),
                  Expanded(
                    child: Column(
                      spacing: 12.0,
                      children: [
                        AppButton(
                          elevation: 2,
                            onPressed: () {
                              notifier.completeOnboarding();
                             Navigator.of(context).push(MaterialPageRoute(builder: (context) => const RegisterScreen()),);},
                            text: "Mulai Sekarang!"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w600),
                                "Sudah punya akun? "),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 0),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () {
                                notifier.completeOnboarding();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()),
                                );
                              },
                              child: const Text(
                                  style: TextStyle(
                                    shadows: [
                                      Shadow(
                                          color: AppColors.primary500,
                                          offset: Offset(0, -1))
                                    ],
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.transparent,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.primary500,
                                    decorationThickness: 2,
                                  ),
                                  "Masuk"),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
