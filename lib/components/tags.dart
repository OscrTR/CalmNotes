import 'package:calm_notes/colors.dart';
import 'package:calm_notes/models/tag.dart';
import 'package:calm_notes/providers/tag_provider.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

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
        _buildtagButtons(context),
      ],
    );
  }

  Widget _buildtagButtons(BuildContext context) {
    final provider = context.watch<TagProvider>();
    final tagsToDisplay = provider.tagsToDisplay;

    return Wrap(
      spacing: 10,
      children: [
        ..._buildtagButtonList(tagsToDisplay),
        _buildAddtagButton(context),
      ],
    );
  }

  List<Widget> _buildtagButtonList(List<Tag> tags) {
    return tags.map(
      (tag) {
        if (tag.selectedCount > 0) {
          return FilledButton(
            onPressed: () {
              context.read<TagProvider>().incrementTag(tag);
            },
            onLongPress: () {
              context.read<TagProvider>().resetSelectedTag(tag);
            },
            child: Text('${tag.name} (${tag.selectedCount})'),
          );
        } else {
          return OutlinedButton(
            onPressed: () {
              context.read<TagProvider>().incrementTag(tag);
            },
            child: Text(tag.name),
          );
        }
      },
    ).toList();
  }

  Widget _buildAddtagButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () => _showAddtagDialog(context),
      child: const Icon(
        Icons.add,
        color: AppColors.primaryColor,
      ),
    );
  }

  void _showAddtagDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: AppColors.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        title: const Text('Add tag'),
        content: _buildAddtagDialogContent(context),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildAddtagDialogContent(BuildContext context) {
    final provider = context.watch<TagProvider>();
    final tags = provider.tags;
    final double height = tags.length < 5 ? tags.length * 48.0 + 66 : 200;

    if (tags.isEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('No tags found.'),
          const SizedBox(height: 10),
          _buildtagCreation(context),
        ],
      );
    }

    return SizedBox(
      height: height,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ..._buildtagList(tags, context),
            const SizedBox(height: 10),
            _buildtagCreation(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildtagList(List<Tag> tags, BuildContext context) {
    return tags.where((tag) => tag.selectedCount == 0).map(
      (tag) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              onPressed: () {
                context.read<TagProvider>().incrementTag(tag);
                Navigator.pop(context, 'Add tag');
              },
              child: Text(tag.name),
            ),
            _buildDeleteButton(tag, context),
          ],
        );
      },
    ).toList();
  }

  Widget _buildDeleteButton(Tag tag, BuildContext context) {
    return GestureDetector(
      onTap: () => _showDeletetagDialog(tag, context),
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

  void _showDeletetagDialog(Tag tag, BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: AppColors.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        title: const Text('tag deletion'),
        content: const Text('Are you sure you want to delete this tag?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<TagProvider>().deleteTag(tag.id!, tag.name);
              Navigator.pop(context, 'Delete');
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildtagCreation(BuildContext context) {
    return Stack(
      children: [
        TextField(
          controller: _tagNameController,
          decoration: InputDecoration(
            labelText: 'tag name',
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
              final tagName = _tagNameController.text.trim();
              if (tagName.isNotEmpty) {
                context
                    .read<TagProvider>()
                    .addAndIncrementTag(_tagNameController.text);
                FocusScope.of(context).unfocus();
                _tagNameController.clear();
                Navigator.pop(context, 'Create tag');
              }
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
