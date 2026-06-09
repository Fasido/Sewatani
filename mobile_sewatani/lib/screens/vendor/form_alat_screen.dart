import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_colors.dart';
import '../../models/alat_model.dart';
import '../../providers/alat_provider.dart';
import '../../providers/auth_provider.dart';

class FormAlatScreen extends StatefulWidget {
  final AlatModel? alat;

  const FormAlatScreen({
    super.key,
    this.alat,
  });

  @override
  State<FormAlatScreen> createState() => _FormAlatScreenState();
}

class _FormAlatScreenState extends State<FormAlatScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _hargaController = TextEditingController();
  final _stokController = TextEditingController();
  final _deskripsiController = TextEditingController();

  String _kategori = 'Pengolahan Tanah';
  String _status = 'tersedia';
  bool _isSubmitting = false;

  bool get isEdit => widget.alat != null;

  final List<String> _kategoriOptions = const [
    'Pengolahan Tanah',
    'Irigasi',
    'Panen',
    'Perawatan',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();

    final alat = widget.alat;
    if (alat != null) {
      _namaController.text = alat.namaAlat;
      _hargaController.text = alat.hargaPerHari.toString();
      _stokController.text = alat.stok.toString();
      _deskripsiController.text = alat.deskripsi;
      _kategori = _kategoriOptions.contains(alat.kategori)
          ? alat.kategori
          : _kategoriOptions.first;
      _status = alat.status == 'tidak_tersedia' ? 'tidak_tersedia' : 'tersedia';
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _hargaController.dispose();
    _stokController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  String _imageByCategory(String kategori) {
    if (kategori == 'Irigasi') return 'alat_pompa_air.png';
    if (kategori == 'Panen') return 'alat_harvester.png';
    if (kategori == 'Perawatan') return 'alat_cultivator.png';
    return 'alat_traktor.png';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() => _isSubmitting = true);

    final authProvider = context.read<AuthProvider>();
    final alatProvider = context.read<AlatProvider>();

    final vendorId = widget.alat?.vendorId ?? authProvider.user?.id ?? 1;

    final data = AlatModel(
      id: widget.alat?.id ?? 0,
      vendorId: vendorId,
      namaAlat: _namaController.text.trim(),
      kategori: _kategori,
      deskripsi: _deskripsiController.text.trim(),
      hargaPerHari: int.tryParse(_hargaController.text.trim()) ?? 0,
      stok: int.tryParse(_stokController.text.trim()) ?? 0,
      status: _status,
      fotoUrl: widget.alat?.fotoUrl.isNotEmpty == true
          ? widget.alat!.fotoUrl
          : _imageByCategory(_kategori),
      namaVendor: authProvider.user?.name ?? 'Vendor SewaTani',
      emailVendor: authProvider.user?.email ?? '',
    );

    final success = isEdit
        ? await alatProvider.updateAlat(data)
        : await alatProvider.addAlat(data);

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? isEdit
                  ? 'Data alat berhasil diperbarui'
                  : 'Data alat berhasil ditambahkan'
              : alatProvider.errorMessage ?? 'Gagal menyimpan alat',
        ),
      ),
    );

    if (success) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(isEdit ? 'Edit Alat' : 'Tambah Alat')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.primary.withOpacity(0.10)),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.eco_rounded, color: AppColors.primary),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        isEdit
                            ? 'Perbarui data alat agar katalog tetap akurat.'
                            : 'Masukkan data alat pertanian yang akan disewakan.',
                        style: const TextStyle(
                          color: AppColors.textDark,
                          height: 1.45,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _FieldLabel('Nama Alat'),
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  hintText: 'Contoh: Traktor Roda 2',
                  prefixIcon: Icon(Icons.agriculture_rounded),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama alat wajib diisi';
                  }
                  if (value.trim().length < 3) {
                    return 'Nama alat minimal 3 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _FieldLabel('Kategori'),
              DropdownButtonFormField<String>(
                value: _kategori,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.category_rounded),
                ),
                items: _kategoriOptions.map((item) {
                  return DropdownMenuItem(value: item, child: Text(item));
                }).toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _kategori = value);
                },
              ),
              const SizedBox(height: 16),
              _FieldLabel('Harga Sewa per Hari'),
              TextFormField(
                controller: _hargaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Contoh: 150000',
                  prefixIcon: Icon(Icons.payments_rounded),
                  prefixText: 'Rp ',
                ),
                validator: (value) {
                  final number = int.tryParse(value?.trim() ?? '');
                  if (number == null || number <= 0) {
                    return 'Harga harus angka lebih dari 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _FieldLabel('Stok'),
              TextFormField(
                controller: _stokController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Contoh: 2',
                  prefixIcon: Icon(Icons.inventory_2_rounded),
                ),
                validator: (value) {
                  final number = int.tryParse(value?.trim() ?? '');
                  if (number == null || number < 0) {
                    return 'Stok harus berupa angka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _FieldLabel('Status'),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.verified_rounded),
                ),
                items: const [
                  DropdownMenuItem(value: 'tersedia', child: Text('Tersedia')),
                  DropdownMenuItem(value: 'tidak_tersedia', child: Text('Tidak tersedia')),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _status = value);
                },
              ),
              const SizedBox(height: 16),
              _FieldLabel('Deskripsi'),
              TextFormField(
                controller: _deskripsiController,
                minLines: 4,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Jelaskan kondisi alat dan aturan sewa singkat.',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Deskripsi wajib diisi';
                  }
                  if (value.trim().length < 15) {
                    return 'Deskripsi minimal 15 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 26),
              ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _submit,
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 19,
                        height: 19,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(isEdit ? Icons.save_rounded : Icons.add_rounded),
                label: Text(
                  _isSubmitting
                      ? 'Menyimpan...'
                      : isEdit
                          ? 'Update Alat'
                          : 'Simpan Alat',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.textDark,
          fontSize: 14,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
