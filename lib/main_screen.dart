import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:provider/provider.dart';
import 'package:puskeswan_app/components/app_colors.dart';
import 'package:puskeswan_app/features/antrian/presentation/screens/antrian_screen.dart';
import 'package:puskeswan_app/features/artikel/artikel_screen.dart';
import 'package:puskeswan_app/features/auth/presentation/screens/login_screen.dart';
import 'package:puskeswan_app/features/hewanku/presentation/screen/riwayat_screen.dart';
import 'package:puskeswan_app/features/home/home_screen.dart';
import 'package:puskeswan_app/features/onboarding/onboarding_screen.dart';
import 'package:puskeswan_app/features/profile/presentation/screens/profil_screen.dart';
import 'package:puskeswan_app/features/onboarding/inisiasi_app_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InisiasiAppProvider>(builder: (context, provider, child) {
      // Navigation logic based on app state
      if (provider.state == InisiasiAppState.login) {
        return const LoginScreen();
      } else if (provider.state == InisiasiAppState.home) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: PersistentTabView(
            navBarHeight: 64,
            tabs: [
              PersistentTabConfig(
                  screen: const HomeScreen(),
                  item: ItemConfig(
                      activeForegroundColor: AppColors.primary500,
                      title: "Beranda",
                      icon: const Icon(Icons.home))),
              PersistentTabConfig(
                  screen: const ArtikelScreen(),
                  item: ItemConfig(
                      activeForegroundColor: AppColors.primary500,
                      title: "Artikel",
                      icon: const Icon(Icons.book_rounded))),
              PersistentTabConfig(
                  screen: const AntrianScreen2(),
                  item: ItemConfig(
                      activeForegroundColor: AppColors.primary500,
                      title: "Antrian",
                      icon: const Icon(Icons.people))),
              PersistentTabConfig(
                  screen: const RiwayatScreen(),
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
      } else if (provider.state == InisiasiAppState.onboarding) {
        return const OnboardingScreen();
      } else {
        return _buildLoading();
      }
    });
  }

  Widget _buildLoading() => const Center(child: CircularProgressIndicator());
}
