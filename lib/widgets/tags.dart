import 'package:calm_notes/colors.dart';
import 'package:calm_notes/models/tag.dart';
import 'package:calm_notes/providers/tag_provider.dart';
import 'package:calm_notes/widgets/anim_btn.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

class Tags extends StatefulWidget {
  const Tags({super.key});

  @override
  State<Tags> createState() => _TagsState();
}

class _TagsState extends State<Tags> {
  final TextEditingController _tagNameController = TextEditingController();

  @override
  void dispose() {
    _tagNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTagButtons(context),
      ],
    );
  }

  Widget _buildTagButtons(BuildContext context) {
    final provider = context.watch<TagProvider>();
    final tagsToDisplay = provider.tagsToDisplay;

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        ..._buildTagButtonList(tagsToDisplay),
        _buildAddTagButton(context),
      ],
    );
  }

  List<Widget> _buildTagButtonList(List<Tag> tags) {
    final double maxButtonWidth = MediaQuery.of(context).size.width / 2;
    final tagProvider = context.read<TagProvider>();

    return tags.map((tag) {
      final bool isSelected = tag.selectedCount > 0;

      final String btnText = tag.name;
      final String fullText =
          isSelected ? '$btnText (${tag.selectedCount})' : btnText;
      final double textWidth =
          _getTextWidth(fullText, const TextStyle(fontSize: 14));

      return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxButtonWidth),
          child: AnimBtn(
            btnText: btnText,
            countText: ' (${tag.selectedCount})',
            isSelected: isSelected,
            borderWidth: 1,
            borderRadius: 5,
            borderColor: isSelected
                ? CustomColors.primaryColor
                : CustomColors.secondaryColor,
            width: textWidth + 40,
            onPress: () {
              tagProvider.incrementTag(tag);
            },
            onLongPress: () {
              tagProvider.resetSelectedTag(tag);
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

  Widget _buildOutlinedTagButton(
      Tag tag, BuildContext context, bool popOnClick) {
    return ConstrainedBox(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2),
      child: OutlinedButton(
        onPressed: () {
          context.read<TagProvider>().incrementTag(tag);
          if (popOnClick) {
            Navigator.pop(context, 'Tag added');
          }
        },
        child: Text(
          tag.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildAddTagButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () => _showAddTagDialog(context),
      child: const Icon(
        Icons.add,
        color: CustomColors.primaryColor,
      ),
    );
  }

  void _showAddTagDialog(BuildContext context) {
    void checkEasyLocalizationInitialized(BuildContext context) {
      final localization = EasyLocalization.of(context);
      if (localization == null) {
        throw Exception("EasyLocalization is not initialized.");
      }
    }

    checkEasyLocalizationInitialized(context);
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: CustomColors.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        title: Text(context.tr('tag_dialog_title')),
        content: _buildAddTagDialogContent(context),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: Text(context.tr('global_dialog_cancel')),
          ),
        ],
      ),
    );
  }

  Widget _buildAddTagDialogContent(BuildContext context) {
    final provider = context.watch<TagProvider>();
    final tags = provider.tags;

    final double height = (tags.length * 48.0 + 66).clamp(0, 470);

    return tags.isEmpty
        ? _buildNoTagsContent(context)
        : _buildTagListContent(tags, context, height);
  }

  Widget _buildNoTagsContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.tr('tag_dialog_no_tag')),
        const SizedBox(height: 10),
        _buildTagCreationField(context),
      ],
    );
  }

  Widget _buildTagListContent(
      List<Tag> tags, BuildContext context, double height) {
    return SizedBox(
      height: height,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ..._buildTagList(tags, context),
            const SizedBox(height: 10),
            _buildTagCreationField(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTagList(List<Tag> tags, BuildContext context) {
    const bool popOnClick = true;
    return tags.where((tag) => tag.selectedCount == 0).map((tag) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildOutlinedTagButton(tag, context, popOnClick),
          _buildDeleteButton(tag, context),
        ],
      );
    }).toList();
  }

  Widget _buildDeleteButton(Tag tag, BuildContext context) {
    return GestureDetector(
      onTap: () => _showDeleteTagDialog(tag, context),
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

  void _showDeleteTagDialog(Tag tag, BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: CustomColors.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        title: Text(context.tr('tag_dialog_delete_dialog_title')),
        content: Text(context.tr('tag_dialog_delete_dialog_subtitle')),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: Text(context.tr('global_dialog_cancel')),
          ),
          TextButton(
            onPressed: () {
              context.read<TagProvider>().deleteTag(tag);
              Navigator.pop(context, 'Delete');
            },
            child: Text(context.tr('tag_dialog_delete_dialog_delete')),
          ),
        ],
      ),
    );
  }

  Widget _buildTagCreationField(BuildContext context) {
    return Stack(
      children: [
        TextField(
          controller: _tagNameController,
          decoration: InputDecoration(
            labelText: context.tr('tag_dialog_hint'),
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
              final tagName = _tagNameController.text.trim();
              if (tagName.isNotEmpty) {
                context.read<TagProvider>().addAndIncrementTag(tagName);
                FocusScope.of(context).unfocus();
                _tagNameController.clear();
                Navigator.pop(context, 'Create tag');
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
