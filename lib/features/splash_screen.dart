// features/onboarding/presentation/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puskeswan_app/features/auth/presentation/screens/login_screen.dart';
import 'package:puskeswan_app/features/home/home_screen.dart';
import 'package:puskeswan_app/features/onboarding/app_initial_state_notifier.dart';
import 'package:puskeswan_app/features/onboarding/onboarding_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AppInitialStateNotifier>(
        builder: (context, notifier, _) {
          switch (notifier.state) {
            case AppInitialState.loading:
              return _buildLoading();
            case AppInitialState.onboarding:
              return const OnboardingScreen();
            case AppInitialState.login:
              return const LoginScreen();
            case AppInitialState.home:
              return const HomeScreen(email: "Tes");
            default:
              return _buildError();
          }
        },
      ),
    );
  }

  Widget _buildLoading() => const Center(child: CircularProgressIndicator());
  Widget _buildError() => const Center(child: Text('Error: Invalid state'));
}