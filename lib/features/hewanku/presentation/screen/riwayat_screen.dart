import 'package:flutter/material.dart';
import 'package:puskeswan_app/components/app_background_overlay.dart';
import 'package:puskeswan_app/components/app_colors.dart';
import 'package:puskeswan_app/components/app_tab_header.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AppBackgroundOverlay(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: const BoxDecoration(
              color: AppColors.neutral100,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            margin: const EdgeInsets.only(top: 150),
            child: Column(
              spacing: 24,
              children: [
                AppTabHeader(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
