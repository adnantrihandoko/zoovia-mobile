// lib/features/hewanku/presentation/screens/tambah_hewan_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:puskeswan_app/components/app_button.dart';
import 'package:puskeswan_app/components/app_colors.dart';
import 'package:puskeswan_app/components/app_loading_overlay.dart';
import 'package:puskeswan_app/components/app_snackbar.dart';
import 'package:puskeswan_app/features/hewanku/presentation/controller/hewanku_controller.dart';

class TambahHewanScreen extends StatefulWidget {

  const TambahHewanScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<TambahHewanScreen> createState() => _TambahHewanScreenState();
}

class _TambahHewanScreenState extends State<TambahHewanScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final _namaController = TextEditingController();
  final _jenisController = TextEditingController();
  final _rasController = TextEditingController();
  final _umurController = TextEditingController();
  
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void dispose() {
    _namaController.dispose();
    _jenisController.dispose();
    _rasController.dispose();
    _umurController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 800,
    );
    
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveHewan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    
    try {
      final provider = Provider.of<HewanProvider>(context, listen: false);
      
      final success = await provider.addHewan(
        namaHewan: _namaController.text,
        jenisHewan: _jenisController.text,
        ras: _rasController.text.isEmpty ? 'Tidak Ada' : _rasController.text,
        umur: int.parse(_umurController.text),
        fotoHewan: _imageFile,
      );
      
      if (success && mounted) {
        Navigator.pop(context); // Kembali ke layar daftar
        AppSnackbar.showSuccess(context, 'Hewan berhasil ditambahkan');
      } else if (mounted) {
        AppSnackbar.showError(context, 'Gagal menambahkan hewan');
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(context, 'Terjadi kesalahan: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        backgroundColor: AppColors.neutral100,
        appBar: AppBar(
          backgroundColor: AppColors.primary500,
          foregroundColor: Colors.white,
          title: const Text('Tambah Hewan'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Foto hewan
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: _imageFile != null 
                            ? FileImage(_imageFile!) as ImageProvider
                            : const AssetImage('assets/images/pet_placeholder.png'),
                        child: _imageFile == null
                            ? const Icon(Icons.pets, size: 60)
                            : null,
                      ),
                      CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, color: Colors.white),
                          onPressed: _pickImage,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Form fields
                TextFormField(
                  controller: _namaController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Hewan *',
                    border: OutlineInputBorder(),
                    hintText: 'Masukkan nama hewan',
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama hewan tidak boleh kosong';
                    }
                    if (value.length > 15) {
                      return 'Nama hewan maksimal 15 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _jenisController,
                  decoration: const InputDecoration(
                    labelText: 'Jenis Hewan *',
                    border: OutlineInputBorder(),
                    hintText: 'Contoh: Kucing, Anjing, Kelinci',
                  ),
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Jenis hewan tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _rasController,
                  decoration: const InputDecoration(
                    labelText: 'Ras',
                    border: OutlineInputBorder(),
                    hintText: 'Opsional, contoh: Persia, Pomeranian',
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _umurController,
                  decoration: const InputDecoration(
                    labelText: 'Umur (dalam bulan) *',
                    border: OutlineInputBorder(),
                    hintText: 'Masukkan umur hewan dalam bulan',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Umur hewan tidak boleh kosong';
                    }
                    final umur = int.tryParse(value);
                    if (umur == null) {
                      return 'Umur harus berupa angka';
                    }
                    if (umur < 0) {
                      return 'Umur tidak boleh negatif';
                    }
                    if (umur > 240) {  // 20 tahun dalam bulan
                      return 'Umur tidak valid (maksimal 240 bulan)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                
                Text(
                  'Catatan: Umur diisi dalam satuan bulan. Contoh: 6 bulan, 12 bulan, 24 bulan, dll.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                
                const SizedBox(height: 32),
                
                // Tombol submit
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    onPressed: _saveHewan,
                    text: "Simpan",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}