// lib/features/artikel/presentation/screens/artikel_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puskeswan_app/components/app_colors.dart';
import 'package:puskeswan_app/features/artikel/artikel_controller.dart';
import 'package:puskeswan_app/features/artikel/artikel_detail_screen.dart';
import 'package:puskeswan_app/features/artikel/artikel_model.dart';

class ArtikelScreen extends StatefulWidget {
  const ArtikelScreen({super.key});

  @override
  State<ArtikelScreen> createState() => _ArtikelScreenState();
}

class _ArtikelScreenState extends State<ArtikelScreen> {
  late ArtikelProvider _artikelProvider;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _artikelProvider = Provider.of<ArtikelProvider>(context, listen: false);
    _loadArtikels();
  }

  Future<void> _loadArtikels() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _artikelProvider.loadArtikels();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral100,
      appBar: AppBar(
        backgroundColor: AppColors.primary500,
        foregroundColor: Colors.white,
        title: const Text('Artikel Kesehatan'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadArtikels,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Consumer<ArtikelProvider>(
                builder: (context, provider, child) {
                  if (provider.status == ArtikelStatus.error) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Terjadi kesalahan saat memuat data'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadArtikels,
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (provider.artikels.isEmpty) {
                    return const Center(
                      child: Text('Tidak ada artikel'),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 248),
                    itemCount: provider.artikels.length,
                    itemBuilder: (context, index) {
                      final artikel = provider.artikels[index];
                      return ArtikelCard(
                        artikel: artikel,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ArtikelDetailScreen(
                                artikelId: artikel.id,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}

class ArtikelCard extends StatelessWidget {
  final ArtikelModel artikel;
  final VoidCallback onTap;

  const ArtikelCard({
    super.key,
    required this.artikel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0.5,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                artikel.thumbnail!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.neutral200,
                    child: const Center(
                      child: Icon(Icons.image_not_supported, size: 40),
                    ),
                  );
                },
              ),
            ),
            // Category badge
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Chip(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                label: const Text('Perawatan'),
                backgroundColor: AppColors.primary100,
                labelStyle: TextStyle(
                  color: AppColors.primary700,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Text(
                artikel.judul,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Footer row
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: AppColors.primary100,
                    child: Text(
                      artikel.penulis.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        color: AppColors.primary700,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    artikel.penulis,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    artikel.formattedDate,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}