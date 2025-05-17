import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puskeswan_app/components/app_background_overlay.dart';
import 'package:puskeswan_app/components/app_colors.dart';
import 'package:puskeswan_app/main_screen.dart';
import 'package:puskeswan_app/features/onboarding/inisiasi_app_provider.dart';
import 'package:puskeswan_app/features/profile/presentation/controllers/profile_controller.dart';
import 'package:puskeswan_app/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:puskeswan_app/features/profile/presentation/screens/ganti_password_screen.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    InisiasiAppProvider inisiasiAppProvider =
        Provider.of<InisiasiAppProvider>(context);

    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        // Menangani status loading
        if (profileProvider.isLoading) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()), // Loading indicator
          );
        }

        // Menangani error jika terjadi
        if (profileProvider.error != null) {
          return Scaffold(
            body: Center(child: Text('Error: ${profileProvider.error?.message}')),
          );
        }

        // Jika profil sudah berhasil dimuat
        final profile = profileProvider.profile;

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
                child: Transform.translate(
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
                            image: profile?.photo != null && profile?.photo != ''
                                ? NetworkImage(profile!.photo)
                                : const AssetImage('assets/images/profile_picture.jpg')
                                    as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
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
                                    if (profile != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditProfileScreen(
                                            initialProfile: profile,
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
                                        builder: (context) => const ChangePasswordScreen(),
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
                                    _showLogoutConfirmationDialog(context, profileProvider, inisiasiAppProvider);
                                  },
                                  color: Colors.red,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
      BuildContext context,
      ProfileProvider profileProvider,
      InisiasiAppProvider inisiasiAppProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
          title: const Text('Konfirmasi Logout', style: TextStyle(fontWeight: FontWeight.w500),),
          content: const Text('Apakah Anda yakin ingin keluar dari akun?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal', style: TextStyle(color: Colors.black),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                          if (states.contains(WidgetState.pressed)) {
                            return Colors.red[900]!; // Warna saat ditekan
                          }
                          return Colors.red; // Warna default
                        },
                      ),
                    ),
              child: const Text('Keluar', style: TextStyle(color: Colors.white),),
              onPressed: () async {
                // Perform logout
                await inisiasiAppProvider.logout();
                await profileProvider.logout();
                print('State setelah logout: ${inisiasiAppProvider.state}');
                // Navigate to login screen
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const MainScreen(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
