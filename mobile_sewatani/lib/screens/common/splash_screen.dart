import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';
import '../petani/petani_main_screen.dart';
import '../vendor/vendor_main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSessionAndRoute();
  }

  Future<void> _checkSessionAndRoute() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.checkSession();

    if (!mounted) return;

    if (!authProvider.isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => authProvider.isVendor
            ? const VendorMainScreen()
            : const PetaniMainScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 138,
                height: 138,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.10),
                      blurRadius: 22,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/images/logo_sewatani.png',
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.agriculture,
                    size: 76,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 26),
              const Text(
                'SewaTani',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Sewa alat pertanian lebih mudah untuk petani Indramayu.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textGrey,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              const CircularProgressIndicator(color: AppColors.primary),
              const SizedBox(height: 12),
              const Text(
                'Mengecek sesi login...',
                style: TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Text(
                  'Menghubungkan petani dengan pemilik alat pertanian secara lebih praktis dan terdata.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: 13,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
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
