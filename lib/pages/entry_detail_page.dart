import 'package:calm_notes/models/entry.dart';
import 'package:calm_notes/services/database_service.dart';
import 'package:flutter/material.dart';

class EntryDetailPage extends StatefulWidget {
  final int entryId;
  const EntryDetailPage({super.key, required this.entryId});

  @override
  State<EntryDetailPage> createState() => _EntryDetailPageState();
}

class _EntryDetailPageState extends State<EntryDetailPage> {
  final DatabaseService _databaseService = DatabaseService.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Entry Details'),
      ),
      body: FutureBuilder<Entry>(
        future: _databaseService.getEntry(widget.entryId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While the future is resolving, show a loading indicator
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // Handle any errors that occur during the future execution
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            // Handle the case where there is no data returned
            return Center(
              child: Text('Entry not found'),
            );
          } else {
            // Once the future resolves, extract the data and display it
            final entry = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.title!,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    entry.description!,
                    style: const TextStyle(fontSize: 16),
                  ),
                  // Add more fields if necessary
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
