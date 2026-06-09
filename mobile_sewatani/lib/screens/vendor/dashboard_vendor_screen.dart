import 'package:flutter/material.dart';

import '../../config/app_colors.dart';
import '../../widgets/section_header.dart';
import '../../widgets/status_badge.dart';

class DashboardVendorScreen extends StatelessWidget {
  const DashboardVendorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
          children: const [
            Text(
              'Dashboard Vendor',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 26,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Pantau alat dan pesanan sewa dari petani.',
              style: TextStyle(color: AppColors.textGrey),
            ),
            SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    icon: Icons.agriculture,
                    title: 'Total Alat',
                    value: '4',
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _SummaryCard(
                    icon: Icons.assignment,
                    title: 'Pesanan',
                    value: '2',
                  ),
                ),
              ],
            ),
            SizedBox(height: 22),
            SectionHeader(title: 'Pesanan Terbaru'),
            SizedBox(height: 12),
            _OrderPreviewCard(
              name: 'Traktor Roda 2',
              renter: 'Fasido',
              status: 'Menunggu',
            ),
            SizedBox(height: 12),
            _OrderPreviewCard(
              name: 'Pompa Air Sawah',
              renter: 'Petani Indramayu',
              status: 'Menunggu',
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _SummaryCard({required this.icon, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 26,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 3),
            Text(title, style: const TextStyle(color: AppColors.textGrey)),
          ],
        ),
      ),
    );
  }
}

class _OrderPreviewCard extends StatelessWidget {
  final String name;
  final String renter;
  final String status;

  const _OrderPreviewCard({required this.name, required this.renter, required this.status});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(14),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primarySoft,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.assignment_outlined, color: AppColors.primary),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w900)),
        subtitle: Text('Penyewa: $renter'),
        trailing: StatusBadge(text: status),
      ),
    );
  }
}
