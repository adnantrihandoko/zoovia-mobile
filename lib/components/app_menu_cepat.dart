import 'package:flutter/material.dart';
import 'package:puskeswan_app/components/app_colors.dart';
import 'package:puskeswan_app/features/antrian/presentation/screens/antrian_screen.dart';
import 'package:puskeswan_app/features/artikel/artikel_screen.dart';
import 'package:puskeswan_app/features/dokter/dokter_screen.dart';
import 'package:puskeswan_app/features/layanan/presentation/screens/layanan_screen.dart';

class AppMenuCepatWidget extends StatelessWidget {
  const AppMenuCepatWidget({super.key});

  // Mendefinisikan button style untuk mengurangi duplikasi
  ButtonStyle get buttonStyle => ButtonStyle(
        shape: WidgetStateProperty.all<OutlinedBorder>(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered)) {
              return Colors.grey.withOpacity(0.04);
            }
            if (states.contains(WidgetState.focused) ||
                states.contains(WidgetState.pressed)) {
              return Colors.grey.withOpacity(0.12);
            }
            return null;
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Menu Cepat',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildMenuButton(Icons.event_note, 'Lihat Antrian', onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (builder) => const AntrianScreen2(),
                ),
              );
            }),
            _buildMenuButton(Icons.cleaning_services, 'Lihat Layanan',
                onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (builder) => const LayananScreen(),
                ),
              );
            }),
            _buildMenuButton(Icons.medical_services, 'Lihat Dokter',
                onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (builder) => const DokterListScreen(),
                ),
              );
            }),
            _buildMenuButton(Icons.article, 'Lihat Artikel', onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (builder) => const ArtikelScreen(),
                ),
              );
            }),
          ],
        ),
      ],
    );
  }

  // Menggunakan metode untuk menghindari kode duplikat
  Widget _buildMenuButton(IconData icon, String label,
      {required VoidCallback onPressed}) {
    return Expanded(
      child: TextButton(
        style: buttonStyle,
        onPressed: onPressed,
        child: MenuButton(
          icon: icon,
          label: label,
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const MenuButton({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: AppColors.primary500,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 60,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
