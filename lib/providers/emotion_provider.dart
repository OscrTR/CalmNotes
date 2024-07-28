import 'package:flutter/material.dart';

class EmotionProvider extends ChangeNotifier {
  final Map<String, int> _selectedEmotionCounts = {};

  Map<String, int> get selectedEmotionCounts => _selectedEmotionCounts;

  void incrementEmotion(String emotion) {
    if (_selectedEmotionCounts.containsKey(emotion)) {
      if (_selectedEmotionCounts[emotion]! < 10) {
        _selectedEmotionCounts[emotion] = _selectedEmotionCounts[emotion]! + 1;
      }
    } else {
      _selectedEmotionCounts[emotion] = 1;
    }
    notifyListeners();
  }

  void decrementEmotion(String emotion) {
    if (_selectedEmotionCounts[emotion]! > 1) {
      _selectedEmotionCounts[emotion] = _selectedEmotionCounts[emotion]! - 1;
    } else {
      _selectedEmotionCounts.remove(emotion);
    }
    notifyListeners();
  }
}
