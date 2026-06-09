import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_colors.dart';
import '../../providers/auth_provider.dart';
import 'role_selection_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> _continueWithGoogle(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.prepareGoogleLoginPlaceholder();

    if (!context.mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/images/logo_sewatani.png',
                    width: 42,
                    height: 42,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.agriculture,
                      color: AppColors.primary,
                      size: 36,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'SewaTani',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Image.asset(
                  'assets/images/hero_petani.png',
                  height: 210,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.agriculture,
                    color: AppColors.primary,
                    size: 120,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Mulai sewa alat pertanian dengan lebih mudah',
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 29,
                  height: 1.13,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Cari alat, lakukan booking, dan pantau status pesanan dalam satu aplikasi yang sederhana untuk petani dan vendor.',
                style: TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: authProvider.isLoading ? null : () => _continueWithGoogle(context),
                  icon: authProvider.isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: Colors.white,
                          ),
                        )
                      : Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'G',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                  label: Text(authProvider.isLoading ? 'Menyiapkan Google...' : 'Lanjut dengan Google'),
                ),
              ),
              const SizedBox(height: 14),
              const Center(
                child: Text(
                  'Pada step ini tombol Google masih memakai Provider sebagai simulasi state. Firebase Auth asli dibuat pada step khusus.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textLight,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
