import 'package:calm_notes/colors.dart';
import 'package:calm_notes/models/emotion.dart';
import 'package:calm_notes/providers/emotion_provider.dart';
import 'package:calm_notes/services/database_service.dart';
import 'package:calm_notes/widgets/anim_btn.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

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
      ],
    );
  }

  final DatabaseService _databaseService = DatabaseService.instance;

  Widget _buildEmotionButtons(BuildContext context) {
    final provider = context.watch<EmotionProvider>();
    final emotionsToDisplay = provider.emotionsToDisplay;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        ..._buildEmotionButtonList(emotionsToDisplay),
        _buildAddEmotionButton(),
        FilledButton(
            onPressed: _databaseService.setOldTable,
            child: const Text('old table'))
      ],
    );
  }

  List<Widget> _buildEmotionButtonList(List<Emotion> emotions) {
    final double maxButtonWidth = MediaQuery.of(context).size.width / 2;
    final emotionProvider = context.read<EmotionProvider>();
    String currentLocale = context.locale.toString();

    return emotions.map((emotion) {
      final bool isSelected = emotion.selectedCount > 0;

      final String btnText =
          currentLocale == 'en_US' ? emotion.nameEn : emotion.nameFr;
      final String fullText =
          isSelected ? '$btnText (${emotion.selectedCount})' : btnText;
      final double textWidth =
          _getTextWidth(fullText, const TextStyle(fontSize: 14));

      return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxButtonWidth),
          child: AnimBtn(
            btnText: currentLocale == 'en_US' ? emotion.nameEn : emotion.nameFr,
            countText: ' (${emotion.selectedCount})',
            isSelected: isSelected,
            borderWidth: 1,
            borderRadius: 5,
            borderColor: isSelected
                ? CustomColors.primaryColor
                : CustomColors.secondaryColor,
            width: textWidth + 40,
            onPress: () {
              emotionProvider.incrementEmotion(emotion);
            },
            onLongPress: () {
              emotionProvider.resetSelectedEmotion(emotion);
            },
          ));
    }).toList();
  }

  double _getTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: ui.TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size.width.clamp(12.0, double.infinity);
  }

  Widget _buildAddEmotionButton() {
    return OutlinedButton(
      onPressed: () => _showAddEmotionDialog(),
      child: const Icon(
        Icons.add,
        color: CustomColors.primaryColor,
      ),
    );
  }

  Future<void> _showAddEmotionDialog() async {
    String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String currentLocale = context.locale.toString();
        final EmotionProvider emotionProvider =
            context.watch<EmotionProvider>();
        final selectedEmotion = emotionProvider.selectedEmotion;

        return AlertDialog(
          backgroundColor: CustomColors.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          title: Text(context.tr('emotion_dialog_title')),
          content: _buildAddEmotionDialogContent(context),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    emotionProvider.setDefaultSelectedEmotion();
                    Navigator.pop(context, 'Cancel');
                  },
                  child: Text(context.tr('global_dialog_cancel')),
                ),
                if (selectedEmotion != null)
                  TextButton(
                    onPressed: () {
                      emotionProvider.incrementEmotion(selectedEmotion);
                      emotionProvider.setDefaultSelectedEmotion();
                      Navigator.pop(context, 'Add emotion');
                    },
                    child: Text(
                      context.tr('entry_add_button', args: [
                        (currentLocale == 'en_US'
                            ? selectedEmotion.nameEn
                            : selectedEmotion.nameFr)
                      ]),
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
    if (result == null) {
      if (mounted) {
        final emotionProvider = context.read<EmotionProvider>();
        emotionProvider.setDefaultSelectedEmotion();
      }
    }
  }

  Widget _buildAddEmotionDialogContent(BuildContext context) {
    final provider = context.watch<EmotionProvider>();
    final emotions = provider.emotions;
    const double height = 470;

    return _buildEmotionsListDialogContent(emotions, height, context);
  }

  Widget _buildEmotionsListDialogContent(
      List<Emotion> emotions, double height, BuildContext context) {
    return SizedBox(
      height: height,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr('entry_basic_emotions'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            _buildBasicEmotionList(emotions, context),
            const SizedBox(height: 20),
            Text(
              context.tr('entry_intermediate_emotions'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            _buildIntermediateEmotionList(emotions, context),
            const SizedBox(height: 20),
            Text(
              context.tr('entry_advanced_emotions'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            _buildAdvancedEmotionList(emotions, context),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicEmotionList(List<Emotion> emotions, BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        ...emotions.where((emotion) => emotion.level == 0).map((emotion) {
          return _buildAddEmotionButtonInDialog(emotion, context);
        })
      ],
    );
  }

  Widget _buildIntermediateEmotionList(
      List<Emotion> emotions, BuildContext context) {
    EmotionProvider emotionProvider = context.watch<EmotionProvider>();
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        ...emotions
            .where((emotion) =>
                emotion.level == 1 &&
                (emotionProvider.selectedEmotion?.nameEn ==
                        emotion.basicEmotion ||
                    emotionProvider.selectedEmotion?.basicEmotion ==
                        emotion.basicEmotion ||
                    emotionProvider.selectedEmotion?.nameEn ==
                        emotion.intermediateEmotion))
            .map((emotion) {
          return _buildAddEmotionButtonInDialog(emotion, context);
        })
      ],
    );
  }

  Widget _buildAdvancedEmotionList(
      List<Emotion> emotions, BuildContext context) {
    EmotionProvider emotionProvider = context.watch<EmotionProvider>();
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        ...emotions
            .where((emotion) =>
                emotion.level == 2 &&
                (emotionProvider.selectedEmotion?.intermediateEmotion ==
                        emotion.intermediateEmotion ||
                    emotionProvider.selectedEmotion?.nameEn ==
                        emotion.intermediateEmotion))
            .map((emotion) {
          return _buildAddEmotionButtonInDialog(emotion, context);
        })
      ],
    );
  }

  Widget _buildAddEmotionButtonInDialog(Emotion emotion, BuildContext context) {
    final emotionProvider = context.watch<EmotionProvider>();
    String currentLocale = context.locale.toString();
    final double textWidth = _getTextWidth(
        currentLocale == 'en_US' ? emotion.nameEn : emotion.nameFr,
        const TextStyle(fontSize: 14));

    final isSelected = _isEmotionSelected(emotion, emotionProvider);
    final isPreviousSelected =
        _isEmotionPreviousSelected(emotion, emotionProvider);

    return AnimBtn(
      btnText: currentLocale == 'en_US' ? emotion.nameEn : emotion.nameFr,
      isSelected: isSelected,
      borderWidth: 1,
      borderRadius: 5,
      enableAnimation: isSelected == true || isPreviousSelected == true,
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      borderColor:
          isSelected ? CustomColors.primaryColor : CustomColors.secondaryColor,
      width: textWidth + 30,
      onPress: () {
        emotionProvider.setSelectedEmotion(emotion);
      },
      onLongPress: () {
        emotionProvider.setDefaultSelectedEmotion();
      },
    );
  }

  bool _isEmotionSelected(Emotion emotion, EmotionProvider emotionProvider) {
    return emotionProvider.selectedEmotion!.nameEn == emotion.nameEn;
  }

  bool _isEmotionPreviousSelected(
      Emotion emotion, EmotionProvider emotionProvider) {
    if (emotionProvider.previousSelectedEmotion != null) {
      return emotionProvider.previousSelectedEmotion!.nameEn == emotion.nameEn;
    } else {
      return false;
    }
  }
}
