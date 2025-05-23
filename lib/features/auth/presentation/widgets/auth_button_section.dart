import 'package:flutter/material.dart';
import 'package:puskeswan_app/components/app_button.dart';
import 'package:puskeswan_app/components/app_colors.dart';
import 'package:puskeswan_app/features/auth/presentation/controllers/login_controller.dart';
import 'package:puskeswan_app/features/auth/presentation/widgets/auth_divider.dart';
import 'package:puskeswan_app/features/onboarding/inisiasi_app_provider.dart';
import 'package:puskeswan_app/main_screen.dart';

class AuthButtonSection extends StatelessWidget {
  final AuthProvider authProvider;
  final InisiasiAppProvider inisiasiAppProvider;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const AuthButtonSection({
    super.key, 
    required this.authProvider,
    required this.inisiasiAppProvider,
    required this.emailController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 26.0,
      children: [
        AppButton(
          onPressed: authProvider.isLoading ? null : () => _handleLogin(context),
          text: authProvider.isLoading ? "Loading..." : "Masuk",
        ),
        const AuthDivider(),
        AppButton(
          onPressed: authProvider.isLoading ? null : () => _handleGoogleLogin(context),
          text: "Lanjutkan dengan google",
          backgroundColor: Colors.white,
          outlineBorderColor: AppColors.neutral100,
          textColor: Colors.black,
          iconButton: Image.asset("assets/googlelogo.png", height: 20),
        ),
      ],
    );
  }

  Future<void> _handleLogin(BuildContext context) async {
    final isSuccess = await authProvider.login(
      emailController.text,
      passwordController.text,
    );
    if (isSuccess == true) {
      await inisiasiAppProvider.login();
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    }
  }

  Future<void> _handleGoogleLogin(BuildContext context) async {
    final isSuccess = await authProvider.loginWithGoogle();
    if (isSuccess == true) {
      await inisiasiAppProvider.login();
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    }
  }
}