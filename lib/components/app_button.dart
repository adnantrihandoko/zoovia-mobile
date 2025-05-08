import 'package:flutter/material.dart';
import 'package:puskeswan_app/components/app_colors.dart';

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final double borderRadius;
  final Color outlineBorderColor;
  final Color? backgroundColor;
  final Color? textColor;
  final Widget? iconButton;
  final IconData? icon;
  final double width;
  final double height;
  final double elevation;
  final Color shadowColor;

  const AppButton({
    super.key,
    this.width = double.infinity,
    this.height = 50,
    this.borderRadius = 999,
    this.outlineBorderColor = Colors.transparent,
    required this.onPressed,
    required this.text,
    this.backgroundColor = AppColors.primary500,
    this.textColor = Colors.white,
    this.iconButton,
    this.icon,
    this.elevation = 0,
    this.shadowColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      style: TextButton.styleFrom(
          shadowColor: Colors.black,
          elevation: elevation,
          minimumSize: Size(width, height),
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: outlineBorderColor,
                  strokeAlign: BorderSide.strokeAlignOutside),
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)))),
      onPressed: onPressed,
      icon: iconButton,
      label: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
