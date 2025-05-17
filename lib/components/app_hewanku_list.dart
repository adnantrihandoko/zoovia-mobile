// lib/features/hewanku/presentation/screens/hewan_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puskeswan_app/components/app_hewan_card.dart';
import 'package:puskeswan_app/features/hewanku/presentation/controller/hewanku_controller.dart';
import 'package:puskeswan_app/features/hewanku/presentation/screen/detail_hewan_screen.dart';
import 'package:puskeswan_app/features/rekammedis/rekam_medis_screen.dart';

class AppHewanList extends StatelessWidget {
  const AppHewanList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HewanProvider>(
      builder: (context, provider, _) {
        if (provider.status == HewanStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (provider.hewanList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.pets,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Belum ada hewan terdaftar',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        }

        if (provider.status == HewanStatus.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                const SizedBox(height: 16),
                Text(
                  provider.errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    provider.getHewanByUserId();
                  },
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.getHewanByUserId(),
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 150),
            itemCount: provider.hewanList.length,
            itemBuilder: (context, index) {
              final hewan = provider.hewanList[index];
              return HewanCard(
                hewan: hewan,
                onTap: () {
                  provider.setSelectedHewan(hewan);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailHewanScreen(hewanId: hewan.id),
                    ),
                  );
                },
                onRekamMedisTap: () {
                  // Navigate to medical record screen
                  provider.setSelectedHewan(hewan);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RekamMedisScreen(hewanId: hewan.id),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
