import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_colors.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/status_badge.dart';

class PesananVendorScreen extends StatefulWidget {
  const PesananVendorScreen({super.key});

  @override
  State<PesananVendorScreen> createState() => _PesananVendorScreenState();
}

class _PesananVendorScreenState extends State<PesananVendorScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<BookingProvider>().fetchBookings());
  }

  Color _statusColor(String status) {
    if (status == 'Diterima') return AppColors.success;
    if (status == 'Ditolak') return AppColors.danger;
    return AppColors.warning;
  }

  Future<void> _setStatus(int id, String status) async {
    await context.read<BookingProvider>().updateStatus(id, status);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Status pesanan diubah menjadi $status')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = context.watch<BookingProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Pesanan Masuk')),
      body: bookingProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
              itemCount: bookingProvider.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final order = bookingProvider.items[index];
                final canAct = order.status == 'Menunggu';

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
                                  Text(order.alatName, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                                  const SizedBox(height: 4),
                                  Text('Penyewa: ${order.renterName}', style: const TextStyle(color: AppColors.textGrey)),
                                  Text('Tanggal: ${order.dateRange}', style: const TextStyle(color: AppColors.textGrey)),
                                  Text('Alamat: ${order.address}', style: const TextStyle(color: AppColors.textGrey)),
                                ],
                              ),
                            ),
                            StatusBadge(text: order.status, color: _statusColor(order.status)),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: canAct ? () => _setStatus(order.id, 'Ditolak') : null,
                                child: const Text('Tolak'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: canAct ? () => _setStatus(order.id, 'Diterima') : null,
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
