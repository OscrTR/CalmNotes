import 'package:calm_notes/colors.dart';
import 'package:calm_notes/providers/tag_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Tags extends StatelessWidget {
  Tags({super.key});

  // List of all possible tags
  final List<String> _tags = [
    'back pain',
    'school',
    'work',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(spacing: 10, children: [
          ..._tags.map((tag) {
            return OutlinedButton(
              onPressed: () {
                // Access the provider and increment the tag count
                context.read<TagProvider>().incrementtag(tag);
              },
              child: Text(tag),
            );
          }),
          OutlinedButton(
            onPressed: () {},
            child: const Icon(
              Icons.add,
              color: AppColors.primaryColor,
            ),
          ),
        ]),
        Consumer<TagProvider>(
          builder: (context, tagProvider, child) {
            return Wrap(
              spacing: 10,
              children: _tags
                  .where(
                      (tag) => tagProvider.selectedtagCounts.containsKey(tag))
                  .map((tag) {
                // If selected, show a filled button with count
                return FilledButton(
                  onPressed: () {
                    // Access the provider and decrement the tag count
                    tagProvider.decrementtag(tag);
                  },
                  child: Text('$tag (${tagProvider.selectedtagCounts[tag]})'),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
