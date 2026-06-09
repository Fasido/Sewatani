import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_colors.dart';
import '../../providers/alat_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/section_header.dart';
import '../../widgets/status_badge.dart';

class DashboardVendorScreen extends StatefulWidget {
  const DashboardVendorScreen({super.key});

  @override
  State<DashboardVendorScreen> createState() => _DashboardVendorScreenState();
}

class _DashboardVendorScreenState extends State<DashboardVendorScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<AlatProvider>().fetchAlat();
      context.read<BookingProvider>().fetchBookings();
    });
  }

  Color _statusColor(String status) {
    if (status == 'Diterima') return AppColors.success;
    if (status == 'Ditolak') return AppColors.danger;
    return AppColors.warning;
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final alatProvider = context.watch<AlatProvider>();
    final bookingProvider = context.watch<BookingProvider>();
    final latestOrders = bookingProvider.items.take(2).toList();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
          children: [
            Text(
              'Dashboard Vendor',
              style: const TextStyle(
                color: AppColors.textDark,
                fontSize: 26,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Halo, ${user?.name ?? 'Vendor'} — pantau alat dan pesanan sewa dari petani.',
              style: const TextStyle(color: AppColors.textGrey),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    icon: Icons.agriculture,
                    title: 'Total Alat',
                    value: '${alatProvider.allItems.length}',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SummaryCard(
                    icon: Icons.pending_actions,
                    title: 'Menunggu',
                    value: '${bookingProvider.waitingOrders}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            const SectionHeader(title: 'Pesanan Terbaru'),
            const SizedBox(height: 12),
            if (bookingProvider.isLoading)
              const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
            else
              ...latestOrders.map(
                (order) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _OrderPreviewCard(
                    name: order.alatName,
                    renter: order.renterName,
                    status: order.status,
                    color: _statusColor(order.status),
                  ),
                ),
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
  final Color color;

  const _OrderPreviewCard({required this.name, required this.renter, required this.status, required this.color});

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
        trailing: StatusBadge(text: status, color: color),
      ),
    );
  }
}
