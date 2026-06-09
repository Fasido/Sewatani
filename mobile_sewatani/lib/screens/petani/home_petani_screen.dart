import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_colors.dart';
import '../../providers/alat_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/alat_preview_card.dart';
import '../../widgets/section_header.dart';
import 'detail_alat_screen.dart';

class HomePetaniScreen extends StatefulWidget {
  const HomePetaniScreen({super.key});

  @override
  State<HomePetaniScreen> createState() => _HomePetaniScreenState();
}

class _HomePetaniScreenState extends State<HomePetaniScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<AlatProvider>().fetchAlat());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    final alatProvider = context.watch<AlatProvider>();

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
                    children: [
                      Text(
                        'Halo, ${user?.name ?? 'Petani'} 👋',
                        style: const TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
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
              controller: _searchController,
              onChanged: alatProvider.setKeyword,
              decoration: InputDecoration(
                hintText: 'Cari traktor, pompa air, cultivator...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: alatProvider.keyword.isEmpty
                    ? Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.tune, color: Colors.white, size: 20),
                      )
                    : IconButton(
                        onPressed: () {
                          _searchController.clear();
                          alatProvider.setKeyword('');
                        },
                        icon: const Icon(Icons.close),
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
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                          style: TextStyle(color: Color(0xFFE9F7EA), height: 1.4),
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
                children: [
                  _CategoryChip(label: 'Semua', isSelected: alatProvider.selectedCategory == null, onTap: () => alatProvider.setCategory(null)),
                  _CategoryChip(label: 'Pengolahan Tanah', isSelected: alatProvider.selectedCategory == 'Pengolahan Tanah', onTap: () => alatProvider.setCategory('Pengolahan Tanah')),
                  _CategoryChip(label: 'Irigasi', isSelected: alatProvider.selectedCategory == 'Irigasi', onTap: () => alatProvider.setCategory('Irigasi')),
                  _CategoryChip(label: 'Panen', isSelected: alatProvider.selectedCategory == 'Panen', onTap: () => alatProvider.setCategory('Panen')),
                ],
              ),
            ),
            const SizedBox(height: 22),
            SectionHeader(title: 'Alat Tersedia', actionText: '${alatProvider.items.length} item'),
            const SizedBox(height: 12),
            if (alatProvider.isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 24),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (alatProvider.items.isEmpty)
              const _EmptyState()
            else
              ...alatProvider.items.map(
                (alat) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AlatPreviewCard(
                    alat: alat,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => DetailAlatScreen(alat: alat)),
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
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textDark,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Column(
        children: [
          Icon(Icons.search_off, color: AppColors.textLight, size: 46),
          SizedBox(height: 10),
          Text('Alat tidak ditemukan', style: TextStyle(fontWeight: FontWeight.w900)),
          SizedBox(height: 4),
          Text('Coba gunakan kata kunci atau kategori lain.', textAlign: TextAlign.center, style: TextStyle(color: AppColors.textGrey)),
        ],
      ),
    );
  }
}
