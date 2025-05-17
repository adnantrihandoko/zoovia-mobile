// lib/features/auth/presentation/screens/verifikasi_otp_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:puskeswan_app/components/app_button.dart';
import 'package:puskeswan_app/components/app_colors.dart';
import 'package:puskeswan_app/components/success_dialog.dart';
import 'package:puskeswan_app/features/auth/presentation/controllers/otp_verification_controller.dart';
import 'package:puskeswan_app/features/auth/presentation/screens/login_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;

  const OtpVerificationScreen({super.key, required this.email});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  late final List<TextEditingController> _otpControllers;
  late final List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _otpControllers = List.generate(4, (index) => TextEditingController());
    _focusNodes = List.generate(4, (index) => FocusNode());
  }

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
    final otpProvider = Provider.of<OtpVerificationProvider>(context);

    // Check for verification success to show the dialog
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (otpProvider.status == OtpVerificationStatus.success) {
        // Reset status to prevent showing dialog again
        otpProvider.resetStatus();
        
        // Show success dialog
        SuccessDialog.show(
          context: context,
          title: 'Verifikasi Berhasil!',
          message: 'Akun Anda telah berhasil diverifikasi. Silakan login untuk melanjutkan.',
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

      // Handle resend OTP success message
      if (otpProvider.status == OtpVerificationStatus.resendSuccess) {
        otpProvider.resetStatus();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kode OTP baru telah dikirim ke email Anda.'),
            backgroundColor: Colors.green,
          ),
        );
      }

      // Handle errors
      if (otpProvider.error != null && 
        (otpProvider.status == OtpVerificationStatus.failure || 
          otpProvider.status == OtpVerificationStatus.resendFailure)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(otpProvider.error!.message),
            backgroundColor: Colors.red,
          ),
        );
        otpProvider.resetStatus();
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
                'Silahkan masukkan kode verifikasi yang telah dikirimkan ke ${widget.email}',
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
                    onPressed: otpProvider.isResending
                        ? null
                        : () => otpProvider.resendOtp(widget.email),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      otpProvider.isResending ? "Mengirim ulang..." : "Kirim ulang kode",
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
                  onPressed: otpProvider.isLoading
                      ? null
                      : () {
                          final otp = _otpControllers
                              .map((c) => c.text)
                              .join();
                          if (otp.length == 4) {
                            otpProvider.verifyOtp(widget.email, otp);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Silakan masukkan kode OTP 4 digit'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                  text: otpProvider.isLoading ? "Verifying..." : "Konfirmasi",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}