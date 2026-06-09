import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../config/app_colors.dart';
import '../../config/app_config.dart';
import '../../models/alat_model.dart';
import '../../providers/alat_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';

class FormAlatScreen extends StatefulWidget {
  final AlatModel? alat;

  const FormAlatScreen({super.key, this.alat});

  @override
  State<FormAlatScreen> createState() => _FormAlatScreenState();
}

class _FormAlatScreenState extends State<FormAlatScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _pemilikController = TextEditingController();
  final _alamatController = TextEditingController();
  final _hargaController = TextEditingController();
  final _stokController = TextEditingController();
  final _deskripsiController = TextEditingController();

  final _picker = ImagePicker();
  final _apiService = ApiService();

  File? _selectedImage;
  String _kategori = 'Pengolahan Tanah';
  String _status = 'tersedia';
  bool _isSubmitting = false;
  bool _isUploadingImage = false;

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
      _pemilikController.text = alat.namaPemilik;
      _alamatController.text = alat.alamatLengkap;
      _hargaController.text = alat.hargaPerHari.toString();
      _stokController.text = alat.stok.toString();
      _deskripsiController.text = alat.deskripsi;
      _kategori = _kategoriOptions.contains(alat.kategori) ? alat.kategori : _kategoriOptions.first;
      _status = alat.status == 'tidak_tersedia' ? 'tidak_tersedia' : 'tersedia';
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _pemilikController.dispose();
    _alamatController.dispose();
    _hargaController.dispose();
    _stokController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Pilih Gambar Alat',
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.primarySoft,
                child: Icon(Icons.photo_library_rounded, color: AppColors.primary),
              ),
              title: const Text('Ambil dari Galeri'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.primarySoft,
                child: Icon(Icons.photo_camera_rounded, color: AppColors.primary),
              ),
              title: const Text('Ambil dari Kamera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final image = await _picker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 1200,
    );

    if (image == null) return;

    setState(() => _selectedImage = File(image.path));
  }

  String _imageByCategory(String kategori) {
    if (kategori == 'Irigasi') return 'alat_pompa_air.png';
    if (kategori == 'Panen') return 'alat_harvester.png';
    if (kategori == 'Perawatan') return 'alat_cultivator.png';
    return 'alat_traktor.png';
  }

  Future<String> _uploadSelectedImageIfNeeded() async {
    if (_selectedImage == null) {
      if (widget.alat?.fotoUrl.isNotEmpty == true) return widget.alat!.fotoUrl;
      return _imageByCategory(_kategori);
    }

    setState(() => _isUploadingImage = true);

    final response = await _apiService.uploadImage(
      'upload/upload_alat_image.php',
      _selectedImage!,
    );

    setState(() => _isUploadingImage = false);

    final data = Map<String, dynamic>.from(response['data']);
    return data['file_path']?.toString() ?? '';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() => _isSubmitting = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final alatProvider = context.read<AlatProvider>();
      final vendorId = widget.alat?.vendorId ?? authProvider.user?.id ?? 1;
      final fotoPath = await _uploadSelectedImageIfNeeded();

      final data = AlatModel(
        id: widget.alat?.id ?? 0,
        vendorId: vendorId,
        namaPemilik: _pemilikController.text.trim(),
        alamatLengkap: _alamatController.text.trim(),
        namaAlat: _namaController.text.trim(),
        kategori: _kategori,
        deskripsi: _deskripsiController.text.trim(),
        hargaPerHari: int.tryParse(_hargaController.text.trim()) ?? 0,
        stok: int.tryParse(_stokController.text.trim()) ?? 0,
        status: _status,
        fotoUrl: fotoPath,
        namaVendor: authProvider.user?.name ?? 'Vendor SewaTani',
        emailVendor: authProvider.user?.email ?? '',
      );

      final success = isEdit ? await alatProvider.updateAlat(data) : await alatProvider.addAlat(data);

      if (!mounted) return;
      setState(() => _isSubmitting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
              ? isEdit
                  ? 'Data alat berhasil diperbarui'
                  : 'Data alat berhasil ditambahkan'
              : alatProvider.errorMessage ?? 'Gagal menyimpan alat'),
        ),
      );

      if (success) Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _isUploadingImage = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan alat: $e')),
      );
    }
  }

  Widget _buildImagePreview() {
    final oldImage = widget.alat?.fotoUrl ?? '';
    Widget image;

    if (_selectedImage != null) {
      image = Image.file(_selectedImage!, fit: BoxFit.cover);
    } else if (oldImage.startsWith('uploads/') || oldImage.startsWith('http://') || oldImage.startsWith('https://')) {
      image = Image.network(
        AppConfig.imageUrl(oldImage),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(widget.alat?.imageAsset ?? 'assets/images/alat_traktor.png', fit: BoxFit.cover),
      );
    } else {
      image = Image.asset(widget.alat?.imageAsset ?? 'assets/images/alat_traktor.png', fit: BoxFit.cover);
    }

    return GestureDetector(
      onTap: _isSubmitting ? null : _pickImage,
      child: Container(
        height: 190,
        decoration: BoxDecoration(
          color: AppColors.primarySoft,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: AppColors.primary.withOpacity(0.15)),
        ),
        child: Stack(
          children: [
            Positioned.fill(child: ClipRRect(borderRadius: BorderRadius.circular(26), child: image)),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.50), Colors.transparent],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 14,
              child: Row(
                children: [
                  const Icon(Icons.image_rounded, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _selectedImage == null ? 'Tap untuk pilih/ganti gambar alat' : 'Gambar baru sudah dipilih',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ),
            if (_isUploadingImage) const Positioned.fill(child: Center(child: CircularProgressIndicator(color: Colors.white))),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final disabled = _isSubmitting || _isUploadingImage;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(isEdit ? 'Edit Alat' : 'Tambah Alat')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
            children: [
              _buildImagePreview(),
              const SizedBox(height: 18),
              _FieldLabel('Nama Pemilik Alat'),
              TextFormField(
                controller: _pemilikController,
                decoration: const InputDecoration(
                  hintText: 'Contoh: Wardi',
                  prefixIcon: Icon(Icons.person_rounded),
                ),
                validator: (v) => v == null || v.trim().isEmpty ? 'Nama pemilik wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              _FieldLabel('Alamat Lengkap Alat'),
              TextFormField(
                controller: _alamatController,
                minLines: 2,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Contoh: Desa Dukuh RT 02 RW 03, Indramayu',
                  prefixIcon: Icon(Icons.location_on_rounded),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Alamat lengkap wajib diisi';
                  if (v.trim().length < 10) return 'Alamat terlalu singkat';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _FieldLabel('Nama Alat'),
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  hintText: 'Contoh: Traktor Roda 2',
                  prefixIcon: Icon(Icons.agriculture_rounded),
                ),
                validator: (v) => v == null || v.trim().isEmpty ? 'Nama alat wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              _FieldLabel('Kategori'),
              DropdownButtonFormField<String>(
                value: _kategori,
                decoration: const InputDecoration(prefixIcon: Icon(Icons.category_rounded)),
                items: _kategoriOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: disabled ? null : (v) => setState(() => _kategori = v ?? _kategori),
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
                validator: (v) {
                  final n = int.tryParse(v?.trim() ?? '');
                  if (n == null || n <= 0) return 'Harga harus angka lebih dari 0';
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
                validator: (v) {
                  final n = int.tryParse(v?.trim() ?? '');
                  if (n == null || n < 0) return 'Stok harus berupa angka';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _FieldLabel('Status'),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(prefixIcon: Icon(Icons.verified_rounded)),
                items: const [
                  DropdownMenuItem(value: 'tersedia', child: Text('Tersedia')),
                  DropdownMenuItem(value: 'tidak_tersedia', child: Text('Tidak tersedia')),
                ],
                onChanged: disabled ? null : (v) => setState(() => _status = v ?? _status),
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
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Deskripsi wajib diisi';
                  if (v.trim().length < 15) return 'Deskripsi minimal 15 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 26),
              ElevatedButton.icon(
                onPressed: disabled ? null : _submit,
                icon: disabled
                    ? const SizedBox(width: 19, height: 19, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Icon(isEdit ? Icons.save_rounded : Icons.add_rounded),
                label: Text(disabled ? 'Menyimpan...' : isEdit ? 'Update Alat' : 'Simpan Alat'),
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
