// features/onboarding/presentation/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puskeswan_app/features/auth/presentation/screens/login_screen.dart';
import 'package:puskeswan_app/features/home/main_screen.dart';
import 'package:puskeswan_app/features/onboarding/app_initial_state_notifier.dart';
import 'package:puskeswan_app/features/onboarding/onboarding_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final initialProvider = Provider.of<AppInitialStateNotifier>(context);
    return Scaffold(
      body: AppInitialState.loading == initialProvider.state
          ? _buildLoading()
          : AppInitialState.onboarding == initialProvider.state
              ? const OnboardingScreen()
              : AppInitialState.login == initialProvider.state
                  ? const LoginScreen()
                  : MainScreen(),
    );
  }

  Widget _buildLoading() => const Center(child: CircularProgressIndicator());
}
