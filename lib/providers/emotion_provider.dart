import 'package:calm_notes/models/emotion.dart';
import 'package:calm_notes/services/database_service.dart';
import 'package:flutter/material.dart';

class EmotionProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService.instance;
  List<Emotion> _emotions = [];
  List<Emotion> _emotionsToDisplay = [];
  List<Emotion> _emotionsInDialog = [];

  List<Emotion> get emotions => _emotions;
  List<Emotion> get emotionsToDisplay => _emotionsToDisplay;
  List<Emotion> get emotionsInDialog => _emotionsInDialog;

  EmotionProvider() {
    fetchEmotions();
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

  // Updates the list of emotions displayed and those in the dialog.
  void _updateDisplayedAndDialogEmotions() {
    _emotionsInDialog = _emotions
        .where((emotion) => !_emotionsToDisplay
            .any((displayedEmotion) => emotion.id == displayedEmotion.id))
        .toList();
  }

  Future<void> fetchEmotions() async {
    _emotions = await _databaseService.fetchEmotions();
    _emotionsToDisplay = _mergeEmotionLists(
        _emotionsToDisplay, await _databaseService.fetchEmotionsToDisplay());
    _updateDisplayedAndDialogEmotions();
    notifyListeners();
  }

  Future<void> fetchDisplayedEmotions() async {
    _emotionsToDisplay = await _databaseService.fetchEmotionsToDisplay();
    _updateDisplayedAndDialogEmotions();
    notifyListeners();
  }

  Future<void> addEmotion(String name) async {
    await _databaseService.addEmotion(name);
    await fetchEmotions();
  }

  Future<void> deleteEmotion(Emotion emotion) async {
    await _databaseService.deleteEmotion(emotion.id!);
    await fetchEmotions();
  }

  Future<void> incrementEmotion(Emotion emotion) async {
    await _databaseService.incrementSelectedEmotionCount(emotion.id!);
    await fetchEmotions();
  }

  Future<void> addAndIncrementEmotion(String emotionName) async {
    final int emotionId = await _databaseService.addEmotion(emotionName);
    await _databaseService.incrementSelectedEmotionCount(emotionId);
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
