import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import 'home_petani_screen.dart';
import 'profil_petani_screen.dart';
import 'riwayat_petani_screen.dart';

class PetaniMainScreen extends StatefulWidget {
  const PetaniMainScreen({super.key});

  @override
  State<PetaniMainScreen> createState() => _PetaniMainScreenState();
}

class _PetaniMainScreenState extends State<PetaniMainScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = const [
    HomePetaniScreen(),
    RiwayatPetaniScreen(),
    ProfilPetaniScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textGrey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w900),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_rounded), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profil'),
        ],
      ),
    );
  }
}
