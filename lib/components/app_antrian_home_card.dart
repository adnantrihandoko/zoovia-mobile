import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puskeswan_app/components/app_colors.dart';
import 'package:puskeswan_app/features/antrian/data/antrian_model.dart';
import 'package:puskeswan_app/features/antrian/presentation/controller/antrian_controller.dart';

class AppAntrianHomeCard extends StatelessWidget {
  const AppAntrianHomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AntrianProvider>(builder: (context, provider, _) {
      final QueueSummary? summary = provider.queueSummary;
      final AntrianModel? userQueue = provider.userActiveQueue;

      if (provider.status == AntrianStatus.loading) {
        return _buildLoadingCard(context);
      }

      if (summary == null) {
        return _buildEmptyCard(context);
      }

      return SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            const Text(
              'Antrian Anda',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(70),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      )
                    ],
                    color: AppColors.primary500,
                    borderRadius: const BorderRadius.all(Radius.circular(18))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Antrian Anda",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 12),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF6228F0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(999)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time_filled_rounded,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                    _buildNomorAntrianAnda(userQueue)
                                  ],
                                ),
                              ),
                              _buildTotalAntrian(summary),
                            ],
                          ),
                          Column(
                            spacing: 4,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Sisa: ${_calculateRemainingQueues(userQueue, summary)}",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    userQueue?.nomorAntrian == null ? "" : " antrian lagi",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    "Status: ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  _buildStatus(userQueue),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Antrian Saat Ini",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 12),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF6228F0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(999)),
                                ),
                                child: Row(children: [
                                  const Icon(
                                    Icons.access_time_filled_rounded,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                  _buildCurrentNumber(summary),
                                ]),
                              ),
                              _buildTotalAntrian(summary),
                            ],
                          ),
                          Column(
                            spacing: 4,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Jenis Layanan:",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              _buildJenisLayananAntrian(userQueue),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  // Menghitung sisa antrian sebelum giliran pengguna
  String _calculateRemainingQueues(AntrianModel? userQueue, QueueSummary? summary) {
    if (userQueue == null || userQueue.nomorAntrian == 0) {
      return "-";
    }

    // Jika status antrian pengguna sudah diproses atau selesai, sisa = 0
    if (userQueue.status == 'diproses' || userQueue.status == 'selesai') {
      return "0";
    }

    // Jika status menunggu
    if (summary != null) {
      // Jika ada antrian aktif saat ini
      if (summary.currentNumber > 0) {
        // Hitung selisih antara nomor antrian pengguna dengan nomor antrian saat ini
        int remaining = userQueue.nomorAntrian - summary.currentNumber;
        return remaining > 0 ? remaining.toString() : "0";
      } 
      // Jika tidak ada antrian aktif tapi ada antrian selanjutnya
      else if (summary.nextNumber > 0) {
        // Hitung selisih antara nomor antrian pengguna dengan nomor antrian selanjutnya
        // Tambah 1 karena nextNumber belum diproses
        int remaining = userQueue.nomorAntrian - summary.nextNumber;
        return remaining > 0 ? remaining.toString() : "0";
      }
    }
    
    return "-";
  }

  // Widget untuk menampilkan ketika loading
  Widget _buildLoadingCard(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Antrian Anda',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(70),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    )
                  ],
                  color: AppColors.primary500,
                  borderRadius: const BorderRadius.all(Radius.circular(18))),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan ketika tidak ada data
  Widget _buildEmptyCard(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      height: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Antrian Anda',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(70),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    )
                  ],
                  color: AppColors.primary500,
                  borderRadius: const BorderRadius.all(Radius.circular(18))),
              child: const Center(
                child: Text(
                  'Tidak ada data antrian tersedia',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNomorAntrianAnda(AntrianModel? userQueue) {
    // Tampilkan nomor antrian pengguna jika ada, jika tidak tampilkan "-"
    return Text(
      userQueue?.nomorAntrian != null && userQueue!.nomorAntrian > 0
          ? userQueue.nomorAntrian.toString()
          : "-",
      style: const TextStyle(
          color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTotalAntrian(QueueSummary? summary) {
    // Tampilkan total antrian jika ada dan lebih dari 0
    return Text(
      summary != null && summary.total > 0
          ? " dari ${summary.total}"
          : "",
      style: const TextStyle(
          color: AppColors.neutral200, fontWeight: FontWeight.w500),
    );
  }

  Widget _buildCurrentNumber(QueueSummary? summary) {
    if (summary == null) {
      return const Text("-", 
        style: TextStyle(
          color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold));
    }
    
    // Jika ada antrian yang sedang diproses, tampilkan nomor antrian tersebut
    if (summary.currentNumber > 0) {
      return Text(
        summary.currentNumber.toString(),
        style: const TextStyle(
          color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)
      );
    } 
    // Jika tidak ada antrian yang sedang diproses tapi ada antrian berikutnya
    else if (summary.nextNumber > 0) {
      return Text(
        summary.nextNumber.toString(),
        style: const TextStyle(
          color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)
      );
    } 
    // Jika tidak ada antrian sama sekali
    else {
      return const Text("-", 
        style: TextStyle(
          color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold));
    }
  }

  Widget _buildJenisLayananAntrian(AntrianModel? userQueue) {
    // Tampilkan jenis layanan antrian pengguna jika ada
    return Text(
      userQueue?.namaLayanan != null && userQueue!.namaLayanan.isNotEmpty 
        ? userQueue.namaLayanan 
        : "-",
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildStatus(AntrianModel? userQueue) {
    if (userQueue == null || userQueue.status.isEmpty) {
      return const Text(
        "-",
        style: TextStyle(color: Colors.white),
      );
    }
    
    // Kapitalisasi setiap kata dalam status
    return Text(
      userQueue.status.toLowerCase().split(' ').map((word) {
        return word.isNotEmpty 
          ? word[0].toUpperCase() + word.substring(1) 
          : word;
      }).join(' '),
      style: const TextStyle(color: Colors.white),
    );
  }
}