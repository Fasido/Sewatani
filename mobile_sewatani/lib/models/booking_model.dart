class BookingModel {
  final int id;
  final int userId;
  final int alatId;
  final int vendorId;
  final String namaAlat;
  final String namaPetani;
  final String namaVendor;
  final String tanggalMulai;
  final String tanggalSelesai;
  final String alamat;
  final String catatan;
  final String status;
  final String fotoUrl;

  const BookingModel({
    required this.id,
    this.userId = 0,
    this.alatId = 0,
    this.vendorId = 0,
    required this.namaAlat,
    this.namaPetani = '',
    this.namaVendor = '',
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.alamat,
    this.catatan = '',
    required this.status,
    this.fotoUrl = '',
  });

  // ===== Alias agar cocok dengan UI lama dan UI baru =====
  int get idBooking => id;
  int get idUser => userId;
  int get idAlat => alatId;
  int get idVendor => vendorId;

  String get title => namaAlat;
  String get alatName => namaAlat;
  String get renterName => namaPetani;
  String get vendorName => namaVendor;
  String get startDate => tanggalMulai;
  String get endDate => tanggalSelesai;
  String get address => alamat;
  String get note => catatan;
  String get dateRange => '$tanggalMulai - $tanggalSelesai';

  String get imageAsset => _localImageAsset;
  String get statusLabel {
    switch (status) {
      case 'diterima':
        return 'Diterima';
      case 'ditolak':
        return 'Ditolak';
      case 'selesai':
        return 'Selesai';
      default:
        return 'Menunggu';
    }
  }

  String get _localImageAsset {
    final file = fotoUrl.toLowerCase();
    final alatNameLower = namaAlat.toLowerCase();

    if (file.contains('pompa') || alatNameLower.contains('pompa')) {
      return 'assets/images/alat_pompa_air.png';
    }

    if (file.contains('cultivator') || alatNameLower.contains('cultivator')) {
      return 'assets/images/alat_cultivator.png';
    }

    if (file.contains('harvester') ||
        file.contains('panen') ||
        alatNameLower.contains('panen')) {
      return 'assets/images/alat_harvester.png';
    }

    return 'assets/images/alat_traktor.png';
  }

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: _toInt(json['id_booking'] ?? json['id'] ?? json['idBooking']),
      userId: _toInt(json['id_user'] ?? json['userId'] ?? json['idUser']),
      alatId: _toInt(json['id_alat'] ?? json['alatId'] ?? json['idAlat']),
      vendorId: _toInt(json['id_vendor'] ?? json['vendorId'] ?? json['idVendor']),
      namaAlat:
          (json['nama_alat'] ?? json['namaAlat'] ?? json['alatName'] ?? '')
              .toString(),
      namaPetani: (json['nama_petani'] ??
              json['namaPetani'] ??
              json['renterName'] ??
              '')
          .toString(),
      namaVendor: (json['nama_vendor'] ??
              json['namaVendor'] ??
              json['vendorName'] ??
              '')
          .toString(),
      tanggalMulai: (json['tanggal_mulai'] ??
              json['tanggalMulai'] ??
              json['startDate'] ??
              '')
          .toString(),
      tanggalSelesai: (json['tanggal_selesai'] ??
              json['tanggalSelesai'] ??
              json['endDate'] ??
              '')
          .toString(),
      alamat: (json['alamat'] ?? json['address'] ?? '').toString(),
      catatan: (json['catatan'] ?? json['note'] ?? '').toString(),
      status: (json['status'] ?? 'menunggu').toString(),
      fotoUrl: (json['foto_url'] ?? json['fotoUrl'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toCreateJson() {
    return {
      'id_user': userId,
      'id_alat': alatId,
      'id_vendor': vendorId,
      'tanggal_mulai': tanggalMulai,
      'tanggal_selesai': tanggalSelesai,
      'alamat': alamat,
      'catatan': catatan,
    };
  }

  BookingModel copyWith({
    int? id,
    int? userId,
    int? alatId,
    int? vendorId,
    String? namaAlat,
    String? namaPetani,
    String? namaVendor,
    String? tanggalMulai,
    String? tanggalSelesai,
    String? alamat,
    String? catatan,
    String? status,
    String? fotoUrl,
  }) {
    return BookingModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      alatId: alatId ?? this.alatId,
      vendorId: vendorId ?? this.vendorId,
      namaAlat: namaAlat ?? this.namaAlat,
      namaPetani: namaPetani ?? this.namaPetani,
      namaVendor: namaVendor ?? this.namaVendor,
      tanggalMulai: tanggalMulai ?? this.tanggalMulai,
      tanggalSelesai: tanggalSelesai ?? this.tanggalSelesai,
      alamat: alamat ?? this.alamat,
      catatan: catatan ?? this.catatan,
      status: status ?? this.status,
      fotoUrl: fotoUrl ?? this.fotoUrl,
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}
