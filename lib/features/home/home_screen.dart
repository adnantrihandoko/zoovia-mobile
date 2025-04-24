// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:puskeswan_app/components/app_bottom_navigation.dart';
import 'package:puskeswan_app/components/app_header.dart';
import 'package:puskeswan_app/components/app_menu_cepat.dart';
import 'package:puskeswan_app/components/app_pmk.dart';
import 'package:puskeswan_app/components/card_antrian.dart';

class HomeScreen extends StatefulWidget {
  final String email;
  const HomeScreen({super.key, required this.email});


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header section with purple background
          AppHeaderWidget(
            name: widget.email,
            actionText: 'Cek kesehatan hewanmu',
          ),
          
          // Main content with light background
          Expanded(
            child: Container(
              color: const Color(0xFFF5F5F5),
              child: const SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Quick menu section
                      const AppMenuCepatWidget(),
                      const SizedBox(height: 24),
                      
                      // Appointment summary section
                      const CardAntrianWidget(),
                      const SizedBox(height: 24),
                      
                      // Service flow section
                      const AlurPmkWidget(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavigationWidget(),
    );
  }
}