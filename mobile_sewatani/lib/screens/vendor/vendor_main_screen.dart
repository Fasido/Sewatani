import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import 'dashboard_vendor_screen.dart';
import 'kelola_alat_screen.dart';
import 'pesanan_vendor_screen.dart';
import 'profil_vendor_screen.dart';

class VendorMainScreen extends StatefulWidget {
  const VendorMainScreen({super.key});

  @override
  State<VendorMainScreen> createState() => _VendorMainScreenState();
}

class _VendorMainScreenState extends State<VendorMainScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = const [
    DashboardVendorScreen(),
    PesananVendorScreen(),
    KelolaAlatScreen(),
    ProfilVendorScreen(),
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
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.inbox_rounded), label: 'Pesanan'),
          BottomNavigationBarItem(icon: Icon(Icons.agriculture_rounded), label: 'Alat'),
          BottomNavigationBarItem(icon: Icon(Icons.storefront_rounded), label: 'Profil'),
        ],
      ),
    );
  }
}
