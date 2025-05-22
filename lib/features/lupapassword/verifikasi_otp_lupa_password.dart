// lib/features/auth/presentation/screens/verify_reset_otp_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:puskeswan_app/components/app_button.dart';
import 'package:puskeswan_app/components/app_colors.dart';
import 'package:puskeswan_app/components/app_loading_overlay.dart';
import 'package:puskeswan_app/components/app_snackbar.dart';
import 'package:puskeswan_app/features/lupapassword/ganti_password_scree.dart';
import 'package:puskeswan_app/features/lupapassword/lupa_password_controller.dart';

class VerifyResetOtpScreen extends StatefulWidget {
  final String email;

  const VerifyResetOtpScreen({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<VerifyResetOtpScreen> createState() => _VerifyResetOtpScreenState();
}

class _VerifyResetOtpScreenState extends State<VerifyResetOtpScreen> {
  final List<TextEditingController> _otpControllers = List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  bool _isLoading = false;

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onOtpFieldChanged(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AppLoadingOverlay(
        isLoading: _isLoading,
        child: Consumer<ForgotPasswordProvider>(
          builder: (context, provider, _) {
            // Handle status changes
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (provider.status == ForgotPasswordStatus.verifySuccess) {
                provider.resetStatus();
                
                // Navigate to reset password screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResetPasswordScreen(email: widget.email),
                  ),
                );
              }

              if (provider.status == ForgotPasswordStatus.verifyFailure && 
                  provider.errorMessage != null) {
                AppSnackbar.showError(context, provider.errorMessage!);
                provider.resetStatus();
              }
            });

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 60.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),
                    const Text(
                      'Verifikasi OTP',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary800,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Silahkan masukkan kode verifikasi untuk reset password yang telah dikirimkan ke ${widget.email}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 60),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        4,
                        (index) => SizedBox(
                          width: 70,
                          child: TextField(
                            controller: _otpControllers[index],
                            focusNode: _focusNodes[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            style: const TextStyle(fontSize: 24),
                            decoration: const InputDecoration(
                              counterText: "",
                              contentPadding: EdgeInsets.zero,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF2A0066),
                                  width: 2,
                                ),
                              ),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (value) => _onOtpFieldChanged(value, index),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text(
                          'Tidak menerima kode?',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary900,
                          ),
                        ),
                        TextButton(
                          onPressed: provider.isLoading
                              ? null
                              : () => _handleResendOtp(provider),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.all(0),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            provider.isLoading ? "Mengirim ulang..." : "Kirim ulang kode",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        onPressed: provider.isLoading
                            ? null
                            : () => _handleVerifyOtp(provider),
                        text: provider.isLoading ? "Verifikasi..." : "Konfirmasi",
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleVerifyOtp(ForgotPasswordProvider provider) async {
    setState(() => _isLoading = true);

    try {
      final otp = _otpControllers.map((c) => c.text).join();
      
      if (otp.length != 4) {
        AppSnackbar.showError(context, 'Silakan masukkan kode OTP 4 digit');
        setState(() => _isLoading = false);
        return;
      }

      await provider.verifyOtp(widget.email, otp);
    } catch (e) {
      AppSnackbar.showError(context, e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleResendOtp(ForgotPasswordProvider provider) async {
    setState(() => _isLoading = true);

    try {
      final success = await provider.requestPasswordReset(widget.email);
      
      if (success && mounted) {
        AppSnackbar.showSuccess(context, 'Kode OTP baru telah dikirim ke email Anda');
        
        // Clear OTP fields
        for (var controller in _otpControllers) {
          controller.clear();
        }
        
        if (_focusNodes.isNotEmpty) {
          _focusNodes[0].requestFocus();
        }
      }
    } catch (e) {
      AppSnackbar.showError(context, e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}