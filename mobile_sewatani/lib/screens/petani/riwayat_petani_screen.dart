import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_colors.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/status_badge.dart';

class RiwayatPetaniScreen extends StatefulWidget {
  const RiwayatPetaniScreen({super.key});

  @override
  State<RiwayatPetaniScreen> createState() => _RiwayatPetaniScreenState();
}

class _RiwayatPetaniScreenState extends State<RiwayatPetaniScreen> {
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

  @override
  Widget build(BuildContext context) {
    final bookingProvider = context.watch<BookingProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Booking')),
      body: bookingProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.all(18),
              itemCount: bookingProvider.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = bookingProvider.items[index];

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: AppColors.primarySoft,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(Icons.receipt_long_outlined, color: AppColors.primary),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.alatName,
                                style: const TextStyle(
                                  color: AppColors.textDark,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                item.dateRange,
                                style: const TextStyle(color: AppColors.textGrey, fontSize: 13),
                              ),
                              Text(
                                item.address,
                                style: const TextStyle(color: AppColors.textGrey, fontSize: 13),
                              ),
                              const SizedBox(height: 8),
                              StatusBadge(text: item.status, color: _statusColor(item.status)),
                            ],
                          ),
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
