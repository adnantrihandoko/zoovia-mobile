// lib/features/hewanku/presentation/screens/detail_hewan_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:puskeswan_app/components/app_loading_overlay.dart';
import 'package:puskeswan_app/components/app_snackbar.dart';
import 'package:puskeswan_app/features/hewanku/data/hewan_model.dart';
import 'package:puskeswan_app/features/hewanku/presentation/controller/hewanku_controller.dart';

class DetailHewanScreen extends StatefulWidget {
  final int hewanId;

  const DetailHewanScreen({
    Key? key,
    required this.hewanId,
  }) : super(key: key);

  @override
  State<DetailHewanScreen> createState() => _DetailHewanScreenState();
}

class _DetailHewanScreenState extends State<DetailHewanScreen> {
  late Hewan _hewan;
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();
  
  // Controller untuk field form
  late TextEditingController _namaController;
  late TextEditingController _jenisController;
  late TextEditingController _rasController;
  late TextEditingController _umurController;
  
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data hewan yang dipilih
    final provider = Provider.of<HewanProvider>(context, listen: false);
    _hewan = provider.hewanList.firstWhere((h) => h.id == widget.hewanId);
    
    _namaController = TextEditingController(text: _hewan.namaHewan);
    _jenisController = TextEditingController(text: _hewan.jenisHewan);
    _rasController = TextEditingController(text: _hewan.ras ?? '');
    _umurController = TextEditingController(text: _hewan.umur.toString());
  }

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

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    
    try {
      final provider = Provider.of<HewanProvider>(context, listen: false);
      
      final success = await provider.updateHewan(
        id: _hewan.id,
        namaHewan: _namaController.text,
        jenisHewan: _jenisController.text,
        ras: _rasController.text,
        umur: int.parse(_umurController.text),
        fotoHewan: _imageFile,
      );
      
      if (success && mounted) {
        setState(() => _isEditing = false);
        AppSnackbar.showSuccess(context, 'Data hewan berhasil diperbarui');
      } else if (mounted) {
        AppSnackbar.showError(context, 'Gagal memperbarui data hewan');
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

  Future<void> _deleteHewan() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: const Text('Apakah Anda yakin ingin menghapus hewan ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    
    if (confirm != true) return;
    
    setState(() => _isLoading = true);
    
    try {
      final provider = Provider.of<HewanProvider>(context, listen: false);
      final success = await provider.deleteHewan(_hewan.id);
      
      if (success && mounted) {
        Navigator.pop(context); // Kembali ke layar daftar
        AppSnackbar.showSuccess(context, 'Hewan berhasil dihapus');
      } else if (mounted) {
        AppSnackbar.showError(context, 'Gagal menghapus hewan');
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
        appBar: AppBar(
          title: Text(_isEditing ? 'Edit Hewan' : 'Detail Hewan'),
          actions: [
            if (!_isEditing) 
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => setState(() => _isEditing = true),
              ),
            if (!_isEditing) 
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: _deleteHewan,
              ),
          ],
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
                            : (_hewan.fotoHewan != null
                                ? NetworkImage(_hewan.fotoHewan!) as ImageProvider
                                : const AssetImage('assets/images/pet_placeholder.png')),
                        child: _hewan.fotoHewan == null && _imageFile == null
                            ? const Icon(Icons.pets, size: 60)
                            : null,
                      ),
                      if (_isEditing)
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
                    labelText: 'Nama Hewan',
                    border: OutlineInputBorder(),
                  ),
                  enabled: _isEditing,
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
                    labelText: 'Jenis Hewan',
                    border: OutlineInputBorder(),
                  ),
                  enabled: _isEditing,
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
                    hintText: 'Opsional',
                  ),
                  enabled: _isEditing,
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _umurController,
                  decoration: const InputDecoration(
                    labelText: 'Umur (bulan)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  enabled: _isEditing,
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
                const SizedBox(height: 24),
                
                // Tombol aksi
                if (_isEditing)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: () => setState(() => _isEditing = false),
                        child: const Text('Batal'),
                      ),
                      ElevatedButton(
                        onPressed: _saveChanges,
                        child: const Text('Simpan'),
                      ),
                    ],
                  ),
                
                // Informasi tambahan
                if (!_isEditing) ...[
                  const Divider(height: 32),
                  Text(
                    'Terdaftar pada: ${_formatDate(_hewan.createdAt)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (_hewan.updatedAt != _hewan.createdAt)
                    Text(
                      'Diperbarui pada: ${_formatDate(_hewan.updatedAt)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return '${date.day}/${date.month}/${date.year}';
  }
}