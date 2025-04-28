// lib\features\auth\presentation\screens\login_screen.dart

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:provider/provider.dart';
import 'package:puskeswan_app/components/app_background_overlay.dart';
import 'package:puskeswan_app/components/app_button.dart';
import 'package:puskeswan_app/components/app_colors.dart';
import 'package:puskeswan_app/features/auth/presentation/controllers/login_controller.dart';
import 'package:puskeswan_app/features/auth/presentation/screens/register_screen.dart';
import 'package:puskeswan_app/features/home/main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authProvider.user != null) {
        Navigator.of(context, rootNavigator: true).pushReplacement(
          MaterialPageRoute(
            builder: (context) => MainScreen(),
          ),
        );
      }
    });

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          // Background Gradient
          const AppBackgroundOverlay(),
          const Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 60.0, horizontal: 40.0),
              child: Text(
                "Selamat datang Silahkan Masuk",
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
              height: MediaQuery.of(context).size.height *
                  0.75, // Menyesuaikan tinggi dengan 60% dari tinggi layar
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(32), bottom: Radius.zero),
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
                  FTextField(
                    controller: _emailController,
                    enabled: true,
                    hint: 'Masukkan email anda',
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.none,
                    maxLines: 1,
                    label: const Text(
                      'Email',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(height: 12.0),
                  FTextField.password(
                    controller: _passwordController,
                    enabled: true,
                    hint: 'Masukkan password anda',
                    textCapitalization: TextCapitalization.none,
                    maxLines: 1,
                    label: const Text(
                      'Password',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(height: 8.0),
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
                            builder: (context) => const RegisterScreen()),
                      );
                    },
                    child: const Text(
                      style: TextStyle(
                        shadows: [
                          Shadow(
                              color: AppColors.primary500,
                              offset: Offset(0, -1))
                        ],
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.transparent,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.primary500,
                        decorationThickness: 2,
                      ),
                      "Lupa Password",
                    ),
                  ),
                  if (authProvider.error != null)
                    Padding(
                      padding: const EdgeInsets.only(),
                      child: Text(
                        authProvider.error!.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  Container(
                    height: authProvider.error != null ? 42.0 : 54.0,
                  ),
                  Column(
                    spacing: 26.0,
                    children: [
                      AppButton(
                        onPressed: authProvider.isLoading
                            ? null
                            : () => authProvider.login(
                                  _emailController.text,
                                  _passwordController.text,
                                ),
                        text: authProvider.isLoading ? "Loading..." : "Masuk",
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Row(
                          spacing: 8.0,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                height: 1,
                                color: AppColors.neutral600,
                              ),
                            ),
                            const Text(
                              "Atau lanjutkan dengan",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                            Expanded(
                              child: Container(
                                width: 40,
                                height: 1,
                                color: AppColors.neutral600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppButton(
                        onPressed: authProvider.isLoading
                            ? null
                            : () async {
                                await authProvider.loginWithGoogle();
                              },
                        text: "Lanjutkan dengan google",
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        iconButton:
                            Image.asset("assets/googlelogo.png", height: 20),
                      ),
                    ],
                  ),
                  Container(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.w600),
                        "Belum punya akun? ",
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
                                builder: (context) => const RegisterScreen()),
                          );
                        },
                        child: const Text(
                          style: TextStyle(
                            shadows: [
                              Shadow(
                                  color: AppColors.primary500,
                                  offset: Offset(0, -1))
                            ],
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.transparent,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.primary500,
                            decorationThickness: 2,
                          ),
                          "Daftar",
                        ),
                      ),
                    ],
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
