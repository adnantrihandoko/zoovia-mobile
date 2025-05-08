// lib/screens/hewan_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puskeswan_app/features/hewanku/data/hewan_model.dart';
import 'package:puskeswan_app/features/hewanku/presentation/controller/hewanku_controller.dart';
import 'package:puskeswan_app/features/hewanku/presentation/screen/detail_hewan_screen.dart';
import 'package:puskeswan_app/features/hewanku/presentation/screen/tambah_hewan_screen.dart';

class HewanListScreen extends StatefulWidget {

  const HewanListScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HewanListScreen> createState() => _HewanListScreenState();
}

class _HewanListScreenState extends State<HewanListScreen> {
  @override
  void initState() {
    super.initState();
    // Ambil data hewan saat screen dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HewanProvider>(context, listen: false)
          .getHewanByUserId();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Hewan'),
      ),
      body: Consumer<HewanProvider>(
        builder: (context, provider, child) {
          switch (provider.status) {
            case HewanStatus.loading:
              return const Center(child: CircularProgressIndicator());
              
            case HewanStatus.loaded:
              final hewanList = provider.hewanList;
              if (hewanList.isEmpty) {
                return const Center(
                  child: Text('Belum ada hewan terdaftar'),
                );
              }
              return ListView.builder(
                itemCount: hewanList.length,
                itemBuilder: (context, index) {
                  final hewan = hewanList[index];
                  return HewanListItem(hewan: hewan);
                },
              );
              
            case HewanStatus.error:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${provider.errorMessage}'),
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
              
            case HewanStatus.initial:
            default:
              return const SizedBox.shrink();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke halaman tambah hewan
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TambahHewanScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class HewanListItem extends StatelessWidget {
  final Hewan hewan;

  const HewanListItem({
    Key? key,
    required this.hewan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: hewan.fotoHewan != null
            ? CircleAvatar(
                backgroundImage: NetworkImage(hewan.fotoHewan!),
              )
            : const CircleAvatar(
                child: Icon(Icons.pets),
              ),
        title: Text(hewan.namaHewan),
        subtitle: Text('${hewan.jenisHewan} - ${hewan.ras ?? 'Tidak ada ras'}'),
        trailing: Text('${hewan.umur} tahun'),
        onTap: () {
          // Set hewan yang dipilih dan navigasi ke detail
          Provider.of<HewanProvider>(context, listen: false)
              .setSelectedHewan(hewan);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailHewanScreen(hewanId: hewan.id),
            ),
          );
        },
      ),
    );
  }
}