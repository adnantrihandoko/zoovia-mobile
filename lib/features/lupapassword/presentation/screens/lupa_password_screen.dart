// lib/features/auth/presentation/screens/forgot_password_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puskeswan_app/components/app_background_overlay.dart';
import 'package:puskeswan_app/core/errors/failures.dart';
import 'package:puskeswan_app/features/auth/presentation/widgets/auth_header_section.dart';
import 'package:puskeswan_app/features/auth/presentation/widgets/auth_logo_section.dart';
import 'package:puskeswan_app/features/auth/presentation/widgets/auth_error_message.dart';
import 'package:puskeswan_app/features/lupapassword/presentation/controller/lupa_password_controller.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ForgotPasswordProvider>();

    return Scaffold(
      body: Stack(
        children: [
          const AppBackgroundOverlay(),
          const AuthHeaderSection(),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AuthLogoSection(imagePath: 'assets/logo.png'),
                  const SizedBox(height: 32),

                  // Field Email
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      errorText: provider.appError?.type == ErrorType.business
                          ? provider.appError!.message
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Error message (non-validation)
                  if (provider.appError != null &&
                      provider.appError!.type != ErrorType.business)
                    AuthErrorMessage(message: provider.appError!.message),

                  const Spacer(),

                  // Button Kirim OTP
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: provider.isLoading
                          ? null
                          : () async {
                              final success = await provider.requestReset(
                                _emailController.text.trim(),
                              );
                              if (success) {
                                if (context.mounted) {
                                  Navigator.pushNamed(context, '/verify-otp',
                                      arguments: _emailController.text.trim());
                                }
                              }
                            },
                      child: provider.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Kirim OTP'),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Back to Login
                  TextButton(
                    onPressed: provider.isLoading
                        ? null
                        : () => Navigator.pop(context),
                    child: const Text('Kembali ke Login'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
