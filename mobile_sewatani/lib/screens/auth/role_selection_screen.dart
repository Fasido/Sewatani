import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../petani/petani_main_screen.dart';
import '../vendor/vendor_main_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  Future<void> _openPetani(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.loginAsPetani();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const PetaniMainScreen()),
      (route) => false,
    );
  }

  Future<void> _openVendor(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.loginAsVendor();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const VendorMainScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Role')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Masuk sebagai siapa?',
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Role akan disimpan di SharedPreferences supaya aplikasi bisa langsung membuka halaman sesuai role saat dibuka kembali.',
                style: TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 26),
              _RoleCard(
                icon: Icons.person_outline,
                title: 'Petani / Penyewa',
                description: 'Cari alat pertanian, lihat detail harga, dan buat booking sewa alat.',
                buttonText: 'Masuk sebagai Petani',
                isLoading: isLoading,
                onTap: () => _openPetani(context),
              ),
              const SizedBox(height: 16),
              _RoleCard(
                icon: Icons.storefront_outlined,
                title: 'Vendor / Pemilik Alat',
                description: 'Kelola data alat pertanian dan pantau pesanan dari petani.',
                buttonText: 'Masuk sebagai Vendor',
                isLoading: isLoading,
                onTap: () => _openVendor(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String buttonText;
  final bool isLoading;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: AppColors.primary, size: 30),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 19,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              description,
              style: const TextStyle(color: AppColors.textGrey, height: 1.45),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : onTap,
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.2,
                        ),
                      )
                    : Text(buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
