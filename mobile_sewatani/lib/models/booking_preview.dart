class BookingPreview {
  final int id;
  final String alatName;
  final String renterName;
  final String dateRange;
  final String address;
  final String status;

  const BookingPreview({
    required this.id,
    required this.alatName,
    required this.renterName,
    required this.dateRange,
    required this.address,
    required this.status,
  });

  BookingPreview copyWith({
    int? id,
    String? alatName,
    String? renterName,
    String? dateRange,
    String? address,
    String? status,
  }) {
    return BookingPreview(
      id: id ?? this.id,
      alatName: alatName ?? this.alatName,
      renterName: renterName ?? this.renterName,
      dateRange: dateRange ?? this.dateRange,
      address: address ?? this.address,
      status: status ?? this.status,
    );
  }
}
