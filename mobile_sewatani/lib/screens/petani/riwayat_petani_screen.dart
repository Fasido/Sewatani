import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/status_badge.dart';

class RiwayatPetaniScreen extends StatefulWidget {
  const RiwayatPetaniScreen({super.key});
  @override
  State<RiwayatPetaniScreen> createState() => _RiwayatPetaniScreenState();
}

class _RiwayatPetaniScreenState extends State<RiwayatPetaniScreen> {
  String _filter = 'semua';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final userId = context.read<AuthProvider>().user?.id ?? 2;
    await context.read<BookingProvider>().fetchBookings(userId: userId);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();
    final items = _filter == 'semua' ? provider.items : provider.items.where((item) => item.status == _filter).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Riwayat Sewa'), actions: [IconButton(onPressed: _load, icon: const Icon(Icons.refresh_rounded))]),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: _load,
        child: Column(children: [
          SizedBox(
            height: 56,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 6),
              scrollDirection: Axis.horizontal,
              children: ['semua', 'menunggu', 'diterima', 'ditolak', 'selesai'].map((v) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  selected: _filter == v,
                  label: Text(v == 'semua' ? 'Semua' : v[0].toUpperCase() + v.substring(1)),
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(color: _filter == v ? Colors.white : AppColors.textDark, fontWeight: FontWeight.w800),
                  onSelected: (_) => setState(() => _filter = v),
                ),
              )).toList(),
            ),
          ),
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : provider.errorMessage != null
                    ? EmptyState(icon: Icons.wifi_off_rounded, title: 'Gagal memuat riwayat', subtitle: provider.errorMessage!, buttonText: 'Coba Lagi', onPressed: _load)
                    : items.isEmpty
                        ? const EmptyState(icon: Icons.receipt_long_rounded, title: 'Belum ada riwayat', subtitle: 'Booking alat pertanian yang kamu buat akan tampil di sini.')
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(18, 10, 18, 28),
                            itemCount: items.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (context, index) => _BookingCard(booking: items[index]),
                          ),
          ),
        ]),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final dynamic booking;
  const _BookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFE5E7EB)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.035), blurRadius: 16, offset: const Offset(0, 8))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const CircleAvatar(backgroundColor: AppColors.primarySoft, child: Icon(Icons.agriculture_rounded, color: AppColors.primary)),
          const SizedBox(width: 12),
          Expanded(child: Text(booking.namaAlat, style: const TextStyle(color: AppColors.textDark, fontSize: 17, fontWeight: FontWeight.w900))),
          StatusBadge(status: booking.status, compact: true),
        ]),
        const SizedBox(height: 14),
        _InfoLine(icon: Icons.calendar_month_rounded, text: booking.dateRange),
        const SizedBox(height: 7),
        _InfoLine(icon: Icons.storefront_rounded, text: booking.vendorName.isEmpty ? 'Vendor SewaTani' : booking.vendorName),
        const SizedBox(height: 7),
        _InfoLine(icon: Icons.location_on_rounded, text: booking.alamat),
        if (booking.catatan.isNotEmpty) ...[const SizedBox(height: 7), _InfoLine(icon: Icons.notes_rounded, text: booking.catatan)],
      ]),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoLine({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: AppColors.textGrey, size: 17),
      const SizedBox(width: 7),
      Expanded(child: Text(text, style: const TextStyle(color: AppColors.textGrey, height: 1.35, fontWeight: FontWeight.w600))),
    ]);
  }
}
