// lib/features/layanan/presentation/screens/layanan_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puskeswan_app/components/app_colors.dart';
import 'package:puskeswan_app/features/dokter/app_dokter_card.dart';
import 'package:puskeswan_app/features/dokter/dokter_model.dart';
import 'package:puskeswan_app/features/layanan/data/layanan_model.dart';
import 'package:puskeswan_app/features/layanan/presentation/controllers/layanan_controller.dart';

class LayananDetailScreen extends StatefulWidget {
  final LayananModel layanan;

  const LayananDetailScreen({
    Key? key,
    required this.layanan,
  }) : super(key: key);

  @override
  _LayananDetailScreenState createState() => _LayananDetailScreenState();
}

class _LayananDetailScreenState extends State<LayananDetailScreen> {
  bool _isLoadingDokter = false;
  List<DokterModel> _dokterList = [];

  @override
  void initState() {
    super.initState();
    _loadDokter();
  }

  Future<void> _loadDokter() async {
    if (widget.layanan.dokters != null && widget.layanan.dokters!.isNotEmpty) {
      setState(() {
        _dokterList = widget.layanan.dokters!;
      });
      return;
    }

    setState(() {
      _isLoadingDokter = true;
    });

    try {
      final layananProvider =
          Provider.of<LayananProvider>(context, listen: false);
      await layananProvider.getDokterByLayananId(widget.layanan.id);

      setState(() {
        _dokterList = layananProvider.dokterList;
        _isLoadingDokter = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingDokter = false;
      });
      // Optionally show a snackbar or other error notification
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data dokter')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral100,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: _buildContent(),
          ),
          SliverToBoxAdapter(
            child: _buildDokterSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      foregroundColor: Colors.white,
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppColors.primary500,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.layanan.namaLayanan,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: widget.layanan.fotoLayanan != null &&
                widget.layanan.fotoLayanan!.isNotEmpty
            ? Image.network(
                "http://192.168.75.220:7071/${widget.layanan.fotoLayanan!}",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildImagePlaceholder(),
              )
            : _buildImagePlaceholder(),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: AppColors.primary500,
      child: Center(
        child: Icon(
          Icons.medical_services_outlined,
          size: 80,
          color: Colors.white.withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Price card
          Card(
            color: Colors.white,
            elevation: 0.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    Icons.money_rounded,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Harga',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    widget.layanan.hargaLayanan,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Description
          const Text(
            'Deskripsi Layanan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.layanan.deskripsiLayanan,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDokterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: const Text(
            'Dokter Tersedia',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (_isLoadingDokter)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: CircularProgressIndicator(),
            ),
          )
        else if (_dokterList.isEmpty)
          _buildEmptyDokterState()
        else
          Transform.translate(
            offset: Offset(0, -16),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _dokterList.length,
              itemBuilder: (context, index) {
                final dokter = _dokterList[index];
                return _buildDokterCard(dokter);
              },
            ),
          ),
        const SizedBox(height: 216),
      ],
    );
  }

  Widget _buildEmptyDokterState() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 32),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.person_off,
              size: 50,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada dokter tersedia untuk layanan ini',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDokterCard(DokterModel dokter) {
    return DokterCard(dokter: dokter);
  }
}
