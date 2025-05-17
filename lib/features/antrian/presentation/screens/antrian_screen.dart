import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:provider/provider.dart';
import 'package:puskeswan_app/components/app_antrian_list.dart';
import 'package:puskeswan_app/components/app_background_overlay.dart';
import 'package:puskeswan_app/components/app_button.dart';
import 'package:puskeswan_app/components/app_colors.dart';
import 'package:puskeswan_app/components/app_header.dart';
import 'package:puskeswan_app/components/app_layanan_list.dart';
import 'package:puskeswan_app/features/antrian/presentation/controller/antrian_controller.dart';
import 'package:puskeswan_app/features/antrian/presentation/screens/create_antrian_screen.dart';
import 'package:puskeswan_app/features/hewanku/presentation/controller/hewanku_controller.dart';
import 'package:puskeswan_app/features/hewanku/presentation/screen/tambah_hewan_screen.dart';

class AntrianScreen2 extends StatefulWidget {
  const AntrianScreen2({super.key});

  @override
  State<AntrianScreen2> createState() => _AntrianScreen2();
}

class _AntrianScreen2 extends State<AntrianScreen2> {
  late AntrianProvider antrianProvider;
  late HewanProvider hewanProvider;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeProvider();
    });
    super.initState();
  }

  Future<void> _initializeProvider() async {
    antrianProvider = Provider.of<AntrianProvider>(context, listen: false);
    hewanProvider = Provider.of<HewanProvider>(context, listen: false);
    await antrianProvider.membuatKoneksi();
    await antrianProvider.loadAntriansByUser();
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
                    borderRadius: BorderRadius.circular(99),
                    color: Colors.white,
                    border: Border.all(color: AppColors.neutral200)),
                selectedLabelTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelTextStyle: const TextStyle(
                  color: Colors.black,
                ),
                indicatorDecoration: BoxDecoration(
                  color: AppColors.primary500,
                  borderRadius: BorderRadius.circular(99),
                ),
                focusedOutlineStyle: FFocusedOutlineStyle(
                  color: AppColors.neutral900,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              children: [
                FTabEntry(
                  label: const Text('Antrian'),
                  child: Expanded(
                      child: AppAntrianList(
                          status: const ['menunggu', 'diproses'])),
                ),
                const FTabEntry(
                  label: Text('Layanan'),
                  child: Expanded(
                    child: AppLayananList(),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 112,
            right: 24,
            child: AppButton(
              elevation: 4,
              onPressed: () async {
                final apakahSudahPunyaHewan =
                    await hewanProvider.getHewanByUserId();
                if (apakahSudahPunyaHewan) {
                  if (context.mounted) {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const CreateAntrianScreen();
                    }));
                  }
                } else {
                  if (context.mounted) {
                    _buildTambahHewanDulu(context);
                  }
                }
              },
              text: "Daftar",
              width: 140,
              iconButton: const Icon(
                Icons.add,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _buildTambahHewanDulu(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            "Belum punya hewan!",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Anda belum memiliki hewan peliharaan. Silahkan tambah hewan terlebih dahulu.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Keluar dari dialog
                    },
                    child: const Text(
                      "Kembali",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.pressed)) {
                            return AppColors.primary600; // Warna saat ditekan
                          }
                          return AppColors.primary500; // Warna default
                        },
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(); // Tutup dialog
                      // Navigasi ke halaman tambah hewan
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const TambahHewanScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Tambah Hewan",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
