// lib/features/antrian/presentation/screens/create_antrian_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puskeswan_app/features/antrian/presentation/controller/antrian_controller.dart';
import 'package:puskeswan_app/features/hewanku/presentation/controller/hewanku_controller.dart';
import 'package:puskeswan_app/core/errors/failures.dart';
import 'package:puskeswan_app/features/layanan/presentation/controllers/layanan_controller.dart';

class CreateAntrianScreen extends StatefulWidget {
  const CreateAntrianScreen({super.key});

  @override
  _CreateAntrianScreenState createState() => _CreateAntrianScreenState();
}

class _CreateAntrianScreenState extends State<CreateAntrianScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _keluhanController = TextEditingController();
  late HewanProvider _hewanProvider;
  late LayananProvider _layananProvider;

  int? _selectedHewanId;
  int? _selectedLayananId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _namaController.dispose();
    _keluhanController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load data hewan milik user
      if (mounted) {
        _hewanProvider = Provider.of<HewanProvider>(context, listen: false);
        _layananProvider = Provider.of<LayananProvider>(context, listen: false);
        await _hewanProvider.getHewanByUserId();
        await _layananProvider.loadLayanan();
      }

      // Load data layanan
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: ${e.toString()}')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _submitAntrian() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final antrianProvider =
            Provider.of<AntrianProvider>(context, listen: false);

        // Buat antrian baru menggunakan provider
        final success = await antrianProvider.createAntrian(
          nama: _namaController.text,
          keluhan: _keluhanController.text,
          idLayanan: _selectedLayananId!,
          idHewan: _selectedHewanId!,
        );

        if (success) {
          // Menampilkan log untuk debugging
          print('✅ Antrian berhasil dibuat, kembali ke layar antrian...');

          // Kembali ke layar antrian dengan hasil true untuk trigger reload
          Navigator.of(context).pop(true);

          // Pesan sukses
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Antrian berhasil dibuat')),
          );
        } else {
          // Menampilkan error message jika gagal
          throw BusinessException(antrianProvider.errorMessage);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error membuat antrian: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hewanProvider = Provider.of<HewanProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Antrian Baru'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Nama field
                    TextFormField(
                      controller: _namaController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Pasien',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Dropdown Hewan
                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: 'Pilih Hewan',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedHewanId,
                      items: hewanProvider.hewanList.map((hewan) {
                        return DropdownMenuItem<int>(
                          value: hewan.id,
                          child:
                              Text('${hewan.namaHewan} (${hewan.jenisHewan})'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedHewanId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Pilih hewan terlebih dahulu';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Dropdown Layanan
                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: 'Pilih Layanan',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedLayananId,
                      items: _layananProvider.layanan.map((layanan) {
                        return DropdownMenuItem<int>(
                          value: layanan.id,
                          child: Text(
                              '${layanan.namaLayanan} - ${layanan.hargaLayanan}'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedLayananId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Pilih layanan terlebih dahulu';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Keluhan field
                    TextFormField(
                      controller: _keluhanController,
                      decoration: const InputDecoration(
                        labelText: 'Keluhan',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Keluhan tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Submit button
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submitAntrian,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Buat Antrian',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
