import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Pastikan import Provider
import 'package:puskeswan_app/components/app_antrian_home_card.dart';
import 'package:puskeswan_app/components/app_background_overlay.dart';
import 'package:puskeswan_app/components/app_colors.dart';
import 'package:puskeswan_app/components/app_header.dart';
import 'package:puskeswan_app/components/app_hewan_home_card.dart';
import 'package:puskeswan_app/components/app_menu_cepat.dart';
import 'package:puskeswan_app/features/profile/presentation/controllers/profile_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Memanggil fetchProfile saat HomeScreen pertama kali dimuat
    // Pastikan ProfileProvider sudah tersedia di widget tree
    Provider.of<ProfileProvider>(context, listen: false).fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AppBackgroundOverlay(),
          const AppHeaderWidget(vertikalPadding: 38,horizontalPadding: 24,),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              color: AppColors.neutral100,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            margin: const EdgeInsets.only(top: 150),
            child: Transform.translate(
              offset: const Offset(0, -45),
              child: const Column(
                spacing: 24,
                children: [
                  AppHewanHomeCard(),
                  AppMenuCepatWidget(),
                  AppAntrianHomeCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
