// models/travel_diary_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class TravelDiary {
  final String? id;
  final String title;
  final String location;
  final String description;

  TravelDiary({this.id, required this.title, required this.location, required this.description});

  // Converte um documento Firestore em um TravelDiary
  factory TravelDiary.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TravelDiary(
      id: doc.id, // O ID do documento
      title: data['title'] ?? '', // Supondo que o campo se chama 'title'
      location: data['location'] ?? '', // Supondo que o campo se chama 'location'
      description: data['description'] ?? '', // Supondo que o campo se chama 'description'
    );
  }

  // Converte o TravelDiary em um Map para enviar ao Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'location': location,
      'description': description,
    };
  }
}