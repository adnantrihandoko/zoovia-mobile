import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:provider/provider.dart';
import 'package:puskeswan_app/components/app_colors.dart';
import 'package:puskeswan_app/features/antrian/presentation/screens/antrian_screen.dart';
import 'package:puskeswan_app/features/auth/presentation/screens/login_screen.dart';
import 'package:puskeswan_app/features/hewanku/presentation/screen/hewanku_screen.dart';
import 'package:puskeswan_app/features/hewanku/presentation/screen/riwayat_screen.dart';
import 'package:puskeswan_app/features/home/home_screen.dart';
import 'package:puskeswan_app/features/onboarding/onboarding_screen.dart';
import 'package:puskeswan_app/features/profile/presentation/controllers/profile_controller.dart';
import 'package:puskeswan_app/features/profile/presentation/screens/profil_screen.dart';
import 'package:puskeswan_app/features/onboarding/inisiasi_app_provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mendengarkan perubahan state
    final inisiasiAppProvider = Provider.of<InisiasiAppProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);
    print(inisiasiAppProvider.state);

    // Cek apakah state adalah login dan arahkan ke LoginScreen
    if (inisiasiAppProvider.state == InisiasiAppState.login) {
      return const LoginScreen(); // LoginScreen jika state login
    } else if (inisiasiAppProvider.state == InisiasiAppState.home) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: PersistentTabView(
          navBarHeight: 64,
          tabs: [
            PersistentTabConfig(
                screen: HomeScreen(),
                item: ItemConfig(
                    activeForegroundColor: AppColors.primary500,
                    title: "Beranda",
                    icon: const Icon(Icons.home))),
            PersistentTabConfig(
                screen: HomeScreen(),
                item: ItemConfig(
                    activeForegroundColor: AppColors.primary500,
                    title: "Layanan",
                    icon: const Icon(Icons.medical_services))),
            PersistentTabConfig(
                screen: const AntrianScreen(),
                item: ItemConfig(
                    activeForegroundColor: AppColors.primary500,
                    title: "Antrian",
                    icon: const Icon(Icons.people))),
            PersistentTabConfig(
                screen: HewanListScreen(),
                item: ItemConfig(
                    activeForegroundColor: AppColors.primary500,
                    title: "Riwayat",
                    icon: const Icon(Icons.article))),
            PersistentTabConfig(
                screen: const ProfilScreen(),
                item: ItemConfig(
                    activeForegroundColor: AppColors.primary500,
                    title: "Profil",
                    icon: const Icon(Icons.person))),
          ],
          navBarBuilder: (navbarConfig) =>
              Style4BottomNavBar(navBarConfig: navbarConfig),
        ),
      );
    } else if (inisiasiAppProvider.state == InisiasiAppState.onboarding) {
      return const OnboardingScreen();
    } else {
      return _buildLoading();
    }
  }

  Widget _buildLoading() => const Center(child: CircularProgressIndicator());

  // Jika bukan login, tampilkan PersistentTabView
}
