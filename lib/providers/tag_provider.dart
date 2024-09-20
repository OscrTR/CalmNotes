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
    fetchTags();
  }

  List<Tag> _combineLists(List<Tag> list1, List<Tag> list2) {
    Map<int, Tag> map2 = {for (var e in list2) e.id!: e};

    List<Tag> updatedList = list1
        .map((tag) {
          if (map2.containsKey(tag.id)) {
            return tag.updateFrom(map2[tag.id]!);
          }
          return null;
        })
        .whereType<Tag>()
        .toList();

    List<Tag> newElements = map2.entries
        .where((entry) => !list1.any((e) => e.id == entry.key))
        .map((entry) => entry.value)
        .toList();

    updatedList.addAll(newElements);

    return updatedList;
  }

  Future<void> fetchTags() async {
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
    await fetchTags();
  }

  Future<void> deleteTag(Tag tag) async {
    await _databaseService.deleteTag(tag.id!);
    await fetchTags();
  }

  Future<void> incrementTag(Tag tag) async {
    await _databaseService.incrementSelectedTagCount(tag.id!);
    await fetchTags();
  }

  Future<void> addAndIncrementTag(String tagName) async {
    final int tagId = await _databaseService.addTag(tagName);
    await _databaseService.incrementSelectedTagCount(tagId);
    await fetchTags();
  }

  Future<void> resetSelectedTag(Tag tag) async {
    await _databaseService.resetSelectedTagCount(tag.id!);
    await fetchTags();
  }

  Future<void> resetTags() async {
    await _databaseService.resetSelectedTagsCount();
    await fetchTags();
  }

  Future<void> setTags(int id) async {
    await _databaseService.setSelectedTagsCount(id);
    await fetchTags();
  }
}
