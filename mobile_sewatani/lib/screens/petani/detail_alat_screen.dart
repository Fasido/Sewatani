import 'package:flutter/material.dart';

import '../../config/app_colors.dart';
import '../../config/app_config.dart';
import '../../models/alat_preview.dart';
import 'form_booking_screen.dart';

class DetailAlatScreen extends StatelessWidget {
  final AlatPreview alat;

  const DetailAlatScreen({
    super.key,
    required this.alat,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Detail Alat')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: _DetailImage(alat: alat),
          ),
          const SizedBox(height: 22),
          Text(
            alat.title,
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            alat.price,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _InfoBox(icon: Icons.category_rounded, label: alat.category),
              const SizedBox(width: 10),
              _InfoBox(icon: Icons.inventory_2_outlined, label: 'Stok ${alat.stock}'),
            ],
          ),
          const SizedBox(height: 14),
          _InfoTile(
            icon: Icons.person_rounded,
            title: 'Pemilik Alat',
            value: alat.ownerName,
          ),
          const SizedBox(height: 10),
          _InfoTile(
            icon: Icons.location_on_rounded,
            title: 'Alamat Lengkap',
            value: alat.location,
          ),
          const SizedBox(height: 22),
          const Text(
            'Deskripsi',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            alat.description,
            style: const TextStyle(
              color: AppColors.textGrey,
              height: 1.6,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 28),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FormBookingScreen(alat: alat),
                ),
              );
            },
            icon: const Icon(Icons.calendar_month_rounded),
            label: const Text('Sewa Sekarang'),
          ),
        ],
      ),
    );
  }
}

class _DetailImage extends StatelessWidget {
  final AlatPreview alat;

  const _DetailImage({required this.alat});

  @override
  Widget build(BuildContext context) {
    if (alat.hasUploadedImage) {
      return Image.network(
        AppConfig.imageUrl(alat.fotoUrl),
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _AssetFallback(alat: alat),
      );
    }

    return _AssetFallback(alat: alat);
  }
}

class _AssetFallback extends StatelessWidget {
  final AlatPreview alat;

  const _AssetFallback({required this.alat});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      alat.imageAsset,
      width: double.infinity,
      height: 250,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return Container(
          height: 250,
          color: AppColors.primarySoft,
          child: const Icon(
            Icons.agriculture_rounded,
            color: AppColors.primary,
            size: 90,
          ),
        );
      },
    );
  }
}

class _InfoBox extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoBox({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    height: 1.35,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
