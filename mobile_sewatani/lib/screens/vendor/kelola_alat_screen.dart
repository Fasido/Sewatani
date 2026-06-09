import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_colors.dart';
import '../../config/app_config.dart';
import '../../models/alat_model.dart';
import '../../providers/alat_provider.dart';
import '../../providers/auth_provider.dart';
import 'form_alat_screen.dart';

class KelolaAlatScreen extends StatefulWidget {
  const KelolaAlatScreen({super.key});

  @override
  State<KelolaAlatScreen> createState() => _KelolaAlatScreenState();
}

class _KelolaAlatScreenState extends State<KelolaAlatScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData() async {
    final vendorId = context.read<AuthProvider>().user?.id ?? 1;
    await context.read<AlatProvider>().fetchByVendor(vendorId);
  }

  Future<void> _openForm({AlatModel? alat}) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => FormAlatScreen(alat: alat)),
    );

    if (result == true && mounted) await _loadData();
  }

  Future<void> _deleteAlat(AlatModel alat) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Hapus Alat?'),
          content: Text('Data "${alat.namaAlat}" akan dihapus. Lanjutkan?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.danger,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    if (confirm != true || !mounted) return;

    final provider = context.read<AlatProvider>();
    final success = await provider.deleteAlat(alat.id);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Data alat berhasil dihapus'
              : provider.errorMessage ?? 'Gagal menghapus alat',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final alatProvider = context.watch<AlatProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Kelola Alat'),
        actions: [
          IconButton(
            onPressed: _loadData,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah Alat'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        color: AppColors.primary,
        child: alatProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : alatProvider.errorMessage != null
                ? _ErrorState(message: alatProvider.errorMessage!, onRetry: _loadData)
                : alatProvider.allItems.isEmpty
                    ? _EmptyState(onAdd: () => _openForm())
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(18, 18, 18, 110),
                        itemCount: alatProvider.allItems.length + 1,
                        itemBuilder: (context, index) {
                          if (index == 0) return const _HeaderInfo();

                          final alat = alatProvider.allItems[index - 1];
                          return _AlatManageCard(
                            alat: alat,
                            onEdit: () => _openForm(alat: alat),
                            onDelete: () => _deleteAlat(alat),
                          );
                        },
                      ),
      ),
    );
  }
}

class _HeaderInfo extends StatelessWidget {
  const _HeaderInfo();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.agriculture_rounded, color: AppColors.primary),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              'Kelola alat lengkap dengan foto, nama pemilik, dan alamat alat.',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AlatManageCard extends StatelessWidget {
  final AlatModel alat;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AlatManageCard({
    required this.alat,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final available = alat.status == 'tersedia';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: _AlatImage(alat: alat),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _AlatInfo(alat: alat, available: available)),
                const SizedBox(width: 4),
                Column(
                  children: [
                    IconButton(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_rounded, color: AppColors.primary),
                    ),
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_outline_rounded, color: AppColors.danger),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AlatImage extends StatelessWidget {
  final AlatModel alat;

  const _AlatImage({required this.alat});

  @override
  Widget build(BuildContext context) {
    if (alat.hasUploadedImage) {
      return Image.network(
        AppConfig.imageUrl(alat.fotoUrl),
        width: double.infinity,
        height: 160,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _AssetFallback(alat: alat),
      );
    }

    return _AssetFallback(alat: alat);
  }
}

class _AssetFallback extends StatelessWidget {
  final AlatModel alat;

  const _AssetFallback({required this.alat});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      alat.imageAsset,
      width: double.infinity,
      height: 160,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return Container(
          width: double.infinity,
          height: 160,
          color: AppColors.primarySoft,
          child: const Icon(
            Icons.agriculture_rounded,
            color: AppColors.primary,
            size: 54,
          ),
        );
      },
    );
  }
}

class _AlatInfo extends StatelessWidget {
  final AlatModel alat;
  final bool available;

  const _AlatInfo({
    required this.alat,
    required this.available,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          alat.namaAlat,
          style: const TextStyle(
            color: AppColors.textDark,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          alat.kategori,
          style: const TextStyle(color: AppColors.textGrey, fontSize: 13),
        ),
        const SizedBox(height: 8),
        Text(
          alat.price,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        _InfoLine(icon: Icons.person_rounded, text: alat.ownerName),
        const SizedBox(height: 6),
        _InfoLine(icon: Icons.location_on_rounded, text: alat.location),
        const SizedBox(height: 10),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            _Badge(label: 'Stok ${alat.stok}', color: AppColors.primary),
            _Badge(
              label: available ? 'Tersedia' : 'Tidak tersedia',
              color: available ? AppColors.primary : AppColors.danger,
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoLine({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.textGrey),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.textGrey,
              fontSize: 12.5,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;

  const _EmptyState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 90),
        const Icon(Icons.agriculture_rounded, color: AppColors.primary, size: 86),
        const SizedBox(height: 18),
        const Text(
          'Belum ada alat',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Tambahkan alat pertanian pertama agar bisa disewa oleh petani.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.textGrey, height: 1.5),
        ),
        const SizedBox(height: 22),
        ElevatedButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Tambah Alat'),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 80),
        const Icon(Icons.wifi_off_rounded, color: AppColors.danger, size: 76),
        const SizedBox(height: 16),
        const Text(
          'Gagal memuat data',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textDark,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textGrey, height: 1.45),
        ),
        const SizedBox(height: 22),
        ElevatedButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Coba Lagi'),
        ),
      ],
    );
  }
}
