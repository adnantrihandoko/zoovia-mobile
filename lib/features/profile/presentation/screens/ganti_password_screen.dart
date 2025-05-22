// lib/features/profile/presentation/screens/change_password_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puskeswan_app/components/app_button.dart';
import 'package:puskeswan_app/components/app_colors.dart';
import 'package:puskeswan_app/features/profile/presentation/controllers/profile_controller.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isObscureOldPassword = true;
  bool _isObscureNewPassword = true;
  bool _isObscureConfirmPassword = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _changePassword(ProfileProvider profileProvider) async {
    if (_formKey.currentState!.validate()) {
      final oldPassword = _oldPasswordController.text.trim();
      final newPassword = _newPasswordController.text.trim();
      final confirmPassword = _confirmPasswordController.text.trim();

      // Show loading dialog
      _showLoadingDialog(context);

      // Attempt to change password
      final success = await profileProvider.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      // Close loading dialog
      Navigator.of(context).pop();

      if (success) {
        // Show success dialog
        _showSuccessDialog();
      } else {
        // Show error from provider
        if (profileProvider.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(profileProvider.error!.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(
            color: AppColors.primary500,
          ),
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Berhasil'),
          content: const Text('Password berhasil diubah'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss success dialog
                Navigator.of(context).pop(); // Go back to previous screen
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
        title: const Text('Ubah Password'),
        backgroundColor: AppColors.primary500,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Old Password Field
              TextFormField(
                controller: _oldPasswordController,
                obscureText: _isObscureOldPassword,
                decoration: InputDecoration(
                  labelText: 'Password Lama',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscureOldPassword 
                        ? Icons.visibility_off 
                        : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscureOldPassword = !_isObscureOldPassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan password lama';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // New Password Field
              TextFormField(
                controller: _newPasswordController,
                obscureText: _isObscureNewPassword,
                decoration: InputDecoration(
                  labelText: 'Password Baru',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscureNewPassword 
                        ? Icons.visibility_off 
                        : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscureNewPassword = !_isObscureNewPassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan password baru';
                  }
                  if (value.length < 8) {
                    return 'Password minimal 8 karakter';
                  }
                  // Additional password strength validation
                  bool hasUppercase = value.contains(RegExp(r'[A-Z]'));
                  bool hasLowercase = value.contains(RegExp(r'[a-z]'));
                  bool hasDigits = value.contains(RegExp(r'[0-9]'));
                  bool hasSpecialChar = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

                  if (!(hasUppercase && hasLowercase && hasDigits && hasSpecialChar)) {
                    return 'Password harus mengandung huruf besar, huruf kecil, angka, dan karakter spesial';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Confirm New Password Field
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _isObscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Konfirmasi Password Baru',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscureConfirmPassword 
                        ? Icons.visibility_off 
                        : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscureConfirmPassword = !_isObscureConfirmPassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Konfirmasi password baru';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Password tidak cocok';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Change Password Button
              Consumer<ProfileProvider>(
                builder: (context, profileProvider, _) {
                  return AppButton(
                    onPressed: profileProvider.isLoading
                        ? null
                        : () => _changePassword(profileProvider),
                    text: profileProvider.isLoading 
                        ? 'Mengubah Password...' 
                        : 'Ubah Password',
                  );
                },
              ),

              // Password Strength Guidelines
              const SizedBox(height: 20),
              const Text(
                'Petunjuk Keamanan Password:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary500,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '• Minimal 8 karakter\n'
                '• Mengandung huruf besar dan kecil\n'
                '• Mengandung angka\n'
                '• Mengandung karakter spesial',
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}