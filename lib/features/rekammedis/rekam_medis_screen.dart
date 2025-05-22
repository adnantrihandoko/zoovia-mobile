// lib/features/rekam_medis/presentation/screens/rekam_medis_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puskeswan_app/components/app_button.dart';
import 'package:puskeswan_app/components/app_colors.dart';
import 'package:puskeswan_app/components/app_loading_overlay.dart';
import 'package:puskeswan_app/components/app_snackbar.dart';
import 'package:puskeswan_app/features/hewanku/data/hewan_model.dart';
import 'package:puskeswan_app/features/rekammedis/detail_rekam_medis_screen.dart';
import 'package:puskeswan_app/features/rekammedis/rekam_medis_controller.dart';
import 'package:puskeswan_app/features/rekammedis/rekam_medis_model.dart';

class RekamMedisScreen extends StatefulWidget {
  final int hewanId;
  
  const RekamMedisScreen({
    Key? key,
    required this.hewanId,
  }) : super(key: key);

  @override
  State<RekamMedisScreen> createState() => _RekamMedisScreenState();
}

class _RekamMedisScreenState extends State<RekamMedisScreen> {
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadRekamMedis();
  }
  
  Future<void> _loadRekamMedis() async {
    setState(() => _isLoading = true);
    
    try {
      final provider = Provider.of<RekamMedisProvider>(context, listen: false);
      await provider.getRekamMedisByHewanId(widget.hewanId);
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(context, 'Gagal memuat data rekam medis: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
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
        title: const Text('Rekam Medis'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadRekamMedis,
          ),
        ],
      ),
      body: AppLoadingOverlay(
        isLoading: _isLoading,
        child: Consumer<RekamMedisProvider>(
          builder: (context, provider, _) {
            if (provider.status == RekamMedisStatus.error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Terjadi kesalahan',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      provider.errorMessage,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _loadRekamMedis,
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            }
            
            final rekamMedisList = provider.rekamMedisList;
            
            if (rekamMedisList.isEmpty) {
              return _buildEmptyState();
            }
            
            return _buildRekamMedisList(rekamMedisList);
          },
        ),
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.medical_services_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada rekam medis',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Belum ada catatan medis untuk hewan ini',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
  
  Widget _buildRekamMedisList(List<RekamMedisModel> rekamMedisList) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: rekamMedisList.length,
      itemBuilder: (context, index) {
        final rekamMedis = rekamMedisList[index];
        return _buildRekamMedisCard(rekamMedis);
      },
    );
  }
  
  Widget _buildRekamMedisCard(RekamMedisModel rekamMedis) {
    final formattedDate = _formatDate(rekamMedis.createdAt ?? '');
    
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _navigateToDetailRekamMedis(context, rekamMedis.id),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with date and doctor info
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.medical_services,
                      color: AppColors.primary600,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formattedDate,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (rekamMedis.dokter != null)
                          Text(
                            'Dokter: ${rekamMedis.dokter?.namaDokter ?? 'Tidak ada data'}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              
              // Description preview
              Text(
                'Deskripsi:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                rekamMedis.deskripsi ?? 'Tidak ada deskripsi',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _navigateToDetailRekamMedis(BuildContext context, int rekamMedisId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailRekamMedisScreen(rekamMedisId: rekamMedisId),
      ),
    );
    
    if (result == true) {
      _loadRekamMedis();
    }
  }
  
  String _formatDate(String dateString) {
    if (dateString.isEmpty) {
      return 'Tanggal tidak tersedia';
    }
    
    try {
      final date = DateTime.parse(dateString);
      // Format date without using DateFormat class
      String day = date.day.toString().padLeft(2, '0');
      String month = _getMonthName(date.month, short: true);
      String year = date.year.toString();
      String hour = date.hour.toString().padLeft(2, '0');
      String minute = date.minute.toString().padLeft(2, '0');
      
      return '$day $month $year, $hour:$minute';
    } catch (e) {
      return 'Format tanggal tidak valid';
    }
  }
  
  String _getMonthName(int month, {bool short = false}) {
    List<String> monthNames = short ? 
      [
        'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'
      ] : 
      [
        'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
        'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
      ];
    return monthNames[month - 1];
  }
}