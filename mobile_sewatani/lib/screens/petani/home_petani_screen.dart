import 'package:flutter/material.dart';

import '../../config/app_colors.dart';
import '../../models/alat_preview.dart';
import '../../widgets/alat_preview_card.dart';
import '../../widgets/section_header.dart';
import 'detail_alat_screen.dart';

class HomePetaniScreen extends StatelessWidget {
  const HomePetaniScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Halo, Fasido 👋',
                        style: TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Butuh alat pertanian apa hari ini?',
                        style: TextStyle(
                          color: AppColors.textDark,
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                          height: 1.15,
                        ),
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  'assets/images/logo_sewatani.png',
                  width: 46,
                  height: 46,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.agriculture,
                    color: AppColors.primary,
                    size: 42,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Cari traktor, pompa air, cultivator...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.tune, color: Colors.white, size: 20),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Sewa alat jadi lebih praktis',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            height: 1.18,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Pilih alat, booking, lalu tunggu konfirmasi vendor.',
                          style: TextStyle(
                            color: Color(0xFFE9F7EA),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Image.asset(
                    'assets/images/hero_petani.png',
                    width: 115,
                    height: 115,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.agriculture,
                      color: Colors.white,
                      size: 70,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const SectionHeader(title: 'Kategori Populer'),
            const SizedBox(height: 12),
            SizedBox(
              height: 42,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  _CategoryChip(label: 'Traktor'),
                  _CategoryChip(label: 'Irigasi'),
                  _CategoryChip(label: 'Panen'),
                  _CategoryChip(label: 'Tanam'),
                ],
              ),
            ),
            const SizedBox(height: 22),
            const SectionHeader(title: 'Alat Tersedia', actionText: 'Lihat semua'),
            const SizedBox(height: 12),
            ...demoAlatList.map(
              (alat) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AlatPreviewCard(
                  alat: alat,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailAlatScreen(alat: alat),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;

  const _CategoryChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.textDark,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
