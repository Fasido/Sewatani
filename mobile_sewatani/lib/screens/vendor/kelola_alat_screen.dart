import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_colors.dart';
import '../../providers/alat_provider.dart';
import '../../widgets/alat_preview_card.dart';

class KelolaAlatScreen extends StatefulWidget {
  const KelolaAlatScreen({super.key});

  @override
  State<KelolaAlatScreen> createState() => _KelolaAlatScreenState();
}

class _KelolaAlatScreenState extends State<KelolaAlatScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<AlatProvider>().fetchAlat());
  }

  @override
  Widget build(BuildContext context) {
    final alatProvider = context.watch<AlatProvider>();

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
              'Daftar alat pada halaman ini sudah diambil dari AlatProvider. Pada step CRUD, data yang sama akan disambungkan ke API MySQL.',
              style: TextStyle(color: AppColors.primaryDark, height: 1.45, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 16),
          if (alatProvider.isLoading)
            const Padding(
              padding: EdgeInsets.only(top: 24),
              child: Center(child: CircularProgressIndicator()),
            )
          else
            ...alatProvider.allItems.map(
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
