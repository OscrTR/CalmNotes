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
    _emotions = await _databaseService.getEmotions();
    final fetchedEmotionsToDisplay =
        await _databaseService.fetchEmotionsToDisplay();
    _emotionsToDisplay = List.from(fetchedEmotionsToDisplay);
    notifyListeners();
  }

  Future<void> addEmotion(String name) async {
    _databaseService.addEmotion(name);
    await _fetchEmotions();
  }

  Future<void> deleteEmotion(int id, String emotionName) async {
    _databaseService.deleteEmotion(id);
    await _fetchEmotions();
  }

  void incrementEmotion(Emotion emotion) async {
    await _databaseService.incrementSelectedEmotionCount(emotion.id);
    await _fetchEmotions();
  }

  void addAndIncrementEmotion(String emotionName) async {
    int emotionId = await _databaseService.addEmotion(emotionName);
    await _databaseService.incrementSelectedEmotionCount(emotionId);
    await _fetchEmotions();
  }

  void decrementEmotion(Emotion emotion) async {
    await _databaseService.decrementSelectedEmotionCount(emotion.id);
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
