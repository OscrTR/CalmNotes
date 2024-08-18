import 'package:calm_notes/models/emotion.dart';
import 'package:calm_notes/services/database_service.dart';
import 'package:flutter/material.dart';

class EmotionProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService.instance;
  List<Emotion> _emotions = [];
  List<Emotion> _emotionsToDisplay = [];

  List<Emotion> get emotions => _emotions;
  List<Emotion> get emotionsToDisplay => _emotionsToDisplay;

  EmotionProvider() {
    _fetchEmotions();
  }

  Future<void> _fetchEmotions() async {
    _emotions = await _databaseService.fetchEmotions();
    _emotionsToDisplay = await _fetchAndCombineEmotionsToDisplay();
    notifyListeners();
  }

  Future<List<Emotion>> _fetchAndCombineEmotionsToDisplay() async {
    final fetchedEmotionsToDisplay =
        await _databaseService.fetchEmotionsToDisplay();
    return _combineLists(_emotionsToDisplay, fetchedEmotionsToDisplay);
  }

  List<Emotion> _combineLists(List<Emotion> list1, List<Emotion> list2) {
    final map2 = {for (var e in list2) e.id!: e};

    final updatedList = [
      for (var emotion in list1)
        if (map2.containsKey(emotion.id))
          emotion.updateFrom(map2.remove(emotion.id)!)
    ];

    updatedList.addAll(map2.values);

    return updatedList;
  }

  Future<void> _updateEmotionsAfterChange() async {
    _emotions = await _databaseService.fetchEmotions();
    _emotionsToDisplay = await _fetchAndCombineEmotionsToDisplay();
    notifyListeners();
  }

  Future<void> addEmotion(String name) async {
    await _databaseService.addEmotion(name);
    await _updateEmotionsAfterChange();
  }

  Future<void> deleteEmotion(int id) async {
    await _databaseService.deleteEmotion(id);
    await _updateEmotionsAfterChange();
  }

  Future<void> incrementEmotion(Emotion emotion) async {
    if (emotion.id == null) {
      print('Emotion ID is null. Cannot increment.');
      return;
    }
    await _databaseService.incrementSelectedEmotionCount(emotion.id!);
    _updateEmotionInList(emotion.id!, (e) => e.selectedCount++);
    notifyListeners();
  }

  Future<void> addAndIncrementEmotion(String emotionName) async {
    int emotionId = await _databaseService.addEmotion(emotionName);
    await _databaseService.incrementSelectedEmotionCount(emotionId);
    await _updateEmotionsAfterChange();
  }

  Future<void> resetSelectedEmotion(Emotion emotion) async {
    await _databaseService.resetSelectedEmotionCount(emotion.id!);
    await _updateEmotionsAfterChange();
  }

  Future<void> resetEmotions() async {
    await _databaseService.resetSelectedEmotionsCount();
    await _updateEmotionsAfterChange();
  }

  Future<void> setEmotions(int id) async {
    await _databaseService.setSelectedEmotionsCount(id);
    await _updateEmotionsAfterChange();
  }

  void _updateEmotionInList(int emotionId, void Function(Emotion) update) {
    // Handle _emotions list
    final emotion = _emotions.firstWhere(
      (e) => e.id == emotionId,
      orElse: () => throw StateError('Emotion not found in _emotions list'),
    );
    update(emotion);

    final selectedEmotions =
        emotions.where((e) => e.selectedCount > 0).toList();

    if (selectedEmotions.length >= 3) {
      _emotionsToDisplay = selectedEmotions;
      return;
    }

    final unselectedEmotions =
        emotions.where((e) => e.selectedCount == 0).toList();
    final minRequired = 3 - selectedEmotions.length;

    _emotionsToDisplay =
        selectedEmotions + unselectedEmotions.take(minRequired).toList();

    notifyListeners();
  }
}
