// lib/features/antrian/presentation/screens/create_antrian_screen.dart
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:provider/provider.dart';
import 'package:puskeswan_app/components/app_button.dart';
import 'package:puskeswan_app/components/app_colors.dart';
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
          _namaController.text,
          _keluhanController.text,
          _selectedLayananId!,
          _selectedHewanId!,
        );

        if (success) {
          // Menampilkan log untuk debugging
          print('✅ Antrian berhasil dibuat, kembali ke layar antrian...');

          // Kembali ke layar antrian dengan hasil true untuk trigger reload
          Navigator.of(context).pop(true);

          // Pesan sukses
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return FDialog(
                title: const Text(
                  'Berhasil',
                  style: TextStyle(color: AppColors.primary500),
                ),
                body: Text('Antrian berhasil dibuat'),
                actions: [
                  AppButton(
                      backgroundColor: AppColors.primary500,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      text: "Oke")
                ],
              );
            },
          );
        } else {
          // Menampilkan error message jika gagal
          throw ValidationFailure(antrianProvider.errorMessage);
        }
      } catch (e) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return FDialog(
                title: const Text(
                  'Gagal membuat antrian!',
                  style: TextStyle(color: Colors.red),
                ),
                body: Text('Terjadi kesalahan: ${e.toString()}'),
                actions: [
                  AppButton(
                      backgroundColor: Colors.red,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      text: "Oke")
                ],
              );
            },
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

  // Perbaikan untuk CreateAntrianScreen
  @override
  Widget build(BuildContext context) {
    final hewanProvider = Provider.of<HewanProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.neutral100,
      appBar: AppBar(
        backgroundColor: AppColors.primary500,
        foregroundColor: Colors.white,
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
                        labelText: 'Nama Pemilik',
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
                    // Hapus Expanded dan gunakan widget langsung
                    DropdownButtonFormField<int>(
                      isExpanded:
                          true, // Pastikan dropdown mengisi width yang tersedia
                      dropdownColor: Colors.white,
                      decoration: const InputDecoration(
                        labelText: 'Pilih Hewan',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedHewanId,
                      items: hewanProvider.hewanList.map((hewan) {
                        return DropdownMenuItem<int>(
                          value: hewan.id,
                          child: Text(
                            '${hewan.namaHewan} (${hewan.jenisHewan})',
                            overflow: TextOverflow.ellipsis,
                          ),
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
                    // Hapus Expanded dan gunakan widget langsung
                    DropdownButtonFormField<int>(
                      isExpanded:
                          true, // Pastikan dropdown mengisi width yang tersedia
                      dropdownColor: Colors.white,
                      decoration: const InputDecoration(
                        labelText: 'Pilih Layanan',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedLayananId,
                      items: _layananProvider.layanan.map((layanan) {
                        return DropdownMenuItem<int>(
                          value: layanan.id,
                          child: Text(
                            '${layanan.namaLayanan} - ${layanan.hargaLayanan}',
                            overflow: TextOverflow.ellipsis,
                          ),
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
                    AppButton(
                      onPressed: _isLoading ? null : _submitAntrian,
                      text: "Buat Antrian",
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
