import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';

class ProfilVendorScreen extends StatelessWidget {
  const ProfilVendorScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    await context.read<AuthProvider>().logout();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil Vendor')),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.primarySoft,
              child: Icon(Icons.storefront, color: AppColors.primary, size: 54),
            ),
            const SizedBox(height: 16),
            Text(
              user?.name ?? 'Vendor SewaTani',
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user?.roleLabel ?? 'Vendor / Pemilik Alat',
              style: const TextStyle(color: AppColors.textGrey),
            ),
            const SizedBox(height: 22),
            _ProfileTile(icon: Icons.email_outlined, label: 'Email', value: user?.email ?? '-'),
            const SizedBox(height: 10),
            const _ProfileTile(icon: Icons.location_on_outlined, label: 'Area Layanan', value: 'Indramayu'),
            const SizedBox(height: 10),
            const _ProfileTile(
              icon: Icons.verified_user_outlined,
              label: 'Sesi Login',
              value: 'Tersimpan di SharedPreferences',
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: authProvider.isLoading ? null : () => _logout(context),
                icon: const Icon(Icons.logout),
                label: Text(authProvider.isLoading ? 'Keluar...' : 'Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
        subtitle: Text(value),
      ),
    );
  }
}
