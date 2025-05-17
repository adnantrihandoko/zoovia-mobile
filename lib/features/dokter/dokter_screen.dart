// lib/features/dokter/presentation/screens/dokter_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puskeswan_app/components/app_colors.dart';
import 'package:puskeswan_app/features/dokter/app_dokter_card.dart';
import 'package:puskeswan_app/features/dokter/dokter_controller.dart';

class DokterListScreen extends StatefulWidget {
  const DokterListScreen({Key? key}) : super(key: key);

  @override
  State<DokterListScreen> createState() => _DokterListScreenState();
}

class _DokterListScreenState extends State<DokterListScreen> {
  @override
  void initState() {
    super.initState();
    // Load dokter list when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DokterProvider>().getAllDokter();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral100,
      appBar: AppBar(
        backgroundColor: AppColors.primary500,
        foregroundColor: Colors.white,
        title: const Text('Daftar Dokter'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        child: Consumer<DokterProvider>(
          builder: (context, provider, child) {
            switch (provider.status) {
              case DokterStatus.loading:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case DokterStatus.error:
                return _buildErrorView(context, provider);
              case DokterStatus.loaded:
                return _buildDokterList(context, provider);
              case DokterStatus.initial:
              default:
                return const Center(
                  child: Text('Memuat data dokter...'),
                );
            }
          },
        ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, DokterProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red[300],
            size: 60,
          ),
          const SizedBox(height: 16),
          Text(
            'Terjadi kesalahan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red[300],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              provider.errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => provider.getAllDokter(),
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildDokterList(BuildContext context, DokterProvider provider) {
    if (provider.dokterList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_off,
              color: Colors.grey[400],
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak ada dokter tersedia',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => provider.getAllDokter(),
              child: const Text('Segarkan'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => provider.getAllDokter(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemCount: provider.dokterList.length,
        itemBuilder: (context, index) {
          final dokter = provider.dokterList[index];
          return DokterCard(
            dokter: dokter,
            onTap: () {
              // Set selected dokter and navigate to detail if needed
              provider.setSelectedDokter(dokter);
              // You can add navigation to doctor detail screen here
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => DokterDetailScreen(),
              //   ),
              // );
            },
          );
        },
      ),
    );
  }
}