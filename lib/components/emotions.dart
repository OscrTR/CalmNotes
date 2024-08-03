import 'package:calm_notes/providers/emotion_provider.dart';
import 'package:calm_notes/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Emotions extends StatelessWidget {
  Emotions({super.key});

  // List of all possible emotions
  final List<String> _emotions = [
    'fear',
    'anger',
    'disgust',
    'sad',
    'happy',
    'surprise',
  ];

  final DatabaseService _databaseService = DatabaseService.instance;

  Future<void> _fetchEmotions() async {
    final data = await _databaseService.getEmotions();
    print(data);
  }

  //TODO
  // 1) Retrieve list of emotions from DB ordered by last use
  // 2) Display the first 3 elements
  // 3) Add button for new emotion
  // 4) Fetch again the emotions

  @override
  Widget build(BuildContext context) {
    _fetchEmotions();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          children: _emotions.map((emotion) {
            return OutlinedButton(
              onPressed: () {
                // Access the provider and increment the emotion count
                context.read<EmotionProvider>().incrementEmotion(emotion);
              },
              child: Text(emotion),
            );
          }).toList(),
        ),
        Consumer<EmotionProvider>(
          builder: (context, emotionProvider, child) {
            return Wrap(
              spacing: 10,
              children: _emotions
                  .where((emotion) => emotionProvider.selectedEmotionCounts
                      .containsKey(emotion))
                  .map((emotion) {
                // If selected, show a filled button with count
                return FilledButton(
                  onPressed: () {
                    // Access the provider and decrement the emotion count
                    emotionProvider.decrementEmotion(emotion);
                  },
                  child: Text(
                      '$emotion (${emotionProvider.selectedEmotionCounts[emotion]})'),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
