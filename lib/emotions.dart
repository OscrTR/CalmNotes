import 'package:calm_notes/providers/emotion_provider.dart';
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

  @override
  Widget build(BuildContext context) {
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
