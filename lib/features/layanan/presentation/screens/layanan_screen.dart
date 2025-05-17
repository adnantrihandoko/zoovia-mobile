// lib/features/layanan/presentation/screens/layanan_screen.dart
import 'package:flutter/material.dart';
import 'package:puskeswan_app/components/app_colors.dart';
import 'package:puskeswan_app/components/app_layanan_list.dart';

class LayananScreen extends StatefulWidget {
  const LayananScreen({Key? key}) : super(key: key);

  @override
  _LayananScreenState createState() => _LayananScreenState();
}

class _LayananScreenState extends State<LayananScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral100,
      appBar: AppBar(
        title: const Text('Layanan'),
        backgroundColor: AppColors.primary500,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: const AppLayananList(),
    );
  }
}