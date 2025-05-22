// lib/features/auth/presentation/screens/reset_password_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puskeswan_app/components/app_background_overlay.dart';
import 'package:puskeswan_app/components/app_button.dart';
import 'package:puskeswan_app/components/app_colors.dart';
import 'package:puskeswan_app/components/app_loading_overlay.dart';
import 'package:puskeswan_app/components/app_snackbar.dart';
import 'package:puskeswan_app/components/success_dialog.dart';
import 'package:puskeswan_app/features/auth/presentation/screens/login_screen.dart';
import 'package:puskeswan_app/features/lupapassword/lupa_password_controller.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
              if (provider.status == ForgotPasswordStatus.resetSuccess) {
                provider.resetStatus();
                
                // Show success dialog
                SuccessDialog.show(
                  context: context,
                  title: 'Password Berhasil Diubah!',
                  message: 'Password Anda telah berhasil diubah. Silakan login dengan password baru Anda.',
                  buttonText: 'Login',
                  onButtonPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) => false, // Remove all previous routes
                    );
                  },
                );
              }

              if (provider.status == ForgotPasswordStatus.resetFailure && 
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
                      "Atur Ulang Password",
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
                          'Silakan masukkan password baru Anda',
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
                              'Password Baru',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _passwordController,
                              enabled: !provider.isLoading,
                              textCapitalization: TextCapitalization.none,
                              maxLines: 1,
                              obscureText: !_passwordVisible,
                              decoration: InputDecoration(
                                hintText: 'Masukkan password baru',
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
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                    color: AppColors.primary500,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(height: 16.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Konfirmasi Password',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _confirmPasswordController,
                              enabled: !provider.isLoading,
                              textCapitalization: TextCapitalization.none,
                              maxLines: 1,
                              obscureText: !_confirmPasswordVisible,
                              decoration: InputDecoration(
                                hintText: 'Konfirmasi password baru',
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
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                    color: AppColors.primary500,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _confirmPasswordVisible = !_confirmPasswordVisible;
                                    });
                                  },
                                ),
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
                                : () => _handleResetPassword(provider),
                            text: provider.isLoading
                                ? "Memproses..."
                                : "Ubah Password",
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

  Future<void> _handleResetPassword(ForgotPasswordProvider provider) async {
    setState(() => _isLoading = true);

    try {
      // Validate passwords
      if (_passwordController.text.isEmpty ||
          _confirmPasswordController.text.isEmpty) {
        AppSnackbar.showError(context, 'Silakan isi semua field');
        setState(() => _isLoading = false);
        return;
      }
      
      if (_passwordController.text.length < 6) {
        AppSnackbar.showError(context, 'Password minimal 6 karakter');
        setState(() => _isLoading = false);
        return;
      }

      if (_passwordController.text != _confirmPasswordController.text) {
        AppSnackbar.showError(context, 'Password dan konfirmasi password tidak cocok');
        setState(() => _isLoading = false);
        return;
      }

      // Submit password change
      await provider.resetPassword(
        widget.email,
        _passwordController.text,
        _confirmPasswordController.text,
      );
    } catch (e) {
      AppSnackbar.showError(context, e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}