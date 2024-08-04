import 'package:calm_notes/models/emotion.dart';
import 'package:calm_notes/services/database_service.dart';
import 'package:flutter/material.dart';

class EmotionProvider extends ChangeNotifier {
  final Map<String, int> _selectedEmotionCounts = {};
  final DatabaseService _databaseService = DatabaseService.instance;
  List<Emotion> _emotions = [];

  Map<String, int> get selectedEmotionCounts => _selectedEmotionCounts;
  List<Emotion> get emotions => _emotions;

  EmotionProvider() {
    _fetchEmotions();
  }

  Future<void> _fetchEmotions() async {
    _emotions = await _databaseService.getEmotions();
    notifyListeners();
  }

  Future<void> addEmotion(String name) async {
    _databaseService.addEmotion(name);
    await _fetchEmotions();
  }

  Future<void> deleteEmotion(int id, String emotionName) async {
    _databaseService.deleteEmotion(id);
    _selectedEmotionCounts.remove(emotionName);
    await _fetchEmotions();
  }

  void incrementEmotion(String emotion) {
    if (_selectedEmotionCounts.containsKey(emotion)) {
      if (_selectedEmotionCounts[emotion]! < 10) {
        _selectedEmotionCounts[emotion] = _selectedEmotionCounts[emotion]! + 1;
      }
    } else {
      _selectedEmotionCounts[emotion] = 1;
    }

    print(_selectedEmotionCounts);
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

  void resetEmotions() {
    _selectedEmotionCounts.clear();
    notifyListeners();
  }

  void setEmotions(Map<String, int> newEmotions) {
    _selectedEmotionCounts.clear();
    _selectedEmotionCounts.addAll(newEmotions);
  }
}
