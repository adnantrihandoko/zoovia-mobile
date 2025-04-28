import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puskeswan_app/components/app_background_overlay.dart';
import 'package:puskeswan_app/components/app_colors.dart';
import 'package:puskeswan_app/features/auth/presentation/screens/login_screen.dart';
import 'package:puskeswan_app/features/profile/presentation/controllers/profile_controller.dart';
import 'package:puskeswan_app/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:puskeswan_app/features/profile/presentation/screens/ganti_password_screen.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          const AppBackgroundOverlay(),
          Container(
            decoration: const BoxDecoration(
                color: AppColors.neutral100,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            margin: const EdgeInsets.only(top: 150),
            child: Consumer<ProfileProvider>(
                builder: (context, profileProvider, _) {
              return Transform.translate(
                  offset: const Offset(0, -60),
                  child: Column(
                    children: [
                      Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.neutral100,
                              width: 4,
                            ),
                            image: DecorationImage(
                              image: profileProvider.profile?.profileImageUrl !=
                                      null
                                  ? NetworkImage(
                                      profileProvider.profile!.profileImageUrl!)
                                  : const AssetImage(
                                          'assets/profile_picture.png')
                                      as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          )),
                      Consumer<ProfileProvider>(
                          builder: (context, profileProvider, _) {
                        return Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Pengaturan Akun',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary800,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _buildProfileMenuItem(
                                    icon: Icons.person_outline,
                                    title: 'Edit Profil',
                                    onTap: () {
                                      if (profileProvider.profile != null) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditProfileScreen(
                                              initialProfile:
                                                  profileProvider.profile!,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  _buildProfileMenuItem(
                                    icon: Icons.lock_outline,
                                    title: 'Ubah Password',
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const ChangePasswordScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                  _buildProfileMenuItem(
                                    icon: Icons.medical_services_outlined,
                                    title: 'Riwayat Hewan',
                                    onTap: () {
                                      // TODO: Implement pet history navigation
                                    },
                                  ),
                                  const SizedBox(height: 24),
                                  const Text(
                                    'Lainnya',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary800,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _buildProfileMenuItem(
                                    icon: Icons.help_outline,
                                    title: 'Pusat Bantuan',
                                    onTap: () {
                                      // TODO: Implement help center navigation
                                    },
                                  ),
                                  _buildProfileMenuItem(
                                    icon: Icons.privacy_tip_outlined,
                                    title: 'Kebijakan Privasi',
                                    onTap: () {
                                      // TODO: Implement privacy policy navigation
                                    },
                                  ),
                                  _buildProfileMenuItem(
                                    icon: Icons.logout,
                                    title: 'Keluar',
                                    onTap: () {
                                      _showLogoutConfirmationDialog(
                                          context, profileProvider);
                                    },
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      })
                    ],
                  ));
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        color: color ?? AppColors.primary500,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? Colors.black87,
          fontSize: 16,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.neutral600,
      ),
      onTap: onTap,
    );
  }

  void _showLogoutConfirmationDialog(
      BuildContext context, ProfileProvider profileProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin keluar dari akun?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Keluar'),
              onPressed: () {
                // Perform logout
                profileProvider.logout();

                // Navigate to login screen
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
