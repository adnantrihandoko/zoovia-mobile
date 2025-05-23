// Register Section Widget
import 'package:flutter/material.dart';
import 'package:puskeswan_app/components/app_colors.dart';
import 'package:puskeswan_app/features/auth/presentation/screens/register_screen.dart';

class AuthRegisterSection extends StatelessWidget {
  const AuthRegisterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Belum punya akun? ",
          style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600),
        ),
        TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegisterScreen()),
          ),
          child: const Text(
            "Daftar",
            style: TextStyle(
              shadows: [Shadow(color: AppColors.primary500, offset: Offset(0, -1))],
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.transparent,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.primary500,
              decorationThickness: 2,
            ),
          ),
        ),
      ],
    );
  }
}