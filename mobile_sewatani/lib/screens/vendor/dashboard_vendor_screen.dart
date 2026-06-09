import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../providers/alat_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/metric_card.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final vendorId = context.read<AuthProvider>().user?.id ?? 1;
    await Future.wait([
      context.read<AlatProvider>().fetchByVendor(vendorId),
      context.read<BookingProvider>().fetchBookings(vendorId: vendorId),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final alatProvider = context.watch<AlatProvider>();
    final bookingProvider = context.watch<BookingProvider>();
    final totalAlat = alatProvider.allItems.length;
    final tersedia = alatProvider.allItems.where((item) => item.tersedia).length;
    final totalStok = alatProvider.allItems.fold<int>(0, (sum, item) => sum + item.stok);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: _load,
          child: ListView(padding: const EdgeInsets.fromLTRB(18, 18, 18, 28), children: [
            _VendorHero(name: auth.user?.name ?? 'Vendor'),
            const SizedBox(height: 18),
            Row(children: [
              Expanded(child: MetricCard(title: 'Total alat', value: '$totalAlat', icon: Icons.agriculture_rounded)),
              const SizedBox(width: 12),
              Expanded(child: MetricCard(title: 'Stok total', value: '$totalStok', icon: Icons.inventory_2_rounded, color: const Color(0xFF2563EB))),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: MetricCard(title: 'Tersedia', value: '$tersedia', icon: Icons.verified_rounded)),
              const SizedBox(width: 12),
              Expanded(child: MetricCard(title: 'Menunggu', value: '${bookingProvider.waitingOrders}', icon: Icons.inbox_rounded, color: const Color(0xFFF59E0B))),
            ]),
            const SizedBox(height: 22),
            const Text('Aktivitas Terbaru', style: TextStyle(color: AppColors.textDark, fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(height: 12),
            if (bookingProvider.recentItems.isEmpty)
              const _SoftCard()
            else
              ...bookingProvider.recentItems.map((booking) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(22), border: Border.all(color: const Color(0xFFE5E7EB))),
                child: Row(children: [
                  const CircleAvatar(backgroundColor: AppColors.primarySoft, child: Icon(Icons.receipt_long_rounded, color: AppColors.primary)),
                  const SizedBox(width: 12),
                  Expanded(child: Text('${booking.namaAlat}\n${booking.namaPetani.isEmpty ? "Petani" : booking.namaPetani}', style: const TextStyle(color: AppColors.textDark, height: 1.35, fontWeight: FontWeight.w800))),
                  StatusBadge(status: booking.status, compact: true),
                ]),
              )),
          ]),
        ),
      ),
    );
  }
}

class _VendorHero extends StatelessWidget {
  final String name;
  const _VendorHero({required this.name});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(30), boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.22), blurRadius: 24, offset: const Offset(0, 12))]),
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Halo, $name', style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          const Text('Kelola alat dan pesanan petani secara rapi.', style: TextStyle(color: Colors.white, fontSize: 25, height: 1.12, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          const Text('Pantau stok, booking masuk, dan status penyewaan dari satu tempat.', style: TextStyle(color: Colors.white70, height: 1.4)),
        ])),
        const SizedBox(width: 14),
        Container(width: 78, height: 78, decoration: BoxDecoration(color: Colors.white.withOpacity(0.16), borderRadius: BorderRadius.circular(28)), child: const Icon(Icons.storefront_rounded, color: Colors.white, size: 44)),
      ]),
    );
  }
}

class _SoftCard extends StatelessWidget {
  const _SoftCard();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: const Row(children: [
        CircleAvatar(backgroundColor: AppColors.primarySoft, child: Icon(Icons.receipt_long_rounded, color: AppColors.primary)),
        SizedBox(width: 12),
        Expanded(child: Text('Belum ada aktivitas\nPesanan dari petani akan muncul di dashboard ini.', style: TextStyle(color: AppColors.textGrey, height: 1.45, fontWeight: FontWeight.w600))),
      ]),
    );
  }
}
