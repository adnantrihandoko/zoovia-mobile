// lib/features/auth/presentation/screens/forgot_password_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puskeswan_app/components/app_background_overlay.dart';
import 'package:puskeswan_app/components/app_button.dart';
import 'package:puskeswan_app/components/app_colors.dart';
import 'package:puskeswan_app/components/app_loading_overlay.dart';
import 'package:puskeswan_app/components/app_snackbar.dart';
import 'package:puskeswan_app/features/lupapassword/lupa_password_controller.dart';
import 'package:puskeswan_app/features/lupapassword/verifikasi_otp_lupa_password.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AppLoadingOverlay(
        isLoading: _isLoading,
        child: Consumer<ForgotPasswordProvider>(
          builder: (context, provider, _) {
            // Handle status changes
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (provider.status == ForgotPasswordStatus.success) {
                provider.resetStatus();
                
                // Navigate to OTP verification screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VerifyResetOtpScreen(
                      email: _emailController.text,
                    ),
                  ),
                );
              }

              if (provider.status == ForgotPasswordStatus.failure && 
                  provider.errorMessage != null) {
                AppSnackbar.showError(context, provider.errorMessage!);
                provider.resetStatus();
              }
            });

            return Stack(
              children: <Widget>[
                // Background Gradient
                const AppBackgroundOverlay(),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 60.0, horizontal: 40.0),
                    child: Text(
                      "Lupa Password",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
                    height: MediaQuery.of(context).size.height * 0.75,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(32),
                        bottom: Radius.zero,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Image.asset(
                              'assets/logo.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(height: 32.0),
                        const Text(
                          'Masukkan email Anda untuk mendapatkan kode verifikasi untuk mengatur ulang password.',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        Container(height: 24.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Email',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _emailController,
                              enabled: !provider.isLoading,
                              keyboardType: TextInputType.emailAddress,
                              textCapitalization: TextCapitalization.none,
                              maxLines: 1,
                              decoration: InputDecoration(
                                hintText: 'Masukkan email anda',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: AppColors.primary500, width: 1),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              ),
                            ),
                          ],
                        ),
                        Container(height: 32.0),
                        SizedBox(
                          width: double.infinity,
                          child: AppButton(
                            onPressed: provider.isLoading
                                ? null
                                : () => _handleRequestPasswordReset(provider),
                            text: provider.isLoading
                                ? "Memproses..."
                                : "Kirim Kode Verifikasi",
                          ),
                        ),
                        Container(height: 16.0),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Kembali ke Login',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleRequestPasswordReset(ForgotPasswordProvider provider) async {
    setState(() => _isLoading = true);

    if (_emailController.text.isEmpty) {
      AppSnackbar.showError(context, 'Silakan masukkan email Anda');
      setState(() => _isLoading = false);
      return;
    }

    try {
      await provider.requestPasswordReset(_emailController.text);
    } catch (e) {
      AppSnackbar.showError(context, e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}