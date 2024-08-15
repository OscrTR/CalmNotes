import 'package:calm_notes/models/tag.dart';
import 'package:calm_notes/services/database_service.dart';
import 'package:flutter/material.dart';

class TagProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService.instance;
  List<Tag> _tags = [];
  List<Tag> _tagsToDisplay = [];

  List<Tag> get tags => _tags;
  List<Tag> get tagsToDisplay => _tagsToDisplay;

  TagProvider() {
    _fetchTags();
  }

  List<Tag> _combineLists(List<Tag> list1, List<Tag> list2) {
    // Create a map from list2 for quick lookup by id
    Map<int, Tag> map2 = {for (var e in list2) e.id!: e};

    // Create a new list with updated values from list2
    List<Tag> updatedList = list1
        .map((tag) {
          if (map2.containsKey(tag.id)) {
            // Update the Tag from list1 with values from list2
            return tag.updateFrom(map2[tag.id]!);
          }
          // If not in list2, exclude this Tag
          return null;
        })
        .whereType<Tag>()
        .toList();

    // Add new elements from list2 that were not in list1
    List<Tag> newElements = map2.entries
        .where((entry) => !list1.any((e) => e.id == entry.key))
        .map((entry) => entry.value)
        .toList();

    // Combine the updated list1 with new elements from list2
    updatedList.addAll(newElements);

    return updatedList;
  }

  Future<void> _fetchTags() async {
    // Fetch tags and tagsToDisplay in parallel
    final results = await Future.wait(
        [_databaseService.fetchTags(), _databaseService.fetchTagsToDisplay()]);

    _tags = results[0];
    _tagsToDisplay = _combineLists(_tagsToDisplay, results[1]);
    notifyListeners();
  }

  Future<void> fetchDisplayedTags() async {
    _tagsToDisplay = await _databaseService.fetchTagsToDisplay();
    notifyListeners();
  }

  Future<void> addTag(String name) async {
    await _databaseService.addTag(name);
    await _fetchTags();
  }

  Future<void> deleteTag(int id, String tagName) async {
    await _databaseService.deleteTag(id);
    await _fetchTags();
  }

  void incrementTag(Tag tag) async {
    await _databaseService.incrementSelectedTagCount(tag.id!);
    await _fetchTags();
  }

  void addAndIncrementTag(String tagName) async {
    final int tagId = await _databaseService.addTag(tagName);
    await _databaseService.incrementSelectedTagCount(tagId);
    await _fetchTags();
  }

  void resetSelectedTag(Tag tag) async {
    await _databaseService.resetSelectedTagCount(tag.id!);
    await _fetchTags();
  }

  void resetTags() async {
    await _databaseService.resetSelectedTagsCount();
    await _fetchTags();
  }

  Future<void> setTags(int id) async {
    await _databaseService.setSelectedTagsCount(id);
    await _fetchTags();
  }
}
