// lib/components/app_antrian_list.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puskeswan_app/components/app_colors.dart';
import 'package:puskeswan_app/features/antrian/presentation/controller/antrian_controller.dart';
import 'package:puskeswan_app/components/app_antrian_card.dart';

class AppAntrianList extends StatefulWidget {
  final List<String>? status;

  const AppAntrianList({
    Key? key,
    this.status,
  }) : super(key: key);

  @override
  State<AppAntrianList> createState() => _AppAntrianListState();
}

class _AppAntrianListState extends State<AppAntrianList> {
  late AntrianProvider _antrianProvider;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _antrianProvider = Provider.of<AntrianProvider>(context, listen: false);
    _loadAntrianData();
  }

  Future<void> _loadAntrianData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final statusParam = widget.status != null && widget.status!.isNotEmpty
          ? widget.status!.join(',')
          : null;
          
      await _antrianProvider.loadAntriansByUser(status: statusParam);
    } catch (e) {
      print("Error loading antrian: $e");
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
    return RefreshIndicator(
      onRefresh: _loadAntrianData,
      color: AppColors.primary500,
      child: Consumer<AntrianProvider>(
        builder: (context, provider, child) {
          if (provider.status == AntrianStatus.loading && _isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary500,
              ),
            );
          }

          if (provider.antrians.isEmpty) {
            return _buildEmptyState();
          }

          // Filter antrian berdasarkan status jika diperlukan
          final filteredAntrians = widget.status != null && widget.status!.isNotEmpty
              ? provider.antrians
                  .where((antrian) => widget.status!.contains(antrian.status))
                  .toList()
              : provider.antrians;

          if (filteredAntrians.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 120),
            itemCount: filteredAntrians.length,
            itemBuilder: (context, index) {
              return AppAntrianCard(
                antrian: filteredAntrians[index],
                position: index + 1,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pets,
            size: 64,
            color: AppColors.neutral300,
          ),
          const SizedBox(height: 16),
          Text(
            "Belum ada antrian",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.neutral500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Klik tombol daftar untuk membuat antrian baru",
            style: TextStyle(
              fontSize: 14,
              color: AppColors.neutral400,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 120), // Give space for the FAB
        ],
      ),
    );
  }
}