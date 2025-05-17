// lib/features/profile/presentation/screens/edit_profile_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puskeswan_app/components/app_button.dart';
import 'package:puskeswan_app/components/app_colors.dart';
import 'package:puskeswan_app/features/profile/domain/entities/profile_entity.dart';
import 'package:puskeswan_app/features/profile/presentation/controllers/profile_controller.dart';
import 'package:puskeswan_app/features/profile/presentation/utils/image_picker_helper.dart';

class EditProfileScreen extends StatefulWidget {
  final ProfileEntity initialProfile;

  const EditProfileScreen({super.key, required this.initialProfile});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  final _formKey = GlobalKey<FormState>();
  File? _selectedImageFile;
  String? _currentProfileImageUrl;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialProfile.nama);
    _emailController = TextEditingController(text: widget.initialProfile.email);
    _phoneController =
        TextEditingController(text: widget.initialProfile.no_hp);
    _currentProfileImageUrl = widget.initialProfile.photo;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _pickImage(ProfileProvider profileProvider) async {
    final pickedFile = await ImagePickerHelper.pickImage(context);

    if (pickedFile != null) {
      setState(() {
        _selectedImageFile = pickedFile;
      });

      // Upload image
      await profileProvider.updateProfileImage(pickedFile.path);
    }
  }

  void _saveProfile(ProfileProvider profileProvider) {
    print(
        "Di edit profil save profile, user id profile nya: ${profileProvider.profile!.userId}");
    if (_formKey.currentState!.validate()) {
      final updatedProfile = ProfileEntity(
        id: profileProvider.profile!.userId,
        userId: profileProvider.profile!.userId,
        nama: _nameController.text.trim(),
        email: _emailController.text.trim(),
        no_hp: _phoneController.text.trim(),
        photo: _currentProfileImageUrl ?? '',
      );

      profileProvider.updateProfile(updatedProfile).then((_) {
        if (profileProvider.error == null) {
          // Show success dialog
          _showSuccessDialog();
        } else {
          // Show error snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(profileProvider.error!.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Berhasil'),
          content: const Text('Profil berhasil diperbarui'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral100,
      appBar: AppBar(
        title: const Text('Edit Profil'),
        backgroundColor: AppColors.primary500,
        foregroundColor: Colors.white,
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Image Upload
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary500,
                              width: 4,
                            ),
                            image: DecorationImage(
                              image:
                                  _selectedImageFile != null
                                      ? FileImage(_selectedImageFile!)
                                      : (_currentProfileImageUrl != null
                                              ? NetworkImage(
                                                  _currentProfileImageUrl!)
                                              : const AssetImage(
                                                  'assets/profile_picture.png'))
                                          as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: AppColors.primary500,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt,
                                  color: Colors.white),
                              onPressed: () => _pickImage(profileProvider),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Existing form fields remain the same...
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nama',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nama tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email tidak boleh kosong';
                      }
                      // Basic email validation
                      final emailRegex =
                          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(value)) {
                        return 'Format email tidak valid';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Nomor Telepon',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        // Basic phone number validation
                        final phoneRegex = RegExp(r'^[0-9]{10,13}$');
                        if (!phoneRegex.hasMatch(value)) {
                          return 'Nomor telepon tidak valid';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  // Save Button
                  AppButton(
                    onPressed: profileProvider.isLoading
                        ? null
                        : () => _saveProfile(profileProvider),
                    text: profileProvider.isLoading
                        ? 'Menyimpan...'
                        : 'Simpan Perubahan',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
