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

  List<Emotion> combineLists(List<Emotion> list1, List<Emotion> list2) {
    // Create a map from list2 for quick lookup by id
    Map<int, Emotion> map2 = {for (var e in list2) e.id!: e};

    // Create a new list with updated values from list2
    List<Emotion> updatedList = list1
        .map((emotion) {
          if (map2.containsKey(emotion.id)) {
            // Update the emotion from list1 with values from list2
            return emotion.updateFrom(map2[emotion.id]!);
          }
          // If not in list2, exclude this emotion
          return null;
        })
        .whereType<Emotion>()
        .toList();

    // Add new elements from list2 that were not in list1
    List<Emotion> newElements = map2.entries
        .where((entry) => !list1.any((e) => e.id == entry.key))
        .map((entry) => entry.value)
        .toList();

    // Combine the updated list1 with new elements from list2
    updatedList.addAll(newElements);

    return updatedList;
  }

  Future<void> _fetchEmotions() async {
    _emotions = await _databaseService.fetchEmotions();
    final fetchedEmotionsToDisplay =
        await _databaseService.fetchEmotionsToDisplay();
    _emotionsToDisplay =
        combineLists(_emotionsToDisplay, fetchedEmotionsToDisplay);
    notifyListeners();
  }

  Future<void> fetchDisplayedEmotions() async {
    _emotionsToDisplay = await _databaseService.fetchEmotionsToDisplay();
    notifyListeners();
  }

  Future<void> addEmotion(String name) async {
    _databaseService.addEmotion(name);
    await _fetchEmotions();
  }

  Future<void> deleteEmotion(Emotion emotion) async {
    _databaseService.deleteEmotion(emotion.id!);
    await _fetchEmotions();
  }

  void incrementEmotion(Emotion emotion) async {
    await _databaseService.incrementSelectedEmotionCount(emotion.id!);
    await _fetchEmotions();
  }

  void addAndIncrementEmotion(String emotionName) async {
    int emotionId = await _databaseService.addEmotion(emotionName);
    await _databaseService.incrementSelectedEmotionCount(emotionId);
    await _fetchEmotions();
  }

  void resetSelectedEmotion(Emotion emotion) async {
    await _databaseService.resetSelectedEmotionCount(emotion.id!);
    await _fetchEmotions();
  }

  void resetEmotions() async {
    await _databaseService.resetSelectedEmotionsCount();
    await _fetchEmotions();
  }

  Future<void> setEmotions(int id) async {
    await _databaseService.setSelectedEmotionsCount(id);
    await _fetchEmotions();
  }
}
