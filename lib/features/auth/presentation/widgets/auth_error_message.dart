import 'package:flutter/material.dart';

class AuthErrorMessage extends StatelessWidget {
  final String message;
  
  const AuthErrorMessage({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        message,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}