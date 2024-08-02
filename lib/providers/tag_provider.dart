import 'package:flutter/material.dart';

class TagProvider extends ChangeNotifier {
  final Map<String, int> _selectedtagCounts = {};

  Map<String, int> get selectedtagCounts => _selectedtagCounts;

  void incrementtag(String tag) {
    if (_selectedtagCounts.containsKey(tag)) {
      if (_selectedtagCounts[tag]! < 10) {
        _selectedtagCounts[tag] = _selectedtagCounts[tag]! + 1;
      }
    } else {
      _selectedtagCounts[tag] = 1;
    }
    notifyListeners();
  }

  void decrementtag(String tag) {
    if (_selectedtagCounts[tag]! > 1) {
      _selectedtagCounts[tag] = _selectedtagCounts[tag]! - 1;
    } else {
      _selectedtagCounts.remove(tag);
    }
    notifyListeners();
  }

  void resettags() {
    _selectedtagCounts.clear();
    notifyListeners();
  }

  void settags(Map<String, int> newtags) {
    _selectedtagCounts.clear();
    _selectedtagCounts.addAll(newtags);
  }
}
