import 'package:flutter/material.dart';
import 'package:forui/widgets/avatar.dart';
import 'package:provider/provider.dart';
import 'package:puskeswan_app/features/profile/presentation/controllers/profile_controller.dart';

class AppHeaderWidget extends StatelessWidget {
  final double horizontalPadding;
  final double vertikalPadding;

  const AppHeaderWidget(
      {super.key, this.horizontalPadding = 0, this.vertikalPadding = 0});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        final profile = profileProvider.profile;

        if (profileProvider.isLoading) {
          // Tampilkan loading saat data sedang diambil
          return Container(
            padding: EdgeInsets.symmetric(
                vertical: vertikalPadding, horizontal: horizontalPadding),
            child: const Row(
              children: [
                CircularProgressIndicator(
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Text("Loading...", style: TextStyle(color: Colors.white)),
              ],
            ),
          );
        } else if (profileProvider.error != null) {
          // Tampilkan pesan error jika terjadi kesalahan jaringan
          return Container(
            padding: EdgeInsets.symmetric(
                vertical: vertikalPadding, horizontal: horizontalPadding),
            child: const Row(
              children: [
                Icon(Icons.error, color: Colors.red),
                SizedBox(width: 10),
                Text(
                  'Terjadi kesalahan jaringan',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          );
        } else {
          // Tampilkan data profil jika sudah tersedia
          return Container(
            padding: EdgeInsets.symmetric(
                vertical: vertikalPadding, horizontal: horizontalPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile?.nama != null
                          ? "Halo, ${profile?.nama}"
                          : "Nama Tidak Tersedia", // Jika nama kosong
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Cek kesehatan hewanmu",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                const Spacer(),
                FAvatar(
                  image: profile?.photo != null && profile?.photo != ''
                      ? NetworkImage(profile!.photo)
                      : const AssetImage('assets/images/profile_picture.jpg')
                          as ImageProvider,
                )
              ],
            ),
          );
        }
      },
    );
  }
}
