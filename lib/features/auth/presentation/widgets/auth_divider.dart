// Divider Widget
import 'package:flutter/material.dart';
import 'package:puskeswan_app/components/app_colors.dart';

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Row(
        spacing: 8.0,
        children: [
          Expanded(child: Container(height: 1, color: AppColors.neutral600)),
          const Text(
            "Atau lanjutkan dengan",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          Expanded(child: Container(height: 1, color: AppColors.neutral600)),
        ],
      ),
    );
  }
}