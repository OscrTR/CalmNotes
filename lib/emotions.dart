import 'package:flutter/material.dart';

class Emotions extends StatefulWidget {
  const Emotions({super.key});

  @override
  State<Emotions> createState() => _EmotionsState();
}

class _EmotionsState extends State<Emotions> {
  // Map to track selected emotions and their counts
  final Map<String, int> _selectedEmotionCounts = {};

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
                setState(() {
                  // Increment count or add the emotion if not already present
                  if (_selectedEmotionCounts.containsKey(emotion)) {
                    if (_selectedEmotionCounts[emotion]! < 10) {
                      _selectedEmotionCounts[emotion] =
                          _selectedEmotionCounts[emotion]! + 1;
                    }
                  } else {
                    _selectedEmotionCounts[emotion] = 1;
                  }
                });
              },
              child: Text(emotion),
            );
          }).toList(),
        ),
        Wrap(
          spacing: 10,
          children: _emotions
              .where((emotion) => _selectedEmotionCounts.containsKey(emotion))
              .map((emotion) {
            // If selected, show a filled button with count
            return FilledButton(
              onPressed: () {
                setState(() {
                  // Decrement count or remove the emotion if count is 1
                  if (_selectedEmotionCounts[emotion]! > 1) {
                    _selectedEmotionCounts[emotion] =
                        _selectedEmotionCounts[emotion]! - 1;
                  } else {
                    _selectedEmotionCounts.remove(emotion);
                  }
                });
              },
              child: Text('$emotion (${_selectedEmotionCounts[emotion]})'),
            );
          }).toList(),
        ),
      ],
    );
  }
}
