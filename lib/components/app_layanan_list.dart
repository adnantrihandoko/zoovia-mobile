// lib/features/layanan/presentation/widgets/layanan_list_content.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puskeswan_app/components/app_colors.dart';
import 'package:puskeswan_app/features/layanan/data/layanan_model.dart';
import 'package:puskeswan_app/features/layanan/presentation/controllers/layanan_controller.dart';
import 'package:puskeswan_app/components/app_layanan_card.dart';
import 'package:puskeswan_app/features/layanan/presentation/screens/layanan_detail_screen.dart';

class AppLayananList extends StatefulWidget {
  const AppLayananList({Key? key}) : super(key: key);

  @override
  _AppLayananListState createState() => _AppLayananListState();
}

class _AppLayananListState extends State<AppLayananList> {
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadLayanan();
  }

  Future<void> _loadLayanan() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      final layananProvider = Provider.of<LayananProvider>(context, listen: false);
      await layananProvider.loadLayanan();
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 60,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Terjadi kesalahan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadLayanan,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary500,
                foregroundColor: Colors.white,
              ),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    return Consumer<LayananProvider>(
      builder: (context, provider, child) {
        final layananList = provider.layanan;

        if (layananList.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: _loadLayanan,
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 128),
            itemCount: layananList.length,
            itemBuilder: (context, index) {
              final layanan = layananList[index];
              return LayananCard(
                layanan: layanan,
                onTap: () => _navigateToDetail(layanan),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Belum ada layanan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Belum ada layanan yang tersedia saat ini',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToDetail(LayananModel layanan) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LayananDetailScreen(layanan: layanan),
      ),
    );
  }
}