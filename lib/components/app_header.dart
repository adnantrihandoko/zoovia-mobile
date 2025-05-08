import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:puskeswan_app/features/profile/presentation/controllers/profile_controller.dart';

class AppHeaderWidget extends StatelessWidget {
  final double horizontalPadding;
  final double vertikalPadding;
  const AppHeaderWidget(
      {super.key, this.horizontalPadding = 0, this.vertikalPadding = 0});

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final profile = profileProvider.profile;
    return profileProvider.isLoading ? Container(
            padding: EdgeInsets.symmetric(
                vertical: vertikalPadding, horizontal: horizontalPadding),
            child: const Row(
              children: [
                CircularProgressIndicator(), // Tampilkan loading saat data sedang diambil
                SizedBox(width: 10),
                Text("Loading..."),
              ],
            ),
          ) : profileProvider.error != null ? Container(
            padding: EdgeInsets.symmetric(
                vertical: vertikalPadding, horizontal: horizontalPadding),
            child: Row(
              children: [
                Icon(Icons.error, color: Colors.red),
                SizedBox(width: 10),
                Text(
                    'Error: ${profileProvider.error?.message ?? 'Unknown error'}'),
              ],
            ),
          ) : Container(
          padding: EdgeInsets.symmetric(
              vertical: vertikalPadding, horizontal: horizontalPadding),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile?.name != null
                        ? "Halo, ${profile?.name}"
                        : "Nama Tidak Tersedia", // Jika nama kosong
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Cek kesehatan hewanmu",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              Spacer(),
              Text("HALO GAES")
            ],
          ),
        );
      
  }
}
