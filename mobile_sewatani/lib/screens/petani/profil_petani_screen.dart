import 'package:flutter/material.dart';

import '../../config/app_colors.dart';
import '../auth/login_screen.dart';

class ProfilPetaniScreen extends StatelessWidget {
  const ProfilPetaniScreen({super.key});

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Petani')),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.primarySoft,
              child: Icon(Icons.person, color: AppColors.primary, size: 54),
            ),
            const SizedBox(height: 16),
            const Text(
              'Fasido',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Petani / Penyewa',
              style: TextStyle(color: AppColors.textGrey),
            ),
            const SizedBox(height: 22),
            const _ProfileTile(icon: Icons.email_outlined, label: 'Email', value: 'fasido@gmail.com'),
            const SizedBox(height: 10),
            const _ProfileTile(icon: Icons.location_on_outlined, label: 'Lokasi', value: 'Indramayu'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _logout(context),
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
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
