import 'package:flutter/material.dart';

import '../models/app_notification_model.dart';

class NotificationProvider extends ChangeNotifier {
  final List<AppNotificationModel> _items = [];

  List<AppNotificationModel> get items => List.unmodifiable(_items);

  int get unreadCount => _items.where((item) => !item.isRead).length;

  void addStatusNotification({
    required String alatName,
    required String status,
  }) {
    final title = _titleByStatus(status);
    final body = _bodyByStatus(alatName, status);

    _items.insert(
      0,
      AppNotificationModel(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title,
        body: body,
        type: 'booking_status',
        createdAt: DateTime.now(),
      ),
    );

    notifyListeners();
  }

  void addVendorOrderNotification({
    required String alatName,
    required String petaniName,
  }) {
    _items.insert(
      0,
      AppNotificationModel(
        id: DateTime.now().millisecondsSinceEpoch,
        title: 'Pesanan Baru Masuk',
        body: '$petaniName mengajukan sewa untuk $alatName.',
        type: 'new_order',
        createdAt: DateTime.now(),
      ),
    );

    notifyListeners();
  }

  void markAllAsRead() {
    for (int i = 0; i < _items.length; i++) {
      _items[i] = _items[i].copyWith(isRead: true);
    }

    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  String _titleByStatus(String status) {
    switch (status) {
      case 'diterima':
        return 'Booking Diterima';
      case 'ditolak':
        return 'Booking Ditolak';
      case 'selesai':
        return 'Sewa Selesai';
      default:
        return 'Update Booking';
    }
  }

  String _bodyByStatus(String alatName, String status) {
    switch (status) {
      case 'diterima':
        return 'Booking $alatName sudah diterima vendor.';
      case 'ditolak':
        return 'Booking $alatName ditolak vendor. Stok alat dikembalikan.';
      case 'selesai':
        return 'Penyewaan $alatName sudah selesai.';
      default:
        return 'Status booking $alatName diperbarui menjadi $status.';
    }
  }
}
