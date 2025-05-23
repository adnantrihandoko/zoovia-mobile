import 'package:flutter/material.dart';

class AuthLogoSection extends StatelessWidget {
  final String imagePath;
  
  const AuthLogoSection({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Align(
        alignment: Alignment.center,
        child: Image.asset(imagePath, fit: BoxFit.cover),
      ),
    );
  }
}