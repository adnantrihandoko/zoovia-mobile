import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puskeswan_app/components/app_button.dart';
import 'package:puskeswan_app/components/app_colors.dart';
import 'package:puskeswan_app/features/hewanku/data/hewan_model.dart';
import 'package:puskeswan_app/features/hewanku/presentation/controller/hewanku_controller.dart';
import 'package:puskeswan_app/features/hewanku/presentation/screen/detail_hewan_screen.dart';
import 'package:puskeswan_app/features/rekammedis/rekam_medis_screen.dart';

class AppHewanHomeCarousel extends StatefulWidget {
  const AppHewanHomeCarousel({super.key});

  @override
  State<AppHewanHomeCarousel> createState() => _AppHewanHomeCarouselState();
}

class _AppHewanHomeCarouselState extends State<AppHewanHomeCarousel> {
  final PageController _pageController = PageController(viewportFraction: 1.1);
  int _currentPage = 0;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadData();

    // Listener untuk mendeteksi perubahan halaman
    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final hewanProvider = Provider.of<HewanProvider>(context, listen: false);

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      await hewanProvider.getHewanByUserId();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HewanProvider>(
      builder: (context, provider, child) {
        if (_isLoading) {
          return _buildLoadingState();
        }

        if (_hasError) {
          return _buildErrorState();
        }

        if (provider.hewanList.isEmpty) {
          return _buildEmptyState();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 140,
              child: PageView.builder(
                controller: _pageController,
                itemCount: provider.hewanList.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final hewan = provider.hewanList[index];
                  return FractionallySizedBox(
                      widthFactor: 1 / _pageController.viewportFraction,
                      child: _buildHewanCard(context, hewan));
                },
              ),
            ),
            const SizedBox(height: 8),

            // Pagination dots
            if (provider.hewanList.length > 1)
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    provider.hewanList.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      height: 8,
                      width: _currentPage == index ? 20 : 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? AppColors.primary500
                            : AppColors.neutral300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildHewanCard(BuildContext context, Hewan hewan) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 6,
            offset: const Offset(0, 4),
          )
        ],
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(18)),
      ),
      child: Row(
        children: [
          // Foto hewan
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: hewan.fotoHewan != null && hewan.fotoHewan!.isNotEmpty
                ? Image.network(
                    width: 75,
                    hewan.fotoHewan!,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, _) => Container(
                      color: AppColors.neutral200,
                      child: const Icon(Icons.pets,
                          size: 50, color: AppColors.neutral400),
                    ),
                  )
                : Container(
                    color: AppColors.neutral200,
                    child: const Icon(Icons.pets,
                        size: 50, color: AppColors.neutral400),
                  ),
          ),
          const SizedBox(width: 12),

          // Informasi hewan
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama dan jenis
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        hewan.namaHewan,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: const BoxDecoration(
                        color: AppColors.secondary200,
                        borderRadius: BorderRadius.all(Radius.circular(99)),
                      ),
                      child: Text(
                        hewan.jenisHewan,
                        style: const TextStyle(fontSize: 12),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 4),

                // Ras dan umur
                Row(
                  children: [
                    const Text("Ras: ",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12, color: AppColors.neutral500)),
                    Text(hewan.ras ?? "Tidak ada",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12)),
                    const SizedBox(width: 10),
                    const Text("Umur: ",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12, color: AppColors.neutral500)),
                    Text(
                      overflow: TextOverflow.ellipsis,
                      _formatUmur(hewan.umur),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),

                const Spacer(),

                // Tombol aksi
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: AppButton(
                        height: 36,
                        outlineBorderColor: AppColors.primary500,
                        backgroundColor: Colors.transparent,
                        textColor: AppColors.primary800,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailHewanScreen(hewanId: hewan.id),
                          ),
                        ),
                        text: "Detail",
                        borderRadius: 6,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: AppButton(
                        height: 36,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RekamMedisScreen(hewanId: hewan.id),
                          ),
                        ),
                        text: "Rekam Medis",
                        borderRadius: 6,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 150,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 6,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      height: 150,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 6,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 40),
            const SizedBox(height: 8),
            const Text('Gagal memuat data hewan'),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _loadData,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 150,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 6,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.pets, color: AppColors.neutral400, size: 40),
            const SizedBox(height: 8),
            const Text('Belum ada hewan terdaftar'),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                // Navigasi ke halaman tambah hewan
                // Navigator.push(context, MaterialPageRoute(builder: (context) => TambahHewanScreen()));
              },
              child: const Text('Tambah Hewan'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatUmur(int umurBulan) {
    if (umurBulan < 12) {
      return '$umurBulan Bulan';
    } else {
      int tahun = umurBulan ~/ 12;
      int bulan = umurBulan % 12;
      if (bulan == 0) {
        return '$tahun Tahun';
      } else {
        return '$tahun Tahun $bulan Bulan';
      }
    }
  }
}
