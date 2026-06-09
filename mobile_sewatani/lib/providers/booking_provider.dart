import 'package:flutter/material.dart';

import '../models/booking_model.dart';
import '../services/api_service.dart';

class BookingProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  final List<BookingModel> _bookings = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _lastNotificationMessage;

  List<BookingModel> get items => List.unmodifiable(_bookings);
  List<BookingModel> get bookings => List.unmodifiable(_bookings);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get lastNotificationMessage => _lastNotificationMessage;

  int get waitingOrders =>
      _bookings.where((item) => item.status == 'menunggu').length;

  int get totalMenunggu => waitingOrders;

  int get totalDiterima =>
      _bookings.where((item) => item.status == 'diterima').length;

  Future<void> fetchBookings({int? userId, int? vendorId}) async {
    _setLoading(true);

    try {
      String endpoint;

      if (vendorId != null && vendorId > 0) {
        endpoint = 'booking/get_by_vendor.php?id_vendor=$vendorId';
      } else {
        endpoint = 'booking/get_by_user.php?id_user=${userId ?? 2}';
      }

      final response = await _apiService.get(endpoint);
      final data = response['data'];

      _bookings
        ..clear()
        ..addAll(
          (data as List)
              .map(
                (item) =>
                    BookingModel.fromJson(Map<String, dynamic>.from(item)),
              )
              .toList(),
        );

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _setLoading(false);
  }

  Future<bool> createBooking(BookingModel booking) async {
    _setLoading(true);

    try {
      final response = await _apiService.post(
        'booking/create.php',
        booking.toCreateJson(),
      );

      final created = BookingModel.fromJson(
        Map<String, dynamic>.from(response['data']),
      );

      _bookings.insert(0, created);
      _lastNotificationMessage =
          'Booking ${created.namaAlat} berhasil dibuat. Vendor akan menerima pesanan.';
      _errorMessage = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> updateStatus(int id, String status) async {
    _setLoading(true);

    try {
      final response = await _apiService.post(
        'booking/update_status.php',
        {
          'id_booking': id,
          'status': status,
        },
      );

      final updated = BookingModel.fromJson(
        Map<String, dynamic>.from(response['data']),
      );

      final index = _bookings.indexWhere((item) => item.id == updated.id);
      if (index != -1) {
        _bookings[index] = updated;
      }

      _lastNotificationMessage = _notificationMessage(updated.namaAlat, status);
      _errorMessage = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  String _notificationMessage(String alatName, String status) {
    switch (status) {
      case 'diterima':
        return 'Notifikasi: Booking $alatName diterima vendor.';
      case 'ditolak':
        return 'Notifikasi: Booking $alatName ditolak dan stok dikembalikan.';
      case 'selesai':
        return 'Notifikasi: Penyewaan $alatName selesai.';
      default:
        return 'Notifikasi: Status booking $alatName diperbarui.';
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
