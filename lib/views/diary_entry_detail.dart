import 'package:flutter/material.dart';
import '../models/travel_diary_model.dart';
import '../services/firestore_service.dart';
import 'add_diary_entry.dart';

class DiaryEntryDetail extends StatelessWidget {
  final TravelDiary entry;

  const DiaryEntryDetail({Key? key, required this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: null, // Remover o título
        backgroundColor: Color(0xFFDDB7AC),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddDiaryEntry(entry: entry),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.white),
            onPressed: () async {
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
                await firestoreService.deleteDiaryEntry(entry.id!);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF050505),
                ),
              ),
              SizedBox(height: 8),
              Text(
                entry.location,
                style: TextStyle(fontSize: 18, color: Color(0xFF999B85)),
              ),
              SizedBox(height: 16),
              Text(
                entry.description,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Divider(color: Color(0xFFDDB7AC)),
              SizedBox(height: 20),
              Text('Avaliação:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < entry.rating ? Icons.star : Icons.star_border,
                    color: Color(0xFF999B85),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
