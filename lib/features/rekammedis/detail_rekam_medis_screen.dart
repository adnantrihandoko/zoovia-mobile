// lib/features/rekam_medis/presentation/screens/detail_rekam_medis_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puskeswan_app/components/app_button.dart';
import 'package:puskeswan_app/components/app_colors.dart';
import 'package:puskeswan_app/components/app_loading_overlay.dart';
import 'package:puskeswan_app/components/app_snackbar.dart';
import 'package:puskeswan_app/features/rekammedis/rekam_medis_controller.dart';

class DetailRekamMedisScreen extends StatefulWidget {
  final int rekamMedisId;
  
  const DetailRekamMedisScreen({
    Key? key,
    required this.rekamMedisId,
  }) : super(key: key);

  @override
  State<DetailRekamMedisScreen> createState() => _DetailRekamMedisScreenState();
}

class _DetailRekamMedisScreenState extends State<DetailRekamMedisScreen> {
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadRekamMedisDetail();
  }
  
  Future<void> _loadRekamMedisDetail() async {
    setState(() => _isLoading = true);
    
    try {
      final provider = Provider.of<RekamMedisProvider>(context, listen: false);
      await provider.getRekamMedisById(widget.rekamMedisId);
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(context, 'Gagal memuat detail rekam medis: ${e.toString()}');
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
        title: const Text('Detail Rekam Medis'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadRekamMedisDetail,
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
                      onPressed: _loadRekamMedisDetail,
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            }
            
            final rekamMedis = provider.selectedRekamMedis;
            
            if (rekamMedis == null) {
              return const Center(
                child: Text('Data rekam medis tidak ditemukan'),
              );
            }
            
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card with basic info
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0.5,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header with animal icon
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.primary100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.pets,
                                  size: 32,
                                  color: AppColors.primary600,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      rekamMedis.hewan?.namaHewan ?? 'Hewan tidak ditemukan',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${rekamMedis.hewan?.jenisHewan ?? '-'}, ${rekamMedis.hewan?.ras ?? 'Tidak ada data ras'}',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 16),
                          
                          // Date and Doctor info
                          _buildInfoRow(
                            'Tanggal Pemeriksaan',
                            _formatDate(rekamMedis.createdAt ?? ''),
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            'Dokter',
                            rekamMedis.dokter?.namaDokter ?? 'Tidak ada data dokter',
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Deskripsi section
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0.5,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Deskripsi Pemeriksaan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Divider(),
                          const SizedBox(height: 8),
                          Text(
                            rekamMedis.deskripsi ?? 'Tidak ada deskripsi',
                            style: const TextStyle(
                              fontSize: 15,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  const SizedBox(height: 16),
                  
                  // Last updated info
                  if (rekamMedis.updatedAt != null)
                    Center(
                      child: Text(
                        'Terakhir diperbarui: ${_formatDate(rekamMedis.updatedAt!)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 150,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
  
  String _formatDate(String dateString) {
    if (dateString.isEmpty) {
      return 'Tanggal tidak tersedia';
    }
    
    try {
      final date = DateTime.parse(dateString);
      // Format date without using DateFormat class
      String day = date.day.toString().padLeft(2, '0');
      String month = _getMonthName(date.month);
      String year = date.year.toString();
      String hour = date.hour.toString().padLeft(2, '0');
      String minute = date.minute.toString().padLeft(2, '0');
      
      return '$day $month $year, $hour:$minute';
    } catch (e) {
      return 'Format tanggal tidak valid';
    }
  }
  
  String _getMonthName(int month) {
    List<String> monthNames = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return monthNames[month - 1];
  }
}