import 'package:flutter/material.dart';

class Tags extends StatefulWidget {
  final List<String>? defaultSelectedTags;
  final Function(List<String>) onSelectedTagsChanged;
  const Tags(
      {super.key,
      this.defaultSelectedTags = const [],
      required this.onSelectedTagsChanged});

  @override
  State<Tags> createState() => _TagsState();
}

class _TagsState extends State<Tags> {
  final List<String> tags = [
    'back pain',
    'school',
    'work',
  ];
  late List<String> selectedTags;

  @override
  void initState() {
    super.initState();
    selectedTags = List.from(widget.defaultSelectedTags as Iterable);
  }

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
