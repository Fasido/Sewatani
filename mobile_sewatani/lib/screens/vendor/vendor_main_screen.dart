import 'package:flutter/material.dart';

import '../../widgets/app_bottom_nav.dart';
import 'dashboard_vendor_screen.dart';
import 'kelola_alat_screen.dart';
import 'pesanan_vendor_screen.dart';

class VendorMainScreen extends StatefulWidget {
  const VendorMainScreen({super.key});

  @override
  State<VendorMainScreen> createState() => _VendorMainScreenState();
}

class _VendorMainScreenState extends State<VendorMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DashboardVendorScreen(),
    KelolaAlatScreen(),
    PesananVendorScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.agriculture),
            selectedIcon: Icon(Icons.agriculture),
            label: 'Alat',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: 'Pesanan',
          ),
        ],
      ),
    );
  }
}
