// lib/features/antrian/presentation/widgets/antrian_card.dart
import 'package:flutter/material.dart';
import 'package:forui/widgets/dialog.dart';
import 'package:provider/provider.dart';
import 'package:puskeswan_app/components/app_button.dart';
import 'package:puskeswan_app/features/antrian/data/antrian_model.dart';
import 'package:puskeswan_app/features/antrian/presentation/controller/antrian_controller.dart';

class AppAntrianCard extends StatelessWidget {
  final AntrianModel antrian;
  final int position;

  const AppAntrianCard({
    Key? key,
    required this.antrian,
    required this.position,
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
                      position.toString(),
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
    final provider = Provider.of<AntrianProvider>(context, listen: false);

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
      builder: (context) => FDialog(
        title: const Text('Detail Antrian Anda'),
        body: const Text('Antrian anda: 1'),
        actions: [
          AppButton(
            onPressed: () => Navigator.of(context).pop(),
            text: "Ok",
          ),
        ],
      ),
    );
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