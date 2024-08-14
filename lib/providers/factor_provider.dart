import 'package:flutter/material.dart';

class FactorProvider with ChangeNotifier {
  String _selectedFactor = '';

  String get selectedFactor => _selectedFactor;

  FactorProvider() {
    _fetchFactors();
  }

  Future<void> _fetchFactors() async {
    notifyListeners();
  }

  void selectFactor(String factor) {
    _selectedFactor = factor;
    notifyListeners();
  }

  void removeFactor() {
    _selectedFactor = '';
    notifyListeners();
  }
}
