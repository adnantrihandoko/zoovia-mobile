import 'package:flutter/material.dart';

class AuthHeaderSection extends StatelessWidget {
  
  const AuthHeaderSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 60.0, horizontal: 40.0),
        child: Text(
          "Selamat datang Silahkan Masuk",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.start,
        ),
      ),
    );
  }
}