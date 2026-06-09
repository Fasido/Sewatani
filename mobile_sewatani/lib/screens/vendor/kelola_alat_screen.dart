import 'package:flutter/material.dart';

import '../../config/app_colors.dart';
import '../../models/alat_preview.dart';
import '../../widgets/alat_preview_card.dart';

class KelolaAlatScreen extends StatelessWidget {
  const KelolaAlatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Alat'),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Form tambah alat dibuat pada step CRUD.')),
              );
            },
            icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Text(
              'Vendor dapat menambah, mengubah, dan menghapus data alat pertanian. Fitur CRUD akan dihubungkan ke API MySQL pada step berikutnya.',
              style: TextStyle(color: AppColors.primaryDark, height: 1.45, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 16),
          ...demoAlatList.map(
            (alat) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AlatPreviewCard(
                alat: alat,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Kelola ${alat.name} pada step CRUD.')),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
