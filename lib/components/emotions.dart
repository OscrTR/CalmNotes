import 'package:calm_notes/colors.dart';
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
        Consumer<EmotionProvider>(
          builder: (context, provider, child) {
            final emotions = provider.emotions;
            return Wrap(
              spacing: 10,
              children: [
                ...emotions.map(
                  (emotion) {
                    return OutlinedButton(
                      onPressed: () {
                        context
                            .read<EmotionProvider>()
                            .incrementEmotion(emotion.name);
                      },
                      child: Text(emotion.name),
                    );
                  },
                ),
                OutlinedButton(
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      backgroundColor: AppColors.backgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      title: const Text('Add emotion'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                              'Select an existing emotion or create a new one.'),
                          const SizedBox(height: 12),
                          Consumer<EmotionProvider>(
                            builder: (context, provider, child) {
                              final emotions = provider.emotions;
                              if (emotions.isEmpty) {
                                return const Center(
                                    child: Text('No emotions found.'));
                              }
                              final double height = emotions.length < 5
                                  ? emotions.length * 48.0
                                  : 200;
                              return SizedBox(
                                height: height,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      ...emotions.map(
                                        (emotion) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              OutlinedButton(
                                                onPressed: () {},
                                                child: Text(emotion.name),
                                              ),
                                              GestureDetector(
                                                onTap: () => showDialog<String>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                    backgroundColor: AppColors
                                                        .backgroundColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    title: const Text(
                                                        'Emotion deletion'),
                                                    content: const Text(
                                                        'Are you sure you want to delete this emotion?'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context,
                                                                'Cancel'),
                                                        child: const Text(
                                                            'Cancel'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          provider
                                                              .deleteEmotion(
                                                                  emotion.id);
                                                          Navigator.pop(context,
                                                              'Delete');
                                                        },
                                                        child: const Text(
                                                            'Delete'),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                child: Container(
                                                  height: 48,
                                                  width: 48,
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: const SizedBox(
                                                    width: 20,
                                                    child: Icon(
                                                      Symbols.delete,
                                                      color: AppColors
                                                          .primaryColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      _buildTitleField(context),
                                      FilledButton(
                                          onPressed: () {
                                            Provider.of<EmotionProvider>(
                                                    context,
                                                    listen: false)
                                                .addEmotion(
                                                    _emotionNameController
                                                        .text);
                                          },
                                          child:
                                              const Text('Create new emotion'))
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            );
          },
        ),
        Consumer<EmotionProvider>(
          builder: (context, provider, child) {
            final emotions = provider.emotions;
            return Wrap(spacing: 10, children: [
              ...emotions
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
              })
            ]);
          },
        ),
      ],
    );
  }

  Widget _buildTitleField(BuildContext context) {
    return TextField(
      controller: _emotionNameController,
      decoration: InputDecoration(
        border: const OutlineInputBorder(borderSide: BorderSide.none),
        hintText: 'Title',
        hintStyle: Theme.of(context).textTheme.titleMedium,
        contentPadding: EdgeInsets.zero,
        isDense: true,
      ),
      style: Theme.of(context).textTheme.titleMedium,
    );
  }
}
