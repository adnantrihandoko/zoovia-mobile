// Login Form Widget
import 'package:flutter/material.dart';
import 'package:puskeswan_app/components/app_colors.dart';
import 'package:puskeswan_app/features/auth/presentation/widgets/auth_textfield.dart';
import 'package:puskeswan_app/features/lupapassword/lupa_password_screen.dart';

class AuthLoginForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool passwordVisible;
  final VoidCallback onPasswordVisibilityToggle;
  final bool isLoading;

  const AuthLoginForm({
    super.key, 
    required this.emailController,
    required this.passwordController,
    required this.passwordVisible,
    required this.onPasswordVisibilityToggle,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AuthTextField(
          label: 'Email',
          hint: 'Masukkan email anda',
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          enabled: !isLoading,
        ),
        const SizedBox(height: 12),
        AuthTextField(
          label: 'Password',
          hint: 'Masukkan password anda',
          controller: passwordController,
          isPassword: true,
          passwordVisible: passwordVisible,
          onPasswordToggle: onPasswordVisibilityToggle,
          enabled: !isLoading,
        ),
        const SizedBox(height: 8),
        const _ForgotPasswordButton(),
      ],
    );
  }
}

// Forgot Password Button Widget
class _ForgotPasswordButton extends StatelessWidget {
  const _ForgotPasswordButton();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size(0, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
        ),
        child: const Text(
          "Lupa Password",
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
    );
  }
}