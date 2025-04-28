import 'package:flutter/material.dart';
import 'package:puskeswan_app/components/app_colors.dart';

class AppBackgroundOverlay extends StatelessWidget {
  const AppBackgroundOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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
      ],
    );
  }
}
