import 'package:calm_notes/colors.dart';
import 'package:calm_notes/models/emotion.dart';
import 'package:calm_notes/providers/emotion_provider.dart';
import 'package:calm_notes/widgets/anim_btn.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
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

  Widget _buildEmotionButtons(BuildContext context) {
    final provider = context.watch<EmotionProvider>();
    final emotionsToDisplay = provider.emotionsToDisplay;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        ..._buildEmotionButtonList(emotionsToDisplay),
        _buildAddEmotionButton(),
      ],
    );
  }

  List<Widget> _buildEmotionButtonList(List<Emotion> emotions) {
    return emotions.map((emotion) {
      final ValueNotifier<bool> isSelectedNotifier =
          ValueNotifier<bool>(emotion.selectedCount > 0 ? true : false);
      return ConstrainedBox(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2),
          child: AnimBtn(
            btnText: isSelectedNotifier.value
                ? '${emotion.name} (${emotion.selectedCount})'
                : emotion.name,
            isSelectedNotifier: isSelectedNotifier,
            borderWidth: 1,
            borderRadius: 5,
            borderColor: isSelectedNotifier.value
                ? CustomColors.primaryColor
                : CustomColors.secondaryColor,
            width: _getTextWidth(
                    isSelectedNotifier.value
                        ? '${emotion.name} (${emotion.selectedCount})'
                        : emotion.name,
                    const TextStyle(
                      fontSize: 14,
                    )) +
                40,
            onPress: () {
              context.read<EmotionProvider>().incrementEmotion(emotion);
            },
            onLongPress: () {
              context.read<EmotionProvider>().resetSelectedEmotion(emotion);
            },
          ));
    }).toList();
  }

  double _getTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: ui.TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    return textPainter.size.width;
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

  void _showAddEmotionDialog() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: CustomColors.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        title: Text(context.tr('emotion_dialog_title')),
        content: _buildAddEmotionDialogContent(context),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: Text(context.tr('global_dialog_cancel')),
          ),
        ],
      ),
    );
  }

  Widget _buildAddEmotionDialogContent(BuildContext context) {
    final provider = context.watch<EmotionProvider>();
    final emotions = provider.emotionsInDialog;
    final double height =
        emotions.length < 5 ? emotions.length * 48.0 + 66 : 200;

    return emotions.isEmpty
        ? _buildEmptyEmotionsDialogContent(context)
        : _buildEmotionsListDialogContent(emotions, height, context);
  }

  Widget _buildEmptyEmotionsDialogContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.tr('emotion_dialog_no_tag')),
        const SizedBox(height: 10),
        _buildEmotionCreation(context),
      ],
    );
  }

  Widget _buildEmotionsListDialogContent(
      List<Emotion> emotions, double height, BuildContext context) {
    return SizedBox(
      height: height,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
    return emotions
        .where((emotion) => emotion.selectedCount == 0)
        .map((emotion) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildAddEmotionButtonInDialog(emotion, context),
          _buildDeleteButton(emotion),
        ],
      );
    }).toList();
  }

  Widget _buildAddEmotionButtonInDialog(Emotion emotion, BuildContext context) {
    return ConstrainedBox(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2),
      child: OutlinedButton(
        onPressed: () {
          context.read<EmotionProvider>().incrementEmotion(emotion);
          Navigator.pop(context, 'Add emotion');
        },
        child: Text(
          emotion.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildDeleteButton(Emotion emotion) {
    return GestureDetector(
      onTap: () => _showDeleteEmotionDialog(emotion),
      child: Container(
        height: 48,
        width: 48,
        alignment: Alignment.centerRight,
        child: const SizedBox(
          width: 20,
          child: Icon(
            Symbols.delete,
            color: CustomColors.primaryColor,
          ),
        ),
      ),
    );
  }

  void _showDeleteEmotionDialog(Emotion emotion) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: CustomColors.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        title: Text(context.tr('emotion_dialog_delete_dialog_title')),
        content: Text(context.tr('emotion_dialog_delete_dialog_subtitle')),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: Text(context.tr('global_dialog_cancel')),
          ),
          TextButton(
            onPressed: () {
              context.read<EmotionProvider>().deleteEmotion(emotion);
              Navigator.pop(context, 'Delete');
            },
            child: Text(context.tr('emotion_dialog_delete_dialog_delete')),
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionCreation(BuildContext context) {
    return Stack(
      children: [
        TextField(
          controller: _emotionNameController,
          decoration: InputDecoration(
            labelText: context.tr('emotion_dialog_hint'),
            labelStyle: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: CustomColors.ternaryColor),
            hintStyle: Theme.of(context).textTheme.bodyMedium,
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: CustomColors.secondaryColor,
                width: 1.0,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: CustomColors.secondaryColor,
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
              final emotionName = _emotionNameController.text.trim();
              if (emotionName.isNotEmpty) {
                context
                    .read<EmotionProvider>()
                    .addAndIncrementEmotion(emotionName);
                FocusScope.of(context).unfocus();
                _emotionNameController.clear();
                Navigator.pop(context, 'Create emotion');
              }
            },
            icon: const Icon(
              Icons.add,
              color: CustomColors.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
