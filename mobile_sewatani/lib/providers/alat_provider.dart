import 'package:flutter/foundation.dart';

import '../models/alat_preview.dart';

class AlatProvider extends ChangeNotifier {
  final List<AlatPreview> _items = [];
  bool _isLoading = false;
  String? _selectedCategory;
  String _keyword = '';

  List<AlatPreview> get items {
    return _items.where((item) {
      final matchCategory = _selectedCategory == null || item.category == _selectedCategory;
      final matchKeyword = _keyword.isEmpty ||
          item.name.toLowerCase().contains(_keyword.toLowerCase()) ||
          item.category.toLowerCase().contains(_keyword.toLowerCase());
      return matchCategory && matchKeyword;
    }).toList(growable: false);
  }

  List<AlatPreview> get allItems => List.unmodifiable(_items);
  bool get isLoading => _isLoading;
  String? get selectedCategory => _selectedCategory;
  String get keyword => _keyword;

  Future<void> fetchAlat() async {
    if (_items.isNotEmpty) return;

    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 650));

    _items.addAll(demoAlatList);
    _isLoading = false;
    notifyListeners();
  }

  void setCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setKeyword(String value) {
    _keyword = value;
    notifyListeners();
  }
}
