// lib/features/antrian/presentation/widgets/antrian_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puskeswan_app/components/app_colors.dart';
import 'package:puskeswan_app/features/antrian/data/antrian_model.dart';
import 'package:puskeswan_app/features/antrian/presentation/controller/antrian_controller.dart';

class AppAntrianCard extends StatelessWidget {
  final AntrianModel antrian;

  const AppAntrianCard({
    Key? key,
    required this.antrian,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 0.5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getStatusColor(antrian.status),
                  ),
                  child: Center(
                    child: Text(
                      antrian.nomorAntrian.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        antrian.nama,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Hewan: ${antrian.namaHewan}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(antrian.status),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Layanan:',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(antrian.namaLayanan),
            const SizedBox(height: 8),
            const Text(
              'Keluhan:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(antrian.keluhan),
            _buildActionButtons(context, antrian),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getStatusText(status),
        style: TextStyle(
          color: _getStatusColor(status),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, AntrianModel antrian) {
    Provider.of<AntrianProvider>(context, listen: false);

    // Different actions based on status
    switch (antrian.status) {
      case 'menunggu':
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: () {
                _showDetailConfirmation(context, antrian);
              },
              child: const Text('Detail antrian'),
            ),
          ],
        );
      case 'diproses':
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: () {
                _showDetailConfirmation(context, antrian);
              },
              child: const Text('Detail antrian'),
            ),
          ],
        );
      case 'selesai':
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: () {
                _showDetailConfirmation(context, antrian);
              },
              child: const Text('Detail Antrian'),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void _showDetailConfirmation(BuildContext context, AntrianModel antrian) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        'Detail Antrian Anda',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        textAlign: TextAlign.center,
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDetailRow('Nomor Antrian', antrian.nomorAntrian.toString()),
            _buildDetailRow('Nama', antrian.nama),
            _buildDetailRow('Hewan', antrian.namaHewan),
            _buildDetailRow('Layanan', antrian.namaLayanan),
            _buildDetailRow('Status', _getStatusText(antrian.status)),
            const SizedBox(height: 8),
            Text('Keluhan:', 
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 4),
            Text(antrian.keluhan),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _getStatusColor(antrian.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _getStatusColor(antrian.status).withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: _getStatusColor(antrian.status)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _getStatusMessage(antrian.status),
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            "Tutup",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary500,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          child: const Text("OK"),
        ),
      ],
      actionsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      buttonPadding: EdgeInsets.zero,
      actionsAlignment: MainAxisAlignment.end,
    ),
  );
}

Widget _buildDetailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            '$label:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    ),
  );
}

String _getStatusMessage(String status) {
  switch (status) {
    case 'menunggu':
      return 'Antrian Anda sedang menunggu. Mohon bersabar, Anda akan dipanggil sesuai urutan.';
    case 'diproses':
      return 'Antrian Anda sedang diproses. Silakan menuju ke ruang pemeriksaan.';
    case 'selesai':
      return 'Antrian Anda telah selesai. Terima kasih telah menggunakan layanan kami.';
    default:
      return 'Status antrian tidak diketahui.';
  }
}

  Color _getStatusColor(String status) {
    switch (status) {
      case 'menunggu':
        return Colors.orange;
      case 'diproses':
        return Colors.blue;
      case 'selesai':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'menunggu':
        return 'Menunggu';
      case 'diproses':
        return 'Diproses';
      case 'selesai':
        return 'Selesai';
      default:
        return status;
    }
  }
}