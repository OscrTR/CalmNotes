import 'package:flutter/material.dart';

class Tags extends StatefulWidget {
  final Function(List<String>) onSelectedTagsChanged;
  const Tags({super.key, required this.onSelectedTagsChanged});

  @override
  State<Tags> createState() => _TagsState();
}

class _TagsState extends State<Tags> {
  final List<String> tags = [
    'back pain',
    'school',
    'work',
  ];
  final List<String> selectedTags = [];
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: tags.map((tag) {
        final isSelected = selectedTags.contains(tag);
        return isSelected
            ? FilledButton(
                onPressed: () {
                  setState(() {
                    selectedTags.remove(tag);
                    widget.onSelectedTagsChanged(selectedTags);
                  });
                },
                child: Text(tag),
              )
            : OutlinedButton(
                onPressed: () {
                  setState(() {
                    selectedTags.add(tag);
                    widget.onSelectedTagsChanged(selectedTags);
                  });
                },
                child: Text(tag));
      }).toList(),
    );
  }
}
