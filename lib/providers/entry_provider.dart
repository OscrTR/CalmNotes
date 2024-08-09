import 'package:calm_notes/models/entry.dart';
import 'package:calm_notes/services/database_service.dart';
import 'package:flutter/material.dart';

class EntryProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService.instance;
  List<Entry> _entries = [];

  List<Entry> get entries => _entries;

  EntryProvider() {
    _fetchEntries();
  }

  Future<void> _fetchEntries() async {
    _entries = await _databaseService.fetchEntries();
    notifyListeners();
  }

  Future<void> addEntry(Entry entry) async {
    _databaseService.addEntry(entry);
    await _fetchEntries();
  }
}
