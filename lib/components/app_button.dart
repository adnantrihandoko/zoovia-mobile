import 'package:flutter/material.dart';
import 'package:puskeswan_app/components/app_colors.dart';

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final Widget? iconButton;

  const AppButton({super.key, 
    required this.onPressed,
    required this.text,
    this.backgroundColor = AppColors.primary500,
    this.textColor = Colors.white,
    this.iconButton,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: backgroundColor,
          foregroundColor: textColor),
      onPressed: onPressed,
      icon: iconButton,
      label: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
