class AlatModel {
  final int id;
  final int vendorId;
  final String namaPemilik;
  final String alamatLengkap;
  final String namaAlat;
  final String kategori;
  final String deskripsi;
  final int hargaPerHari;
  final int stok;
  final String status;
  final String fotoUrl;
  final String namaVendor;
  final String emailVendor;

  const AlatModel({
    required this.id,
    required this.vendorId,
    this.namaPemilik = '',
    this.alamatLengkap = '',
    required this.namaAlat,
    required this.kategori,
    required this.deskripsi,
    required this.hargaPerHari,
    required this.stok,
    required this.status,
    this.fotoUrl = '',
    this.namaVendor = '',
    this.emailVendor = '',
  });

  bool get tersedia => status == 'tersedia' && stok > 0;

  int get idAlat => id;
  int get idVendor => vendorId;
  String get title => namaAlat;
  String get name => namaAlat;
  String get nama => namaAlat;
  String get category => kategori;
  String get description => deskripsi;
  int get pricePerDay => hargaPerHari;
  int get stock => stok;
  String get price => formattedPrice;
  String get priceLabel => formattedPrice;
  String get formattedPrice => _formatRupiah(hargaPerHari);
  String get location => alamatLengkap.isNotEmpty ? alamatLengkap : 'Indramayu';
  String get ownerName =>
      namaPemilik.isNotEmpty ? namaPemilik : 'Pemilik alat belum diisi';
  String get vendorName => namaVendor.isEmpty ? 'Vendor SewaTani' : namaVendor;
  String get imageAsset => _localImageAsset;
  String get imagePath => _localImageAsset;
  String get imageUrl => fotoUrl;
  String get statusLabel => tersedia ? 'Tersedia' : 'Tidak Tersedia';

  bool get hasUploadedImage =>
      fotoUrl.startsWith('uploads/') ||
      fotoUrl.startsWith('http://') ||
      fotoUrl.startsWith('https://');

  String get _localImageAsset {
    final file = fotoUrl.toLowerCase();
    final alatName = namaAlat.toLowerCase();

    if (file.contains('pompa') || alatName.contains('pompa')) {
      return 'assets/images/alat_pompa_air.png';
    }

    if (file.contains('cultivator') || alatName.contains('cultivator')) {
      return 'assets/images/alat_cultivator.png';
    }

    if (file.contains('harvester') ||
        file.contains('panen') ||
        alatName.contains('panen')) {
      return 'assets/images/alat_harvester.png';
    }

    return 'assets/images/alat_traktor.png';
  }

  factory AlatModel.fromJson(Map<String, dynamic> json) {
    return AlatModel(
      id: _toInt(json['id_alat'] ?? json['id'] ?? json['idAlat']),
      vendorId: _toInt(json['id_vendor'] ?? json['vendorId'] ?? json['idVendor']),
      namaPemilik:
          (json['nama_pemilik'] ?? json['namaPemilik'] ?? '').toString(),
      alamatLengkap:
          (json['alamat_lengkap'] ?? json['alamatLengkap'] ?? '').toString(),
      namaAlat: (json['nama_alat'] ??
              json['namaAlat'] ??
              json['title'] ??
              json['name'] ??
              '')
          .toString(),
      kategori: (json['kategori'] ?? json['category'] ?? '').toString(),
      deskripsi:
          (json['deskripsi'] ?? json['description'] ?? '').toString(),
      hargaPerHari: _toInt(
        json['harga_per_hari'] ??
            json['hargaPerHari'] ??
            json['pricePerDay'] ??
            json['harga'] ??
            json['price'],
      ),
      stok: _toInt(json['stok'] ?? json['stock']),
      status: (json['status'] ?? 'tersedia').toString(),
      fotoUrl: (json['foto_url'] ??
              json['fotoUrl'] ??
              json['imageAsset'] ??
              json['imageUrl'] ??
              '')
          .toString(),
      namaVendor:
          (json['nama_vendor'] ?? json['namaVendor'] ?? json['vendorName'] ?? '')
              .toString(),
      emailVendor:
          (json['email_vendor'] ?? json['emailVendor'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_alat': id,
      'id_vendor': vendorId,
      'nama_pemilik': namaPemilik,
      'alamat_lengkap': alamatLengkap,
      'nama_alat': namaAlat,
      'kategori': kategori,
      'deskripsi': deskripsi,
      'harga_per_hari': hargaPerHari,
      'stok': stok,
      'status': stok <= 0 ? 'tidak_tersedia' : status,
      'foto_url': fotoUrl,
    };
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'id_vendor': vendorId,
      'nama_pemilik': namaPemilik,
      'alamat_lengkap': alamatLengkap,
      'nama_alat': namaAlat,
      'kategori': kategori,
      'deskripsi': deskripsi,
      'harga_per_hari': hargaPerHari,
      'stok': stok,
      'status': stok <= 0 ? 'tidak_tersedia' : status,
      'foto_url': fotoUrl,
    };
  }

  AlatModel copyWith({
    int? id,
    int? vendorId,
    String? namaPemilik,
    String? alamatLengkap,
    String? namaAlat,
    String? kategori,
    String? deskripsi,
    int? hargaPerHari,
    int? stok,
    String? status,
    String? fotoUrl,
    String? namaVendor,
    String? emailVendor,
  }) {
    return AlatModel(
      id: id ?? this.id,
      vendorId: vendorId ?? this.vendorId,
      namaPemilik: namaPemilik ?? this.namaPemilik,
      alamatLengkap: alamatLengkap ?? this.alamatLengkap,
      namaAlat: namaAlat ?? this.namaAlat,
      kategori: kategori ?? this.kategori,
      deskripsi: deskripsi ?? this.deskripsi,
      hargaPerHari: hargaPerHari ?? this.hargaPerHari,
      stok: stok ?? this.stok,
      status: status ?? this.status,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      namaVendor: namaVendor ?? this.namaVendor,
      emailVendor: emailVendor ?? this.emailVendor,
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }

  static String _formatRupiah(int value) {
    final text = value.toString();
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      final indexFromEnd = text.length - i;
      buffer.write(text[i]);

      if (indexFromEnd > 1 && indexFromEnd % 3 == 1) {
        buffer.write('.');
      }
    }

    return 'Rp$buffer / hari';
  }
}
