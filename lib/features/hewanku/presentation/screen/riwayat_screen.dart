import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:provider/provider.dart';
import 'package:puskeswan_app/components/app_antrian_list.dart';
import 'package:puskeswan_app/components/app_background_overlay.dart';
import 'package:puskeswan_app/components/app_button.dart';
import 'package:puskeswan_app/components/app_colors.dart';
import 'package:puskeswan_app/components/app_header.dart';
import 'package:puskeswan_app/components/app_hewanku_list.dart';
import 'package:puskeswan_app/features/hewanku/presentation/controller/hewanku_controller.dart';
import 'package:puskeswan_app/features/hewanku/presentation/screen/tambah_hewan_screen.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreen();
}

class _RiwayatScreen extends State<RiwayatScreen> {
  late HewanProvider provider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeProvider();
    });
    super.initState();
  }

  Future<void> _initializeProvider() async {
    provider = Provider.of<HewanProvider>(context, listen: false);
    await provider.getHewanByUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AppBackgroundOverlay(),
          const AppHeaderWidget(
            vertikalPadding: 38,
            horizontalPadding: 24,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: const BoxDecoration(
              color: AppColors.neutral100,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            margin: const EdgeInsets.only(top: 110),
            child: FTabs(
              style: FTabsStyle(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(99), // Mengatur border radius
                    color: Colors.white, // Mengatur warna latar belakang tab
                    border: Border.all(color: AppColors.neutral200)),
                selectedLabelTextStyle: const TextStyle(
                  color: Colors.white, // Mengatur warna teks label yang dipilih
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelTextStyle: const TextStyle(
                  color: Colors
                      .black, // Mengatur warna teks label yang tidak dipilih
                ),
                indicatorDecoration: BoxDecoration(
                  color: AppColors.primary500, // Mengatur warna indikator tab
                  borderRadius: BorderRadius.circular(
                      99), // Mengatur border radius indikator
                ),
                focusedOutlineStyle: FFocusedOutlineStyle(
                  color: AppColors.neutral900,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              children: [
                FTabEntry(
                    label: Text('Riwayat'),
                    child: Expanded(child: AppAntrianList(status: const ['selesai'],))),
                const FTabEntry(
                  label: Text('Hewanku'),
                  child: Expanded(child: AppHewanList()),
                ),
              ],
            ),
          ),
          Positioned(
              bottom: 112,
              right: 24,
              child: AppButton(
                elevation: 4,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TambahHewanScreen()));
                },
                text: "Hewan",
                width: 140,
                iconButton: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 22,
                ),
              )),
        ],
      ),
    );
  }
}
