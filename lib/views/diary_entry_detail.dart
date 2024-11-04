// views/diary_entry_detail.dart
import 'package:flutter/material.dart';
import '../models/travel_diary_model.dart';
import '../services/firestore_service.dart';
import 'add_diary_entry.dart';

class DiaryEntryDetail extends StatelessWidget {
  final TravelDiary entry;

  const DiaryEntryDetail({Key? key, required this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService(); // Instância do FirestoreService

    return Scaffold(
      appBar: AppBar(
        title: Text(entry.title),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Navega para a tela de edição, passando a entrada atual
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddDiaryEntry(entry: entry),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              // Confirmar exclusão
              final shouldDelete = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Excluir informações'),
                  content: Text('Tem certeza de que deseja excluir?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text('Excluir'),
                    ),
                  ],
                ),
              );
              if (shouldDelete ?? false) {
                // Exclui a entrada e volta para a lista
                await firestoreService.deleteDiaryEntry(entry.id!); // Chama o método diretamente
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              entry.location,
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 16),
            Text(
              entry.description,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
