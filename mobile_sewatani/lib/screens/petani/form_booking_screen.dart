import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/app_colors.dart';
import '../../models/alat_preview.dart';
import '../../models/booking_model.dart';
import '../../providers/alat_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';

class FormBookingScreen extends StatefulWidget {
  final AlatPreview alat;

  const FormBookingScreen({super.key, required this.alat});

  @override
  State<FormBookingScreen> createState() => _FormBookingScreenState();
}

class _FormBookingScreenState extends State<FormBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tanggalMulaiController = TextEditingController();
  final _tanggalSelesaiController = TextEditingController();
  final _alamatController = TextEditingController();
  final _catatanController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _tanggalMulaiController.text = _formatDate(now);
    _tanggalSelesaiController.text = _formatDate(now.add(const Duration(days: 1)));

    if (widget.alat.location.isNotEmpty && widget.alat.location != 'Indramayu') {
      _alamatController.text = widget.alat.location;
    }
  }

  @override
  void dispose() {
    _tanggalMulaiController.dispose();
    _tanggalSelesaiController.dispose();
    _alamatController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final initialDate = DateTime.tryParse(controller.text) ?? DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) controller.text = _formatDate(picked);
  }

  Future<void> _submitBooking() async {
    if (widget.alat.stok <= 0 || !widget.alat.tersedia) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stok alat habis, alat tidak bisa disewa.')),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    final start = DateTime.tryParse(_tanggalMulaiController.text);
    final end = DateTime.tryParse(_tanggalSelesaiController.text);

    if (start == null || end == null || end.isBefore(start)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tanggal selesai tidak boleh sebelum tanggal mulai.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final authProvider = context.read<AuthProvider>();
    final bookingProvider = context.read<BookingProvider>();

    final booking = BookingModel(
      id: 0,
      userId: authProvider.user?.id ?? 2,
      alatId: widget.alat.id,
      vendorId: widget.alat.vendorId,
      namaAlat: widget.alat.namaAlat,
      namaPetani: authProvider.user?.name ?? 'Petani SewaTani',
      namaVendor: widget.alat.vendorName,
      tanggalMulai: _tanggalMulaiController.text.trim(),
      tanggalSelesai: _tanggalSelesaiController.text.trim(),
      alamat: _alamatController.text.trim(),
      catatan: _catatanController.text.trim(),
      status: 'menunggu',
      fotoUrl: widget.alat.fotoUrl,
    );

    final success = await bookingProvider.createBooking(booking);

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Booking berhasil. Stok alat otomatis berkurang.'
              : bookingProvider.errorMessage ?? 'Gagal membuat booking.',
        ),
      ),
    );

    if (success) {
      await context.read<AlatProvider>().fetchAlat();
      if (!mounted) return;
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final alat = widget.alat;
    final outOfStock = alat.stok <= 0 || !alat.tersedia;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Booking Sewa')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: outOfStock ? AppColors.danger : AppColors.primary,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.calendar_month_rounded, color: AppColors.primary),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        '${alat.namaAlat}\n${alat.price} • Stok ${alat.stok} • ${alat.statusLabel}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _InfoTile(icon: Icons.person_rounded, title: 'Pemilik Alat', value: alat.ownerName),
              const SizedBox(height: 10),
              _InfoTile(icon: Icons.location_on_rounded, title: 'Alamat Alat', value: alat.location),
              const SizedBox(height: 18),
              _FieldLabel('Tanggal Mulai'),
              TextFormField(
                controller: _tanggalMulaiController,
                readOnly: true,
                onTap: () => _pickDate(_tanggalMulaiController),
                decoration: const InputDecoration(prefixIcon: Icon(Icons.event_rounded)),
                validator: (v) => v == null || v.isEmpty ? 'Tanggal mulai wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              _FieldLabel('Tanggal Selesai'),
              TextFormField(
                controller: _tanggalSelesaiController,
                readOnly: true,
                onTap: () => _pickDate(_tanggalSelesaiController),
                decoration: const InputDecoration(prefixIcon: Icon(Icons.event_available_rounded)),
                validator: (v) => v == null || v.isEmpty ? 'Tanggal selesai wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              _FieldLabel('Alamat Penggunaan / Lokasi Sawah'),
              TextFormField(
                controller: _alamatController,
                minLines: 3,
                maxLines: 4,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.map_rounded),
                  hintText: 'Contoh: Desa Dukuh RT 02 RW 03, Indramayu',
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Alamat penggunaan wajib diisi';
                  if (v.trim().length < 10) return 'Alamat terlalu singkat';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _FieldLabel('Catatan Tambahan'),
              TextFormField(
                controller: _catatanController,
                minLines: 3,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Contoh: Alat dibutuhkan pagi hari.',
                ),
              ),
              const SizedBox(height: 26),
              ElevatedButton.icon(
                onPressed: outOfStock || _isSubmitting ? null : _submitBooking,
                icon: _isSubmitting
                    ? const SizedBox(width: 19, height: 19, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.send_rounded),
                label: Text(outOfStock ? 'Stok Habis' : _isSubmitting ? 'Mengirim Booking...' : 'Kirim Booking'),
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

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoTile({required this.icon, required this.title, required this.value});

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
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: AppColors.textGrey, fontSize: 12, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(color: AppColors.textDark, height: 1.4, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
