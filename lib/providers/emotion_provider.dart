import 'package:calm_notes/models/emotion.dart';
import 'package:calm_notes/services/database_service.dart';
import 'package:flutter/material.dart';

class EmotionProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService.instance;
  List<Emotion> _emotions = [];
  List<Emotion> _emotionsToDisplay = [];
  Emotion? _selectedEmotion;
  Emotion? _previousSelectedEmotion;

  List<Emotion> get emotions => _emotions;
  List<Emotion> get emotionsToDisplay => _emotionsToDisplay;
  Emotion? get selectedEmotion => _selectedEmotion;
  Emotion? get previousSelectedEmotion => _previousSelectedEmotion;

  EmotionProvider() {
    fetchEmotions();
  }

  Future<void> setSelectedEmotion(Emotion? emotion) async {
    _previousSelectedEmotion = _selectedEmotion;
    _selectedEmotion = emotion;
    notifyListeners();
  }

  Future<void> setDefaultSelectedEmotion() async {
    if (_selectedEmotion == null) {
      _previousSelectedEmotion = null;
      _selectedEmotion = _emotions.first;
      notifyListeners();
    }
  }

  // Combines two lists of emotions, updating existing ones and adding new ones.
  List<Emotion> _mergeEmotionLists(List<Emotion> list1, List<Emotion> list2) {
    Map<int, Emotion> map2 = {for (var e in list2) e.id!: e};

    List<Emotion> updatedList = list1
        .map((emotion) {
          if (map2.containsKey(emotion.id)) {
            return emotion.updateFrom(map2[emotion.id]!);
          }
          return null;
        })
        .whereType<Emotion>()
        .toList();

    List<Emotion> newElements = map2.entries
        .where((entry) => !list1.any((e) => e.id == entry.key))
        .map((entry) => entry.value)
        .toList();

    updatedList.addAll(newElements);

    return updatedList;
  }

  Future<void> fetchEmotions() async {
    _emotions = await _databaseService.fetchEmotions();
    _emotionsToDisplay = _mergeEmotionLists(
        _emotionsToDisplay, await _databaseService.fetchEmotionsToDisplay());
    if (_selectedEmotion == null) {
      setDefaultSelectedEmotion();
    }
    notifyListeners();
  }

  Future<void> fetchDisplayedEmotions() async {
    _emotionsToDisplay = await _databaseService.fetchEmotionsToDisplay();
    notifyListeners();
  }

  Future<void> deleteEmotion(Emotion emotion) async {
    await _databaseService.deleteEmotion(emotion.id!);
    await fetchEmotions();
  }

  Future<void> incrementEmotion(Emotion emotion) async {
    await _databaseService.incrementSelectedEmotionCount(emotion.id!);
    await fetchEmotions();
  }

  Future<void> resetSelectedEmotion(Emotion emotion) async {
    await _databaseService.resetSelectedEmotionCount(emotion.id!);
    await fetchEmotions();
  }

  Future<void> resetEmotions() async {
    await _databaseService.resetSelectedEmotionsCount();
    await fetchEmotions();
  }

  Future<void> setEmotions(int id) async {
    await _databaseService.setSelectedEmotionsCount(id);
    await fetchEmotions();
  }
}
