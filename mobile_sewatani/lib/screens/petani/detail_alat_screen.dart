import 'package:flutter/material.dart';

import '../../config/app_colors.dart';
import '../../models/alat_preview.dart';

class DetailAlatScreen extends StatelessWidget {
  final AlatPreview alat;

  const DetailAlatScreen({super.key, required this.alat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Alat')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          Container(
            height: 230,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Image.asset(
              alat.imagePath,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.agriculture,
                color: AppColors.primary,
                size: 110,
              ),
            ),
          ),
          const SizedBox(height: 22),
          Text(
            alat.name,
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 26,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            alat.price,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _InfoBox(icon: Icons.category_outlined, label: alat.category),
              const SizedBox(width: 10),
              _InfoBox(icon: Icons.inventory_2_outlined, label: 'Stok ${alat.stock}'),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'Deskripsi',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            alat.description,
            style: const TextStyle(
              color: AppColors.textGrey,
              fontSize: 15,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 18),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      alat.location,
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Form booking akan dibuat pada step fitur booking.'),
                ),
              );
            },
            icon: const Icon(Icons.calendar_month_outlined),
            label: const Text('Sewa Sekarang'),
          ),
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoBox({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
