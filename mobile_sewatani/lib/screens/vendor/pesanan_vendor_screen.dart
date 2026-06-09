import 'package:flutter/material.dart';

import '../../config/app_colors.dart';
import '../../widgets/status_badge.dart';

class PesananVendorScreen extends StatelessWidget {
  const PesananVendorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = [
      ('Traktor Roda 2', 'Fasido', '10 Jun 2026', 'Menunggu'),
      ('Pompa Air Sawah', 'Petani Indramayu', '08 Jun 2026', 'Menunggu'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Pesanan Masuk')),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        itemCount: orders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppColors.primarySoft,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.assignment_outlined, color: AppColors.primary),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(order.$1, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text('Penyewa: ${order.$2}', style: const TextStyle(color: AppColors.textGrey)),
                            Text('Tanggal: ${order.$3}', style: const TextStyle(color: AppColors.textGrey)),
                          ],
                        ),
                      ),
                      StatusBadge(text: order.$4),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          child: const Text('Tolak'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text('Setujui'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
