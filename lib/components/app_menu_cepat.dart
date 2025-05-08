// widgets/quick_menu_widget.dart
import 'package:flutter/material.dart';
import 'package:puskeswan_app/components/app_colors.dart';

class AppMenuCepatWidget extends StatelessWidget {
  const AppMenuCepatWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        const Text(
          'Menu Cepat',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              style: ButtonStyle(
                shape: WidgetStateProperty.all<OutlinedBorder>(
                    const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                overlayColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.hovered)) {
                      return Colors.grey.withOpacity(0.04);
                    }
                    if (states.contains(WidgetState.focused) ||
                        states.contains(WidgetState.pressed)) {
                      return Colors.grey.withOpacity(0.12);
                    }
                    return null; // Defer to the widget's default.
                  },
                ),
              ),
              onPressed: () => print("Tes1"),
              child: const MenuButton(
                icon: Icons.event_note,
                label: 'Lihat Antrian',
              ),
            ),
            TextButton(
              style: ButtonStyle(
                shape: WidgetStateProperty.all<OutlinedBorder>(
                    const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                overlayColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.hovered)) {
                      return Colors.grey.withOpacity(0.04);
                    }
                    if (states.contains(WidgetState.focused) ||
                        states.contains(WidgetState.pressed)) {
                      return Colors.grey.withOpacity(0.12);
                    }
                    return null; // Defer to the widget's default.
                  },
                ),
              ),
              onPressed: () => {print("Tes2")},
              child: const MenuButton(
                icon: Icons.cleaning_services,
                label: 'Lihat Layanan',
              ),
            ),
            TextButton(
              style: ButtonStyle(
                shape: WidgetStateProperty.all<OutlinedBorder>(
                    const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                overlayColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.hovered)) {
                      return Colors.grey.withOpacity(0.04);
                    }
                    if (states.contains(WidgetState.focused) ||
                        states.contains(WidgetState.pressed)) {
                      return Colors.grey.withOpacity(0.12);
                    }
                    return null; // Defer to the widget's default.
                  },
                ),
              ),
              onPressed: () => print("tes3"),
              child: const MenuButton(
                icon: Icons.medical_services,
                label: 'Lihat Dokter',
              ),
            ),
            TextButton(
              style: ButtonStyle(
                shape: WidgetStateProperty.all<OutlinedBorder>(
                    const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                overlayColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.hovered)) {
                      return Colors.grey.withOpacity(0.04);
                    }
                    if (states.contains(WidgetState.focused) ||
                        states.contains(WidgetState.pressed)) {
                      return Colors.grey.withOpacity(0.12);
                    }
                    return null; // Defer to the widget's default.
                  },
                ),
              ),
              onPressed: () => print("Tes4"),
              child: const MenuButton(
                icon: Icons.article,
                label: 'Lihat Artikel',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const MenuButton({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: AppColors.primary500,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 60,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
