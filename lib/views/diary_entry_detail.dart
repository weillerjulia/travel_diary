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
        backgroundColor: Color(0xFFF0D901), // Cor de fundo do AppBar
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
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
            icon: Icon(Icons.delete, color: Colors.white),
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
        child: SingleChildScrollView( // Permite rolagem se o conteúdo for longo
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF5060FF)), // Cor do título
              ),
              SizedBox(height: 8),
              Text(
                entry.location,
                style: TextStyle(fontSize: 18, color: Color(0xFF999B85)), // Cor do local
              ),
              SizedBox(height: 16),
              Text(
                entry.description,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20), // Espaçamento adicional
              Divider(color: Color(0xFFDDB7AC)), // Divisória
              SizedBox(height: 20), // Espaçamento adicional
              Text('Avaliação:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < entry.rating ? Icons.star : Icons.star_border,
                    color: Colors.yellow,
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
