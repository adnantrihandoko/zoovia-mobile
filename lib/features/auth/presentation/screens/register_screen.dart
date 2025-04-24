// lib\features\auth\presentation\screens\register_screen.dart

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:provider/provider.dart';
import 'package:puskeswan_app/components/app_button.dart';
import 'package:puskeswan_app/components/app_colors.dart';
import 'package:puskeswan_app/features/auth/presentation/controllers/register_controller.dart';
import 'package:puskeswan_app/features/auth/presentation/screens/login_screen.dart';
import 'package:puskeswan_app/features/auth/presentation/screens/verifikasi_otp_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _navigationTriggered = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final registerProvider = Provider.of<RegisterProvider>(context);

    // Store email before potential reset
    final String? emailForNavigation = registerProvider.registeredEmail;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (registerProvider.registeredEmail != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => OtpVerificationScreen(
              email: emailForNavigation!,
            ),
          ),
        );
        registerProvider.registeredEmail = null; // Reset state
      }

      if (registerProvider.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(registerProvider.error!),
            backgroundColor: Colors.red,
          ),
        );
        registerProvider.resetError(); // Reset error
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(left: 40, right: 40, top: 60),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 24),
              alignment: Alignment.topLeft,
              child: const Text(
                "Silahkan daftar untuk melanjutkan",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary800,
                ),
              ),
            ),
            if (registerProvider.error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  registerProvider.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            Column(
              spacing: 12,
              children: [
                FTextField(
                  controller: _nameController,
                  enabled: true,
                  hint: 'Masukkan nama anda',
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.none,
                  maxLines: 1,
                  label: const Text(
                    'Nama',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                FTextField(
                  controller: _emailController,
                  enabled: true,
                  hint: 'Masukkan email anda',
                  keyboardType: TextInputType.emailAddress,
                  textCapitalization: TextCapitalization.none,
                  maxLines: 1,
                  label: const Text(
                    'Email',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                FTextField(
                  controller: _phoneController,
                  enabled: true,
                  hint: 'Masukkan nomor hp anda',
                  keyboardType: TextInputType.number,
                  textCapitalization: TextCapitalization.none,
                  maxLines: 1,
                  label: const Text(
                    'Nomor Hp',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                FTextField.password(
                  controller: _passwordController,
                  enabled: true,
                  hint: 'Masukkan password anda',
                  textCapitalization: TextCapitalization.none,
                  maxLines: 1,
                  label: const Text(
                    'Password',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                FTextField.password(
                  controller: _confirmPasswordController,
                  enabled: true,
                  hint: 'Masukkan konfirmasi password anda',
                  textCapitalization: TextCapitalization.none,
                  maxLines: 1,
                  label: const Text(
                    'Konfirmasi password',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 42),
            Column(
              spacing: 26,
              children: [
                AppButton(
                  onPressed: registerProvider.isLoading
                      ? null
                      : () => registerProvider.register(
                            name: _nameController.text,
                            email: _emailController.text,
                            phone: _phoneController.text,
                            password: _passwordController.text,
                            passwordConfirmation:
                                _confirmPasswordController.text,
                          ),
                  text: registerProvider.isLoading ? "Loading..." : "Daftar",
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Expanded(
                        child: Divider(
                          color: AppColors.neutral800,
                          thickness: 1,
                        ),
                      ),
                      const Text(
                        "Atau daftar dengan",
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      const Expanded(
                        child: Divider(
                          color: AppColors.neutral800,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                AppButton(
                  onPressed: () {
                    // Implementasi login dengan google (jika diperlukan)
                  },
                  text: "Lanjutkan dengan google",
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  iconButton: Image.asset(
                    "assets/googlelogo.png",
                    height: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Sudah punya akun? ",
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Masuk",
                    style: TextStyle(
                      shadows: [
                        Shadow(
                            color: AppColors.primary500, offset: Offset(0, -1))
                      ],
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
            ),
          ],
        ),
      ),
    );
  }
}
