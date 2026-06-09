import 'package:flutter/material.dart';

import '../../widgets/app_bottom_nav.dart';
import 'home_petani_screen.dart';
import 'riwayat_petani_screen.dart';
import 'profil_petani_screen.dart';

class PetaniMainScreen extends StatefulWidget {
  const PetaniMainScreen({super.key});

  @override
  State<PetaniMainScreen> createState() => _PetaniMainScreenState();
}

class _PetaniMainScreenState extends State<PetaniMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePetaniScreen(),
    RiwayatPetaniScreen(),
    ProfilPetaniScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Riwayat',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
