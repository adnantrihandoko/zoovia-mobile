// widgets/bottom_navigation_widget.dart
import 'package:flutter/material.dart';

class AppBottomNavigationWidget extends StatelessWidget {
  const AppBottomNavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      height: 70,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          NavItem(
            icon: Icons.home,
            label: 'Beranda',
            isActive: true,
          ),
          NavItem(
            icon: Icons.article,
            label: 'Artikel',
          ),
          NavItem(
            icon: Icons.add_box,
            label: 'Antrian',
          ),
          NavItem(
            icon: Icons.history,
            label: 'Riwayat',
          ),
          NavItem(
            icon: Icons.person,
            label: 'Profilku',
          ),
        ],
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isActive ? const Color(0xFF4E0CA2) : Colors.grey,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? const Color(0xFF4E0CA2) : Colors.grey,
          ),
        ),
      ],
    );
  }
}