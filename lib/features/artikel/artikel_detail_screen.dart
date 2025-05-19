// lib/features/artikel/presentation/screens/artikel_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puskeswan_app/components/app_colors.dart';
import 'package:puskeswan_app/features/artikel/artikel_controller.dart';

class ArtikelDetailScreen extends StatefulWidget {
  final int artikelId;

  const ArtikelDetailScreen({
    super.key,
    required this.artikelId,
  });

  @override
  State<ArtikelDetailScreen> createState() => _ArtikelDetailScreenState();
}

class _ArtikelDetailScreenState extends State<ArtikelDetailScreen> {
  late ArtikelProvider _artikelProvider;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _artikelProvider = Provider.of<ArtikelProvider>(context, listen: false);
    _loadArtikelDetail();
  }

  @override
  void dispose() {
    _artikelProvider.clearSelectedArtikel();
    super.dispose();
  }

  Future<void> _loadArtikelDetail() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await _artikelProvider.loadArtikelDetail(widget.artikelId);
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Consumer<ArtikelProvider>(
              builder: (context, provider, child) {
                final artikel = provider.selectedArtikel;

                if (artikel == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Artikel tidak ditemukan'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Kembali'),
                        ),
                      ],
                    ),
                  );
                }

                return CustomScrollView(
                  slivers: [
                    // App Bar
                    SliverAppBar(
                      backgroundColor: AppColors.primary500,
                      foregroundColor: Colors.white,
                      expandedHeight: 240,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              artikel.thumbnail!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: AppColors.neutral200,
                                  child: const Center(
                                    child:
                                        Icon(Icons.image_not_supported, size: 40),
                                  ),
                                );
                              },
                            ),
                            // Gradient overlay for better readability
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.7),
                                  ],
                                  stops: const [0.6, 1.0],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Content
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Category
                            Chip(
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              label: const Text('Perawatan'),
                              backgroundColor: AppColors.primary100,
                              labelStyle: TextStyle(
                                color: AppColors.primary700,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Title
                            Text(
                              artikel.judul,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Author and date
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: AppColors.primary100,
                                  child: Text(
                                    artikel.penulis.substring(0, 1).toUpperCase(),
                                    style: TextStyle(
                                      color: AppColors.primary700,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      artikel.penulis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      artikel.formattedDate,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Content
                            Text(
                              artikel.deskripsi,
                              style: const TextStyle(
                                fontSize: 16,
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 248),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}