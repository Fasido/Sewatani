import 'package:flutter/material.dart';

import '../models/alat_model.dart';
import '../services/api_service.dart';

class AlatProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  final List<AlatModel> _items = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _keyword = '';
  String? _selectedCategory;

  List<AlatModel> get items {
    Iterable<AlatModel> result = _items;

    if (_keyword.trim().isNotEmpty) {
      final query = _keyword.toLowerCase();
      result = result.where((alat) {
        return alat.namaAlat.toLowerCase().contains(query) ||
            alat.kategori.toLowerCase().contains(query);
      });
    }

    if (_selectedCategory != null && _selectedCategory!.isNotEmpty) {
      result = result.where((alat) => alat.kategori == _selectedCategory);
    }

    return result.toList();
  }

  // Alias untuk UI lama.
  List<AlatModel> get allItems => List.unmodifiable(_items);
  List<AlatModel> get rawItems => List.unmodifiable(_items);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get keyword => _keyword;
  String? get selectedCategory => _selectedCategory;

  Future<void> fetchAlat() async {
    _setLoading(true);

    try {
      final response = await _apiService.get('alat/get_all.php');
      final data = response['data'];

      _items
        ..clear()
        ..addAll(
          (data as List)
              .map((item) => AlatModel.fromJson(Map<String, dynamic>.from(item)))
              .toList(),
        );

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _setLoading(false);
  }

  Future<void> fetchByVendor(int vendorId) async {
    _setLoading(true);

    try {
      final response =
          await _apiService.get('alat/get_by_vendor.php?id_vendor=$vendorId');

      final data = response['data'];

      _items
        ..clear()
        ..addAll(
          (data as List)
              .map((item) => AlatModel.fromJson(Map<String, dynamic>.from(item)))
              .toList(),
        );

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _setLoading(false);
  }

  Future<bool> addAlat(AlatModel alat) async {
    _setLoading(true);

    try {
      final response = await _apiService.post(
        'alat/create.php',
        alat.toCreateJson(),
      );

      final created = AlatModel.fromJson(
        Map<String, dynamic>.from(response['data']),
      );

      _items.insert(0, created);
      _errorMessage = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> updateAlat(AlatModel alat) async {
    _setLoading(true);

    try {
      final response = await _apiService.post(
        'alat/update.php',
        alat.toJson(),
      );

      final updated = AlatModel.fromJson(
        Map<String, dynamic>.from(response['data']),
      );

      final index = _items.indexWhere((item) => item.id == updated.id);
      if (index != -1) {
        _items[index] = updated;
      }

      _errorMessage = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> deleteAlat(int id) async {
    _setLoading(true);

    try {
      await _apiService.post('alat/delete.php', {'id_alat': id});
      _items.removeWhere((item) => item.id == id);
      _errorMessage = null;
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  void search(String value) {
    setKeyword(value);
  }

  void setKeyword(String value) {
    _keyword = value;
    notifyListeners();
  }

  void clearSearch() {
    setKeyword('');
  }

  void setCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void clearCategory() {
    setCategory(null);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
