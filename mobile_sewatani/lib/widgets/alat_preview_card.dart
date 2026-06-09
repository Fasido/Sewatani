import 'package:flutter/material.dart';

import '../config/app_colors.dart';
import '../config/app_config.dart';
import '../models/alat_preview.dart';

class AlatPreviewCard extends StatelessWidget {
  final AlatPreview alat;
  final VoidCallback onTap;

  const AlatPreviewCard({
    super.key,
    required this.alat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(24),
              ),
              child: _ImageBox(alat: alat),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alat.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textDark,
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      alat.category,
                      style: const TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      alat.price,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          color: AppColors.textGrey,
                          size: 15,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            alat.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.textGrey,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.chevron_right_rounded, color: AppColors.textGrey),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageBox extends StatelessWidget {
  final AlatPreview alat;

  const _ImageBox({required this.alat});

  @override
  Widget build(BuildContext context) {
    if (alat.hasUploadedImage) {
      return Image.network(
        AppConfig.imageUrl(alat.fotoUrl),
        width: 108,
        height: 126,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _AssetImage(alat: alat),
      );
    }

    return _AssetImage(alat: alat);
  }
}

class _AssetImage extends StatelessWidget {
  final AlatPreview alat;

  const _AssetImage({required this.alat});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      alat.imageAsset,
      width: 108,
      height: 126,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return Container(
          width: 108,
          height: 126,
          color: AppColors.primarySoft,
          child: const Icon(
            Icons.agriculture_rounded,
            color: AppColors.primary,
            size: 42,
          ),
        );
      },
    );
  }
}
