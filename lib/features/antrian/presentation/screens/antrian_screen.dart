// lib/features/antrian/presentation/screens/antrian_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puskeswan_app/features/antrian/data/antrian_model.dart';
import 'package:puskeswan_app/features/antrian/presentation/controller/antrian_controller.dart';
import 'package:puskeswan_app/features/antrian/presentation/screens/create_antrian_screen.dart';

class AntrianScreen extends StatefulWidget {
  const AntrianScreen({Key? key}) : super(key: key);

  @override
  State<AntrianScreen> createState() => _AntrianScreenState();
}

class _AntrianScreenState extends State<AntrianScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeRealTimeData();
  }

  Future<void> _initializeRealTimeData() async {
    final provider = Provider.of<AntrianProvider>(context, listen: false);

    try {
      setState(() {
        _isInitializing = true;
      });

      // Initialize Pusher WebSocket connection
      await provider.initialize(apiKey: "e5c82108dec6c8942c45", cluster: "ap1");

      // Load initial data
      await provider.loadAntriansByUser();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error initializing: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isInitializing = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Antrian'),
        actions: [
          // Show WebSocket connection status
          Consumer<AntrianProvider>(
            builder: (context, provider, _) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Icon(
                      provider.isConnected ? Icons.wifi : Icons.wifi_off,
                      color: provider.isConnected ? Colors.green : Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      provider.isConnected ? 'Online' : 'Offline',
                      style: TextStyle(
                        fontSize: 12,
                        color: provider.isConnected ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Menunggu'),
            Tab(text: 'Diproses'),
            Tab(text: 'Selesai'),
          ],
        ),
      ),
      body: _isInitializing
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: const [
                // Tab for antrian with "menunggu" status
                AntrianListByStatus(status: 'menunggu'),
                // Tab for antrian with "diproses" status
                AntrianListByStatus(status: 'diproses'),
                // Tab for antrian with "selesai" status
                AntrianListByStatus(status: 'selesai'),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create antrian screen (not in this example)
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => CreateAntrianScreen()));
        },
        child: const Icon(Icons.add),
        tooltip: 'Tambah Antrian',
      ),
    );
  }
}

class AntrianListByStatus extends StatelessWidget {
  final String status;

  const AntrianListByStatus({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AntrianProvider>(
      builder: (context, provider, _) {
        // Show loading indicator
        if (provider.status == AntrianStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Show error message
        if (provider.status == AntrianStatus.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 16),
                Text(
                  provider.errorMessage,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => provider.loadAntriansByUser(status: status),
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }

        // Filter items by status
        final filteredItems =
            provider.antrians.where((item) => item.status == status).toList();

        // Show empty state
        if (filteredItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.queue, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Tidak ada antrian ${_getStatusText(status)}',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        // Show the list of items
        return RefreshIndicator(
          onRefresh: () => provider.loadAntriansByUser(status: status),
          child: ListView.builder(
            itemCount: filteredItems.length,
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final antrian = filteredItems[index];
              return AntrianCard(
                antrian: antrian,
                position: index + 1,
              );
            },
          ),
        );
      },
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'menunggu':
        return 'yang menunggu';
      case 'diproses':
        return 'yang sedang diproses';
      case 'selesai':
        return 'yang sudah selesai';
      default:
        return status;
    }
  }
}

class AntrianCard extends StatelessWidget {
  final AntrianModel antrian;
  final int position;

  const AntrianCard({
    Key? key,
    required this.antrian,
    required this.position,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 2,
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
              'Layanan: ${antrian.namaLayanan}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            const Text(
              'Keluhan:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(antrian.keluhan),
            const SizedBox(height: 12),
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
                provider.updateAntrianStatus(
                  id: antrian.id,
                  status: 'diproses',
                );
              },
              child: const Text('Proses'),
            ),
          ],
        );
      case 'diproses':
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: () {
                provider.updateAntrianStatus(
                  id: antrian.id,
                  status: 'selesai',
                );
              },
              child: const Text('Selesai'),
            ),
          ],
        );
      case 'selesai':
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: () {
                _showDeleteConfirmation(context, antrian);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void _showDeleteConfirmation(BuildContext context, AntrianModel antrian) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Antrian'),
        content: const Text('Anda yakin ingin menghapus antrian ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Provider.of<AntrianProvider>(context, listen: false)
                  .deleteAntrian(antrian.id);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Hapus'),
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
