import 'package:calm_notes/colors.dart';
import 'package:calm_notes/models/emotion.dart';
import 'package:calm_notes/providers/emotion_provider.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

class Emotions extends StatefulWidget {
  const Emotions({super.key});

  @override
  State<Emotions> createState() => _EmotionsState();
}

class _EmotionsState extends State<Emotions> {
  final TextEditingController _emotionNameController = TextEditingController();

  @override
  void dispose() {
    _emotionNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildEmotionButtons(context),
        _buildSelectedEmotions(context),
      ],
    );
  }

  Widget _buildEmotionButtons(BuildContext context) {
    final provider = context.watch<EmotionProvider>();
    final emotions = provider.emotions;

    return Wrap(
      spacing: 10,
      children: [
        ..._buildEmotionButtonList(emotions),
        _buildAddEmotionButton(context),
      ],
    );
  }

  List<Widget> _buildEmotionButtonList(List<Emotion> emotions) {
    return emotions.map(
      (emotion) {
        return OutlinedButton(
          onPressed: () {
            context.read<EmotionProvider>().incrementEmotion(emotion.name);
          },
          child: Text(emotion.name),
        );
      },
    ).toList();
  }

  Widget _buildAddEmotionButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () => _showAddEmotionDialog(context),
      child: const Icon(
        Icons.add,
        color: AppColors.primaryColor,
      ),
    );
  }

  void _showAddEmotionDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: AppColors.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        title: const Text('Add emotion'),
        content: _buildAddEmotionDialogContent(context),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildAddEmotionDialogContent(BuildContext context) {
    final provider = context.watch<EmotionProvider>();
    final emotions = provider.emotions;

    if (emotions.isEmpty) {
      return const Center(child: Text('No emotions found.'));
    }
    final double height = emotions.length < 5 ? emotions.length * 48.0 : 200;
    return SizedBox(
      height: height,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ..._buildEmotionList(emotions, context),
            const SizedBox(height: 10),
            _buildEmotionCreation(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildEmotionList(List<Emotion> emotions, BuildContext context) {
    return emotions.map(
      (emotion) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              onPressed: () {
                context.read<EmotionProvider>().incrementEmotion(emotion.name);
                Navigator.pop(context, 'Add emotion');
              },
              child: Text(emotion.name),
            ),
            _buildDeleteButton(emotion, context),
          ],
        );
      },
    ).toList();
  }

  Widget _buildDeleteButton(Emotion emotion, BuildContext context) {
    return GestureDetector(
      onTap: () => _showDeleteEmotionDialog(emotion, context),
      child: Container(
        height: 48,
        width: 48,
        alignment: Alignment.centerRight,
        child: const SizedBox(
          width: 20,
          child: Icon(
            Symbols.delete,
            color: AppColors.primaryColor,
          ),
        ),
      ),
    );
  }

  void _showDeleteEmotionDialog(Emotion emotion, BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: AppColors.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        title: const Text('Emotion deletion'),
        content: const Text('Are you sure you want to delete this emotion?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context
                  .read<EmotionProvider>()
                  .deleteEmotion(emotion.id, emotion.name);
              Navigator.pop(context, 'Delete');
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedEmotions(BuildContext context) {
    final provider = context.watch<EmotionProvider>();
    final emotions = provider.emotions;

    return Wrap(
      spacing: 10,
      children: [
        ..._buildSelectedEmotionButtons(emotions, provider),
      ],
    );
  }

  List<Widget> _buildSelectedEmotionButtons(
      List<Emotion> emotions, EmotionProvider provider) {
    return emotions
        .where((emotion) =>
            provider.selectedEmotionCounts.containsKey(emotion.name))
        .map((emotion) {
      return FilledButton(
        onPressed: () {
          provider.decrementEmotion(emotion.name);
        },
        child: Text(
            '${emotion.name} (${provider.selectedEmotionCounts[emotion.name]})'),
      );
    }).toList();
  }

  Widget _buildEmotionCreation(BuildContext context) {
    return Stack(
      children: [
        TextField(
          controller: _emotionNameController,
          decoration: InputDecoration(
            labelText: 'Emotion name',
            labelStyle: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.ternaryColor),
            hintStyle: Theme.of(context).textTheme.bodyMedium,
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.secondaryColor,
                width: 1.0,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.secondaryColor,
                width: 1.0,
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          child: IconButton(
            onPressed: () {
              context
                  .read<EmotionProvider>()
                  .addEmotion(_emotionNameController.text);
              context
                  .read<EmotionProvider>()
                  .incrementEmotion(_emotionNameController.text);
              FocusScope.of(context).unfocus();
              _emotionNameController.clear();
              Navigator.pop(context, 'Create emotion');
            },
            icon: const Icon(
              Icons.add,
              color: AppColors.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
