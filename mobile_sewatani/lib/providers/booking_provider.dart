import 'package:flutter/foundation.dart';

import '../models/booking_preview.dart';

class BookingProvider extends ChangeNotifier {
  final List<BookingPreview> _items = [];
  bool _isLoading = false;

  List<BookingPreview> get items => List.unmodifiable(_items);
  bool get isLoading => _isLoading;

  int get totalOrders => _items.length;
  int get waitingOrders => _items.where((item) => item.status == 'Menunggu').length;
  int get acceptedOrders => _items.where((item) => item.status == 'Diterima').length;

  Future<void> fetchBookings() async {
    if (_items.isNotEmpty) return;

    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    _items.addAll(const [
      BookingPreview(
        id: 1,
        alatName: 'Traktor Roda 2',
        renterName: 'Fasido',
        dateRange: '10 Jun 2026 - 11 Jun 2026',
        address: 'Lohbener, Indramayu',
        status: 'Menunggu',
      ),
      BookingPreview(
        id: 2,
        alatName: 'Pompa Air Sawah',
        renterName: 'Petani Indramayu',
        dateRange: '08 Jun 2026 - 08 Jun 2026',
        address: 'Jatibarang, Indramayu',
        status: 'Diterima',
      ),
    ]);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateStatus(int id, String status) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (index == -1) return;

    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 450));

    _items[index] = _items[index].copyWith(status: status);
    _isLoading = false;
    notifyListeners();
  }
}
