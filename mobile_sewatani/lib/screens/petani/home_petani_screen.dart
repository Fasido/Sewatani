import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_colors.dart';
import '../../config/app_config.dart';
import '../../models/alat_preview.dart';
import '../../providers/alat_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/metric_card.dart';
import '../../widgets/status_badge.dart';
import 'detail_alat_screen.dart';

class HomePetaniScreen extends StatefulWidget {
  const HomePetaniScreen({super.key});

  @override
  State<HomePetaniScreen> createState() => _HomePetaniScreenState();
}

class _HomePetaniScreenState extends State<HomePetaniScreen> {
  final _searchController = TextEditingController();
  final _categories = const ['Semua', 'Pengolahan Tanah', 'Irigasi', 'Panen', 'Perawatan'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final auth = context.read<AuthProvider>();
    await Future.wait([
      context.read<AlatProvider>().fetchAlat(),
      context.read<BookingProvider>().fetchBookings(userId: auth.user?.id ?? 2),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final alatProvider = context.watch<AlatProvider>();
    final bookingProvider = context.watch<BookingProvider>();
    final alatList = alatProvider.items;
    final totalTersedia = alatProvider.allItems.where((item) => item.tersedia).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: _load,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HeroHeader(name: auth.user?.name ?? 'Petani'),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(child: MetricCard(title: 'Alat tersedia', value: '$totalTersedia', icon: Icons.agriculture_rounded)),
                          const SizedBox(width: 12),
                          Expanded(child: MetricCard(title: 'Booking aktif', value: '${bookingProvider.totalMenunggu + bookingProvider.totalDiterima}', icon: Icons.calendar_month_rounded, color: const Color(0xFF2563EB))),
                        ],
                      ),
                      const SizedBox(height: 18),
                      TextField(
                        controller: _searchController,
                        onChanged: alatProvider.setKeyword,
                        decoration: InputDecoration(
                          hintText: 'Cari traktor, pompa air, cultivator...',
                          prefixIcon: const Icon(Icons.search_rounded),
                          suffixIcon: _searchController.text.isEmpty ? null : IconButton(
                            onPressed: () {
                              _searchController.clear();
                              alatProvider.clearSearch();
                            },
                            icon: const Icon(Icons.close_rounded),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 42,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _categories.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final category = _categories[index];
                            final selected = category == 'Semua'
                                ? alatProvider.selectedCategory == null
                                : alatProvider.selectedCategory == category;
                            return ChoiceChip(
                              selected: selected,
                              label: Text(category),
                              selectedColor: AppColors.primary,
                              labelStyle: TextStyle(color: selected ? Colors.white : AppColors.textDark, fontWeight: FontWeight.w800),
                              onSelected: (_) {
                                if (category == 'Semua') {
                                  alatProvider.clearCategory();
                                } else {
                                  alatProvider.setCategory(category);
                                }
                              },
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text('Katalog Alat', style: TextStyle(color: AppColors.textDark, fontSize: 20, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              if (alatProvider.isLoading)
                const SliverFillRemaining(hasScrollBody: false, child: Center(child: CircularProgressIndicator(color: AppColors.primary)))
              else if (alatProvider.errorMessage != null)
                SliverFillRemaining(hasScrollBody: false, child: EmptyState(icon: Icons.wifi_off_rounded, title: 'Gagal memuat katalog', subtitle: alatProvider.errorMessage!, buttonText: 'Coba Lagi', onPressed: _load))
              else if (alatList.isEmpty)
                const SliverFillRemaining(hasScrollBody: false, child: EmptyState(icon: Icons.inventory_2_outlined, title: 'Alat tidak ditemukan', subtitle: 'Coba gunakan kata kunci lain atau ubah kategori pencarian.'))
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
                  sliver: SliverList.separated(
                    itemCount: alatList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) => _AlatCard(alat: alatList[index]),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  final String name;
  const _HeroHeader({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.22), blurRadius: 24, offset: const Offset(0, 12))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Halo, $name', style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text('Sewa alat tani lebih mudah dan terdata.', style: TextStyle(color: Colors.white, fontSize: 26, height: 1.12, fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              const Text('Cari alat, cek stok, lihat pemilik, dan booking langsung dari aplikasi.', style: TextStyle(color: Colors.white70, height: 1.4)),
            ]),
          ),
          const SizedBox(width: 14),
          Container(width: 78, height: 78, decoration: BoxDecoration(color: Colors.white.withOpacity(0.16), borderRadius: BorderRadius.circular(28)), child: const Icon(Icons.agriculture_rounded, color: Colors.white, size: 46)),
        ],
      ),
    );
  }
}

class _AlatCard extends StatelessWidget {
  final AlatPreview alat;
  const _AlatCard({required this.alat});

  @override
  Widget build(BuildContext context) {
    final outOfStock = !alat.tersedia;
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailAlatScreen(alat: alat))),
      child: Container(
        decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(26), border: Border.all(color: const Color(0xFFE5E7EB)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.035), blurRadius: 18, offset: const Offset(0, 9))]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(children: [
            ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(26)), child: _Image(alat: alat)),
            Positioned(top: 12, left: 12, child: StatusBadge(status: outOfStock ? 'tidak_tersedia' : 'tersedia', compact: true)),
          ]),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 14, 15, 15),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(alat.title, style: const TextStyle(color: AppColors.textDark, fontSize: 19, fontWeight: FontWeight.w900)),
              const SizedBox(height: 6),
              Text(alat.category, style: const TextStyle(color: AppColors.textGrey, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: Text(alat.price, style: const TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.w900))),
                Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6), decoration: BoxDecoration(color: AppColors.primarySoft, borderRadius: BorderRadius.circular(999)), child: Text('Stok ${alat.stock}', style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w900))),
              ]),
              const SizedBox(height: 10),
              _IconText(icon: Icons.person_rounded, text: alat.ownerName),
              const SizedBox(height: 6),
              _IconText(icon: Icons.location_on_rounded, text: alat.location),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _Image extends StatelessWidget {
  final AlatPreview alat;
  const _Image({required this.alat});
  @override
  Widget build(BuildContext context) {
    if (alat.hasUploadedImage) {
      return Image.network(AppConfig.imageUrl(alat.fotoUrl), height: 172, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _AssetImage(alat: alat));
    }
    return _AssetImage(alat: alat);
  }
}

class _AssetImage extends StatelessWidget {
  final AlatPreview alat;
  const _AssetImage({required this.alat});
  @override
  Widget build(BuildContext context) {
    return Image.asset(alat.imageAsset, height: 172, width: double.infinity, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(height: 172, color: AppColors.primarySoft, child: const Icon(Icons.agriculture_rounded, color: AppColors.primary, size: 64)));
  }
}

class _IconText extends StatelessWidget {
  final IconData icon;
  final String text;
  const _IconText({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, color: AppColors.textGrey, size: 16),
      const SizedBox(width: 6),
      Expanded(child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.textGrey, fontSize: 13, fontWeight: FontWeight.w600))),
    ]);
  }
}
