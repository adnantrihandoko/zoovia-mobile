
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puskeswan_app/components/app_background_overlay.dart';
import 'package:puskeswan_app/features/auth/presentation/controllers/login_controller.dart';
import 'package:puskeswan_app/features/auth/presentation/widgets/auth_button_section.dart';
import 'package:puskeswan_app/features/auth/presentation/widgets/auth_error_message.dart';
import 'package:puskeswan_app/features/auth/presentation/widgets/auth_header_section.dart';
import 'package:puskeswan_app/features/auth/presentation/widgets/auth_login_form.dart';
import 'package:puskeswan_app/features/auth/presentation/widgets/auth_logo_section.dart';
import 'package:puskeswan_app/features/auth/presentation/widgets/auth_register_section.dart';
import 'package:puskeswan_app/features/onboarding/inisiasi_app_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final inisiasiAppProvider = Provider.of<InisiasiAppProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          const AppBackgroundOverlay(),
          const AuthHeaderSection(),
          _BottomFormSection(
            authProvider: authProvider,
            inisiasiAppProvider: inisiasiAppProvider,
            emailController: _emailController,
            passwordController: _passwordController,
            passwordVisible: _passwordVisible,
            onPasswordVisibilityToggle: () => setState(() => _passwordVisible = !_passwordVisible),
          ),
        ],
      ),
    );
  }
}

// Bottom Form Section Widget
class _BottomFormSection extends StatelessWidget {
  final AuthProvider authProvider;
  final InisiasiAppProvider inisiasiAppProvider;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool passwordVisible;
  final VoidCallback onPasswordVisibilityToggle;

  const _BottomFormSection({
    required this.authProvider,
    required this.inisiasiAppProvider,
    required this.emailController,
    required this.passwordController,
    required this.passwordVisible,
    required this.onPasswordVisibilityToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AuthLogoSection(imagePath: 'assets/logo.png',),
            const SizedBox(height: 32),
            AuthLoginForm(
              emailController: emailController,
              passwordController: passwordController,
              passwordVisible: passwordVisible,
              onPasswordVisibilityToggle: onPasswordVisibilityToggle,
              isLoading: authProvider.isLoading,
            ),
            if (authProvider.appError != null) AuthErrorMessage(message: authProvider.appError!.message),
            SizedBox(height: authProvider.appError != null ? 42.0 : 54.0),
            Expanded(
              child: AuthButtonSection(
                authProvider: authProvider,
                inisiasiAppProvider: inisiasiAppProvider,
                emailController: emailController,
                passwordController: passwordController,
              ),
            ),
            const SizedBox(height: 16),
            const AuthRegisterSection(),
          ],
        ),
      ),
    );
  }
}
