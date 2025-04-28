import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:provider/provider.dart';
import 'package:puskeswan_app/components/app_colors.dart';
import 'package:puskeswan_app/features/auth/presentation/controllers/login_controller.dart';
import 'package:puskeswan_app/features/home/home_screen.dart';
import 'package:puskeswan_app/features/profile/presentation/screens/profil_screen.dart';
import 'package:puskeswan_app/features/profile/presentation/screens/profile_screen.dart';

class MainScreen extends StatelessWidget {
  final authProvider = GetIt.instance<AuthProvider>();

  MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: PersistentTabView(
          navBarHeight: 64,
          tabs: [
            PersistentTabConfig(
                screen: HomeScreen(email: authProvider.user!.email),
                item: ItemConfig(
                    activeForegroundColor: AppColors.primary500,
                    title: "Beranda",
                    icon: const Icon(Icons.home))),
            PersistentTabConfig(
                screen: HomeScreen(email: authProvider.user!.email),
                item: ItemConfig(
                    activeForegroundColor: AppColors.primary500,
                    title: "Layanan",
                    icon: const Icon(Icons.medical_services))),
            PersistentTabConfig(
                screen: HomeScreen(email: authProvider.user!.email),
                item: ItemConfig(
                    activeForegroundColor: AppColors.primary500,
                    title: "Antrian",
                    icon: const Icon(Icons.people))),
            PersistentTabConfig(
                screen: HomeScreen(email: authProvider.user!.email),
                item: ItemConfig(
                    activeForegroundColor: AppColors.primary500,
                    title: "Riwayat",
                    icon: const Icon(Icons.article))),
            PersistentTabConfig(
                screen: const ProfilScreen(
                ),
                item: ItemConfig(
                    activeForegroundColor: AppColors.primary500,
                    title: "Beranda",
                    icon: const Icon(Icons.home))),
          ],
          navBarBuilder: (navbarConfig) =>
              Style4BottomNavBar(navBarConfig: navbarConfig)),
    );
  }
}
