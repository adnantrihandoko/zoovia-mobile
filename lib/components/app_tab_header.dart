import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:puskeswan_app/components/app_colors.dart';

class AppTabHeader extends StatefulWidget {
  const AppTabHeader({super.key});

  @override
  State<AppTabHeader> createState() => _AppTabHeaderState();
}

class _AppTabHeaderState extends State<AppTabHeader> {
  @override
  Widget build(BuildContext context) {
    return FTabs(
      style: FTabsStyle(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(99), // Mengatur border radius
            color: Colors.white, // Mengatur warna latar belakang tab
            border: Border.all(color: AppColors.neutral200)),
        selectedLabelTextStyle: TextStyle(
          color: Colors.white, // Mengatur warna teks label yang dipilih
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelTextStyle: TextStyle(
          color: Colors.black, // Mengatur warna teks label yang tidak dipilih
        ),
        indicatorDecoration: BoxDecoration(
          color: AppColors.primary500, // Mengatur warna indikator tab
          borderRadius:
              BorderRadius.circular(99), // Mengatur border radius indikator
        ),
        focusedOutlineStyle: FFocusedOutlineStyle(
          color: AppColors.neutral900,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      children: [
        FTabEntry(
          label: const Text('Riwayat'),
          child: FCard(
            title: const Text('Riwayat'),
            subtitle: const Text(
                'Make changes to your account here. Click save when you are done.'),
            child: Column(
              children: [
                const FTextField(
                  label: Text('Name'),
                  hint: 'John Renalo',
                ),
                const SizedBox(height: 10),
                const FTextField(
                  label: Text('Email'),
                  hint: 'john@doe.com',
                ),
                const SizedBox(height: 16),
                FButton(
                  onPress: () {},
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
        FTabEntry(
          label: const Text('Hewanku'),
          child: FCard(
            title: const Text('Password'),
            subtitle: const Text(
                'Change your password here. After saving, you will be logged out.'),
            child: Column(
              children: [
                const FTextField(label: Text('Current password')),
                const SizedBox(height: 10),
                const FTextField(label: Text('New password')),
                const SizedBox(height: 16),
                FButton(
                  onPress: () {},
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
