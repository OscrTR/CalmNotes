import 'package:calm_notes/models/emotion.dart';
import 'package:calm_notes/services/database_service.dart';
import 'package:flutter/material.dart';

class EmotionProvider extends ChangeNotifier {
  final Map<String, int> _selectedEmotionCounts = {};
  final DatabaseService _databaseService = DatabaseService.instance;
  List<Emotion> _emotions = [];
  List<Emotion> _selectedEmotions = [];
  List<Emotion> _lastUsedEmotions = [];
  final List<Emotion> _emotionsToDisplay = [];

  Map<String, int> get selectedEmotionCounts => _selectedEmotionCounts;
  List<Emotion> get emotions => _emotions;
  List<Emotion> get selectedEmotions => _selectedEmotions;
  List<Emotion> get lastUsedEmotions => _lastUsedEmotions;
  List<Emotion> get emotionsToDisplay => _emotionsToDisplay;

  EmotionProvider() {
    _fetchEmotions();
  }

  Future<void> _fetchEmotions() async {
    _emotions = await _databaseService.getEmotions();
    _lastUsedEmotions = emotions.take(3).toList();

    for (var e in _selectedEmotions) {
      if (_emotionsToDisplay.isEmpty) {
        _emotionsToDisplay.add(e);
      } else {
        bool notAlreadyDisplayed = true;
        for (var emotion in _emotionsToDisplay) {
          if (emotion.id == e.id) {
            notAlreadyDisplayed = false;
          }
        }
        if (notAlreadyDisplayed) {
          _emotionsToDisplay.add(e);
        }
      }
    }

    if (_selectedEmotions.length < 3) {
      for (var e in _lastUsedEmotions) {
        if (_emotionsToDisplay.length >= 3) {
          break; // Stop adding once we have 3 emotions
        }
        if (!_selectedEmotions.contains(e)) {
          _emotionsToDisplay.add(e);
        }
      }
    }
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

  void incrementEmotion(Emotion emotion) async {
    if (_selectedEmotionCounts.containsKey(emotion.name)) {
      if (_selectedEmotionCounts[emotion.name]! < 10) {
        _selectedEmotionCounts[emotion.name] =
            _selectedEmotionCounts[emotion.name]! + 1;
      }
    } else {
      _selectedEmotionCounts[emotion.name] = 1;
    }
    _selectedEmotions = await getSelectedEmotionsList();

    // If incremented emotion not in recent emotions, update its use
    _lastUsedEmotions = emotions.take(3).toList();
    bool emotionDisplayed = _lastUsedEmotions.any((e) => e.id == emotion.id);
    if (!emotionDisplayed) {
      _databaseService.updateEmotionUse(emotion.id);
    }
    await _fetchEmotions();
  }

  void addAndIncrementEmotion(String emotionName) async {
    int emotionId = await _databaseService.addEmotion(emotionName);
    if (_selectedEmotionCounts.containsKey(emotionName)) {
      if (_selectedEmotionCounts[emotionName]! < 10) {
        _selectedEmotionCounts[emotionName] =
            _selectedEmotionCounts[emotionName]! + 1;
      }
    } else {
      _selectedEmotionCounts[emotionName] = 1;
    }
    _databaseService.updateEmotionUse(emotionId);
    await _fetchEmotions();
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

  Future<List<Emotion>> getSelectedEmotionsList() async {
    List<Emotion> selectedEmotionsList = [];

    for (String selectedEmotionName in _selectedEmotionCounts.keys) {
      for (Emotion emotion in _emotions) {
        if (emotion.name == selectedEmotionName) {
          selectedEmotionsList.add(emotion);
          break;
        }
      }
    }
    return selectedEmotionsList;
  }
}
