import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/travel_diary_model.dart';
import 'add_diary_entry.dart';
import 'diary_entry_detail.dart';

class DiaryEntryList extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();

  // Método para criar uma linha de estrelas com base na avaliação
  Widget _buildRatingStars(int rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Color(0xFF999B85),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.airplane_ticket, color: Colors.white), // Ícone do avião
            SizedBox(width: 8), // Espaçamento
            Text('Diário de Viagens'),
          ],
        ),
        backgroundColor: Color(0xFFDDB7AC), // Cor de fundo do AppBar
      ),
      body: Container(
        color: Color(0xFFEAD5D5), // Cor de fundo da tela
        child: StreamBuilder<List<TravelDiary>>(
          stream: firestoreService.getDiaryEntries(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final entries = snapshot.data!;
              return ListView.builder(
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  return Card(
                    color: Color(0xFFFDFBFB), // Cor de fundo dos cards
                    margin: EdgeInsets.all(8),
                    elevation: 4,
                    child: ListTile(
                      title: Text(entry.title, style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(entry.location),
                          _buildRatingStars(entry.rating), // Exibe as estrelas
                        ],
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DiaryEntryDetail(entry: entry),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddDiaryEntry()),
        ),
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF999B85), // Cor do botão
      ),
    );
  }
}
