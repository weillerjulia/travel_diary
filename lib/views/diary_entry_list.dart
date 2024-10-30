// views/diary_entry_list.dart
import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/travel_diary_model.dart';
import 'add_diary_entry.dart';
import 'diary_entry_detail.dart';

class DiaryEntryList extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService(); // Instância direta

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Diário de Viagens')),
      body: StreamBuilder<List<TravelDiary>>(
        stream: firestoreService.getDiaryEntries(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final entries = snapshot.data!;
            return ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                return ListTile(
                  title: Text(entry.title),
                  subtitle: Text(entry.location),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DiaryEntryDetail(entry: entry),
                    ),
                  ),
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddDiaryEntry()),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
